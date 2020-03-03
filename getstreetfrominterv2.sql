CREATE OR REPLACE FUNCTION getstreetfrominterv2 ( interId integer, direction VARCHAR(200) )
    RETURNS integer
AS
$body$
DECLARE
    streetID integer := 0;
    newintid bigint := 0;
BEGIN

    SELECT "Intersections".intid into newintid from "Intersections" where "Intersections".id = interId;

    IF UPPER(direction) = 'NORTH' THEN
        SELECT Q.id INTO streetID FROM
            (SELECT id, geom FROM "StreetCenterlines" where frominteri = newintid OR tointerid = newintid) as Q
        ORDER BY ST_Y(ST_Centroid(Q.geom)) DESC limit 1;
    END IF;
    IF UPPER(direction) = 'SOUTH' THEN
        SELECT Q.id INTO streetID FROM
            (SELECT id, geom FROM "StreetCenterlines" where frominteri = newintid OR tointerid = newintid) as Q
        ORDER BY ST_Y(ST_Centroid(Q.geom)) limit 1;
    END IF;
    IF UPPER(direction) = 'EAST' THEN
        SELECT Q.id INTO streetID FROM
            (SELECT id, geom FROM "StreetCenterlines" where frominteri = newintid OR tointerid = newintid) as Q
        ORDER BY ST_X(ST_Centroid(Q.geom)) DESC limit 1;
    END IF;
    IF UPPER(direction) = 'WEST' THEN
        SELECT Q.id INTO streetID FROM
            (SELECT id, geom FROM "StreetCenterlines" where frominteri = newintid OR tointerid = newintid) as Q
        ORDER BY ST_X(ST_Centroid(Q.geom)) limit 1;
    END IF;

    RETURN streetID;

END;
$body$
LANGUAGE PLPGSQL;