-- Заполнение всех таблиц БД тестовыми данными

-- ====================================================================================================================================== --
--														USER
-- ====================================================================================================================================== --

INSERT INTO "account_status" ("id", "status")
VALUES (1, 'Online'),
       (2, 'Offline'),
       (3, 'Want trade'),
       (4, 'Eating olivie');

INSERT INTO "inventory_status" ("id", "status")
VALUES (1, 'Opened'),
       (2, 'Closed'),
       (3, 'Opened only for frieds');

INSERT INTO "cs_user" ("id", "login", "password", "nickname", "description", "img_url", "account_status", "inventory_status")
VALUES (1, 'alex', '123123', 'alex2001', 'Hello everyone!', NULL, 1, 1),
       (2, 'csgo22', 'qwerty', 'bo$$133', NULL, 'https://image', 2, 2),
       (3, 'i_am_pro', 'qwerty123', 'i_am_pro', 'Friends want trade? I want new knife $', NULL, 4, 3),
       (4, 'nikita2009', 'nikita2009', 'funny_guy', 'Trade?', 'https://image', 3, 1);

INSERT INTO "friends" ("user_id_sender", "user_id_recipient")
VALUES (1, 2),
       (1, 3),
       (1, 4);

INSERT INTO "friend_request" ("sender", "recipient", "message")
VALUES (2, 4, 'Add me to friends, please');

-- ====================================================================================================================================== --
--														SKIN
-- ====================================================================================================================================== --

INSERT INTO "weapon_category" ("id", "category")
VALUES (1, 'Knife'),
	   (2, 'Pistol'),
	   (3, 'Submachine guns'),
	   (4, 'Rifle'),
	   (5, 'Sniper rifles'),
	   (6, 'Heavy');

INSERT INTO "weapon" ("id", "name", "description", "category")
VALUES (1, 'Butterfly Knife', 'Folding knife. Based on the traditional Philippine balisong. Butterfly Knife has 2 unique draw animations and 3 inspect animations.', 1),
	   (2, 'Bayonet Knife', NULL, 1),
	   (3, 'Glock-18', 'The Glock 18 is a serviceable first-round pistol that works best against unarmored opponents and is capable of firing three-round bursts.', 2),
	   (4, 'P250', NULL, 2),
	   (5, 'Desert Eagle', NULL, 2),
	   (6, 'MP7', NULL, 3),
	   (7, 'UMP-45', NULL, 3),
	   (8, 'AK-47', 'Powerful and reliable, the AK-47 is one of the most popular assault rifles in the world. It is most deadly in short, controlled bursts of fire.', 4),
	   (9, 'M4A1-S', NULL, 4),
	   (10, 'M4A4', NULL, 4),
	   (11, 'SCAR-20', NULL, 5),
	   (12, 'AWP', 'High risk and high reward, the infamous AWP is recognizable by its signature report and one-shot, one-kill policy.', 5),
	   (13, 'Sawed-off', NULL, 6),
	   (14, 'Nova', NULL, 6),
	   (15, 'Negev', NULL, 6);

INSERT INTO "rarity" ("id", "rarity")
VALUES (1, 'Blue'),
       (2, 'Purple'),
       (3, 'Pink'),
       (4, 'Red'),
       (5, 'Gold');

INSERT INTO "quality" ("id", "quality")
VALUES (1, 'Battle-Scarred'),
       (2, 'Well-Worn'),
       (3, 'Field-Tested'),
       (4, 'Minimal Wear'),
       (5, 'Factory New');

INSERT INTO "skin" ("name", "weapon", "rarity", "quality", "owner")
VALUES ('Asimov', 11, 4, 5, 1),
	   ('Asimov', 4, 3, 4, 1),
	   ('Dark Water', 9, 2, 1, 2),
	   ('Howl', 10, 5, 5, 4),
	   ('Uncharted', 8, 1, 3, 4),
	   ('Dragon Lore', 12, 4, 4, 4),
	   ('Nitro', 9, 2, 2, 4),
	   ('Crimson Web', 2, 4, 3, 4),
	   ('Crimson Web', 5, 2, 1, 3),
	   ('Dragon Lore', 12, 4, 5, 2);

-- ====================================================================================================================================== --
--														USER/SKIN
-- ====================================================================================================================================== --

INSERT INTO "skin_for_sale" ("price", "skin_id")
VALUES (10.5, 7),
       (20.28, 8);

INSERT INTO "trade" ("id", "sender", "recipient")
VALUES (1, 3, 2);

INSERT INTO "skin_in_trade" ("trade_id", "user_id", "skin_id")
VALUES (1, 3, 9),
	   (1, 2, 10);

