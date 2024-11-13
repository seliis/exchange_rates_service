package requests

import (
	"strings"

	"github.com/gofiber/fiber/v3"
)

type CurrencyRequest struct {
	CurrencyCode string `json:"currency_code"`
	Date         string `json:"date"`
}

func ParseCurrencyRequest(c fiber.Ctx) CurrencyRequest {
	var request CurrencyRequest

	request.CurrencyCode = strings.ToUpper(c.Params("currencyCode"))
	request.Date = c.Query("date")

	return request
}
