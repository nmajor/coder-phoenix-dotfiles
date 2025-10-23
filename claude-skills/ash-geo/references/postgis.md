# Ash-Geo - Postgis

**Pages:** 1

---

## AshGeo.Postgis (AshGeo v0.3.0)

**URL:** https://hexdocs.pm/ash_geo/AshGeo.Postgis.html

**Contents:**
- AshGeo.Postgis (AshGeo v0.3.0)
- Summary
- Functions
- Functions
- gis_index(column, name \\ nil)
- st_area(geometry)
- st_as_binary(geometry)
- st_as_text(geometry)
- st_bd_m_poly_from_text(wkt, srid)
- st_bd_poly_from_text(wkt, srid)

PostGIS functions for use with Ash.Expr

Casts the 2 geometries given to geographies in order to return distance in meters.

Please note that ST_Distance_Sphere has been deprecated as of Postgis 2.2. Postgis 2.1 is no longer supported on PostgreSQL >= 9.5. This macro is still in place to support users of PostgreSQL <= 9.4.x.

Casts the 2 geometries given to geographies in order to check for distance in meters.

Casts the 2 geometries given to geographies in order to return distance in meters.

Please note that ST_Distance_Sphere has been deprecated as of Postgis 2.2. Postgis 2.1 is no longer supported on PostgreSQL >= 9.5. This macro is still in place to support users of PostgreSQL <= 9.4.x.

Casts the 2 geometries given to geographies in order to check for distance in meters.

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.34.2) for the Elixir programming language

---
