-- +goose Up
CREATE SCHEMA IF NOT EXISTS boombox;
SET search_path TO boombox, public;

CREATE EXTENSION IF NOT EXISTS citext;

CREATE TABLE IF NOT EXISTS boombox.users (
    user_id         BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    username        CITEXT NOT NULL UNIQUE,
    display_name    TEXT,
    is_active       BOOLEAN NOT NULL DEFAULT true,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS boombox.oauth_account (
    oauth_account_id        BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    user_id                 BIGINT NOT NULL REFERENCES boombox.users(user_id) ON DELETE CASCADE,
    provider                TEXT NOT NULL CHECK (provider IN ('github')),
    provider_user_id        TEXT NOT NULL,
    provider_login          CITEXT,
    provider_email          CITEXT,
    access_token            TEXT NOT NULL,
    refresh_token           TEXT,
    token_type              TEXT NOT NULL DEFAULT 'bearer',
    scope                   TEXT,
    expires_at              TIMESTAMPTZ,
    revoked_at              TIMESTAMPTZ,
    last_used_at            TIMESTAMPTZ,
    created_at              TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at              TIMESTAMPTZ NOT NULL DEFAULT now(),
    CONSTRAINT uq_oauth_provider_user UNIQUE (provider, provider_user_id),
    CONSTRAINT uq_oauth_user_provider UNIQUE (user_id, provider)
);

CREATE INDEX IF NOT EXISTS idx_oauth_user_id
    ON boombox.oauth_account (user_id);

CREATE INDEX IF NOT EXISTS idx_oauth_provider_login
    ON boombox.oauth_account (provider, provider_login);

CREATE INDEX IF NOT EXISTS idx_oauth_expires_at
    ON boombox.oauth_account (expires_at);

CREATE TABLE IF NOT EXISTS boombox.box (
    box_id         BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    user_id        BIGINT NOT NULL REFERENCES boombox.users(user_id) ON DELETE CASCADE,
    box_name       TEXT NOT NULL,
    image_url      TEXT NOT NULL UNIQUE,
    created_at     TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at     TIMESTAMPTZ NOT NULL DEFAULT now(),
    CONSTRAINT uq_box_user_name UNIQUE (user_id, box_name),
    CONSTRAINT chk_box_image_url_not_blank CHECK (length(trim(image_url)) > 0)
);

CREATE INDEX IF NOT EXISTS idx_box_user_id
    ON boombox.box(user_id);

CREATE TABLE IF NOT EXISTS boombox.item (
    item_id        BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    item_name      TEXT NOT NULL UNIQUE,
    created_at     TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS boombox.box_item (
    box_id         BIGINT NOT NULL REFERENCES boombox.box(box_id) ON DELETE CASCADE,
    item_id        BIGINT NOT NULL REFERENCES boombox.item(item_id) ON DELETE RESTRICT,
    quantity       INTEGER NOT NULL DEFAULT 1 CHECK (quantity > 0),
    created_at     TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at     TIMESTAMPTZ NOT NULL DEFAULT now(),
    PRIMARY KEY (box_id, item_id)
);

CREATE INDEX IF NOT EXISTS idx_box_item_item_id
    ON boombox.box_item(item_id);

-- +goose Down
DROP SCHEMA IF EXISTS boombox CASCADE;