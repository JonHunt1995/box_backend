package main

import (
	"net/http"

	"github.com/labstack/echo/v5"
)

func (app *app) RegisterRoutes(e *echo.Echo, ) {
	e.GET("/", func(c *echo.Context) error {
		return c.JSON(http.StatusOK, map[string]string{"message": "Hello, World!"})
	})
	e.GET("/api/v1/:user_id", app.getUserBoxes)
	e.POST("/api/v1/:user_id", app.registerNewBoxes)
}
