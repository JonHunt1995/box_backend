-- ==========================================
-- USERS
-- ==========================================

-- name: CreateUser :one
INSERT INTO boombox.users (username, display_name)
VALUES ($1, $2)
RETURNING user_id, username, display_name, is_active, created_at, updated_at;

-- name: GetUserByID :one
SELECT user_id, username, display_name, is_active, created_at, updated_at
FROM boombox.users
WHERE user_id = $1;

-- name: GetUserByUsername :one
SELECT user_id, username, display_name, is_active, created_at, updated_at
FROM boombox.users
WHERE username = $1;

-- name: UpdateUserDisplayName :one
UPDATE boombox.users
SET display_name = $2,
    updated_at = now()
WHERE user_id = $1
RETURNING user_id, username, display_name, is_active, created_at, updated_at;

-- name: DeactivateUser :one
UPDATE boombox.users
SET is_active = false,
    updated_at = now()
WHERE user_id = $1
RETURNING user_id, username, display_name, is_active, created_at, updated_at;


-- ==========================================
-- OAUTH ACCOUNT
-- ==========================================

-- name: UpsertGithubOAuthAccount :one
INSERT INTO boombox.oauth_account (
    user_id,
    provider,
    provider_user_id,
    provider_login,
    provider_email,
    access_token,
    refresh_token,
    token_type,
    scope,
    expires_at,
    revoked_at,
    last_used_at
)
VALUES (
    $1,                 -- user_id
    'github',
    $2,                 -- provider_user_id
    $3,                 -- provider_login
    $4,                 -- provider_email
    $5,                 -- access_token
    $6,                 -- refresh_token
    COALESCE($7, 'bearer'),
    $8,                 -- scope
    $9,                 -- expires_at
    NULL,
    now()
)
ON CONFLICT (provider, provider_user_id)
DO UPDATE SET
    provider_login = EXCLUDED.provider_login,
    provider_email = EXCLUDED.provider_email,
    access_token   = EXCLUDED.access_token,
    refresh_token  = EXCLUDED.refresh_token,
    token_type     = EXCLUDED.token_type,
    scope          = EXCLUDED.scope,
    expires_at     = EXCLUDED.expires_at,
    revoked_at     = NULL,
    last_used_at   = now(),
    updated_at     = now()
RETURNING
    oauth_account_id, user_id, provider, provider_user_id, provider_login, provider_email,
    access_token, refresh_token, token_type, scope, expires_at, revoked_at, last_used_at,
    created_at, updated_at;

-- name: GetOAuthAccountByProviderUserID :one
SELECT
    oauth_account_id, user_id, provider, provider_user_id, provider_login, provider_email,
    access_token, refresh_token, token_type, scope, expires_at, revoked_at, last_used_at,
    created_at, updated_at
FROM boombox.oauth_account
WHERE provider = 'github'
  AND provider_user_id = $1;

-- name: GetOAuthAccountByUserID :one
SELECT
    oauth_account_id, user_id, provider, provider_user_id, provider_login, provider_email,
    access_token, refresh_token, token_type, scope, expires_at, revoked_at, last_used_at,
    created_at, updated_at
FROM boombox.oauth_account
WHERE user_id = $1
  AND provider = 'github';

-- name: RevokeOAuthAccount :one
UPDATE boombox.oauth_account
SET revoked_at = now(),
    updated_at = now()
WHERE oauth_account_id = $1
RETURNING
    oauth_account_id, user_id, provider, provider_user_id, provider_login, provider_email,
    access_token, refresh_token, token_type, scope, expires_at, revoked_at, last_used_at,
    created_at, updated_at;


-- ==========================================
-- BOX
-- ==========================================

-- name: CreateBox :one
INSERT INTO boombox.box (user_id, box_name, image_url)
VALUES ($1, $2, $3)
RETURNING box_id, user_id, box_name, image_url, created_at, updated_at;

-- name: GetBoxByID :one
SELECT box_id, user_id, box_name, image_url, created_at, updated_at
FROM boombox.box
WHERE box_id = $1;

-- name: GetBoxByImageURL :one
SELECT box_id, user_id, box_name, image_url, created_at, updated_at
FROM boombox.box
WHERE image_url = $1;

