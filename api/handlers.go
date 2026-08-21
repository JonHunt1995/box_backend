package main

import (
	"net/http"

	"github.com/labstack/echo/v5"
)

func (a *app) getUserBoxes(c *echo.Context) error {
	userID := c.Param("user_id")
	a.DB.mu.Lock()
	defer a.DB.mu.Unlock()

	boxes, found := a.DB.data[userID]

	if !found {
		return c.String(http.StatusBadRequest, "bad request")
	}
	
	user := user.Response{Name: userID, Rooms: boxes}
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
