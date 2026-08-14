-- +goose Up
SET search_path TO boombox, public;

-- ------------------------------------------
-- USERS (5)
-- ------------------------------------------
INSERT INTO boombox.users (username, display_name) VALUES
('alice', 'Alice Johnson'),
('bob', 'Bob Smith'),
('carol', 'Carol Davis'),
('dave', 'Dave Miller'),
('eve', 'Eve Wilson')
ON CONFLICT (username) DO NOTHING;

-- ------------------------------------------
-- OAUTH ACCOUNTS (one github account per user)
-- Note: access_token values are fake demo tokens
-- ------------------------------------------
INSERT INTO boombox.oauth_account (
    user_id, provider, provider_user_id, provider_login, provider_email,
    access_token, refresh_token, token_type, scope, expires_at, revoked_at, last_used_at
)
SELECT u.user_id, 'github', 'ghu_alice_1001', 'alice-gh', 'alice@example.dev',
       'demo_token_alice', NULL, 'bearer', 'read:user,user:email', NULL, NULL, now()
FROM boombox.users u WHERE u.username = 'alice'
ON CONFLICT (provider, provider_user_id) DO NOTHING;

INSERT INTO boombox.oauth_account (
    user_id, provider, provider_user_id, provider_login, provider_email,
    access_token, refresh_token, token_type, scope, expires_at, revoked_at, last_used_at
)
SELECT u.user_id, 'github', 'ghu_bob_1002', 'bob-gh', 'bob@example.dev',
       'demo_token_bob', NULL, 'bearer', 'read:user,user:email', NULL, NULL, now()
FROM boombox.users u WHERE u.username = 'bob'
ON CONFLICT (provider, provider_user_id) DO NOTHING;

INSERT INTO boombox.oauth_account (
    user_id, provider, provider_user_id, provider_login, provider_email,
    access_token, refresh_token, token_type, scope, expires_at, revoked_at, last_used_at
)
SELECT u.user_id, 'github', 'ghu_carol_1003', 'carol-gh', 'carol@example.dev',
       'demo_token_carol', NULL, 'bearer', 'read:user,user:email', NULL, NULL, now()
FROM boombox.users u WHERE u.username = 'carol'
ON CONFLICT (provider, provider_user_id) DO NOTHING;

INSERT INTO boombox.oauth_account (
    user_id, provider, provider_user_id, provider_login, provider_email,
    access_token, refresh_token, token_type, scope, expires_at, revoked_at, last_used_at
)
SELECT u.user_id, 'github', 'ghu_dave_1004', 'dave-gh', 'dave@example.dev',
       'demo_token_dave', NULL, 'bearer', 'read:user,user:email', NULL, NULL, now()
FROM boombox.users u WHERE u.username = 'dave'
ON CONFLICT (provider, provider_user_id) DO NOTHING;

INSERT INTO boombox.oauth_account (
    user_id, provider, provider_user_id, provider_login, provider_email,
    access_token, refresh_token, token_type, scope, expires_at, revoked_at, last_used_at
)
SELECT u.user_id, 'github', 'ghu_eve_1005', 'eve-gh', 'eve@example.dev',
       'demo_token_eve', NULL, 'bearer', 'read:user,user:email', NULL, NULL, now()
FROM boombox.users u WHERE u.username = 'eve'
ON CONFLICT (provider, provider_user_id) DO NOTHING;

-- ------------------------------------------
-- ITEMS (10)
-- ------------------------------------------
INSERT INTO boombox.item (item_name) VALUES
('HDMI Cable'),
('USB-C Cable'),
('Ethernet Cable'),
('Power Adapter'),
('Wireless Mouse'),
('Keyboard'),
('Notebook'),
('Marker Pack'),
('AA Batteries'),
('Phone Charger')
ON CONFLICT (item_name) DO NOTHING;

-- ------------------------------------------
-- BOXES (20) - 4 per user
-- Canonical QR identifier is image_url
-- ------------------------------------------
INSERT INTO boombox.box (user_id, box_name, image_url)
SELECT u.user_id, 'Alice Box 01', 'https://img.boombox.dev/qr/alice-box-01.png' FROM boombox.users u WHERE u.username='alice'
ON CONFLICT (image_url) DO NOTHING;
INSERT INTO boombox.box (user_id, box_name, image_url)
SELECT u.user_id, 'Alice Box 02', 'https://img.boombox.dev/qr/alice-box-02.png' FROM boombox.users u WHERE u.username='alice'
ON CONFLICT (image_url) DO NOTHING;
INSERT INTO boombox.box (user_id, box_name, image_url)
SELECT u.user_id, 'Alice Box 03', 'https://img.boombox.dev/qr/alice-box-03.png' FROM boombox.users u WHERE u.username='alice'
ON CONFLICT (image_url) DO NOTHING;
INSERT INTO boombox.box (user_id, box_name, image_url)
SELECT u.user_id, 'Alice Box 04', 'https://img.boombox.dev/qr/alice-box-04.png' FROM boombox.users u WHERE u.username='alice'
ON CONFLICT (image_url) DO NOTHING;

