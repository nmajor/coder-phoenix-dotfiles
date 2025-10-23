# Ash-Geo - Types

**Pages:** 8

---

## AshGeo.GeoWkb (AshGeo v0.3.0)

**URL:** https://hexdocs.pm/ash_geo/AshGeo.GeoWkb.html

**Contents:**
- AshGeo.GeoWkb (AshGeo v0.3.0)
  - Options
    - Examples
    - Examples
    - See also
    - Examples
    - Examples
- Summary
- Functions
- Functions

Geometry type which accepts and decodes WKB input

Accepts all options of AshGeo.Geometry, and may be narrowed with use in the same way.

:storage_type (atom/0) - Column type in the databaseMay NOT be overridden using :constraints.

:geo_types - Allowed Geo types

:force_srid (integer/0) - SRID to force on the geometry

:check_srid (integer/0) - SRID to check on the geometry

Try decoding with Geo.WKB.

Try decoding with Geo.WKB.

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.34.2) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
use AshGeo.Geometry, storage_type: :"geometry(Point,26918)"
```

Example 2 (unknown):
```unknown
use AshGeo.Geometry, geo_types: :point
```

Example 3 (unknown):
```unknown
use AshGeo.Geometry, geo_types: [:point, :point_z, :point_zm]
```

Example 4 (unknown):
```unknown
use AshGeo.Geometry, geo_types: [:point, Geo.PointZ, :point_zm]
```

---

## API Reference AshGeo v0.3.0

**URL:** https://hexdocs.pm/ash_geo/api-reference.html

**Contents:**
- API Reference AshGeo v0.3.0
- Modules

Base module containing common utility functions

Geometry type which attempts to auto-detect and decode from JSON, WKT and WKB

Geometry type which accepts and decodes GeoJSON input

Geometry type which accepts and decodes WKB input

Geometry type which accepts and decodes WKT input

PostGIS functions for use with Ash.Expr

Validation shorthands for Geo.PostGIS types for use with Ash validate

Validate that the argument's value matches the specified struct type.

Validate that the specified Topo function return true.

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.34.2) for the Elixir programming language

---

## AshGeo.GeoJson (AshGeo v0.3.0)

**URL:** https://hexdocs.pm/ash_geo/AshGeo.GeoJson.html

**Contents:**
- AshGeo.GeoJson (AshGeo v0.3.0)
  - Options
    - Examples
    - Examples
    - See also
    - Examples
    - Examples
- Summary
- Functions
- Functions

Geometry type which accepts and decodes GeoJSON input

Accepts all options of AshGeo.Geometry, and may be narrowed with use in the same way.

:storage_type (atom/0) - Column type in the databaseMay NOT be overridden using :constraints.

:geo_types - Allowed Geo types

:force_srid (integer/0) - SRID to force on the geometry

:check_srid (integer/0) - SRID to check on the geometry

Try decoding with Geo.JSON.

Try decoding with Geo.JSON.

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.34.2) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
use AshGeo.Geometry, storage_type: :"geometry(Point,26918)"
```

Example 2 (unknown):
```unknown
use AshGeo.Geometry, geo_types: :point
```

Example 3 (unknown):
```unknown
use AshGeo.Geometry, geo_types: [:point, :point_z, :point_zm]
```

Example 4 (unknown):
```unknown
use AshGeo.Geometry, geo_types: [:point, Geo.PointZ, :point_zm]
```

---

## AshGeo.GeoAny (AshGeo v0.3.0)

**URL:** https://hexdocs.pm/ash_geo/AshGeo.GeoAny.html

**Contents:**
- AshGeo.GeoAny (AshGeo v0.3.0)
  - Options
    - Examples
    - Examples
    - See also
    - Examples
    - Examples
- Summary
- Functions
- Functions

Geometry type which attempts to auto-detect and decode from JSON, WKT and WKB

