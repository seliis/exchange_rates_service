package config

import (
	"encoding/json"
	"os"
)

type Config struct {
	AppName    string   `json:"app_name"`
	AppVersion string   `json:"app_version"`
	DebugMode  bool     `json:"debug_mode"`
	Base       string   `json:"base"`
	ApiKey     string   `json:"api_key"`
	DataType   string   `json:"data_type"`
	Port       string   `json:"port"`
	Currencies []string `json:"currencies"`
}

var Data *Config

func Load(path string) error {
	f, err := os.ReadFile(path)
	if err != nil {
		return err
	}

	if err := json.Unmarshal(f, &Data); err != nil {
		return err
	}

	return nil
}
