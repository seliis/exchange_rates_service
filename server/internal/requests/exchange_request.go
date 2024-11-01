package requests

import (
	"strings"

	"github.com/gofiber/fiber/v3"
)

type ExchangeRequest struct {
	CurrencyCode string `json:"currency_code"`
	Date         string `json:"date"`
}

func ParseCurrencyRequest(c fiber.Ctx) ExchangeRequest {
	var currencyRequest ExchangeRequest

	currencyRequest.CurrencyCode = strings.ToUpper(c.Params("currency_code"))
	currencyRequest.Date = c.Query("date")

	return currencyRequest
}
