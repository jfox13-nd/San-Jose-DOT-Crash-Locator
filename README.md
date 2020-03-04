# San Jose DOT Finding Crash Locations

These scripts and SQL functions are designed to help the city of San Jose determine the GPS locations of traffic crashes.

The primary function is `findcrashlocation(interID integer, direction VARCHAR(200), distance integer)`. Any additional functions are called by `findcrashlocation(interID integer, direction VARCHAR(200), distance integer)`.

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