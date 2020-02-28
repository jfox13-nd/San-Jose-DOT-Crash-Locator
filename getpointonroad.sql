CREATE OR REPLACE FUNCTION getpointonroad ( interId integer, streetID integer )
    RETURNS Point
AS
$body$
DECLARE
    road line;
    inter Point;
BEGIN

    SELECT ST_AsText(ST_LineMerge(geom)) INTO road FROM "StreetCenterlines" WHERE id = streetID;
    SELECT (ST_Dump(geom)).geom INTO inter FROM "Intersections" where id = interID;

    RETURN ST_ClosestPoint(road, inter);

END;
$body$
LANGUAGE PLPGSQL;