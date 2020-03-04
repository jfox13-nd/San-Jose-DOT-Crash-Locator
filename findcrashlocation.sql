CREATE OR REPLACE FUNCTION findcrashlocation ( interID integer, direction VARCHAR(200), distance integer)
    RETURNS geometry
AS
$body$
DECLARE
    final geometry;
    streetID integer;
BEGIN

SELECT getstreetfrominterv2(interID, direction) INTO streetID FROM "Intersections", interclean WHERE "Intersections".id = interID and interclean.id = interID;

IF streetID is NUll THEN
    RETURN NULL;
END IF;

RETURN getnewlocation ( getpointonroad (interId, streetID), streetID, direction, distance);

END;
$body$
LANGUAGE PLPGSQL;