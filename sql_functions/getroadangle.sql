CREATE OR REPLACE FUNCTION getroadangle (interID integer, streetID integer)
    RETURNS float8
AS
$body$
DECLARE
    interpoint geometry;
    streetstart geometry;
    streetend geometry;
    streetstart2 geometry;
    streetend2 geometry;
BEGIN

    -- get intersection point
    SELECT
        (ST_Dump("intersections".geom)).geom
    INTO
        interpoint
    FROM "intersections"
    WHERE "intersections".id = interID;

    -- get start of street
    SELECT
        ST_StartPoint(ST_LineMerge("streetcenterlines".geom))
    INTO
        streetstart
    FROM "streetcenterlines"
    WHERE "streetcenterlines".id = streetID;

    -- get end of street
    SELECT
        ST_EndPoint(ST_LineMerge("streetcenterlines".geom))
    INTO
        streetend
    FROM "streetcenterlines"
    WHERE "streetcenterlines".id = streetID;

    -- get second point in street
    SELECT
        ST_PointN(ST_LineMerge("streetcenterlines".geom),2)
    INTO
        streetstart2
    FROM "streetcenterlines"
    WHERE "streetcenterlines".id = streetID;

    -- get second to last point in street
    SELECT
        ST_PointN(ST_LineMerge("streetcenterlines".geom),-2)
    INTO
        streetend2
    FROM "streetcenterlines"
    WHERE "streetcenterlines".id = streetID;

    -- return the azimuth of the first point to the second, starting from the relevant end of the line
    IF ST_Distance(interpoint,streetstart) < ST_Distance(interpoint,streetend) THEN
        RETURN ST_Azimuth(streetstart,streetstart2);
    END IF;
    
    RETURN ST_Azimuth(streetend,streetend2);

END;
$body$
LANGUAGE PLPGSQL;