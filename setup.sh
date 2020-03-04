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

psql -d $1 -U $2 -a -f getstreetfrominterv2.sql > /dev/null
psql -d $1 -U $2 -a -f getnewlocation.sql > /dev/null
psql -d $1 -U $2 -a -f getpointonroad.sql > /dev/null
psql -d $1 -U $2 -a -f findcrashlocation.sql > /dev/null
psql -d $1 -U $2 -a -f pointx.sql > /dev/null
psql -d $1 -U $2 -a -f pointy.sql > /dev/null