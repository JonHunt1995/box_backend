package main

import (
	"sync"

	"inventorybox.com/db"
)

type app struct {
	DB db.Querier
}

type Box struct {
	Name     string   `json:"name"`
	Contents []string `json:"contents"`
}

type Cache struct {
	mu   sync.RWMutex
	data map[string][]Box
}

type User struct {
	Name  string `json:"name"`
	Rooms []Box  `json:"boxes"`
}
