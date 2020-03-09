#!/usr/bin/env python3

'''random_testing.py: test the algorithim is working by generating all points 50 ft away from a random intersection so that a user can manually check'''
__author__ = "Jack Fox"
__email__ = "jfox13@nd.edu"

import json
import psycopg2
import sys
import unittest
import math
import random

USERNAME = "jfox13"
DBLOCALNAME = "dot"
MAX_ID = 12670

def db_setup() -> None:
    ''' connect to postgres database '''
    try:
        connection = psycopg2.connect(user = USERNAME,
                                    host = "127.0.0.1",
                                    port = "5432",
                                    database = DBLOCALNAME)
        cursor = connection.cursor()
        return cursor
    except:
        print("Error: Could not connect to SQL database {} as {}".format(DBLOCALNAME,USERNAME),file=sys.stderr)
        return None

def query_gen(id: int, direction: str) -> str:
    ''' generate a location query given a string and an id and direction '''
    return """
    SELECT
    pointy(Q.g) AS y,
    pointx(Q.g) AS x,
    Q.astreetnam,
    Q.bstreetnam
FROM (SELECT 
        findcrashlocation(id, '{}', 50) AS g,
        astreetnam,
        bstreetnam
    FROM intersections
    WHERE
    id = {}
    ) AS Q;
    """.format(direction,id)

def check_id(id: int, cursor) -> bool:
    ''' test if id is valid '''
    query ="""
    SELECT COUNT(*)
    FROM intersections
    WHERE id = {};
    """.format(id)

    cursor.execute(query)
    record = cursor.fetchall()

    if record and record[0] and record[0][0] and int(record[0][0]) != 0:
        return True
    return False

def generate_random_id() -> int:
    ''' generates random id '''
    return random.randrange(1,MAX_ID+1)

def get_info(id: int) -> bool:
    ''' finds the x and y coordinates 50 ft in each cardinal direction of an intersection '''
    queries = [ query_gen(id,'North'), query_gen(id,'South'), query_gen(id,'East'), query_gen(id,'West')]
    querry_results = list()

    for q in queries:
        cursor.execute(q)
        record = cursor.fetchall()
        if not record and record[0] and len(record[0]) == 4:
            return False
        querry_results.append(record[0])
    astreet = record[0][2]
    bstreet = record[0][3]

    print("""
    {} & {}
    North:
    {},{}
    South:
    {},{}
    East:
    {},{}
    West:
    {},{}
    """.format(
        astreet, 
        bstreet, 
        querry_results[0][0], querry_results[0][1], 
        querry_results[1][0],querry_results[1][1], 
        querry_results[2][0], querry_results[2][1], 
        querry_results[3][0], querry_results[3][1]))

    return True

if __name__ == '__main__':
    cursor = db_setup()
    if not cursor:
        print("Error: cursor failed to connect to DB",file=sys.stderr)
        sys.exit(1)

    id = generate_random_id()
    
    while not check_id(id,cursor):
        id = generate_random_id()
    
    if not get_info(id):
        print("Error: failed for id: {}", id, file=sys.stderr)
        sys.exit(1)
