CREATE OR REPLACE FUNCTION getnewlocation ( inter_point geometry, streetID integer, direction VARCHAR(200), distance integer)
    RETURNS geometry
AS
$body$
DECLARE
    fract_distance float8;
    inter_fract float8;
    final geometry;
BEGIN

    -- convert distance to crash from feet to a fraction of the road segment length
    SELECT
        distance / ST_Length(ST_AsText(ST_LineMerge(geom)))
    INTO fract_distance
    FROM "StreetCenterlines"
    WHERE id = streetID;
    -- locate the fraction of the road line where the intersection is located
    SELECT
        ST_LineLocatePoint( ST_LineMerge(geom) , inter_point)
    INTO inter_fract
    FROM "StreetCenterlines"
    WHERE id = streetID;

    -- combine the fraction distance to the crash with the fraction distance to intersection
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
    -- convert the fraction down the road line into a geometry point
    SELECT
        ST_LineInterpolatePoint( ST_LineMerge(geom), inter_fract)
    INTO final 
    FROM "StreetCenterlines"
    WHERE id = streetID;

    RETURN final;

END;
$body$
LANGUAGE PLPGSQL;