-- Disable host "TAA Server"
UPDATE hosts SET status=1 WHERE host='TAA server';
-- clear changelog table
TRUNCATE TABLE changelog;

