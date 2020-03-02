CREATE OR REPLACE FUNCTION getstreetfrominter ( interId integer, streetaname VARCHAR(200), streetbname VARCHAR(200), astreetdir VARCHAR(20), bstreetdir VARCHAR(20), direction VARCHAR(200) )
    RETURNS integer
AS
$body$
DECLARE
    streetID integer := 0;
BEGIN

    IF direction = 'East-West' OR direction = 'East' OR direction = 'West' THEN
        IF astreetdir = 'East-West' THEN
            --SELECT INTO streetID streetclean.id FROM streetclean, interclean where streetclean.street = streeta;
            --streetID := (SELECT streetclean.id FROM streetclean, interclean where streetclean.street = streeta limit 1);
            SELECT streetclean.id INTO streetID FROM streetclean, interclean where streetclean.street = streetaname limit 1;
        END IF;
        IF bstreetdir = 'East-West' THEN
            --SELECT INTO streetID streetclean.id FROM streetclean, interclean where streetclean.street = streetb;
            --streetID := (SELECT streetclean.id FROM streetclean, interclean where streetclean.street = streetb limit 1);
            SELECT streetclean.id INTO streetID FROM streetclean, interclean where streetclean.street = streetbname limit 1;
        END IF;
    END IF;

    IF direction = 'North-South' OR direction = 'North' OR direction = 'South' THEN
        IF astreetdir = 'North-South' THEN
            --SELECT INTO streetID streetclean.id FROM streetclean, interclean where streetclean.street = streeta;
            --streetID := (SELECT streetclean.id FROM streetclean, interclean where streetclean.street = streeta limit 1);
            SELECT streetclean.id INTO streetID FROM streetclean, interclean where streetclean.street = streetaname limit 1;
        END IF;
        IF bstreetdir = 'North-South' THEN
            --SELECT INTO streetID streetclean.id FROM streetclean, interclean where streetclean.street = streetb;
            --streetID := (SELECT streetclean.id FROM streetclean, interclean where streetclean.street = streeta limit 1);
            SELECT streetclean.id INTO streetID FROM streetclean, interclean where streetclean.street = streetbname limit 1;
        END IF;
    END IF;
    
    RETURN streetID;

END;
$body$
LANGUAGE PLPGSQL;