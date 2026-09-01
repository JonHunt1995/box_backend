package user

import (
	"context"
	"database/sql"
	"errors"

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

func (s *Service) Create(ctx context.Context, userName string, displayName string) (db.BoomboxUser, error) {
	if min(len(userName), len(displayName)) == 0 {
		return db.BoomboxUser{}, errors.New("missing display name or username")
	}
	return s.repo.CreateUser(ctx, db.CreateUserParams{Username: userName, DisplayName: sql.NullString{String: displayName}})
}

func (s *Service) ReadBoxes(ctx context.Context, userID int) ([]db.BoomboxBox, error) {
	return s.repo.ListBoxesByUser(ctx, int64(userID))
}

func (s *Service) Delete(ctx context.Context, userID int) (db.BoomboxUser, error) {
	return s.repo.DeactivateUser(ctx, int64(userID))
}

func (s *Service) UpdateUsername(ctx context.Context, userID int, newName string) (db.BoomboxUser, error) {
	if newName == "" {
		return db.BoomboxUser{}, errors.New("missing new username")
	}
	return s.repo.UpdateUserDisplayName(ctx, db.UpdateUserDisplayNameParams{UserID: int64(userID), DisplayName: sql.NullString{String: newName}})
}
