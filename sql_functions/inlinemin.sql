CREATE OR REPLACE FUNCTION inlinemin ( a float, b float )
    RETURNS float
AS
$body$
BEGIN

IF a < b THEN
    RETURN a;
ELSE
    RETURN b;
END IF;

END;
$body$
LANGUAGE PLPGSQL;