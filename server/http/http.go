package http

import (
	"crypto/tls"
	"time"

	"github.com/gofiber/fiber/v3/client"
)

var Instance *client.Client

func Start() {
	instance := client.New()

	instance.SetCookieJar(client.AcquireCookieJar())
	instance.SetTimeout(10 * time.Second)
	instance.SetTLSConfig(&tls.Config{
		InsecureSkipVerify: true,
	})

	Instance = instance
}
