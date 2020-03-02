#!/usr/bin/env python3

'''test_sql_func.py: testing for sql function'''
__author__ = "Jack Fox"
__email__ = "jfox13@nd.edu"

import json
import psycopg2
import sys
import unittest
import math

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
        ''' Given a sample intersection test that the correct street id is returned '''
        cursor = db_setup()
        self.assertNotEqual(cursor,None)

        querry = """SELECT getstreetfrominter(interclean.id, interclean.streeta, interclean.streetb, "Intersections".astreetdir, "Intersections".bstreetdir, "Intersections".{}streetdir) from interclean, "Intersections" where interclean.id = "Intersections".id and interclean.id = {};""".format('b',126)

        cursor.execute(querry)
        record = cursor.fetchall()
        self.assertNotEqual(record, None)
        self.assertNotEqual(record[0], None)
        self.assertNotEqual(record[0][0], None)
        self.assertEqual(record[0][0], 12290)

    def test_getpointfrominter(self):
        ''' Given a sample intersection id get the nearest point on one of the roads '''
        y_geom = 37.2666
        x_geom = -121.9262
        rel_tol = 0.01
        cursor = db_setup()
        self.assertNotEqual(cursor,None)

        querry = """
        SELECT ST_X( ST_Transform((ST_dump(pt)).geom,4269) ), ST_Y( ST_Transform((ST_dump(pt)).geom,4269) ) FROM
            (SELECT getpointonroad( interclean.id, getstreetfrominter(interclean.id, interclean.streeta, interclean.streetb, "Intersections".astreetdir, "Intersections".bstreetdir, "Intersections".{}streetdir)) AS pt
            FROM interclean, "Intersections"
            WHERE interclean.id = "Intersections".id AND interclean.id = {}) AS sub;
        """.format('b',126)
        cursor.execute(querry)
        record = cursor.fetchall()

        self.assertNotEqual(record, None)
        self.assertNotEqual(record[0], None)
        self.assertNotEqual(record[0][0], None)
        self.assertNotEqual(record[0][1], None)
        self.assertTrue(math.isclose(record[0][0], x_geom, rel_tol=rel_tol))
        self.assertTrue(math.isclose(record[0][1], y_geom, rel_tol=rel_tol))

if __name__ == '__main__':
    unittest.main()