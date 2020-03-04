# San Jose DOT Finding Crash Locations

These scripts and SQL functions are designed to help the city of San Jose determine the GPS locations of traffic crashes.

The primary function is `findcrashlocation(interID integer, direction VARCHAR(200), distance integer)`. Any additional functions are called by `findcrashlocation()`.

## Example Query
```sql
-- Find the GPS coordinates of a crash site 50 feet down the road from the intersection with an id of 126
-- The intersection with an id of 126 is Geneva Ave / Hilary Dr
SELECT pointy(Q.g), pointx(Q.g) FROM (select findcrashlocation(id, 'South', 50) as g from interclean where id = 126) as Q;
```
```
      pointy      |      pointx       
------------------+-------------------
 37.2666285162342 | -121.926072017947
```
[Google maps confirmation](https://www.google.com/maps/place/37%C2%B015'59.4%22N+121%C2%B055'34.5%22W/@37.2664954,-121.928441,17z/data=!3m1!4b1!4m5!3m4!1s0x0:0x0!8m2!3d37.2664912!4d-121.926247)

## Setup
Run the bash script setup.sh

```
setup.sh [-h|-?] {databse} {username} -- program to upload relevant functions to your postgres database

where:
    -h|-?  show this help text
```

Then the function `findcrashlocation()` can be used in any query.

## References
Traffic abbreviations from https://gist.github.com/xjlin0/47b4afeaef480cbc4b5d and https://pe.usps.com/text/pub28/28apc_002.htm