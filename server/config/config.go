package config

import (
	"encoding/json"
	"os"
)

var ServerConfig *ServerConfiguration

type ServerConfiguration struct {
	AppName     string `json:"app_name"`
	AppVersion  string `json:"app_version"`
	IsDebugMode bool   `json:"is_debug_mode"`
	Port        string `json:"port"`
	AMOS        struct {
		BaseURL   string `json:"base_url"`
		EndPoints struct {
			ImportCurrency string `json:"import_currency"`
		} `json:"end_points"`
		Auth struct {
			ID       string `json:"id"`
			Password string `json:"password"`
		} `json:"auth"`
		KeyCurrencyCode string `json:"key_currency_code"`
	} `json:"amos"`
	StandardCurrencyCode string `json:"standard_currency_code"`
	DataSource           struct {
		Name                string `json:"name"`
		BaseURL             string `json:"base_url"`
		APIKey              string `json:"api_key"`
		DataType            string `json:"data_type"`
		SupportedCurrencies []struct {
			CurrencyCode string `json:"currency_code"`
			CurrencyName string `json:"currency_name"`
			IsApplicable bool   `json:"is_applicable"`
		} `json:"supported_currencies"`
	} `json:"data_source"`
}

func Load(path string) error {
	f, err := os.ReadFile(path)
	if err != nil {
		return err
	}

	if err := json.Unmarshal(f, &ServerConfig); err != nil {
		return err
	}

	return nil
}
