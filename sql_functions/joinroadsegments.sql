CREATE OR REPLACE FUNCTION joinroadsegments ( interId integer, streetID integer )
    RETURNS integer
AS
$body$
DECLARE
    road geometry;
    inter geometry;
    names table (name VARCHAR(200));
BEGIN

INSERT INTO names SELECT DISTINCT street from streetclean;

RETURN count(*) from names group by name order desc limit 1;

END;
$body$
LANGUAGE PLPGSQL;