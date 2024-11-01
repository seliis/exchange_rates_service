package database

import (
	"context"
	"database/sql"
	"package/server/internal/models"

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

func CreateScheme() error {
	_, err := Instance.NewCreateTable().IfNotExists().Model((*models.Exchange)(nil)).Exec(context.Background())
	if err != nil {
		return err
	}

	return nil
}
