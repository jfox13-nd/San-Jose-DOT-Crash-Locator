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
DBLOCALNAME = "dot"

def db_setup():
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

def point_within_bounding_box(x_y: tuple, bottom_left: tuple, top_right: tuple) -> bool:
    ''' Check that a point is within a bounding box, tuples in format (x,y) '''
    if( x_y[0] >= bottom_left[0] and x_y[0] <= top_right[0] and x_y[1] >= bottom_left[1] and x_y[1] <= top_right[1] ):
        return True
    return False

def create_findcrashlocation_query(interID: int, direction: str, distance: int) -> str:
    ''' quickly generate findcrashlocation queries '''
    return """
    select pointx(Q.g), pointy(Q.g) from (select findcrashlocation(id, '{}', {}) as g from interclean where id = {}) as Q;
    """.format(direction, distance, interID)

class DotSQLTesting(unittest.TestCase):

    def test_getstreetfrominter00(self):
        ''' Given a sample intersection test that the correct street id is returned '''
        cursor = db_setup()
        self.assertNotEqual(cursor,None)

        query = """SELECT getstreetfrominter(interclean.id, interclean.streeta, interclean.streetb, "intersections".astreetdir, "intersections".bstreetdir, "intersections".{}streetdir) from interclean, "intersections" where interclean.id = "intersections".id and interclean.id = {};""".format('b',126)

        cursor.execute(query)
        record = cursor.fetchall()
        self.assertNotEqual(record, None)
        self.assertNotEqual(record[0], None)
        self.assertNotEqual(record[0][0], None)
        self.assertEqual(record[0][0], 12290)

    def test_getpointonroad00(self):
        ''' Given a sample intersection id get the nearest point on one of the roads '''
        bottom_left = (-121.926463, 37.266587)
        top_right = (-121.926074, 37.266697)

        cursor = db_setup()
        self.assertNotEqual(cursor,None)

        query = """
        SELECT ST_X( ST_Transform((ST_dump(pt)).geom,4269) ), ST_Y( ST_Transform((ST_dump(pt)).geom,4269) ) FROM
            (SELECT getpointonroad( interclean.id, getstreetfrominter(interclean.id, interclean.streeta, interclean.streetb, "intersections".astreetdir, "intersections".bstreetdir, "intersections".{}streetdir)) AS pt
            FROM interclean, "intersections"
            WHERE interclean.id = "intersections".id AND interclean.id = {}) AS sub;
        """.format('b',126)
        cursor.execute(query)
        record = cursor.fetchall()

        self.assertNotEqual(record, None)
        self.assertNotEqual(record[0], None)
        self.assertNotEqual(record[0][0], None)
        self.assertNotEqual(record[0][1], None)
        self.assertTrue( point_within_bounding_box(record[0], bottom_left, top_right) )

    def test_findcrashlocation00(self):
        ''' find actual location of a crash '''
        bottom_left = (-121.926347, 37.266326)
        top_right = (-121.926222, 37.266406)
        cursor = db_setup()
        self.assertNotEqual(cursor,None)

        query = create_findcrashlocation_query(126, "South", 100)

        cursor.execute(query)
        record = cursor.fetchall()
        
        self.assertNotEqual(record, None)
        self.assertNotEqual(record[0], None)
        self.assertNotEqual(record[0][0], None)
        self.assertNotEqual(record[0][1], None)
        self.assertTrue( point_within_bounding_box(record[0], bottom_left, top_right) )

    def test_findcrashlocation01(self):
        ''' find actual location of a crash '''
        bottom_left = (-121.915447, 37.258559)
        top_right = (-121.915127, 37.258770)
        cursor = db_setup()
        self.assertNotEqual(cursor,None)

        query = create_findcrashlocation_query(127, "East", 100)

        cursor.execute(query)
        record = cursor.fetchall()
        
        self.assertNotEqual(record, None)
        self.assertNotEqual(record[0], None)
        self.assertNotEqual(record[0][0], None)
        self.assertNotEqual(record[0][1], None)
        self.assertTrue( point_within_bounding_box(record[0], bottom_left, top_right) )

    def test_findcrashlocation02(self):
        ''' find actual location of a crash '''
        bottom_left = (-121.915513, 37.258181)
        top_right = (-121.915329, 37.258356)
        cursor = db_setup()
        self.assertNotEqual(cursor,None)

        query = create_findcrashlocation_query(127, "South", 100)

        cursor.execute(query)
        record = cursor.fetchall()
        
        self.assertNotEqual(record, None)
        self.assertNotEqual(record[0], None)
        self.assertNotEqual(record[0][0], None)
        self.assertNotEqual(record[0][1], None)
        self.assertTrue( point_within_bounding_box(record[0], bottom_left, top_right) )

    def test_findcrashlocation02(self):
        ''' find actual location of a crash '''
        bottom_left = (-121.916085, 37.258278)
        top_right = (-121.915735, 37.258516)
        cursor = db_setup()
        self.assertNotEqual(cursor,None)

        query = create_findcrashlocation_query(127, "West", 100)

        cursor.execute(query)
        record = cursor.fetchall()
        
        self.assertNotEqual(record, None)
        self.assertNotEqual(record[0], None)
        self.assertNotEqual(record[0][0], None)
        self.assertNotEqual(record[0][1], None)
        self.assertTrue( point_within_bounding_box(record[0], bottom_left, top_right) )

if __name__ == '__main__':
    unittest.main()