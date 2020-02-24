#!/usr/bin/env python3

'''add USPS abbreviations to string_conversions.json'''
__author__ = "Jack Fox"
__email__ = "jfox13@nd.edu"

import json

UPSJSON = "ups.json"
USPSTEXT = "usps.txt"
CONVERTJSON = "unique_conversions.json"
FINALJSON = "conversions.json"

def create_usps_dict(usps_textfile: str, conversion_dict: dict) -> None:
    with open(usps_textfile, 'r') as f:
        text = f.readlines()
        last_word = text[0].strip()
        word_set = set()
        for index, line in enumerate(text):
            line = line.strip()
            if line == last_word:
                continue
            if not line:
                for word in word_set:
                    conversion_dict[word.lower()] = last_word.lower()
                    #conversion_dict["{}.".format(word.lower())] = last_word.lower()
                word_set = set()
                last_word = text[index+1].strip()
                continue
            word_set.add(line)




if __name__ == '__main__':
    with open(CONVERTJSON, 'r') as f:
        conversion_dict = json.load(f)
    create_usps_dict(USPSTEXT, conversion_dict)
    with open(UPSJSON, 'r') as f:
        usps_dict = json.load(f)
        for key in usps_dict:
            if key in conversion_dict:
                continue
            conversion_dict[key.lower()] = usps_dict[key].lower()
            #conversion_dict['{}.'.format(key.lower())] = usps_dict[key].lower()
    with open(FINALJSON, 'w') as f:
        f.write(json.dumps(conversion_dict,indent=4))