CREATE USER twittmap SUPERUSER;
ALTER USER twittmap WITH PASSWORD 'twitter';
CREATE DATABASE twittmap_production WITH OWNER twittmap;
