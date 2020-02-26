CREATE OR REPLACE FUNCTION getnewlocation ( interPoint Point, streetID integer, direction VARCHAR(200), distance integer)
    RETURNS Point
AS
$body$
DECLARE
    fract_distance float8;
    inter_fract float8;
    final Point;
BEGIN

    SELECT distance / ST_Length(ST_AsText(ST_LineMerge(geom))) INTO fract_distance FROM "StreetCenterlines" where id = streetID;
    SELECT ST_Line_Locate_Point(geom, interPoint) INTO inter_fract FROM "StreetCenterlines" where id = streetID;

    IF direction = 'West' THEN
        fract_distance := fract_distance * -1;
    END IF;
    IF direction = 'South' THEN
        fract_distance := fract_distance * -1;
    END IF;

    -- check if start is more west or south

    inter_fract := inter_fract + fract_distance;

    SELECT ST_Line_Interpolate_Point(geom, inter_fract) INTO final FROM "StreetCenterlines" where id = streetID;

    RETURN final;

END;
$body$
LANGUAGE PLPGSQL;