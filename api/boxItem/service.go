package boxItem

import (
	"context"

	"inventorybox.com/db"
)

type Service struct {
	repo db.Storer
}

type Request struct {
	ItemID    string `json:"itemID"`
	UpdatedAt string `json:"updatedAt"`
	ItemName  string `json:"itemName"`
	Quantity  int    `json:"quantity"`
	ImageURL  string `json:"imageURL"`
}

func New(repo db.Storer) *Service {
	return &Service{repo: repo}
}

func (s *Service) Create(ctx context.Context, boxID int64, itemID int64, quantity int32) (db.BoomboxBoxItem, error) {
	return s.repo.AddItemToBoxByIDs(ctx, db.AddItemToBoxByIDsParams{BoxID: boxID, ItemID: itemID, Quantity: quantity})
}

func (s *Service) Read(ctx context.Context, itemName string) (db.BoomboxItem, error) {
	return s.repo.GetItemByName(ctx, itemName)
}
