CREATE OR REPLACE FUNCTION pointy ( pt geometry )
    RETURNS float
AS
$body$
BEGIN

RETURN ST_Y( ST_Transform((ST_dump(pt)).geom,4269) );

END;
$body$
LANGUAGE PLPGSQL;