#!/usr/bin/env python3

'''build SQL query'''
__author__ = "Jack Fox"
__email__ = "jfox13@nd.edu"

import json
import psycopg2
import sys

STRINGCONVERSIONJSON = "conversions.json"
DBLOCALNAME = "dot"
USERNAME = "jfox13"

def replace_string_builder(replace_json: str, col_name: str) -> str:
    ''' builds the piece of a querry responsible for doing all string replacements to clean data '''
    with open(replace_json, 'r') as f:
        replace_dict = json.load(f)
    replace_string = col_name

    # TODO: resolve accurate way of handling a / in a street name (suggesting an alternative name for a street)
    # discards latter half of word if '/' is present
    replace_string = "REGEXP_REPLACE({}, \'/.*\', \'\')".format(replace_string)

    # REGEX assumes only spaces and no other whitespace
    for key in replace_dict:
        replace_string = "REGEXP_REPLACE({}, \'(^| ){}\.?($| )\', \' {} \','g')".format(replace_string, key, replace_dict[key])

    # remove beginning and trailing spaces
    replace_string = "REGEXP_REPLACE({}, \'(^ +)|( +$)\', \'\')".format(replace_string)

    return replace_string

def connect_db():
    ''' quickly connects to postgres database and returns cursor '''
    try:
        connection = psycopg2.connect(user = USERNAME,
                                    host = "127.0.0.1",
                                    port = "5432",
                                    database = DBLOCALNAME)
        return connection.cursor()
    except:
        print("Error: Could not connect to SQL database {} as {}".format(DBLOCALNAME,USERNAME),file=sys.stderr)
        sys.exit()