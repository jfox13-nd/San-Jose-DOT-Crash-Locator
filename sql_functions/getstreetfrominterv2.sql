CREATE OR REPLACE FUNCTION getstreetfrominterv2 ( interId integer, direction VARCHAR(200) )
    RETURNS integer
AS
$body$
DECLARE
    streetID integer := 0;
    newintid bigint := 0;
BEGIN

    -- get the intid from the id, intid is a second key used to uniquely identify intersections, it can later be joined with road data
    SELECT 
        "Intersections".intid
    INTO newintid
    FROM "Intersections"
    WHERE "Intersections".id = interId;

    -- of all the roads that meet at a given intersection, find the road segment that is in the X direction by seeing which road segment centroid is the farthest distance away in X direction
    IF UPPER(direction) = 'NORTH' THEN
        SELECT
            Q.id 
        INTO streetID
        FROM
            (SELECT
                id,
                geom
            FROM "StreetCenterlines" 
            WHERE frominteri = newintid
                OR tointerid = newintid
            ) as Q
        --ORDER BY ST_Y(ST_Centroid(Q.geom)) DESC limit 1;
        ORDER BY  ABS(0.0 - getroadangle(interID,Q.id)) limit 1;
    END IF;

    IF UPPER(direction) = 'SOUTH' THEN
        SELECT
            Q.id
        INTO streetID
        FROM
            (SELECT
                id,
                geom
            FROM "StreetCenterlines"
            WHERE frominteri = newintid 
                OR tointerid = newintid
            ) as Q
        --ORDER BY ST_Y(ST_Centroid(Q.geom)) limit 1;
        ORDER BY  ABS(PI() - getroadangle(interID,Q.id)) limit 1;
    END IF;

    IF UPPER(direction) = 'EAST' THEN
        SELECT
            Q.id
        INTO streetID
        FROM
            (SELECT
                id,
                geom
            FROM "StreetCenterlines"
            WHERE frominteri = newintid 
                OR tointerid = newintid
            ) as Q
        --ORDER BY ST_X(ST_Centroid(Q.geom)) DESC limit 1;
        ORDER BY  ABS(PI() / 2.0 - getroadangle(interID,Q.id)) limit 1;
    END IF;

    IF UPPER(direction) = 'WEST' THEN
        SELECT
            Q.id
        INTO streetID
        FROM
            (SELECT
                id,
                geom
            FROM "StreetCenterlines"
            WHERE frominteri = newintid 
                OR tointerid = newintid
            ) as Q
        --ORDER BY ST_X(ST_Centroid(Q.geom)) limit 1;
        ORDER BY  ABS(3.0 * PI() / 2.0 - getroadangle(interID,Q.id)) limit 1;
    END IF;

    RETURN streetID;

END;
$body$
LANGUAGE PLPGSQL;