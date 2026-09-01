package main

import (
	"inventorybox.com/api/box"
	"inventorybox.com/api/boxItem"
	"inventorybox.com/api/user"
)

type app struct {
	Users    *user.Service
	Boxes    *box.Service
	BoxItems *boxItem.Service
}