Accepts all options for AshGeo.Geometry, plus prefer_binary_encoding, and may also be narrowed with use in the same way.

:prefer_binary_encoding - Which binary encoding format to attempt first: WKT or WKB. Valid values are :wkt, :wkb The default value is :wkt.

:storage_type (atom/0) - Column type in the databaseMay NOT be overridden using :constraints.

:geo_types - Allowed Geo types

:force_srid (integer/0) - SRID to force on the geometry

:check_srid (integer/0) - SRID to check on the geometry

Try decoding with Geo.WKB and Geo.WKT, in the order specified by :prefer.

Try decoding with Geo.WKB and Geo.WKT, in the order specified by :prefer.

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.34.2) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
use AshGeo.Geometry, storage_type: :"geometry(Point,26918)"
```

Example 2 (unknown):
```unknown
use AshGeo.Geometry, geo_types: :point
```

Example 3 (unknown):
```unknown
use AshGeo.Geometry, geo_types: [:point, :point_z, :point_zm]
```

Example 4 (unknown):
```unknown
use AshGeo.Geometry, geo_types: [:point, Geo.PointZ, :point_zm]
```

---

## AshGeo.Validation.ArgumentStructType (AshGeo v0.3.0)

**URL:** https://hexdocs.pm/ash_geo/AshGeo.Validation.ArgumentStructType.html

**Contents:**
- AshGeo.Validation.ArgumentStructType (AshGeo v0.3.0)
  - Options

Validate that the argument's value matches the specified struct type.

:argument (atom/0) - Required. Argument to assert struct type

:struct_type (atom/0) - Required. Struct type to assert

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.34.2) for the Elixir programming language

---

## AshGeo.GeoWkt (AshGeo v0.3.0)

**URL:** https://hexdocs.pm/ash_geo/AshGeo.GeoWkt.html

**Contents:**
- AshGeo.GeoWkt (AshGeo v0.3.0)
  - Options
    - Examples
    - Examples
    - See also
    - Examples
    - Examples
- Summary
- Functions
- Functions

Geometry type which accepts and decodes WKT input

Accepts all options of AshGeo.Geometry, and may be narrowed with use in the same way.

:storage_type (atom/0) - Column type in the databaseMay NOT be overridden using :constraints.

:geo_types - Allowed Geo types

:force_srid (integer/0) - SRID to force on the geometry

:check_srid (integer/0) - SRID to check on the geometry

Try decoding with Geo.WKT.

Try decoding with Geo.WKT.

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.34.2) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
use AshGeo.Geometry, storage_type: :"geometry(Point,26918)"
```

Example 2 (unknown):
```unknown
use AshGeo.Geometry, geo_types: :point
```

Example 3 (unknown):
```unknown
use AshGeo.Geometry, geo_types: [:point, :point_z, :point_zm]
```

Example 4 (unknown):
```unknown
use AshGeo.Geometry, geo_types: [:point, Geo.PointZ, :point_zm]
```

---

## AshGeo.Validation (AshGeo v0.3.0)

**URL:** https://hexdocs.pm/ash_geo/AshGeo.Validation.html

**Contents:**
- AshGeo.Validation (AshGeo v0.3.0)
- Summary
- Functions
- Functions
- contains(geometry_a, geometry_b)
- disjoint(geometry_a, geometry_b)
- equals(geometry_a, geometry_b)
- intersects(geometry_a, geometry_b)
- is_geometry_collection(argument)
- is_line_string(argument)

Validation shorthands for Geo.PostGIS types for use with Ash validate

Check geometry A against geometry B using Topo.contains?/2

Check geometry A against geometry B using Topo.disjoint?/2

Check geometry A against geometry B using Topo.equals?/2

Check geometry A against geometry B using Topo.intersects?/2

Check argument is a :geometry_collection (Geo.GeometryCollection)

Check argument is a :line_string (Geo.LineString)

Check argument is a :line_string_z (Geo.LineStringZ)

