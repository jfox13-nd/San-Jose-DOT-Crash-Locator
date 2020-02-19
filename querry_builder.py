#!/usr/bin/env python3

'''build SQL query'''
__author__ = "Jack Fox"
__email__ = "jfox13@nd.edu"

import json

def replace_string_builder(replace_json: str, col_name: str) -> str:
    ''' builds the piece of a querry responsible for doing all string replacements to clean data '''
    with open(replace_json, 'r') as f:
        replace_dict = json.load(f)
    replace_string = "replace({}, \'\', \'\')".format(col_name)

    for key in replace_dict:
        replace_string = "replace({}, {}, {})".format(replace_string, key, replace_dict[key])
        replace_string = "replace({}, {}, {})".format(replace_string, key, replace_dict[key])
    
    return replace_string