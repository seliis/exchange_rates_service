package database

import (
	"context"
	"database/sql"
	"package/server/config"
	"package/server/internal/entities"

	"github.com/uptrace/bun"
	"github.com/uptrace/bun/dialect/sqlitedialect"
	"github.com/uptrace/bun/driver/sqliteshim"
)

var Instance *bun.DB

func Connect() error {
	instance, err := sql.Open(sqliteshim.ShimName, "file:database.db?cache=shared")
	if err != nil {
		return err
	}

	Instance = bun.NewDB(instance, sqlitedialect.New())

	return nil
}

func ResetDatabase(context context.Context) error {
	if _, err := Instance.NewDropTable().Model((*entities.CurrencyBasicData)(nil)).IfExists().Exec(context); err != nil {
		return err
	}

	if _, err := Instance.NewDropTable().Model((*entities.Currency)(nil)).IfExists().Exec(context); err != nil {
		return err
	}

	return nil
}

func CreateScheme(context context.Context) error {
	if config.ServerConfig.IsDebugMode {
		if err := ResetDatabase(context); err != nil {
			return err
		}
	}

	if _, err := Instance.NewCreateTable().IfNotExists().Model((*entities.CurrencyBasicData)(nil)).Exec(context); err != nil {
		return err
	}

	if _, err := Instance.NewCreateTable().IfNotExists().Model((*entities.Currency)(nil)).Exec(context); err != nil {
		return err
	}

	return nil
}

func UpsertCurrencyBasicData(context context.Context) error {
	currencies := config.ServerConfig.DataSource.SupportedCurrencies

	for _, currency := range currencies {
		data := entities.CurrencyBasicData{
			CurrencyCode: currency.CurrencyCode,
			CurrencyName: currency.CurrencyName,
		}
		if _, err := Instance.NewInsert().Model(&data).On("conflict (currency_code) do update").Set("currency_name = ?", data.CurrencyName).Exec(context); err != nil {
			return err
		}
	}

	return nil
}
