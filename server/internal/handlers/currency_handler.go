package handlers

import (
	"log"
	"package/server/internal/requests"
	"package/server/internal/responses"
	"package/server/internal/services"
	"time"

	"github.com/gofiber/fiber/v3"
)

type CurrencyHandler struct {
	CurrencyService services.CurrencyService
}

func NewCurrencyHandler(currencyService services.CurrencyService) CurrencyHandler {
	return CurrencyHandler{CurrencyService: currencyService}
}

func (h CurrencyHandler) UpdateAMOS(c fiber.Ctx) error {
	data, err := h.CurrencyService.UpdateAMOS(c.Context(), requests.ParseAmosUpdateRequest(c))
	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(responses.NewErrorResponse(err.Error()))
	}

	return c.Status(fiber.StatusOK).JSON(responses.NewSuccessResponse(data))
}

func (h CurrencyHandler) GetCurrencyCodes(c fiber.Ctx) error {
	data, err := h.CurrencyService.GetCurrencyCodes(c.Context())
	if err != nil {
		log.Printf("Error: %v", err)
		return c.Status(fiber.StatusInternalServerError).JSON(responses.NewErrorResponse(err.Error()))
	}

	return c.Status(fiber.StatusOK).JSON(responses.NewSuccessResponse(data))
}

func (h CurrencyHandler) GetCurrency(c fiber.Ctx) error {
	data, err := h.CurrencyService.GetCurrency(c.Context(), requests.ParseCurrencyRequest(c))
	if err != nil {
		log.Printf("Error: %v", err)
		return c.Status(fiber.StatusInternalServerError).JSON(responses.NewErrorResponse(err.Error()))
	}

	return c.Status(fiber.StatusOK).JSON(responses.NewSuccessResponse(data))
}

func (h CurrencyHandler) UpdateDatabase(c fiber.Ctx) error {
	date := time.Now().Format("2006-01-02")

	if err := h.CurrencyService.UpdateDatabase(c.Context(), date); err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(responses.NewErrorResponse(err.Error()))
	}

	return c.Status(fiber.StatusOK).JSON(responses.NewSuccessResponse(nil))
}