INSERT INTO boombox.box (user_id, box_name, image_url)
SELECT u.user_id, 'Bob Box 01', 'https://img.boombox.dev/qr/bob-box-01.png' FROM boombox.users u WHERE u.username='bob'
ON CONFLICT (image_url) DO NOTHING;
INSERT INTO boombox.box (user_id, box_name, image_url)
SELECT u.user_id, 'Bob Box 02', 'https://img.boombox.dev/qr/bob-box-02.png' FROM boombox.users u WHERE u.username='bob'
ON CONFLICT (image_url) DO NOTHING;
INSERT INTO boombox.box (user_id, box_name, image_url)
SELECT u.user_id, 'Bob Box 03', 'https://img.boombox.dev/qr/bob-box-03.png' FROM boombox.users u WHERE u.username='bob'
ON CONFLICT (image_url) DO NOTHING;
INSERT INTO boombox.box (user_id, box_name, image_url)
SELECT u.user_id, 'Bob Box 04', 'https://img.boombox.dev/qr/bob-box-04.png' FROM boombox.users u WHERE u.username='bob'
ON CONFLICT (image_url) DO NOTHING;

INSERT INTO boombox.box (user_id, box_name, image_url)
SELECT u.user_id, 'Carol Box 01', 'https://img.boombox.dev/qr/carol-box-01.png' FROM boombox.users u WHERE u.username='carol'
ON CONFLICT (image_url) DO NOTHING;
INSERT INTO boombox.box (user_id, box_name, image_url)
SELECT u.user_id, 'Carol Box 02', 'https://img.boombox.dev/qr/carol-box-02.png' FROM boombox.users u WHERE u.username='carol'
ON CONFLICT (image_url) DO NOTHING;
INSERT INTO boombox.box (user_id, box_name, image_url)
SELECT u.user_id, 'Carol Box 03', 'https://img.boombox.dev/qr/carol-box-03.png' FROM boombox.users u WHERE u.username='carol'
ON CONFLICT (image_url) DO NOTHING;
INSERT INTO boombox.box (user_id, box_name, image_url)
SELECT u.user_id, 'Carol Box 04', 'https://img.boombox.dev/qr/carol-box-04.png' FROM boombox.users u WHERE u.username='carol'
ON CONFLICT (image_url) DO NOTHING;

INSERT INTO boombox.box (user_id, box_name, image_url)
SELECT u.user_id, 'Dave Box 01', 'https://img.boombox.dev/qr/dave-box-01.png' FROM boombox.users u WHERE u.username='dave'
ON CONFLICT (image_url) DO NOTHING;
INSERT INTO boombox.box (user_id, box_name, image_url)
SELECT u.user_id, 'Dave Box 02', 'https://img.boombox.dev/qr/dave-box-02.png' FROM boombox.users u WHERE u.username='dave'
ON CONFLICT (image_url) DO NOTHING;
INSERT INTO boombox.box (user_id, box_name, image_url)
SELECT u.user_id, 'Dave Box 03', 'https://img.boombox.dev/qr/dave-box-03.png' FROM boombox.users u WHERE u.username='dave'
ON CONFLICT (image_url) DO NOTHING;
INSERT INTO boombox.box (user_id, box_name, image_url)
SELECT u.user_id, 'Dave Box 04', 'https://img.boombox.dev/qr/dave-box-04.png' FROM boombox.users u WHERE u.username='dave'
ON CONFLICT (image_url) DO NOTHING;

INSERT INTO boombox.box (user_id, box_name, image_url)
SELECT u.user_id, 'Eve Box 01', 'https://img.boombox.dev/qr/eve-box-01.png' FROM boombox.users u WHERE u.username='eve'
ON CONFLICT (image_url) DO NOTHING;
INSERT INTO boombox.box (user_id, box_name, image_url)
SELECT u.user_id, 'Eve Box 02', 'https://img.boombox.dev/qr/eve-box-02.png' FROM boombox.users u WHERE u.username='eve'
ON CONFLICT (image_url) DO NOTHING;
INSERT INTO boombox.box (user_id, box_name, image_url)
SELECT u.user_id, 'Eve Box 03', 'https://img.boombox.dev/qr/eve-box-03.png' FROM boombox.users u WHERE u.username='eve'
ON CONFLICT (image_url) DO NOTHING;
INSERT INTO boombox.box (user_id, box_name, image_url)
SELECT u.user_id, 'Eve Box 04', 'https://img.boombox.dev/qr/eve-box-04.png' FROM boombox.users u WHERE u.username='eve'
ON CONFLICT (image_url) DO NOTHING;

