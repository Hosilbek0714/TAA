-- Disable host "TAAE Server"
UPDATE hosts SET status=1 WHERE host='TAAE server';
-- clear changelog table
TRUNCATE TABLE changelog;

