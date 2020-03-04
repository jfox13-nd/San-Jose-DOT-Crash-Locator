CREATE OR REPLACE FUNCTION findcrashlocation ( interID integer, direction VARCHAR(200), distance integer)
    RETURNS geometry
AS
$body$
DECLARE
    final geometry;
    streetID integer;
BEGIN

-- find the relevant street segment connected to the given intersection in the given direction
SELECT 
    getstreetfrominterv2(interID, direction) 
INTO streetID 
FROM "Intersections", interclean
WHERE "Intersections".id = interID
    AND interclean.id = interID;

IF streetID is NUll THEN
    RETURN NULL;
END IF;

-- return the point that is the correct distance along the road segment
RETURN getnewlocation ( getpointonroad (interId, streetID), streetID, direction, distance);

END;
$body$
LANGUAGE PLPGSQL;