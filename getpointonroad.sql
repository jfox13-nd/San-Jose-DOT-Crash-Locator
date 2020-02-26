CREATE OR REPLACE FUNCTION getpointonroad ( interId integer, streetID integer )
    RETURNS POINT
AS
$body$
DECLARE
    road LINE;
    inter POINT;
BEGIN

    SELECT geom INTO road FROM "StreetCenterlines" WHERE id = streetID;
    SELECT (ST_Dump(geom)).geom INTO inter FROM "Intersections" where id = interID;

    RETURN ST_ClosestPoint(road, inter)

END;
$body$
LANGUAGE PLPGSQL;