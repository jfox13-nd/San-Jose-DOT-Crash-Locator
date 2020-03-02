CREATE OR REPLACE FUNCTION checkconnectedroad ( streeta integer, streetb integer )
    RETURNS boolean
AS
$body$
DECLARE
    roada geometry;
    roadb geometry;
BEGIN

SELECT ST_LineMerge(geom) INTO roada FROM "StreetCenterlines" where id = streeta;
SELECT ST_LineMerge(geom) INTO roadb FROM "StreetCenterlines" where id = streetb;

IF streeta <> streetb 
AND ST_StartPoint(roada) = ST_EndPoint(roadb) 
OR ST_StartPoint(roadb) = ST_EndPoint(roada) 
OR ST_StartPoint(roada) = ST_StartPoint(roadb)
OR ST_EndPoint(roada) = ST_EndPoint(roadb)
THEN
    RETURN TRUE;
END IF;

RETURN FALSE;

END;
$body$
LANGUAGE PLPGSQL;