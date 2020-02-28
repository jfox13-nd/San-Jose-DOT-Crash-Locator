CREATE OR REPLACE FUNCTION getnewlocation ( inter_point Point, streetID integer, direction VARCHAR(200), distance integer)
    RETURNS Point
AS
$body$
DECLARE
    fract_distance float8;
    inter_fract float8;
    azimuth float8;
    final Point;
    line_start line;
BEGIN

    SELECT distance / ST_Length(ST_AsText(ST_LineMerge(geom))) INTO fract_distance FROM "StreetCenterlines" WHERE id = streetID;
    SELECT ST_Line_Locate_Point(geom, inter_point) INTO inter_fract FROM "StreetCenterlines" WHERE id = streetID;
    SELECT ST_StartPoint(geom) INTO line_start FROM "StreetCenterlines" WHERE id = streetID;

    azimuth := ST_Azimuth(inter_point,line_start);

    -- Solution to check if line starts from West or South not entirely correct if road turns in very different direction
    IF direction = 'West' THEN
        fract_distance := fract_distance * -1.0;
        IF azimuth > PI() AND azimuth < 2.0 * PI() THEN
            fract_distance := fract_distance * -1;
        END IF;
    END IF;
    IF direction = 'South' THEN
        fract_distance := fract_distance * -1.0;
        IF azimuth > PI() / 2.0 AND azimuth < 3.0 * PI() / 2.0 THEN
            fract_distance := fract_distance * -1.0;
        END IF;
    END IF;

    inter_fract := inter_fract + fract_distance;

    SELECT ST_Line_Interpolate_Point(geom, inter_fract) INTO final FROM "StreetCenterlines" where id = streetID;

    RETURN final;

END;
$body$
LANGUAGE PLPGSQL;