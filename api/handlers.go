package main

import (
	"net/http"
	"strconv"
	"time"

	"github.com/labstack/echo/v5"
)

type BoxItem struct {
	ID        string    `json:"id"`
	UpdatedAt time.Time `json:"updatedAt"`
	Quantity  int       `json:"quantity"`
}

type Box struct {
	ID string `json:"id"`
}

type User struct {
	Boxes []Box `json:"boxes"`
}

func (a *app) getUserBoxes(c *echo.Context) error {
	userID, err := echo.PathParam[int](c, "user_id")
	if err != nil {
		return err
	}

	ctx := c.Request().Context()
	dbBoxes, err := a.Users.ReadBoxes(ctx, userID)
	if err != nil {
		return c.String(http.StatusBadRequest, err.Error())
	}

	boxes := make([]Box, len(dbBoxes))
	for i, dbBox := range dbBoxes {
		boxes[i] = Box{ID: strconv.Itoa(int(dbBox.BoxID))}
	}
	user := User{
		Boxes: boxes,
	}
	return c.JSON(http.StatusOK, user)
}

func (a *app) registerNewBoxes(c *echo.Context) error {
	userID, err := echo.PathParam[int](c, "user_id")
	if err != nil {
		return err
	}

	ctx := c.Request().Context()
	a.Boxes.Create(ctx, userID, "")
	return c.NoContent(http.StatusCreated)
}
