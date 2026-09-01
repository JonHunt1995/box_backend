ifneq (,$(wildcard ./.env))
    include .env
    export
endif

.PHONY: dev down clean reset migrate-up migrate-down psql

# Start up the environment
dev:
	docker compose up --build

# Tear down the containers but keeps the database data intact
down:
	docker compose down

# Tear down containers AND blow up the database completely (deletes volumes)
clean:
	docker compose down -v

# blows everything up, then starts fresh
reset: clean dev

migrate-up:
	GOOSE_DBSTRING="postgres://user:user@localhost:5432/mydb?sslmode=disable" goose -dir ./db/migrations up

migrate-down:
	GOOSE_DBSTRING="postgres://user:user@localhost:5432/mydb?sslmode=disable" goose -dir ./db/migrations down

migrate-reset:
	# This wipes everything!
	GOOSE_DBSTRING="postgres://user:user@localhost:5432/mydb?sslmode=disable" goose -dir ./db/migrations reset

psql:
	docker compose exec postgres psql -U $(POSTGRES_USER) -d $(POSTGRES_DB)