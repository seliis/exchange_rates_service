package main

import (
	"fmt"
	"package/server/config"
	"package/server/database"
	"package/server/debug"
	"package/server/http"
	"package/server/internal/handlers"
	"package/server/internal/repositories"
	"package/server/internal/services"

	"github.com/gofiber/fiber/v3"
	"github.com/gofiber/fiber/v3/middleware/cors"
	"github.com/gofiber/fiber/v3/middleware/static"
)

func init() {
	if err := config.Load("config.json"); err != nil {
		panic(err)
	}

	if err := debug.Start("debug.log"); err != nil {
		panic(err)
	}

	if err := database.Connect(); err != nil {
		panic(err)
	}

	if err := database.CreateScheme(); err != nil {
		panic(err)
	}

	http.Start()
}

func main() {
	app := fiber.New(fiber.Config{
		AppName: fmt.Sprintf("%s v%s", config.Data.AppName, config.Data.AppVersion),
	})

	app.Use(cors.New(
		cors.Config{
			AllowOrigins: []string{"*"},
		},
	))

	setExchangeRoute(app)

	app.Use("/", static.New("./public"))

	app.Listen(":" + config.Data.Port)
}

func setExchangeRoute(app *fiber.App) {
	repository := repositories.NewExchangeRepository()
	service := services.NewExchangeService(repository)
	handler := handlers.NewExchangeHandler(service)

	app.Get("/api/exchange/:currency_code", handler.GetExchangeData)
	app.Get("/api/update/", handler.UpdateExchangeData)
}
