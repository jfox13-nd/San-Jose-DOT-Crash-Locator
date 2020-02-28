CREATE OR REPLACE FUNCTION findcrashlocation ( interID integer, direction VARCHAR(200), distance integer)
    RETURNS geometry
AS
$body$
DECLARE
    final geometry;
    streetID integer;
BEGIN

SELECT getstreetfrominter(interID, "Interclean".streeta, "Interclean".streetb, "Intersections".astreetdir, "Intersections".bstreetdir, direction) INTO streetID FROM "Intersections", interclean where "Intersections".id = interID and interclean.id = interID;

RETURN getnewlocation ( getpointonroad (interId, streetID), streetID, direction, distance);

END;
$body$
LANGUAGE PLPGSQL;