# San Jose DOT Finding Crash Locations

These scripts and SQL functions are designed to help the city of San Jose determine the GPS locations of traffic crashes.

The primary function is `findcrashlocation(interID integer, direction VARCHAR(200), distance integer)`. Any additional functions are called by `findcrashlocation()`.

The returned geometry from `findcrashlocation()` is in EPSG projection 4269. The functions `pointx()` and `pointy()` can be used to convert the returned geometry to GPS coordinates.

## Example Query
```sql
-- Find the GPS coordinates of a crash site 50 feet down the road from the intersection with an id of 126
-- The intersection with an id of 126 is Geneva Ave / Hilary Dr
SELECT
    pointy(Q.g) AS y,
    pointx(Q.g) AS x 
FROM (SELECT 
        findcrashlocation(id, 'South', 50) AS g
    FROM intersections
    WHERE
    id = 126
    ) AS Q;
```
```
      pointy      |      pointx       
------------------+-------------------
 37.2666285162342 | -121.926072017947
```
[Google Maps confirmation](https://www.google.com/maps/place/37%C2%B015'59.4%22N+121%C2%B055'34.5%22W/@37.2664954,-121.928441,17z/data=!3m1!4b1!4m5!3m4!1s0x0:0x0!8m2!3d37.2664912!4d-121.926247)

## Setup
Install [PostgreSQL](https://www.postgresql.org/) and create a database with the PostGIS extension.

If you have a Mac or Linux machine you can then run the bash script setup.sh to import all relevant files and functions.

```
setup.sh [-h|-?] {databse} {username} -- program to upload relevant functions to your postgres database

where:
    -h|-?  show this help text
```

On a Windows machine you will need to upload all the sql files from the `\data` and `\sql_functions` directories manually.

Then the function `findcrashlocation()` can be used in queries.

## Additional Scripts and Files

### test_sql_func.py
This script provides basic unit testing for some of the SQL functions used elsewhere. Change the `USERNAME` and `DBLOCALNAME` global variable values to your postgres username and database name.

### querry_builder.py
This script can be used when you need to form a query that involves comparison of road segments names. This data is very unclean, so the function `replace_string_builder()` is used to create a string that can be inserted into your SQL query to clean, consistent street names.

### comprehensive_replacement.py
This script is used to create the conversions.json file of all possible string substitutions, to be used by the aforementioned `replace_string_builder()` function in querry_builder.py.

### conversions.json
A JSON file containing all possible string substitutions that might be needed when performing a query on street names.

### usps.txt
A text file containing USPS commonly seen substitutions in addresses. Used to form conversions.json.

### ups.json
A text file containing UPS commonly seen substitutions in addresses. Used to form conversions.json.

### schema.md
A detailed description of the data used for this project.

### intersections_import.sql
Contains the SQL code to import the "intersections" table into your PostgreSQL database.

### streetcenterlines_import.sql
Contains the SQL code to import the "streetcenterlines" table into your PostgreSQL database.

## Description of Tables
See schema.md for a full description of the data.

## References
Traffic abbreviations from https://gist.github.com/xjlin0/47b4afeaef480cbc4b5d and https://pe.usps.com/text/pub28/28apc_002.htm