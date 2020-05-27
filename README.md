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
 37.2664911999069 | -121.926246994479
```
[Google Maps confirmation](https://www.google.com/maps/place/37%C2%B015'59.4%22N+121%C2%B055'34.5%22W/@37.2664923,-121.9267955,19z/data=!3m1!4b1!4m5!3m4!1s0x0:0x0!8m2!3d37.2664912!4d-121.926247)

## Setup
Install [PostgreSQL](https://www.postgresql.org/) and create a database with the [PostGIS](https://postgis.net/install/) extension. Make sure to enable all relevant [PostGIS](https://postgis.net/install/) extensions.

```sql
-- Enable PostGIS (as of 3.0 contains just geometry/geography)
CREATE EXTENSION postgis;
-- enable raster support (for 3+)
CREATE EXTENSION postgis_raster;
-- Enable Topology
CREATE EXTENSION postgis_topology;
-- Enable PostGIS Advanced 3D
-- and other geoprocessing algorithms
-- sfcgal not available with all distributions
CREATE EXTENSION postgis_sfcgal;
-- fuzzy matching needed for Tiger
CREATE EXTENSION fuzzystrmatch;
-- rule based standardizer
CREATE EXTENSION address_standardizer;
-- example rule data set
CREATE EXTENSION address_standardizer_data_us;
-- Enable US Tiger Geocoder
CREATE EXTENSION postgis_tiger_geocoder;
```

If you have a machine that can run Bash scripts (such as a Mac or Linux machine) you should run [setup.sh](https://github.com/jfox13-nd/San-Jose-DOT-Crash-Locator/blob/master/setup.sh) to import all relevant files and functions.

```bash
setup.sh [-h|-?] {database} {username} -- program to upload relevant functions to your postgres database

where:
    -h|-?  show this help text
```

If you cannot run Bash scripts you will need to upload all the sql files from the [data](https://github.com/jfox13-nd/San-Jose-DOT-Crash-Locator/tree/master/data) and [sql_functions](https://github.com/jfox13-nd/San-Jose-DOT-Crash-Locator/tree/master/sql_functions) directories manually. Try running the following in Windows Command Prompt for each SQL file in [data](https://github.com/jfox13-nd/San-Jose-DOT-Crash-Locator/tree/master/data) and [sql_functions](https://github.com/jfox13-nd/San-Jose-DOT-Crash-Locator/tree/master/sql_functions):

```shell
psql -d $DATABASE -U $USERNAME -a -f "$FILE_NAME"
```

Then the function `findcrashlocation()` can be used in queries.

## Additional Scripts and Files

### [test_sql_func.py](https://github.com/jfox13-nd/San-Jose-DOT-Crash-Locator/blob/master/test_sql_func.py)
This script provides basic unit testing for some of the SQL functions used elsewhere. Change the `USERNAME` and `DBLOCALNAME` global variable values to your postgres username and database name.

### [random_testing.py](https://github.com/jfox13-nd/San-Jose-DOT-Crash-Locator/blob/master/random_testing.py)
This script helps test the `findcrashlocation()` function by choosing a random id and showing the GPS coordinates of queries for the locations 50 feet North, South, East, and West of that intersection.

### [querry_builder.py](https://github.com/jfox13-nd/San-Jose-DOT-Crash-Locator/blob/master/street_name_querying/querry_builder.py)
This script can be used when you need to form a query that involves comparison of road segments names. This data is very unclean, so the function `replace_string_builder()` is used to create a string that can be inserted into your SQL query to clean, consistent street names.

### [comprehensive_replacement.py](https://github.com/jfox13-nd/San-Jose-DOT-Crash-Locator/blob/master/street_name_querying/comprehensive_replacement.py)
This script is used to create the conversions.json file of all possible string substitutions, to be used by the aforementioned `replace_string_builder()` function in querry_builder.py.

### [conversions.json](https://github.com/jfox13-nd/San-Jose-DOT-Crash-Locator/blob/master/street_name_querying/conversions.json)
A JSON file containing all possible string substitutions that might be needed when performing a query on street names.

### [usps.txt](https://github.com/jfox13-nd/San-Jose-DOT-Crash-Locator/blob/master/street_name_querying/usps.txt)
A text file containing USPS commonly seen substitutions in addresses. Used to form conversions.json.

### [ups.json](https://github.com/jfox13-nd/San-Jose-DOT-Crash-Locator/blob/master/street_name_querying/ups.json)
A text file containing UPS commonly seen substitutions in addresses. Used to form conversions.json.

### [schema.md](https://github.com/jfox13-nd/San-Jose-DOT-Crash-Locator/blob/master/schema.md)
A detailed description of the data used for this project.

### [intersections_import.sql](https://github.com/jfox13-nd/San-Jose-DOT-Crash-Locator/blob/master/data/intersections_import.sql)
Contains the SQL code to import the "intersections" table into your PostgreSQL database.

### [streetcenterlines_import.sql](https://github.com/jfox13-nd/San-Jose-DOT-Crash-Locator/blob/master/data/streetcenterlines_import.sql)
Contains the SQL code to import the "streetcenterlines" table into your PostgreSQL database.

## Description of Tables
See schema.md for a full description of the data.

## References
### Street Name Abbreviations
 * https://gist.github.com/xjlin0/47b4afeaef480cbc4b5d
 * https://pe.usps.com/text/pub28/28apc_002.htm