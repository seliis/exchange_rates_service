package repositories

import (
	"context"
	"encoding/base64"
	"fmt"
	"log"
	"package/server/config"
	"package/server/database"
	"package/server/http"
	"package/server/internal/entities"
	"time"
)

type CurrencyRepository struct {
}

func NewCurrencyRepository() CurrencyRepository {
	return CurrencyRepository{}
}

func (r CurrencyRepository) UpdateAMOS(context context.Context, url, id, password string, data entities.ImportCurrency) error {
	auth := base64.StdEncoding.EncodeToString([]byte(fmt.Sprintf("%s:%s", id, password)))

	request := http.Instance.R()
	request.SetMethod("POST")
	request.SetURL(url)
	request.SetHeader("Authorization", fmt.Sprintf("Basic %s", auth))
	request.SetHeader("Content-Type", "application/xml; charset=utf-8")
	request.SetXML(data)

	response, err := request.Send()
	if err != nil {
		log.Printf("Error Response: %s", err.Error())
		return err
	}

	fmt.Println(response.StatusCode())
	fmt.Println(response.String())

	return nil
}

func (r CurrencyRepository) GetPrimitives(date string) ([]entities.Primitive, error) {
	src := config.ServerConfig.DataSource
	var primitives []entities.Primitive
	const max = 10

	url := fmt.Sprintf("%s?authkey=%s&searchdate=%s&data=%s", src.BaseURL, src.APIKey, date, src.DataType)

	for i := 0; i < max; i++ {
		response, err := http.Instance.Get(url)
		if err != nil {
			time.Sleep(3 * time.Second)
			continue
		}

		if err := response.JSON(&primitives); err != nil {
			time.Sleep(3 * time.Second)
			continue
		}

		return primitives, nil
	}

	return nil, fmt.Errorf("NO_RESPONSE_FROM_URL: %s", url)
}

func (r CurrencyRepository) GetCurrencies(context context.Context, date string) ([]entities.Currency, error) {
	var currencies []entities.Currency

	if err := database.Instance.NewSelect().Model(&currencies).Where("date = ?", date).Scan(context); err != nil {
		return nil, err
	}

	return currencies, nil
}

func (r CurrencyRepository) GetCurrency(context context.Context, currencyCode string, date string) (*entities.Currency, error) {
	var currency entities.Currency

	if err := database.Instance.NewSelect().Model(&currency).Where("currency_code = ? and date = ?", currencyCode, date).Scan(context); err != nil {
		return nil, err
	}

	return &currency, nil
}

func (r CurrencyRepository) GetCurrencyBasicData(context context.Context, currencyCode string) (*entities.CurrencyBasicData, error) {
	var currencyBasicData entities.CurrencyBasicData

	if err := database.Instance.NewSelect().Model(&currencyBasicData).Where("currency_code = ?", currencyCode).Scan(context); err != nil {
		return nil, err
	}

	return &currencyBasicData, nil
}

func (r CurrencyRepository) IsExists(context context.Context, currencyCode string, date string) (bool, error) {
	return database.Instance.NewSelect().Model((*entities.Currency)(nil)).Where("currency_code = ? and date = ?", currencyCode, date).Exists(context)
}
