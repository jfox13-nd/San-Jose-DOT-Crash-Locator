CREATE OR REPLACE FUNCTION pointx ( pt geometry )
    RETURNS float
AS
$body$
BEGIN

RETURN ST_X( ST_Transform((ST_dump(pt)).geom,4269) );

END;
$body$
LANGUAGE PLPGSQL;