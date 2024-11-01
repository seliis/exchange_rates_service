package repositories

import (
	"fmt"
	"log"
	"package/server/config"
	"package/server/http"
	"package/server/internal/models"
	"time"
)

type ExchangeRepository struct {
}

func NewExchangeRepository() ExchangeRepository {
	return ExchangeRepository{}
}

func (r ExchangeRepository) GetPrimitives(date string) ([]models.Primitive, error) {
	url := fmt.Sprintf("%s?authkey=%s&searchdate=%s&data=%s", config.Data.Base, config.Data.ApiKey, date, config.Data.DataType)

	var primitives []models.Primitive
	const max = 10

	for i := 0; i < max; i++ {
		response, err := http.Instance.Get(url)
		if err != nil {
			log.Printf("can't get primitives from url: %s, try: %d", url, i)
			time.Sleep(3 * time.Second)
			continue
		}

		if err := response.JSON(&primitives); err != nil {
			log.Printf("can't parse response from url: %s, try: %d", url, i)
			time.Sleep(3 * time.Second)
			continue
		}

		return primitives, nil
	}

	return nil, fmt.Errorf("can't get primitives from url: %s", url)
}
