package user

import (
	"context"

	"inventorybox.com/db"
)

type Service struct {
	repo db.Storer
}

type Request struct {

}

func New(repo db.Storer) *Service {
	return &Service{repo: repo}
}

func (s *Service) Create(ctx context.Context) (db.BoomboxUser, error) {
	
}
