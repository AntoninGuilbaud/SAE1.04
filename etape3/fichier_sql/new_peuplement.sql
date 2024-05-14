\copy PORT FROM '/users/info/pub/1a/S1.04/Donnees_Titanic/PORTS.csv' WITH (DELIMITER ';', format CSV, HEADER, ENCODING 'UTF8');
\copy PASSENGER FROM '/users/info/pub/1a/S1.04/Donnees_Titanic/Patch_Passengers.csv' WITH (DELIMITER ';', format CSV, HEADER, ENCODING 'UTF8');
\copy OCCUPATION FROM '/users/info/pub/1a/S1.04/Donnees_Titanic/OCCUPATION.csv' WITH (DELIMITER ';', format CSV, HEADER, ENCODING 'UTF8');
\copy SERVICE FROM '/users/info/pub/1a/S1.04/Donnees_Titanic/SERVICE.csv' WITH (DELIMITER ';', format CSV, HEADER, ENCODING 'UTF8');
\copy CATEGORY FROM '/users/info/pub/1a/S1.04/Donnees_Titanic/CATEGORY.csv' WITH (DELIMITER ';', format CSV, HEADER, ENCODING 'UTF8');
\copy LIFEBOAT FROM '/users/info/pub/1a/S1.04/Donnees_Titanic/LIFEBOAT.csv' WITH (DELIMITER ';', format CSV, HEADER, ENCODING 'UTF8');
\copy RECOVERY FROM '/users/info/pub/1a/S1.04/Donnees_Titanic/RECOVERY.csv' WITH (DELIMITER ';', format CSV, HEADER, ENCODING 'UTF8');
\copy RESCUE FROM '/users/info/pub/1a/S1.04/Donnees_Titanic/RESCUE.csv' WITH (DELIMITER ';', format CSV, HEADER, ENCODING 'UTF8');
