package db

import (
	"context"
	"database/sql"
)

type Storer interface {
	Querier
	ExecTx(ctx context.Context, fn func(Querier) error) error
}

type Repo struct {
	*Queries
	db *sql.DB
}

func NewRepo(db *sql.DB) Storer {
	return &Repo{
		Queries: New(db),
		db:      db,
	}
}

func (r *Repo) ExecTx(ctx context.Context, fn func(Querier) error) error {
	tx, err := r.db.BeginTx(ctx, nil)
	if err != nil {
		return err
	}

	defer tx.Rollback()
	q := r.Queries.WithTx(tx)
	err = fn(q)

	if err != nil {
		return err
	}

	return tx.Commit()
}