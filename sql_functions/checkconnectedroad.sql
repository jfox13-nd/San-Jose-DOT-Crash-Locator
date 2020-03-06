CREATE OR REPLACE FUNCTION checkconnectedroad ( streeta integer, streetb integer )
    RETURNS boolean
AS
$body$
DECLARE
    roada geometry;
    roadaname VARCHAR(200);
    roadb geometry;
    roadbname VARCHAR(200);
BEGIN

SELECT ST_LineMerge(geom) INTO roada FROM "StreetCenterlines" WHERE id = streeta;
SELECT ST_LineMerge(geom) INTO roadb FROM "StreetCenterlines" WHERE id = streetb;

SELECT street INTO roadaname FROM streetclean WHERE id = streeta;
SELECT street INTO roadbname FROM streetclean WHERE id = streetb;

IF streeta <> streetb 
AND ST_StartPoint(roada) = ST_EndPoint(roadb)
AND roadaname = roadbname
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