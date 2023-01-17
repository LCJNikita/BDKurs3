
-- Тригер, если вдруг удаляются скины, участвовавшие в трейдах, то дропать трейд в котором нет скинов для обмена

CREATE OR REPLACE FUNCTION DeleteEmptyTrades() RETURNS TRIGGER AS
$$
BEGIN
    
    IF ((SELECT COUNT(*) FROM skin_in_trade WHERE skin_in_trade.trade_id = OLD.trade_id) = 0) THEN
        DELETE FROM trade WHERE trade.id = OLD.trade_id;
    END IF;

    return OLD;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS emptyTrades ON skin_in_trade;
CREATE TRIGGER emptyTrades
    AFTER DELETE
    ON skin_in_trade
    FOR EACH ROW
EXECUTE PROCEDURE deleteEmptyTrades();

-- проверить индексы, тригеры у таблицы - \d <tableName>
-- проверить функции \df
-- проверить функции с кодом \df+
-- запустить скрипт \i 'script.sql'
-- запустить функцию - SELECT func(.., ..)
-- запустить процедуру CALL proc(.., ..)

-- вызвать процедуру с массивом - CALL proc(ARRAY [1,2,3,4])