# Table: "intersections"

## Overview
The tables `intersections` and `streetcenterlines` can be found in the `\data` directory.

## Description
This table contains data on each intersection in San Jose. All geometry is in EPSG:4269.

## Schema

```sql
                                        Table "public.intersections"
   Column   |           Type            | Collation | Nullable |                   Default                   
------------+---------------------------+-----------+----------+---------------------------------------------
 id         | integer                   |           | not null | nextval('"intersections_id_seq"'::regclass)
 geom       | geometry(MultiPoint,2227) |           |          | 
 intid      | bigint                    |           |          | 
 astreetdir | character varying(20)     |           |          | 
 astreetnam | character varying(40)     |           |          | 
 bstreetdir | character varying(20)     |           |          | 
 bstreetnam | character varying(40)     |           |          | 
Indexes:
    "intersections_pkey" PRIMARY KEY, btree (id)
Referenced by:
sections"(id)
```
## Important notes

### geom
The geometry of each intersection is held as a multipoint, although there is only actualy one single point.

### astreetdir / bstreetdir
The cardinal direction of the relevant street.
```sql
dot=# select astreetdir, count(*) from "intersections" group by astreetdir;
 astreetdir  | count 
-------------+-------
             |   172
 East-West   |  6360
 North-South |  6138
```

### id, intid
although `id` is the primary key both are unique integer IDs for the elements in the table.

# Table: "streetcenterlines"

## Description
This table contains data on each street segment in San Jose. Most street segments connect (with first and last points) two adjacent intersections. Some streets may not connect two intersections, however it is believed that each intersection will only share points with the beginnings and endings of street segments. All geometry is in EPSG:4269.

## Schema
```sql
                                           Table "public.streetcenterlines"
   Column   |              Type              | Collation | Nullable |                     Default                     
------------+--------------------------------+-----------+----------+-------------------------------------------------
 id         | integer                        |           | not null | nextval('"streetcenterlines_id_seq"'::regclass)
 geom       | geometry(MultiLineString,2227) |           |          | 
 intid      | bigint                         |           |          | 
 frominteri | bigint                         |           |          | 
 tointerid  | bigint                         |           |          | 
 fromleft   | bigint                         |           |          | 
 toleft     | bigint                         |           |          | 
 fromright  | bigint                         |           |          | 
 toright    | bigint                         |           |          | 
 fullname   | character varying(125)         |           |          | 
Indexes:
    "streetcenterlines_pkey" PRIMARY KEY, btree (id)
Referenced by:
    TABLE "streetclean" CONSTRAINT "streetclean_id_fkey" FOREIGN KEY (id) REFERENCES "streetcenterlines"(id)
```

## Important notes

### geom
The geometry of each intersection is held as a MultiLineString, although there is only actualy one single line.

### frominteri, tointeri
The IDs of the intersection that each street segment starts and ends on. The values for these attributes correspond to `intid` in the "intersections" table, not the primary key `id`.

# Table: "streetclean"

## Description
This table references "streetcenterlines" and simply provides street names that have been better cleaned and standardized. This table is not required to use `findcrashlocations()` and is only relevant for some of the functions found in the [depreciated branch](https://github.com/jfox13-nd/San-Jose-DOT-Crash-Locator/tree/depreciated).

## Schema
```sql
                    Table "public.streetclean"
 Column |          Type          | Collation | Nullable | Default 
--------+------------------------+-----------+----------+---------
 id     | integer                |           | not null | 
 street | character varying(200) |           |          | 
Indexes:
    "streetclean_pkey" PRIMARY KEY, btree (id)
Foreign-key constraints:
    "streetclean_id_fkey" FOREIGN KEY (id) REFERENCES "streetcenterlines"(id)
```

# Table: "interclean"

## Description
This table references "intersections" and simply provides street names that have been better cleaned and standardized. This table is not required to use `findcrashlocations()` and is only relevant for some of the functions found in the [depreciated branch](https://github.com/jfox13-nd/San-Jose-DOT-Crash-Locator/tree/depreciated).

## Schema
```sql
                     Table "public.interclean"
 Column  |          Type          | Collation | Nullable | Default 
---------+------------------------+-----------+----------+---------
 id      | integer                |           | not null | 
 streeta | character varying(200) |           |          | 
 streetb | character varying(200) |           |          | 
Indexes:
    "interclean_pkey" PRIMARY KEY, btree (id)
Foreign-key constraints:
    "interclean_id_fkey" FOREIGN KEY (id) REFERENCES "intersections"(id)
```