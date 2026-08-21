package main

import (
	"sync"

	"github.com/labstack/echo/v5"
	"github.com/labstack/echo/v5/middleware"
)

func main() {
	e := echo.New()

	e.Use(middleware.RequestLogger())
	e.Use(middleware.Recover())

	app := app{
		DB: &Cache{
			mu:   sync.RWMutex{},
			data: make(map[string][]Box),
		},
	}

	app.RegisterRoutes(e)

	if err := e.Start(":1323"); err != nil {
		e.Logger.Error("failed to start server", "error", err)
	}
}
