package main

import (
	"context"
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
	context := context.Background()

	if err := config.Load("config.json"); err != nil {
		panic(err)
	}

	if err := debug.Start("debug.log"); err != nil {
		panic(err)
	}

	if err := database.Connect(); err != nil {
		panic(err)
	}

	if err := database.CreateScheme(context); err != nil {
		panic(err)
	}

	if err := database.UpsertCurrencyBasicData(context); err != nil {
		panic(err)
	}

	http.Start()
}

func main() {
	app := fiber.New(fiber.Config{
		AppName: fmt.Sprintf("%s v%s", config.ServerConfig.AppName, config.ServerConfig.AppVersion),
	})

	app.Use(cors.New(
		cors.Config{
			AllowOrigins: []string{"*"},
		},
	))

	api := app.Group("/api")

	setExchangeRoute(api)

	app.Use("/", static.New("./public"))

	app.Listen(":" + config.ServerConfig.Port)
}

func setExchangeRoute(api fiber.Router) {
	repository := repositories.NewCurrencyRepository()
	service := services.NewCurrencyService(repository)
	handler := handlers.NewCurrencyHandler(service)

	api.Get("/currencyCodes", handler.GetCurrencyCodes)
	api.Get("/currency/:currencyCode", handler.GetCurrency)
	api.Patch("/currency/", handler.UpdateDatabase)
	api.Post("/currency/", handler.UpdateAMOS)

	// Scheduler
	// c := cron.New()
	// c.AddFunc("0 0 0 * * *", func() {
	// 	t := time.Now().UTC()
	// 	d := t.Weekday()

	// 	if d != time.Saturday && d != time.Sunday {
	// 		service.UpdateAMOS(context.Background(), t.Format("2006-01-02"))
	// 	}
	// })
	// c.Start()
}
