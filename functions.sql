
-----------------------------------------------------------------------------------------------------------------------------------------
-- Добавление скина пользователю (может выпасть за игру/за вход в игру и т.д.) ----------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------

CREATE OR REPLACE PROCEDURE NewSkin(user_id INTEGER) AS $$
begin

	INSERT INTO skin ("name", "weapon", "rarity", "quality", "owner")
	VALUES ('Name of skin',  floor(random() * 10 + 1)::int, 5, 5, user_id);

end;
$$ LANGUAGE plpgsql;

-----------------------------------------------------------------------------------------------------------------------------------------
-- Добавляем скин на продажу ------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------

CREATE OR REPLACE PROCEDURE CreateMarketLot(price NUMERIC, skin_id INTEGER) AS $$
begin

	INSERT INTO skin_for_sale ("price", "skin_id")
	VALUES (price, skin_id);

end;
$$ LANGUAGE plpgsql;

-----------------------------------------------------------------------------------------------------------------------------------------
-- Снимаем предмет с продажи ------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------

CREATE OR REPLACE PROCEDURE CancelMarketLot(skinId INTEGER) AS $$
begin

	-- Убираем из таблицы продаж
	DELETE FROM skin_for_sale 
	WHERE skin_for_sale.skin_id = skinId;

end;
$$ LANGUAGE plpgsql;

-----------------------------------------------------------------------------------------------------------------------------------------
-- Покупка скина ------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------

CREATE OR REPLACE PROCEDURE BuyMarketLot(skinId INTEGER, customer INTEGER) AS $$
DECLARE
	v_price NUMERIC;
	v_seller INTEGER;
begin

	SELECT skin_for_sale.price, skin.owner
	INTO v_price, v_seller
	FROM skin_for_sale 
	JOIN skin 
	ON skin_for_sale.skin_id = skin.id
	WHERE skin_for_sale.skin_id = skinId;

	-- Вычитаем стоимость предмета из баланса покупателя
	UPDATE cs_user
	SET balance = balance - v_price
	WHERE cs_user.id = customer;

	-- Меняем owner'а у скина
	UPDATE skin
	SET owner = customer
	WHERE skin.id = skinId;

	-- Добавляем баланс продавцу
	UPDATE cs_user
	SET balance = balance + v_price
	WHERE cs_user.id = v_seller;

	-- Удаляем из таблицы продаж
	DELETE FROM skin_for_sale WHERE skin_for_sale.skin_id = skinId;

end;
$$ LANGUAGE plpgsql;

-----------------------------------------------------------------------------------------------------------------------------------------
-- Запросить инвентарь пользователя
-----------------------------------------------------------------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION GetInventoryById(userId INTEGER) RETURNS TABLE(skin_name VARCHAR(40), weapon_name VARCHAR(40), rarity VARCHAR(40), quality VARCHAR(40)) AS $$
begin	
	RETURN QUERY
		SELECT skin.name, weapon.name, rarity.rarity, quality.quality 
		FROM cs_user
		JOIN skin
		ON skin.owner = cs_user.id
		JOIN weapon
		ON skin.weapon = weapon.id
		JOIN rarity
		ON skin.rarity = rarity.id
		JOIN quality
		ON skin.quality = quality.id
		WHERE cs_user.id = userId;
end;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION GetInventoryByNickname(nick VARCHAR(20)) RETURNS TABLE(skin_name VARCHAR(40), weapon_name VARCHAR(40), rarity VARCHAR(40), quality VARCHAR(40)) AS $$
begin	
	RETURN QUERY
		SELECT skin.name, weapon.name, rarity.rarity, quality.quality 
		FROM cs_user
		JOIN skin
		ON skin.owner = cs_user.id
		JOIN weapon
		ON skin.weapon = weapon.id
		JOIN rarity
		ON skin.rarity = rarity.id
		JOIN quality
		ON skin.quality = quality.id
		WHERE cs_user.nickname = nick;
end;
$$ LANGUAGE plpgsql;

-----------------------------------------------------------------------------------------------------------------------------------------
-- Добавить в друзья
-----------------------------------------------------------------------------------------------------------------------------------------

CREATE OR REPLACE PROCEDURE AddToFriends(recipient_id INTEGER, sender_id INTEGER) AS $$
begin

	DELETE FROM friend_request 
	WHERE friend_request.recipient = recipient_id AND friend_request.sender = sender_id;

	INSERT INTO friends ("user_id_sender", "user_id_recipient")
	VALUES (sender_id, recipient_id);

end;
$$ LANGUAGE plpgsql;


-----------------------------------------------------------------------------------------------------------------------------------------
-- Запросить отправленные запросы на дружбу
-----------------------------------------------------------------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION GetSendedFriendsRequest(userId INTEGER) RETURNS TABLE(recipientId INTEGER, userNickName VARCHAR(40), message TEXT) AS $$
begin

	RETURN QUERY
		SELECT friend_request.recipient, cs_user.nickname, friend_request.message
		FROM friend_request
		JOIN cs_user
		ON cs_user.id = friend_request.recipient
		WHERE friend_request.sender = userId;

end;
$$ LANGUAGE plpgsql;

-----------------------------------------------------------------------------------------------------------------------------------------
-- Запросить пришедшие запросы на дружбу
-----------------------------------------------------------------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION GetReceivedFriendsRequest(userId INTEGER) RETURNS TABLE(senderId INTEGER, userNickName VARCHAR(40), message TEXT) AS $$
begin

	RETURN QUERY
		SELECT friend_request.sender, cs_user.nickname, friend_request.message
		FROM friend_request
		JOIN cs_user
		ON cs_user.id = friend_request.sender
		WHERE friend_request.recipient = userId;

end;
$$ LANGUAGE plpgsql;

-----------------------------------------------------------------------------------------------------------------------------------------
-- Создать трейд
-----------------------------------------------------------------------------------------------------------------------------------------

CREATE OR REPLACE PROCEDURE SendTrade(
	senderId INTEGER, 
	recipientId INTEGER, 
	sender_skin_ids INTEGER[], 
	recipient_skin_ids INTEGER[]
	) AS $$
DECLARE
	trade_id INTEGER;
	sender_skin_id INTEGER;
	recipient_skin_id INTEGER;
begin
	
	-- Создаем трейд, сохраняем айдишник в trade_id
	INSERT INTO trade("sender", "recipient")
   	VALUES (senderId, recipientId)
   	RETURNING id INTO trade_id;

   	-- Добавляем скины из трейда от отправляющего
   	FOREACH sender_skin_id IN ARRAY sender_skin_ids
   	LOOP 
      	INSERT INTO skin_in_trade("trade_id", "user_id", "skin_id")
   		VALUES (trade_id, senderId, sender_skin_id);
   	END LOOP;

   	-- Добавляем скины из трейда от принимающего
   	FOREACH recipient_skin_id IN ARRAY recipient_skin_ids
   	LOOP 
      	INSERT INTO skin_in_trade("trade_id", "user_id", "skin_id")
   		VALUES (trade_id, recipientId, recipient_skin_id);
   	END LOOP;

end;
$$ LANGUAGE plpgsql;