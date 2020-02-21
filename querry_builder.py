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

def replace_string_builder(replace_json: str, col_name: str) -> str:
    ''' builds the piece of a querry responsible for doing all string replacements to clean data '''
    with open(replace_json, 'r') as f:
        replace_dict = json.load(f)
    replace_string = col_name

    '''
    Error in regex: REGEXP_REPLACE() does not allow for capture groups so string replacements might create odd formatting by adding excess spaces
    ex. "^Example ct.$" -> "^Example court $"
    '''
    for key in replace_dict:
        replace_string = "REGEXP_REPLACE({}, \'(^| ){}($| )\', \'{}\','g')".format(replace_string, key, replace_dict[key])

    return replace_string

if __name__ == '__main__':
    try:
        connection = psycopg2.connect(user = USERNAME,
                                    host = "127.0.0.1",
                                    port = "5432",
                                    database = DBLOCALNAME)
        cursor = connection.cursor()
    except:
        print("Error: Could not connect to SQL database {} as {}".format(DBLOCALNAME,USERNAME),file=sys.stderr)
    #print('select {}, {} from "Intersections" limit 2'.format(replace_string_builder(STRINGCONVERSIONJSON,'LOWER("Intersections".astreetnam)'),replace_string_builder(STRINGCONVERSIONJSON,'LOWER("Intersections".astreetnam)')))
    #cursor.execute('select {}, {} from "Intersections" limit 2'.format(replace_string_builder(STRINGCONVERSIONJSON,'LOWER("Intersections".astreetnam)'),replace_string_builder(STRINGCONVERSIONJSON,'LOWER("Intersections".bstreetnam)')))
    cursor.execute('select {}, {} from "Intersections" limit 2'.format('LOWER("Intersections".astreetnam)','LOWER("Intersections".bstreetnam)'))
    record = cursor.fetchall()
    print(record)