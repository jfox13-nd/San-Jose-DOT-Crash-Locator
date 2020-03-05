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
        (ST_Dump("Intersections".geom)).geom
    INTO
        interpoint
    FROM "Intersections"
    WHERE "Intersections".id = interID;

    -- get start of street
    SELECT
        ST_StartPoint(ST_LineMerge("StreetCenterlines".geom))
    INTO
        streetstart
    FROM "StreetCenterlines"
    WHERE "StreetCenterlines".id = streetID;

    -- get end of street
    SELECT
        ST_EndPoint(ST_LineMerge("StreetCenterlines".geom))
    INTO
        streetend
    FROM "StreetCenterlines"
    WHERE "StreetCenterlines".id = streetID;

    -- get second point in street
    SELECT
        ST_PointN(ST_LineMerge("StreetCenterlines".geom),2)
    INTO
        streetstart2
    FROM "StreetCenterlines"
    WHERE "StreetCenterlines".id = streetID;

    -- get second to last point in street
    SELECT
        ST_PointN(ST_LineMerge("StreetCenterlines".geom),-2)
    INTO
        streetend2
    FROM "StreetCenterlines"
    WHERE "StreetCenterlines".id = streetID;

    -- return the azimuth of the first point to the second, starting from the relevant end of the line
    IF ST_Distance(interpoint,streetstart) < ST_Distance(interpoint,streetend) THEN
        RETURN ST_Azimuth(streetstart,streetstart2);
    END IF;
    
    RETURN ST_Azimuth(streetend,streetend2);

END;
$body$
LANGUAGE PLPGSQL;