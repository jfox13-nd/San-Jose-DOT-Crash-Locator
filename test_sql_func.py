#!/usr/bin/env python3

'''build SQL query'''
__author__ = "Jack Fox"
__email__ = "jfox13@nd.edu"

import json
import psycopg2
import sys
import unittest

USERNAME = "jfox13"
EWINTERSTRING = "East-West"
NSINTERSTRING = "North-South"
DBLOCALNAME = "dot"

def db_setup():
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

class DotSQLTesting(unittest.TestCase):

    def test_getstreetfrominter(self):
        cursor = db_setup()
        self.assertNotEqual(cursor,None)

        querry = """SELECT getstreetfrominter(interclean.id, interclean.streeta, interclean.streetb, "Intersections".astreetdir, "Intersections".bstreetdir, "Intersections".{}streetdir) from interclean, "Intersections" where interclean.id = "Intersections".id and interclean.id = {};""".format('b',126)

        cursor.execute(querry)
        record = cursor.fetchall()
        record[0][0]
        self.assertEqual(record[0][0], 12290)


if __name__ == '__main__':
    unittest.main()