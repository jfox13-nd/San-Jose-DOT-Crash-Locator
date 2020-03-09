# Table: "Intersections"

## Description
This table contains data on each intersection in San Jose. All geometry is in EPSG:4269.

## Schema

```sql
                                        Table "public.Intersections"
   Column   |           Type            | Collation | Nullable |                   Default                   
------------+---------------------------+-----------+----------+---------------------------------------------
 id         | integer                   |           | not null | nextval('"Intersections_id_seq"'::regclass)
 geom       | geometry(MultiPoint,2227) |           |          | 
 objectid   | bigint                    |           |          | 
 facilityid | character varying(20)     |           |          | 
 intid      | bigint                    |           |          | 
 inttype    | character varying(25)     |           |          | 
 intname    | character varying(100)    |           |          | 
 plancrt    | character varying(25)     |           |          | 
 planmod    | character varying(25)     |           |          | 
 modelflag  | character varying(1)      |           |          | 
 private    | character varying(3)      |           |          | 
 incorporat | character varying(3)      |           |          | 
 unityname  | character varying(10)     |           |          | 
 astreetdir | character varying(20)     |           |          | 
 astreetnam | character varying(40)     |           |          | 
 astreettyp | character varying(40)     |           |          | 
 bstreetdir | character varying(20)     |           |          | 
 bstreetnam | character varying(40)     |           |          | 
 bstreettyp | character varying(40)     |           |          | 
 intersecti | character varying(10)     |           |          | 
 trafficcon | character varying(15)     |           |          | 
 intnum     | bigint                    |           |          | 
 shopid     | bigint                    |           |          | 
 maintid    | character varying(4)      |           |          | 
 losno      | bigint                    |           |          | 
 shopstatus | character varying(25)     |           |          | 
 devicetype | character varying(50)     |           |          | 
 ownedby    | character varying(50)     |           |          | 
 activation | date                      |           |          | 
 shopoperat | character varying(60)     |           |          | 
 flag       | character varying(10)     |           |          | 
 rsn        | character varying(10)     |           |          | 
 connectstr | character varying(254)    |           |          | 
 longitude  | double precision          |           |          | 
 latitude   | double precision          |           |          | 
 lastupdate | date                      |           |          | 
 lasteditor | character varying(20)     |           |          | 
 notes      | character varying(254)    |           |          | 
 globalid   | character varying(38)     |           |          | 
 parcelid   | character varying(20)     |           |          | 
 enterprise | character varying(20)     |           |          | 
Indexes:
    "Intersections_pkey" PRIMARY KEY, btree (id)
Referenced by:
sections"(id)
```
## Important notes

### geom
The geometry of each intersection is held as a multipoint, although there is only actualy one single point.

### astreetdir / bstreetdir
The cardinal direction of the relevant street.
```sql
dot=# select astreetdir, count(*) from "Intersections" group by astreetdir;
 astreetdir  | count 
-------------+-------
             |   172
 East-West   |  6360
 North-South |  6138
```

### id, intid
although `id` is the primary key both are unique integer IDs for the elements in the table.

# Table: "StreetCenterlines"

## Description
This table contains data on each street segment in San Jose. Most street segments connect (with first and last points) two adjacent intersections. Some streets may not connect two intersections, however it is believed that each intersection will only share points with the beginnings and endings of street segments. All geometry is in EPSG:4269.

## Schema
```sql
                                           Table "public.StreetCenterlines"
   Column   |              Type              | Collation | Nullable |                     Default                     
------------+--------------------------------+-----------+----------+-------------------------------------------------
 id         | integer                        |           | not null | nextval('"StreetCenterlines_id_seq"'::regclass)
 geom       | geometry(MultiLineString,2227) |           |          | 
 objectid   | bigint                         |           |          | 
 facilityid | character varying(20)          |           |          | 
 intid      | bigint                         |           |          | 
 streetmast | bigint                         |           |          | 
 frominteri | bigint                         |           |          | 
 tointerid  | bigint                         |           |          | 
 fromleft   | bigint                         |           |          | 
 toleft     | bigint                         |           |          | 
 fromright  | bigint                         |           |          | 
 toright    | bigint                         |           |          | 
 addrnumtyp | character varying(20)          |           |          | 
 fullname   | character varying(125)         |           |          | 
 onewaydir  | character varying(10)          |           |          | 
 modelflag  | character varying(1)           |           |          | 
 streetclas | character varying(20)          |           |          | 
 functclass | character varying(20)          |           |          | 
 speedlimit | integer                        |           |          | 
 private    | character varying(3)           |           |          | 
 incorporat | character varying(3)           |           |          | 
 official   | character varying(3)           |           |          | 
 munileft   | character varying(10)          |           |          | 
 muniright  | character varying(10)          |           |          | 
 zipleft    | character varying(5)           |           |          | 
 zipright   | character varying(5)           |           |          | 
 focwidth   | double precision               |           |          | 
 rowwidth   | double precision               |           |          | 
 rsn        | character varying(10)          |           |          | 
 featurecla | character varying(50)          |           |          | 
 plancrt    | character varying(25)          |           |          | 
 planmod    | character varying(25)          |           |          | 
 lastupdate | date                           |           |          | 
 lasteditor | character varying(50)          |           |          | 
 notes      | character varying(254)         |           |          | 
 globalid   | character varying(38)          |           |          | 
 parcelid   | character varying(20)          |           |          | 
 enterprise | character varying(20)          |           |          | 
 shape_leng | double precision               |           |          | 
Indexes:
    "StreetCenterlines_pkey" PRIMARY KEY, btree (id)
Referenced by:
    TABLE "streetclean" CONSTRAINT "streetclean_id_fkey" FOREIGN KEY (id) REFERENCES "StreetCenterlines"(id)
```

## Important notes

### geom
The geometry of each intersection is held as a MultiLineString, although there is only actualy one single line.

### frominteri, tointeri
The IDs of the intersection that each street segment starts and ends on. The values for these attributes correspond to `intid` in the "Intersections" table, not the primary key `id`.

# Table: "streetclean"

## Description
This table references "StreetCenterlines" and simply provides street names that have been better cleaned and standardized. This table is not required to use `findcrashlocations()`.

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
    "streetclean_id_fkey" FOREIGN KEY (id) REFERENCES "StreetCenterlines"(id)
```

# Table: "interclean"

## Description
This table references "Intersections" and simply provides street names that have been better cleaned and standardized. This table is not required to use `findcrashlocations()`.

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
    "interclean_id_fkey" FOREIGN KEY (id) REFERENCES "Intersections"(id)
```