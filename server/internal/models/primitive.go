package models

type Primitive struct {
	RequestResult           int    `json:"result"`
	CurrencyCode            string `json:"cur_unit"`
	CurrencyName            string `json:"cur_nm"`
	BuyingRate              string `json:"ttb"`
	SellingRate             string `json:"tts"`
	ExchangeRate            string `json:"deal_bas_r"`
	BookPrice               string `json:"bkpr"`
	YearHigh                string `json:"yy_efee_r"`
	TenDaysHigh             string `json:"ten_dd_efee_r"`
	MoneyBrokerExchangeRate string `json:"kftc_deal_bas_r"`
	MoneyBrokerBookPrice    string `json:"yy_kftc_bkpr"`
}
