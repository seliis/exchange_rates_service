package handlers

import (
	"log"
	"package/server/internal/requests"
	"package/server/internal/responses"
	"package/server/internal/services"
	"time"

	"github.com/gofiber/fiber/v3"
)

type ExchangeHandler struct {
	ExchangeService services.ExchangeService
}

func NewExchangeHandler(exchangeService services.ExchangeService) ExchangeHandler {
	return ExchangeHandler{ExchangeService: exchangeService}
}

func (h ExchangeHandler) GetExchangeData(c fiber.Ctx) error {
	data, err := h.ExchangeService.GetExchangeData(c.Context(), requests.ParseCurrencyRequest(c))
	if err != nil {
		log.Printf("Error: %v", err)
		return c.Status(fiber.StatusInternalServerError).JSON(responses.NewErrorResponse(err.Error()))
	}

	return c.Status(fiber.StatusOK).JSON(responses.NewSuccessResponse(data))
}

func (h ExchangeHandler) UpdateExchangeData(c fiber.Ctx) error {
	date := time.Now().Format("2006-01-02")

	if err := h.ExchangeService.UpdateExchangeData(c.Context(), date); err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(responses.NewErrorResponse(err.Error()))
	}

	return c.Status(fiber.StatusOK).JSON(responses.NewSuccessResponse(nil))
}
