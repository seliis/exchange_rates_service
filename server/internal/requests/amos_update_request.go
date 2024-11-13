package requests

import (
	"github.com/gofiber/fiber/v3"
)

type AmosUpdateRequest struct {
	Date string `json:"date"`
}

func ParseAmosUpdateRequest(c fiber.Ctx) AmosUpdateRequest {
	var request AmosUpdateRequest

	request.Date = c.Query("date")

	return request
}
