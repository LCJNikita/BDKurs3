-- Создание всех таблиц БД

-- ====================================================================================================================================== --
--														USER
-- ====================================================================================================================================== --

CREATE TABLE account_status
(
    id     SERIAL PRIMARY KEY,
    status VARCHAR(40) NOT NULL
);

CREATE TABLE inventory_status
(
    id     SERIAL PRIMARY KEY,
    status VARCHAR(40) NOT NULL
);

CREATE TABLE cs_user
(
    id    				SERIAL PRIMARY KEY,
    login 				VARCHAR(20) NOT NULL UNIQUE,
    password 			VARCHAR(30) NOT NULL,
    nickname 			VARCHAR(20) NOT NULL UNIQUE,
    description 		TEXT,
    img_url 			TEXT,
    balance 			NUMERIC DEFAULT 0 CHECK (balance >= 0.0) NOT NULL,
    account_status 		SERIAL references "account_status"("id") ON UPDATE CASCADE NOT NULL,
    inventory_status	SERIAL references "inventory_status"("id") ON UPDATE CASCADE NOT NULL
);

CREATE TABLE friends
(
	id    				SERIAL PRIMARY KEY,
    user_id_sender     	SERIAL references "cs_user"("id") ON DELETE CASCADE ON UPDATE CASCADE NOT NULL,
    user_id_recipient 	SERIAL references "cs_user"("id") ON DELETE CASCADE ON UPDATE CASCADE NOT NULL CHECK (user_id_sender != user_id_recipient),
	
    CONSTRAINT uq_friends UNIQUE (user_id_sender, user_id_recipient),
	CONSTRAINT uq_friends_reversed UNIQUE (user_id_recipient, user_id_sender)
);

CREATE TABLE friend_request
(
	id    		SERIAL PRIMARY KEY,
    sender     	SERIAL references "cs_user"("id") ON DELETE CASCADE ON UPDATE CASCADE NOT NULL,
    recipient 	SERIAL references "cs_user"("id") ON DELETE CASCADE ON UPDATE CASCADE NOT NULL CHECK (sender != recipient),
    message		TEXT,
	
    CONSTRAINT uq_friend_request UNIQUE (sender, recipient),
    CONSTRAINT uq_friend_request_reversed UNIQUE (recipient, sender)
);

-- ====================================================================================================================================== --
--														SKIN
-- ====================================================================================================================================== --

CREATE TABLE weapon_category
(
    id 			SERIAL PRIMARY KEY,
    category 	VARCHAR(40) NOT NULL
);

CREATE TABLE weapon
(
    id 				SERIAL PRIMARY KEY,
    name 			VARCHAR(40) NOT NULL,
    description 	TEXT,
    category SERIAL references "weapon_category"("id") ON DELETE CASCADE NOT NULL
);

CREATE TABLE rarity
(
    id 			SERIAL PRIMARY KEY,
    rarity 		VARCHAR(40) NOT NULL
);

CREATE TABLE quality
(
    id 			SERIAL PRIMARY KEY,
    quality 	VARCHAR(40) NOT NULL
);

CREATE TABLE skin
(
    id 				SERIAL PRIMARY KEY,
    name 			VARCHAR(40) NOT NULL,
    weapon 			SERIAL references "weapon"("id") ON DELETE CASCADE ON UPDATE CASCADE NOT NULL,
    rarity 			SERIAL references "rarity"("id") ON DELETE CASCADE ON UPDATE CASCADE NOT NULL,
    quality 		SERIAL references "quality"("id") ON DELETE CASCADE ON UPDATE CASCADE NOT NULL,
    owner           SERIAL references "cs_user"("id") ON DELETE CASCADE ON UPDATE CASCADE NOT NULL
);

-- ====================================================================================================================================== --
--														SALE/TRADE
-- ====================================================================================================================================== --

CREATE TABLE skin_for_sale
(
    id              SERIAL PRIMARY KEY,
    price			NUMERIC CHECK (price > 0.0) NOT NULL,
    skin_id			SERIAL references "skin"("id") ON DELETE CASCADE ON UPDATE CASCADE NOT NULL UNIQUE
);

CREATE TABLE trade
(
    id 				SERIAL PRIMARY KEY,
    sender			SERIAL references "cs_user"("id") ON DELETE CASCADE ON UPDATE CASCADE NOT NULL,
    recipient		SERIAL references "cs_user"("id") ON DELETE CASCADE ON UPDATE CASCADE NOT NULL CHECK (sender != recipient)
);

CREATE TABLE skin_in_trade
(
    trade_id	SERIAL references "trade"("id") ON DELETE CASCADE ON UPDATE CASCADE NOT NULL,
    user_id		SERIAL references "cs_user"("id") ON DELETE CASCADE ON UPDATE CASCADE NOT NULL,
    skin_id		SERIAL references "skin"("id") ON DELETE CASCADE ON UPDATE CASCADE NOT NULL,
    PRIMARY KEY (trade_id, skin_id)
);
