#!/usr/bin/env python3

'''add USPS abbreviations to string_conversions.json'''
__author__ = "Jack Fox"
__email__ = "jfox13@nd.edu"

import json

USPSJSON = "ups.json"
CONVERTJSON = "unique_conversions.json"
FINALJSON = "conversions.json"

if __name__ == "__main__":
    with open(CONVERTJSON, 'r') as f:
        convert_dict = json.load(f)
    with open(USPSJSON, 'r') as f:
        usps_dict = json.load(f)
        for key in usps_dict:
            convert_dict[key.lower()] = usps_dict[key].lower()
    with open(FINALJSON, 'w') as f:
        f.write(json.dumps(convert_dict,indent=4))
    
    
    