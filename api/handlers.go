package main

import (
	"log"
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
	ID   string `json:"id"`
	Name string `json:"name"`
}

type User struct {
	Boxes []Box `json:"boxes"`
}

// getUserBoxes godoc
//
//	@Summary	Get all boxes from a user based off of the user id
//	@Tags		Boxes
//	@Accept		json
//	@Produce	json
//	@Param		user_id	path		int	true	"Unique user id"
//	@Success	200		{object}	User
//	@Failure	400		{string}	string	"Bad Request: (error description)"
//
//	@Failure	404		{string}	string	"User Not Found"
//
//	@Router		/{user_id}/boxes [get]
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
		boxes[i] = Box{ID: strconv.Itoa(int(dbBox.BoxID)), Name: dbBox.BoxName}
	}
	user := User{
		Boxes: boxes,
	}
	return c.JSON(http.StatusOK, user)
}

// registerNewBoxes godoc
//
//	@Summary	Add a box to a user's collection
//	@Tags		Boxes
//	@Param		user_id	path	int	true	"Unique user id"
//	@Success	201
//	@Failure	400	{string}	string	"Bad Request: (error description)"
//	@Failure	404	{string}	string	"User Not Found"
//	@Router		/{user_id}/add-box [post]
func (a *app) registerNewBoxes(c *echo.Context) error {
	userID, err := echo.PathParam[int](c, "user_id")
	if err != nil {
		return c.String(http.StatusBadRequest, err.Error())
	}

	ctx := c.Request().Context()
	result, err := a.Boxes.Create(ctx, userID, "test")
	if err != nil {
		return c.String(http.StatusBadRequest, err.Error())
	}
	log.Println(result)
	return c.NoContent(http.StatusCreated)
}
