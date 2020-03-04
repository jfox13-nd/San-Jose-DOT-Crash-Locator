CREATE OR REPLACE FUNCTION getnewlocation ( inter_point geometry, streetID integer, direction VARCHAR(200), distance integer)
    RETURNS geometry
AS
$body$
DECLARE
    fract_distance float8;
    inter_fract float8;
    final geometry;
BEGIN

    SELECT distance / ST_Length(ST_AsText(ST_LineMerge(geom))) INTO fract_distance FROM "StreetCenterlines" WHERE id = streetID;
    SELECT ST_LineLocatePoint( ST_LineMerge(geom) , inter_point) INTO inter_fract FROM "StreetCenterlines" WHERE id = streetID;

    -- makes sure data is accurate wether the starting point is at the beginning or end of a line
    IF inter_fract > 0.5 THEN
        inter_fract := inter_fract - fract_distance;
    END IF;
    IF inter_fract < 0.5 THEN
        inter_fract := inter_fract + fract_distance;
    END IF;

    -- if the fraction of the line is out of bounds then null is returned
    IF inter_fract < 0 OR inter_fract > 1 THEN
        RETURN NULL;
    END IF;

    SELECT ST_LineInterpolatePoint( ST_LineMerge(geom), inter_fract) INTO final FROM "StreetCenterlines" where id = streetID;

    RETURN final;

END;
$body$
LANGUAGE PLPGSQL;