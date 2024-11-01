package services

import (
	"context"
	"log"
	"package/server/config"
	"package/server/database"
	"package/server/internal/models"
	"package/server/internal/repositories"
	"package/server/internal/requests"
	"strconv"
	"strings"
)

type ExchangeService struct {
	ExchangeRepository repositories.ExchangeRepository
}

func NewExchangeService(exchangeRepository repositories.ExchangeRepository) ExchangeService {
	return ExchangeService{ExchangeRepository: exchangeRepository}
}

func (s ExchangeService) UpdateExchangeData(context context.Context, date string) error {
	data, err := s.ExchangeRepository.GetPrimitives(date)
	if err != nil {
		log.Printf("Error getting exchange data: %s", err.Error())
		return err
	}

	var exchanges []models.Exchange

	for _, item := range data {
		for _, currency := range config.Data.Currencies {
			if item.CurrencyCode[:3] == currency {
				exchange, err := parse(item, date)
				if err != nil {
					log.Printf("Error parsing exchange data: %s", err.Error())
					return err
				}
				exchanges = append(exchanges, *exchange)
			}
		}
	}

	for _, exchange := range exchanges {
		if exists, err := s.isExists(context, exchange.Currency, exchange.Date); err != nil {
			log.Printf("Error checking exchange data: %s", err.Error())
			return err
		} else if !exists {
			_, err := database.Instance.NewInsert().Model(&exchange).Exec(context)
			if err != nil {
				log.Printf("Error inserting exchange data: %s", err.Error())
				return err
			}
		}
	}

	return nil
}

func (s ExchangeService) isExists(context context.Context, currency, date string) (bool, error) {
	return database.Instance.NewSelect().Model((*models.Exchange)(nil)).Where("currency = ? AND date = ?", currency, date).Exists(context)
}

func (s ExchangeService) GetExchangeData(context context.Context, request requests.ExchangeRequest) (*models.Exchange, error) {
	exists, err := s.isExists(context, request.CurrencyCode, request.Date)
	if err != nil {
		log.Printf("Error checking exchange data: %s", err.Error())
		return nil, err
	}

	if !exists {
		if err := s.UpdateExchangeData(context, request.Date); err != nil {
			log.Printf("Error updating exchange data: %s", err.Error())
			return nil, err
		}
	}

	var exchange models.Exchange

	if err := database.Instance.NewSelect().Model(&exchange).Where("currency = ? AND date = ?", request.CurrencyCode, request.Date).Scan(context); err != nil {
		log.Printf("Error reading exchange data: %s", err.Error())
		return nil, err
	}

	return &exchange, nil
}

func parse(data models.Primitive, date string) (*models.Exchange, error) {
	rates, err := strconv.ParseFloat(strings.ReplaceAll(data.ExchangeRate, ",", ""), 64)
	if err != nil {
		return nil, err
	}

	return &models.Exchange{
		Currency:  data.CurrencyCode[:3],
		Date:      date,
		Rates:     rates,
		AmosRates: 1 / rates,
	}, nil
}
