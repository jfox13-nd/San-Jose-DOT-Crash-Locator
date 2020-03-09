#!/bin/bash

usage="$(basename "$0") [-h|-?] {databse} {username} -- program to upload relevant functions to your postgres database

where:
    -h|-?  show this help text"

psqluser="postgres"
psqldatabse="postgres"

if [ "$1" = "-h" ]; then
    echo "$usage"
    exit
fi
if [ "$1" = "-?" ]; then
    echo "$usage"
    exit
fi
if [ "$#" -ne 2 ]; then
    echo "$usage"
    exit
fi

psql -d $1 -U $2 -a -f sql_functions/getstreetfrominterv2.sql > /dev/null
psql -d $1 -U $2 -a -f sql_functions/getnewlocation.sql > /dev/null
psql -d $1 -U $2 -a -f sql_functions/getpointonroad.sql > /dev/null
psql -d $1 -U $2 -a -f sql_functions/findcrashlocation.sql > /dev/null
psql -d $1 -U $2 -a -f sql_functions/pointx.sql > /dev/null
psql -d $1 -U $2 -a -f sql_functions/pointy.sql > /dev/null
psql -d $1 -U $2 -a -f data/intersections_import.sql > /dev/null
psql -d $1 -U $2 -a -f data/streetcenterlines_import.sql > /dev/null