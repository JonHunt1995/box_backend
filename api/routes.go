package main

import (
	"net/http"

	"github.com/labstack/echo/v5"
)

func (app *app) RegisterRoutes(e *echo.Echo) {
	e.GET("/", func(c *echo.Context) error {
		return c.JSON(http.StatusOK, map[string]string{"message": "Hello, World!"})
	})
	e.GET("/api/v1/:user_id/boxes", app.getUserBoxes)
	e.POST("/api/v1/:user_id/add-box", app.registerNewBoxes)
	//e.GET("/api/v1/items/:box_id", app.getItemsFromBox)
	//e.POST("/api/v1/items/:box_id/update", app.addItemsToBox)
	//e.DELETE("/api/v1/items/:box_id/update", app.deleteItemsFromBox)
	//e.Get("/api/v1/:user_id/profile", app.)
}
