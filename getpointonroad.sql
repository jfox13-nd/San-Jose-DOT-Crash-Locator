CREATE OR REPLACE FUNCTION getpointonroad ( interId integer, streetID integer )
    RETURNS geometry
AS
$body$
DECLARE
    road geometry;
    inter geometry;
BEGIN
    -- ST_AsText
    SELECT ST_LineMerge(geom) INTO road FROM "StreetCenterlines" WHERE id = streetID;
    SELECT (ST_Dump(geom)).geom INTO inter FROM "Intersections" where id = interID;

    RETURN ST_ClosestPoint(road, inter);

END;
$body$
LANGUAGE PLPGSQL;