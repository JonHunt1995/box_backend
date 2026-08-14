package main

import (
	"net/http"
	"sync"

	"github.com/labstack/echo/v5"
	"github.com/labstack/echo/v5/middleware"
)

type Box struct {
	Name     string   `json:"name"`
	Contents []string `json:"contents"`
}

type Cache struct {
	mu   sync.RWMutex
	data map[string][]Box
}

type app struct {
	DB *Cache
}

type User struct {
	Name  string `json:"name"`
	Rooms []Box  `json:"boxes"`
}

func (a *app) getUserBoxes(c *echo.Context) error {
	userID := c.Param("user_id")
	a.DB.mu.Lock()
	defer a.DB.mu.Unlock()

	boxes, found := a.DB.data[userID]

	if !found {
		return c.String(http.StatusBadRequest, "bad request")
	}

	user := User{Name: userID, Rooms: boxes}
	return c.JSON(http.StatusOK, user)
}

func (a *app) registerNewBoxes(c *echo.Context) error {
	userID := c.Param("user_id")
	var box Box
	if err := c.Bind(&box); err != nil {
		return c.String(http.StatusBadRequest, err.Error())
	}

	a.DB.mu.Lock()
	defer a.DB.mu.Unlock()
	boxes, ok := a.DB.data[userID]
	c.Logger().Debug("did it make it here? kinda doubtful")
	if !ok {
		a.DB.data[userID] = []Box{box}
		return c.NoContent(http.StatusCreated)
	}

	a.DB.data[userID] = append(boxes, box)
	return c.NoContent(http.StatusCreated)
}

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
	e.GET("/", func(c *echo.Context) error {
		return c.JSON(http.StatusOK, map[string]string{"message": "Hello, World!"})
	})
	e.GET("/api/v1/:user_id", app.getUserBoxes)
	e.POST("/api/v1/:user_id", app.registerNewBoxes)

	if err := e.Start(":1323"); err != nil {
		e.Logger.Error("failed to start server", "error", err)
	}
}
