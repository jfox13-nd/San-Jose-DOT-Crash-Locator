#!/usr/bin/env python3

'''build SQL query'''
__author__ = "Jack Fox"
__email__ = "jfox13@nd.edu"

import json
import psycopg2
import sys

STRINGCONVERSIONJSON = "conversions.json"
DBNAME = "?????"
DBLOCALNAME = "dot"
USERNAME = "jfox13"
EWINTERSTRING = "East-West"
NSINTERSTRING = "North-South"

def replace_string_builder(replace_json: str, col_name: str) -> str:
    ''' builds the piece of a querry responsible for doing all string replacements to clean data '''
    with open(replace_json, 'r') as f:
        replace_dict = json.load(f)
    replace_string = col_name

    # TODO: resolve accurate way of handling a /
    # discards latter half of word if '/' is present
    replace_string = "REGEXP_REPLACE({}, \'/.*\', \'\')".format(replace_string)

    # REGEX assumes only spaces and no other whitespace
    for key in replace_dict:
        replace_string = "REGEXP_REPLACE({}, \'(^| ){}\.?($| )\', \' {} \','g')".format(replace_string, key, replace_dict[key])

    # remove beginning and trailing spaces
    replace_string = "REGEXP_REPLACE({}, \'(^ +)|( +$)\', \'\')".format(replace_string)

    return replace_string

if __name__ == '__main__':
    q = """
select {} as a, {} as b from "StreetCenterlines", "Intersections"

where {} not in (select {} from "StreetCenterlines") or
{} not in (select {} from "StreetCenterlines");
""".format( replace_string_builder(STRINGCONVERSIONJSON,'LOWER("Intersections".astreetnam)'),
            replace_string_builder(STRINGCONVERSIONJSON,'LOWER("Intersections".bstreetnam)'),
            replace_string_builder(STRINGCONVERSIONJSON,'LOWER("Intersections".astreetnam)'),
            replace_string_builder(STRINGCONVERSIONJSON,'LOWER("StreetCenterlines".fullname)'),
            replace_string_builder(STRINGCONVERSIONJSON,'LOWER("Intersections".bstreetnam)'),
            replace_string_builder(STRINGCONVERSIONJSON,'LOWER("StreetCenterlines".fullname)'),
)
    q = """
    INSERT INTO interclean (id, streeta, streetb)
    SELECT id, {}, {} from "Intersections";

    INSERT INTO streetclean (id, street)
    SELECT id, {} from "StreetCenterlines";
""".format( replace_string_builder(STRINGCONVERSIONJSON,'LOWER("Intersections".astreetnam)'),
            replace_string_builder(STRINGCONVERSIONJSON,'LOWER("Intersections".bstreetnam)'),
            replace_string_builder(STRINGCONVERSIONJSON,'LOWER("StreetCenterlines".fullname)'),
)

    q = """
    INSERT INTO streetclean (id, street)
    SELECT id, {} from "StreetCenterlines";
""".format( replace_string_builder(STRINGCONVERSIONJSON,'LOWER("StreetCenterlines".fullname)') )

    q = """
    INSERT INTO interclean (id, streeta, streetb)
    SELECT id, {}, {} from "Intersections";
""".format( replace_string_builder(STRINGCONVERSIONJSON,'LOWER("Intersections".astreetnam)'),
            replace_string_builder(STRINGCONVERSIONJSON,'LOWER("Intersections".bstreetnam)'),
)



    '''

    try:
        connection = psycopg2.connect(user = USERNAME,
                                    host = "127.0.0.1",
                                    port = "5432",
                                    database = DBLOCALNAME)
        cursor = connection.cursor()
    except:
        print("Error: Could not connect to SQL database {} as {}".format(DBLOCALNAME,USERNAME),file=sys.stderr)
        sys.exit()
    #querry = 'select {}, {} from "Intersections" limit 2'.format(replace_string_builder(STRINGCONVERSIONJSON,'LOWER("Intersections".astreetnam)'),replace_string_builder(STRINGCONVERSIONJSON,'LOWER("Intersections".bstreetnam)'))
    querry = q
    cursor.execute(querry)
    record = cursor.fetchall()
    print(record)
    '''
    print(q)