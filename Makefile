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
	# Make automatically grabs $(GOOSE_MIGRATION_DIR) from the .env file!
	goose -dir $(GOOSE_MIGRATION_DIR) $(GOOSE_DRIVER) "${GOOSE_DBSTRING}" up

migrate-down:
	goose -dir $(GOOSE_MIGRATION_DIR) $(GOOSE_DRIVER) "${GOOSE_DBSTRING}" down

psql:
	docker compose exec postgres psql -U $(POSTGRES_USER) -d $(POSTGRES_DB)