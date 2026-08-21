package box

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

func (s *Service) Create(ctx context.Context, name string) (db.BoomboxBox, error) {
	if name == "" {
		return db.BoomboxBox{}, errors.New("item requires name")
	}
	return s.repo.CreateBox(ctx, db.CreateBoxParams{})
}