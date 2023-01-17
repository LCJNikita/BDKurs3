-- Отчистка всех таблиц БД

-- ====================================================================================================================================== --
--														USER
-- ====================================================================================================================================== --
\echo ''
\echo 'Deleting cs_user:'

DELETE
FROM "cs_user";

\echo ''
\echo 'Deleting account_status:'

DELETE
FROM "account_status";

\echo ''
\echo 'Deleting inventory_status:'

DELETE
FROM "inventory_status";

-- DELETE
-- FROM "Friends";

-- DELETE
-- FROM "Friend_request";

-- ====================================================================================================================================== --
--														SKIN
-- ====================================================================================================================================== --

-- \echo ''
-- \echo 'Deleting weapon:'

-- DELETE
-- FROM "weapon";

\echo ''
\echo 'Deleting weapon_category:'

DELETE
FROM "weapon_category";

\echo ''
\echo 'Deleting rarity:'

DELETE
FROM "rarity";

\echo ''
\echo 'Deleting quality:'

DELETE
FROM "quality";

-- \echo ''
-- \echo 'Deleting skin:'

-- DELETE
-- FROM "skin";

-- ====================================================================================================================================== --
--														USER/SKIN
-- ====================================================================================================================================== --

-- DELETE
-- FROM "skin_for_sale";

-- DELETE
-- FROM "trade";

-- DELETE
-- FROM "skin_in_trade";
