CREATE OR REPLACE FUNCTION getpointonroad ( interId integer, streetID integer )
    RETURNS geometry
AS
$body$
DECLARE
    road geometry;
    inter geometry;
BEGIN

    SELECT 
        ST_LineMerge(geom)
    INTO road
    FROM "StreetCenterlines"
    WHERE id = streetID;

    SELECT 
        (ST_Dump(geom)).geom 
    INTO inter 
    FROM "Intersections"
    WHERE id = interID;

    -- return the closest point on a road to the given intersection
    RETURN ST_ClosestPoint(road, inter);

END;
$body$
LANGUAGE PLPGSQL;