-- name: ListBoxesByUser :many
SELECT box_id, user_id, box_name, image_url, created_at, updated_at
FROM boombox.box
WHERE user_id = $1
ORDER BY box_name;

-- name: RenameBox :one
UPDATE boombox.box
SET box_name = $2,
    updated_at = now()
WHERE box_id = $1
RETURNING box_id, user_id, box_name, image_url, created_at, updated_at;

-- name: DeleteBox :exec
DELETE FROM boombox.box
WHERE box_id = $1;


-- ==========================================
-- ITEM
-- ==========================================

-- name: CreateItem :one
INSERT INTO boombox.item (item_name)
VALUES ($1)
RETURNING item_id, item_name, created_at;

-- name: GetItemByName :one
SELECT item_id, item_name, created_at
FROM boombox.item
WHERE item_name = $1;

-- name: ListItems :many
SELECT item_id, item_name, created_at
FROM boombox.item
ORDER BY item_name;


-- ==========================================
-- BOX_ITEM (JUNCTION)
-- ==========================================

-- name: AddItemToBoxByIDs :one
INSERT INTO boombox.box_item (box_id, item_id, quantity)
VALUES ($1, $2, $3)
ON CONFLICT (box_id, item_id)
DO UPDATE SET
    quantity = boombox.box_item.quantity + EXCLUDED.quantity,
    updated_at = now()
RETURNING box_id, item_id, quantity, created_at, updated_at;

-- name: AddItemToBoxByImageURL :one
WITH target_box AS (
    SELECT box_id FROM boombox.box WHERE image_url = $1
),
target_item AS (
    INSERT INTO boombox.item (item_name)
    VALUES ($2)
    ON CONFLICT (item_name) DO UPDATE SET item_name = EXCLUDED.item_name
    RETURNING item_id
)
INSERT INTO boombox.box_item (box_id, item_id, quantity)
SELECT tb.box_id, ti.item_id, $3
FROM target_box tb
CROSS JOIN target_item ti
ON CONFLICT (box_id, item_id)
DO UPDATE SET
    quantity = boombox.box_item.quantity + EXCLUDED.quantity,
    updated_at = now()
RETURNING box_id, item_id, quantity, created_at, updated_at;

-- name: RemoveItemFromBoxByImageURL :execrows
WITH target AS (
    SELECT bi.box_id, bi.item_id
    FROM boombox.box_item bi
    JOIN boombox.box b ON b.box_id = bi.box_id
    JOIN boombox.item i ON i.item_id = bi.item_id
    WHERE b.image_url = $1
      AND i.item_name = $2
      AND bi.quantity >= $3
)
UPDATE boombox.box_item bi
SET quantity = bi.quantity - $3,
    updated_at = now()
FROM target t
WHERE bi.box_id = t.box_id
  AND bi.item_id = t.item_id;

-- name: DeleteZeroQuantityBoxItems :execrows
DELETE FROM boombox.box_item
WHERE quantity = 0;

-- name: GetBoxContentsByImageURL :many
SELECT
    b.box_id,
    b.box_name,
    b.image_url,
    i.item_id,
    i.item_name,
    bi.quantity,
    bi.updated_at
FROM boombox.box b
JOIN boombox.box_item bi ON bi.box_id = b.box_id
JOIN boombox.item i ON i.item_id = bi.item_id
WHERE b.image_url = $1
ORDER BY i.item_name;

-- name: GetBoxContentsByBoxID :many
SELECT
    b.box_id,
    b.box_name,
    b.image_url,
    i.item_id,
    i.item_name,
    bi.quantity,
    bi.updated_at
FROM boombox.box b
JOIN boombox.box_item bi ON bi.box_id = b.box_id
JOIN boombox.item i ON i.item_id = bi.item_id
WHERE b.box_id = $1
ORDER BY i.item_name;

-- name: SetBoxItemQuantityByIDs :one
UPDATE boombox.box_item
SET quantity = $3,
    updated_at = now()
WHERE box_id = $1
  AND item_id = $2
RETURNING box_id, item_id, quantity, created_at, updated_at;

-- name: RemoveBoxItemByIDs :exec
DELETE FROM boombox.box_item
WHERE box_id = $1
  AND item_id = $2;
