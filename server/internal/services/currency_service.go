package services

import (
	"context"
	"errors"
	"log"
	"package/server/config"
	"package/server/database"
	"package/server/internal/entities"
	"package/server/internal/repositories"
	"package/server/internal/requests"
	"strconv"
	"strings"
)

type CurrencyService struct {
	CurrencyRepository repositories.CurrencyRepository
}

func NewCurrencyService(currencyRepository repositories.CurrencyRepository) CurrencyService {
	return CurrencyService{CurrencyRepository: currencyRepository}
}

func (s CurrencyService) UpdateAMOS(context context.Context, request requests.AmosUpdateRequest) ([]entities.AmosCurrency, error) {
	if err := s.UpdateDatabase(context, request.Date); err != nil {
		log.Printf("Error updating exchange data: %s", err.Error())
		return nil, err
	}

	currencies, err := s.CurrencyRepository.GetCurrencies(context, request.Date)
	if err != nil {
		log.Printf("Error getting exchange data: %s", err.Error())
		return nil, err
	}

	var keyCurrencyRate float64

	for _, currency := range currencies {
		if currency.CurrencyCode == config.ServerConfig.AMOS.KeyCurrencyCode {
			keyCurrencyRate = currency.Rate
			break
		}
	}

	var amosCurrencies []entities.AmosCurrency

	supportedCurrencies := config.ServerConfig.DataSource.SupportedCurrencies

	for _, currency := range currencies {
		for _, supportedCurrency := range supportedCurrencies {
			if currency.CurrencyCode == supportedCurrency.CurrencyCode && supportedCurrency.IsApplicable {
				amosCurrencies = append(amosCurrencies, entities.AmosCurrency{
					CurrencyCode: currency.CurrencyCode,
					ExchangeRate: currency.Rate / keyCurrencyRate,
					Description:  supportedCurrency.CurrencyName,
					ExchangeBase: 1,
				})
				break
			}
		}
	}

	id := config.ServerConfig.AMOS.Auth.ID
	password := config.ServerConfig.AMOS.Auth.Password
	url := config.ServerConfig.AMOS.BaseURL + config.ServerConfig.AMOS.EndPoints.ImportCurrency

	if err := s.CurrencyRepository.UpdateAMOS(context, url, id, password, entities.NewImportCurrency(amosCurrencies)); err != nil {
		log.Printf("Error updating AMOS data: %s", err.Error())
		return nil, err
	}

	return amosCurrencies, nil
}

func (s CurrencyService) UpdateDatabase(context context.Context, date string) error {
	if date == "" {
		log.Println("Date is empty")
		return errors.New("date is empty")
	}

	primitives, err := s.CurrencyRepository.GetPrimitives(date)
	if err != nil {
		log.Printf("Error getting exchange primitives: %s", err.Error())
		return err
	}

	var currencies []entities.Currency

	for _, primitive := range primitives {
		for _, supportedCurrency := range config.ServerConfig.DataSource.SupportedCurrencies {
			if primitive.CurrencyCode[:3] == supportedCurrency.CurrencyCode && supportedCurrency.IsApplicable {
				currency, err := parse(primitive, date)
				if err != nil {
					log.Printf("Error parsing currency data: %s", err.Error())
					return err
				}
				currencies = append(currencies, *currency)
			}
		}
	}

	for _, currency := range currencies {
		if exists, err := s.CurrencyRepository.IsExists(context, currency.CurrencyCode, currency.Date); err != nil {
			log.Printf("Error checking currency data: %s", err.Error())
			return err
		} else if !exists {
			_, err := database.Instance.NewInsert().Model(&currency).Exec(context)
			if err != nil {
				log.Printf("Error inserting currency data: %s", err.Error())
				return err
			}
		}
	}

	return nil
}

func (s CurrencyService) GetCurrencyCodes(context context.Context) ([]entities.CurrencyBasicData, error) {
	supportedCurrencies := config.ServerConfig.DataSource.SupportedCurrencies

	var currencyCodes []entities.CurrencyBasicData

	for _, supportedCurrency := range supportedCurrencies {
		if supportedCurrency.IsApplicable && supportedCurrency.CurrencyCode != config.ServerConfig.StandardCurrencyCode {
			currencyCodes = append(currencyCodes, entities.CurrencyBasicData{
				CurrencyCode: supportedCurrency.CurrencyCode,
				CurrencyName: supportedCurrency.CurrencyName,
			})
		}
	}

	return currencyCodes, nil
}

func (s CurrencyService) GetCurrency(context context.Context, request requests.CurrencyRequest) (*entities.Currency, error) {
	exists, err := s.CurrencyRepository.IsExists(context, request.CurrencyCode, request.Date)
	if err != nil {
		log.Printf("Error checking exchange data: %s", err.Error())
		return nil, err
	}

	if !exists {
		if err := s.UpdateDatabase(context, request.Date); err != nil {
			log.Printf("Error updating exchange data: %s", err.Error())
			return nil, err
		}
	}

	return s.CurrencyRepository.GetCurrency(context, request.CurrencyCode, request.Date)
}

func parse(data entities.Primitive, date string) (*entities.Currency, error) {
	rate, err := strconv.ParseFloat(strings.ReplaceAll(data.ExchangeRate, ",", ""), 64)
	if err != nil {
		return nil, err
	}

	if strings.Contains(data.CurrencyCode, "(100)") {
		rate /= 100
	}

	return &entities.Currency{
		CurrencyCode: data.CurrencyCode[:3],
		Date:         date,
		Rate:         rate,
	}, nil
}