-- ------------------------------------------
-- BOX_ITEM links (sample inventory)
-- ------------------------------------------
-- Alice Box 01
INSERT INTO boombox.box_item (box_id, item_id, quantity)
SELECT b.box_id, i.item_id, 3
FROM boombox.box b, boombox.item i
WHERE b.image_url='https://img.boombox.dev/qr/alice-box-01.png' AND i.item_name='HDMI Cable'
ON CONFLICT (box_id, item_id) DO UPDATE SET quantity = EXCLUDED.quantity;

INSERT INTO boombox.box_item (box_id, item_id, quantity)
SELECT b.box_id, i.item_id, 2
FROM boombox.box b, boombox.item i
WHERE b.image_url='https://img.boombox.dev/qr/alice-box-01.png' AND i.item_name='USB-C Cable'
ON CONFLICT (box_id, item_id) DO UPDATE SET quantity = EXCLUDED.quantity;

-- Bob Box 02
INSERT INTO boombox.box_item (box_id, item_id, quantity)
SELECT b.box_id, i.item_id, 5
FROM boombox.box b, boombox.item i
WHERE b.image_url='https://img.boombox.dev/qr/bob-box-02.png' AND i.item_name='AA Batteries'
ON CONFLICT (box_id, item_id) DO UPDATE SET quantity = EXCLUDED.quantity;

INSERT INTO boombox.box_item (box_id, item_id, quantity)
SELECT b.box_id, i.item_id, 1
FROM boombox.box b, boombox.item i
WHERE b.image_url='https://img.boombox.dev/qr/bob-box-02.png' AND i.item_name='Power Adapter'
ON CONFLICT (box_id, item_id) DO UPDATE SET quantity = EXCLUDED.quantity;

-- Carol Box 03
INSERT INTO boombox.box_item (box_id, item_id, quantity)
SELECT b.box_id, i.item_id, 4
FROM boombox.box b, boombox.item i
WHERE b.image_url='https://img.boombox.dev/qr/carol-box-03.png' AND i.item_name='Notebook'
ON CONFLICT (box_id, item_id) DO UPDATE SET quantity = EXCLUDED.quantity;

INSERT INTO boombox.box_item (box_id, item_id, quantity)
SELECT b.box_id, i.item_id, 2
FROM boombox.box b, boombox.item i
WHERE b.image_url='https://img.boombox.dev/qr/carol-box-03.png' AND i.item_name='Marker Pack'
ON CONFLICT (box_id, item_id) DO UPDATE SET quantity = EXCLUDED.quantity;

-- Dave Box 04
INSERT INTO boombox.box_item (box_id, item_id, quantity)
SELECT b.box_id, i.item_id, 1
FROM boombox.box b, boombox.item i
WHERE b.image_url='https://img.boombox.dev/qr/dave-box-04.png' AND i.item_name='Wireless Mouse'
ON CONFLICT (box_id, item_id) DO UPDATE SET quantity = EXCLUDED.quantity;

INSERT INTO boombox.box_item (box_id, item_id, quantity)
SELECT b.box_id, i.item_id, 1
FROM boombox.box b, boombox.item i
WHERE b.image_url='https://img.boombox.dev/qr/dave-box-04.png' AND i.item_name='Keyboard'
ON CONFLICT (box_id, item_id) DO UPDATE SET quantity = EXCLUDED.quantity;

-- Eve Box 01
INSERT INTO boombox.box_item (box_id, item_id, quantity)
SELECT b.box_id, i.item_id, 2
FROM boombox.box b, boombox.item i
WHERE b.image_url='https://img.boombox.dev/qr/eve-box-01.png' AND i.item_name='Phone Charger'
ON CONFLICT (box_id, item_id) DO UPDATE SET quantity = EXCLUDED.quantity;

INSERT INTO boombox.box_item (box_id, item_id, quantity)
SELECT b.box_id, i.item_id, 1
FROM boombox.box b, boombox.item i
WHERE b.image_url='https://img.boombox.dev/qr/eve-box-01.png' AND i.item_name='Ethernet Cable'
ON CONFLICT (box_id, item_id) DO UPDATE SET quantity = EXCLUDED.quantity;

-- +goose Down
DELETE FROM boombox.users WHERE username IN ('alice', 'bob', 'carol', 'dave', 'eve');
DELETE FROM boombox.item WHERE item_name IN ('HDMI Cable', 'USB-C Cable', 'Ethernet Cable', 'Power Adapter', 'Wireless Mouse', 'Keyboard', 'Notebook', 'Marker Pack', 'AA Batteries', 'Phone Charger');