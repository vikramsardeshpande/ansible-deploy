---------------------------------------------------------------------------------------------
--  Name    : DROP_DB_PG.sql
--  Purpose : Drop database
--  Version : 5.1.4-GA
--  [postgres]$ psql -f DROP_DB_PG.sql -v oltpdb=<OLTP Database Name> -v oltpdata=<OLTP Tablespace> -v <OLTP Database User> 
--  For Example:
--  [postgres]$ psql -f DROP_DB_PG.sql -v oltpdb=oltpdatab -v oltpdata=testoltp -v oltpuser=oltpu
--------------------------------------------------------------------------------------------

drop database :oltpdb;
drop role :oltpuser;
