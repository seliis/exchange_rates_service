package models

import "github.com/uptrace/bun"

type Exchange struct {
	bun.BaseModel `bun:"table:exchanges,alias:exchanges"`

	Currency  string  `json:"currency" bun:"currency,notnull"`
	Date      string  `json:"date" bun:"date,notnull"`
	Rates     float64 `json:"rates" bun:"rates,notnull"`
	AmosRates float64 `json:"amos_rates" bun:"amos_rates,notnull"`
}