Check argument is a :multi_line_string (Geo.MultiLineString)

Check argument is a :multi_line_string_z (Geo.MultiLineStringZ)

Check argument is a :multi_point (Geo.MultiPoint)

Check argument is a :multi_point_z (Geo.MultiPointZ)

Check argument is a :multi_polygon (Geo.MultiPolygon)

Check argument is a :multi_polygon_z (Geo.MultiPolygonZ)

Check argument is a :point (Geo.Point)

Check argument is a :point_m (Geo.PointM)

Check argument is a :point_z (Geo.PointZ)

Check argument is a :point_zm (Geo.PointZM)

Check argument is a :polygon (Geo.Polygon)

Check argument is a :polygon_z (Geo.PolygonZ)

Check geometry A against geometry B using Topo.within?/2

Check geometry A against geometry B using Topo.contains?/2

Check geometry A against geometry B using Topo.disjoint?/2

Check geometry A against geometry B using Topo.equals?/2

Check geometry A against geometry B using Topo.intersects?/2

Check argument is a :geometry_collection (Geo.GeometryCollection)

Check argument is a :line_string (Geo.LineString)

Check argument is a :line_string_z (Geo.LineStringZ)

Check argument is a :multi_line_string (Geo.MultiLineString)

Check argument is a :multi_line_string_z (Geo.MultiLineStringZ)

Check argument is a :multi_point (Geo.MultiPoint)

Check argument is a :multi_point_z (Geo.MultiPointZ)

Check argument is a :multi_polygon (Geo.MultiPolygon)

Check argument is a :multi_polygon_z (Geo.MultiPolygonZ)

Check argument is a :point (Geo.Point)

Check argument is a :point_m (Geo.PointM)

Check argument is a :point_z (Geo.PointZ)

Check argument is a :point_zm (Geo.PointZM)

Check argument is a :polygon (Geo.Polygon)

Check argument is a :polygon_z (Geo.PolygonZ)

Check geometry A against geometry B using Topo.within?/2

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.34.2) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
actions do
  read :containing do
    argument :point, :geo_any

    validate is_point(:point)

    filter expr(^st_contains(^arg(:point)))
  end
end
```

---

## AshGeo.Geometry (AshGeo v0.3.0)

**URL:** https://hexdocs.pm/ash_geo/AshGeo.Geometry.html

**Contents:**
- AshGeo.Geometry (AshGeo v0.3.0)
  - Example
- Options
    - Examples
    - Examples
    - See also
    - Examples
    - Examples

To create a constrained geometry type, use AshGeo.Geometry accepts several options that may be useful. Options provided to use define constraints that are applied statically to a new type instance, and may be further added or overridden using :constraints on instances of that type, with the exception of :storage_type.

:storage_type (atom/0) - Column type in the databaseMay NOT be overridden using :constraints.

:geo_types - Allowed Geo types

:force_srid (integer/0) - SRID to force on the geometry

:check_srid (integer/0) - SRID to check on the geometry

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.34.2) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
defmodule App.Type.Point26918 do
  use AshGeo.Geometry,
    storage_type: :"geometry(Point,26918)",
    geo_types: :point
end

defmodule App.Resource.PointOfInterest do
  alias App.Type.Point26918

  attributes do
    attribute :name, :string
    attribute :location, Point26918, allow_nil?: false
  end

  actions do
    create :create do
      argument :location, Point26918 do
        allow_nil? false
        constraits: [force_srid: 26918]
      end

      change set_attribute(:location, arg(:location))
    end
  end
end
```

Example 2 (unknown):
```unknown
use AshGeo.Geometry, storage_type: :"geometry(Point,26918)"
```

Example 3 (unknown):
```unknown
use AshGeo.Geometry, geo_types: :point
```

Example 4 (unknown):
```unknown
use AshGeo.Geometry, geo_types: [:point, :point_z, :point_zm]
```

---
