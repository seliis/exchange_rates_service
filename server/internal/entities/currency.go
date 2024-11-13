package entities

import (
	"encoding/xml"

	"github.com/uptrace/bun"
)

type CurrencyBasicData struct {
	bun.BaseModel `bun:"table:currency_basic_data,alias:currency_basic_data"`

	CurrencyCode string `json:"currency_code" bun:"currency_code,notnull,pk"`
	CurrencyName string `json:"currency_name" bun:"currency_name,notnull"`
}

type Currency struct {
	bun.BaseModel `bun:"table:currency,alias:currency"`

	CurrencyCode string  `json:"currency_code" bun:"currency_code,notnull"`
	Date         string  `json:"date" bun:"date,notnull"`
	Rate         float64 `json:"rate" bun:"rate,notnull"`
	// ExchangeRate float64 `json:"exchange_rate" bun:"exchange_rate,notnull"`
	// ExchangeBase uint    `json:"exchange_base" bun:"exchange_base,notnull"`
}

type ImportCurrency struct {
	XMLName    string         `xml:"importCurrency"`
	Version    xml.Attr       `xml:"version,attr"`
	Currencies []AmosCurrency `xml:"currency"`
}

func NewImportCurrency(amosCurrencies []AmosCurrency) ImportCurrency {
	return ImportCurrency{
		Version: xml.Attr{
			Name:  xml.Name{Local: "version"},
			Value: "0.2",
		},
		Currencies: amosCurrencies,
	}
}

type AmosCurrency struct {
	XMLName      string  `xml:"currency"`
	CurrencyCode string  `xml:"currencyCode"`
	Description  string  `xml:"description"`
	ExchangeRate float64 `xml:"exchangeRate"`
	ExchangeBase uint    `xml:"exchangeBase"`
}

func NewAmosCurrency(currency Currency, description string) AmosCurrency {
	return AmosCurrency{
		CurrencyCode: currency.CurrencyCode,
		Description:  description,
		ExchangeRate: currency.Rate,
	}
}
