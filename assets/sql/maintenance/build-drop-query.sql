
-- this query generates list of DROP statements for all tables of given database

SELECT concat('DROP TABLE IF EXISTS ', table_name, ';')
FROM information_schema.tables
WHERE table_schema = 'mandrillcms';
