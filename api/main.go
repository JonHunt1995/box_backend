package main

import (
	"context"
	"database/sql"
	"log"
	"os"
	"time"

	_ "github.com/jackc/pgx/v5/stdlib"

	"github.com/labstack/echo/v5"
	"github.com/labstack/echo/v5/middleware"
	"inventorybox.com/api/box"
	"inventorybox.com/api/boxItem"
	"inventorybox.com/api/user"
	"inventorybox.com/db"
)

func main() {
	e := echo.New()

	e.Use(middleware.RequestLogger())
	e.Use(middleware.Recover())
	e.Use(middleware.ContextTimeout(5 * time.Second))

	conn, err := sql.Open("pgx", os.Getenv("GOOSE_DBSTRING"))
	if err != nil {
		log.Fatal("cannot connect to db:", err)
	}
	defer conn.Close()

	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()
	if err := conn.PingContext(ctx); err != nil {
		log.Fatal("cannot connect to db:", err)
	}

	conn.SetMaxIdleConns(10)
	conn.SetMaxOpenConns(10)
	conn.SetConnMaxLifetime(5 * time.Minute)

	repo := db.NewRepo(conn)

	app := &app{
		Users:    user.New(repo),
		Boxes:    box.New(repo),
		BoxItems: boxItem.New(repo),
	}

	app.RegisterRoutes(e)

	if err := e.Start(":1323"); err != nil {
		e.Logger.Error("failed to start server", "error", err)
	}
}
