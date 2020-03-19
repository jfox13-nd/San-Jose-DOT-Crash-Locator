#!/bin/bash

usage="$(basename "$0") [-h|-?] {database} {username} -- program to upload relevant functions to your postgres database

where:
    -h|-?  show this help text"

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

# load functions
for f in sql_functions/*.sql; do
    psql -d $1 -U $2 -a -f "$f" > /dev/null && echo "$(basename "$0"): Successfully Imported $f"
done

# load data
for f in data/*.sql; do
    psql -d $1 -U $2 -a -f "$f" > /dev/null && echo "$(basename "$0"): Successfully Imported $f"
done