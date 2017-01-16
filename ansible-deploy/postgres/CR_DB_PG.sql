CREATE USER :oltpuser WITH PASSWORD :oltppass ;
CREATE DATABASE :oltpdb;
GRANT ALL PRIVILEGES ON DATABASE :oltpdb to :oltpuser;
