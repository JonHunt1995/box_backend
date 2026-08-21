package item

import (
	"context"
	"errors"

	"inventorybox.com/db"
)

type Service struct {
	repo db.Querier
}

type Request struct {
	name string
}

func New(repo db.Querier) *Service {
	return &Service{repo: repo}
}

func (s *Service) Create(ctx context.Context, name string) (db.BoomboxItem, error) {
	if name == "" {
		return db.BoomboxItem{}, errors.New("item requires name")
	}
	return s.repo.CreateItem(ctx, name)
}

func Read(ctx context.Context, )
