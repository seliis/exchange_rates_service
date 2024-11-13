package debug

import (
	"io"
	"log"
	"os"
	"package/server/config"
)

func Start(fileName string) error {
	if !config.ServerConfig.IsDebugMode {
		return nil
	}

	f, err := os.OpenFile(fileName, os.O_CREATE|os.O_WRONLY|os.O_APPEND, 0666)
	if err != nil {
		return err
	}

	log.SetFlags(log.Ldate | log.Ltime | log.Lshortfile)
	log.SetOutput(io.MultiWriter(os.Stdout, f))
	log.SetPrefix("[DEBUG]: ")

	return nil
}
