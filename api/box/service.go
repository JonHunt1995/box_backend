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
// 
// Box
// {
//   boxId: string; // <- query param
//   boxItems: BoxItem[];
// }

// User
// {
//   boxIds: Box[];
// }
type Response struct {
	boxID string
}

func New(repo db.Querier) *Service {
	return &Service{repo: repo}
}

func (s *Service) Create(ctx context.Context, userID int, name string) (db.BoomboxBox, error) {
	if name == "" {
		return db.BoomboxBox{}, errors.New("item requires name")
	}
	return s.repo.CreateBox(ctx, db.CreateBoxParams{
		UserID: int64(userID),
		BoxName: name,
		ImageUrl: "",
	})
}