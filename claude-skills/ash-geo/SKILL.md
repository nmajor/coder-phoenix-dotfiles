---
name: ash-geo
description: Geospatial data and GIS operations. Use for Points, coordinates, spatial queries, distance calculations, PostGIS features, mapping, location-based features, geographic data, and geometry types.
---

# Ash-Geo Skill

Comprehensive assistance with AshGeo - geospatial types and functions for Ash Framework, backed by PostGIS and the Geo library.

## When to Use This Skill

Trigger this skill automatically when working with:

**Geospatial Data Types:**
- Storing Points, LineStrings, Polygons in Ash resources
- Working with GeoJSON, WKT (Well-Known Text), WKB (Well-Known Binary)
- Geographic coordinates (latitude/longitude)
- PostGIS geometry and geography types

**Spatial Queries:**
- Finding nearby locations (within radius)
- Checking if point is inside polygon (containment)
- Calculating distances between geometries
- Spatial relationships (intersects, touches, overlaps)

**PostGIS Integration:**
- Using PostGIS functions in Ash expressions
- Spatial indexes for performance
- SRID (Spatial Reference System) management
- Database-level geometric operations

**Framework Setup:**
- Configuring AshGeo types in Ash Framework projects
- Setting up PostGIS extensions in PostgreSQL
- Integrating with AshPostgres data layer

## 🎯 THE GOLDEN RULES

### ALWAYS Use Ash.Geo Types First

**CRITICAL:** When working with geospatial data in Ash Framework projects:

1. **ALWAYS use Ash.Geo type shorthands** - `:geometry`, `:geo_json`, `:geo_wkt`, `:geo_wkb`, `:geo_any`
2. **NEVER use raw Geo types in attributes** unless Ash.Geo doesn't support your use case
3. **Geo library documentation is for REFERENCE ONLY** - fallback when Ash.Geo docs don't cover something

### Priority Hierarchy

**1. Ash.Geo Types (FIRST PRIORITY)**
- Use `:geometry` type for PostGIS geometry columns
- Use `:geo_json`, `:geo_wkt`, `:geo_wkb` for specific input formats
- Use `:geo_any` when accepting multiple formats
- Use `AshGeo.Postgis` functions in expressions
- Configure type shorthands in config.exs

**2. Geo Library (FALLBACK REFERENCE ONLY)**
- Only consult when Ash.Geo docs don't cover something
- Understand Geo.Point, Geo.LineString, etc. structures
- Reference for WKT/WKB/GeoJSON encoding/decoding
- Useful for understanding underlying data structures

**3. PostGIS (DATABASE LAYER)**
- Use PostGIS via `AshGeo.Postgis` functions
- Don't write raw PostGIS SQL unless absolutely necessary
- Leverage `gis_index` for spatial indexes
- SRID configuration through Ash.Geo type constraints

### Why Ash.Geo First?

**Type Safety:**
- Automatic validation of geometry types
- Constraint system for SRID enforcement
- Type narrowing (e.g., only allow Points)
- Compile-time checks

**Ash Integration:**
- Works with Ash queries and expressions
- Automatic serialization/deserialization
- Type shorthands for cleaner code
- Authorization with policies

**PostGIS Functions:**
- `st_within`, `st_distance`, `st_intersects` in filters
- Database-level spatial operations
- Efficient spatial queries
- Automatic type handling

## Quick Reference

### 1. Installation and Dependencies

```elixir
# mix.exs - Add dependencies
def deps do
  [
    {:ash_geo, "~> 0.3.0"},
    # Required dependencies - add the ones you need
    {:geo, "~> 3.0"},           # Core Geo types
    {:geo_postgis, "~> 3.0"},   # PostGIS integration
    {:ash_postgres, "~> 2.0"}   # Ash PostgreSQL data layer
  ]
end
```

### 2. Configuration Setup

```elixir
# config/config.exs - Configure type shorthands
config :geo_postgis, json_library: Jason

config :ash, :custom_types, [
  geometry: AshGeo.Geometry,
  geo_json: AshGeo.GeoJson,
  geo_wkt: AshGeo.GeoWkt,
  geo_wkb: AshGeo.GeoWkb,
  geo_any: AshGeo.GeoAny
]
```

```elixir
# config/runtime.exs - Configure Postgrex types
Postgrex.Types.define(MyApp.PostgresTypes,
  [Geo.PostGIS.Extension | Ecto.Adapters.Postgres.extensions()],
  json: Jason)

config :my_app, MyApp.Repo, types: MyApp.PostgresTypes
```

### 3. Basic Resource with Geometry Attribute

```elixir
defmodule MyApp.Location do
  use Ash.Resource, data_layer: AshPostgres.DataLayer

  attributes do
    uuid_primary_key :id

    attribute :name, :string do
      allow_nil? false
    end

    # Basic geometry - accepts any geometry type
    attribute :position, :geometry do
      allow_nil? false
    end
  end

  postgres do
    table "locations"
    repo MyApp.Repo
  end
end
```

### 4. Constrained Geometry (Points Only)

```elixir
defmodule MyApp.Store do
  use Ash.Resource, data_layer: AshPostgres.DataLayer

  attributes do
    uuid_primary_key :id
    attribute :name, :string

    # Only accept Point geometries
    attribute :location, :geometry do
      constraints geo_types: :point
      allow_nil? false
    end

    # With specific SRID (WGS84 for GPS)
    attribute :gps_coord, :geometry do
      constraints [
        geo_types: :point,
        force_srid: 4326  # WGS84 standard
      ]
    end
  end
end
```

### 5. Flexible Input Formats with :geo_any

```elixir
defmodule MyApp.Area do
  use Ash.Resource, data_layer: AshPostgres.DataLayer

  attributes do
    attribute :name, :string
    attribute :geom, :geometry, allow_nil?: false
  end

  actions do
    create :create do
      # Accept GeoJSON, WKT, or WKB input
      argument :geom, :geo_any do
        allow_nil? false
      end

      change set_attribute(:geom, arg(:geom))
    end
  end
end
```

### 6. Spatial Queries - Find Nearby Locations

```elixir
defmodule MyApp.Location do
  use Ash.Resource, data_layer: AshPostgres.DataLayer

  import AshGeo.Postgis

  attributes do
    uuid_primary_key :id
    attribute :name, :string
    attribute :position, :geometry do
      constraints geo_types: :point
    end
  end

  actions do
    # Find locations within radius
    read :nearby do
      argument :center, :geo_any do
        allow_nil? false
        constraints geo_types: :point
      end

      argument :radius_meters, :decimal do
        allow_nil? false
      end

      # Use st_dwithin_in_meters for geography-based distance
      filter expr(
        ^st_dwithin_in_meters(position, ^arg(:center), ^arg(:radius_meters))
      )
    end
  end
end
```

### 7. Point-in-Polygon Queries

```elixir
defmodule MyApp.Area do
  use Ash.Resource, data_layer: AshPostgres.DataLayer

  import AshGeo.Postgis

  attributes do
    attribute :name, :string
    attribute :boundary, :geometry do
      constraints geo_types: :polygon
    end
  end

  actions do
    # Find areas containing a point
    read :containing do
      argument :point, :geo_any do
        allow_nil? false
        constraints geo_types: :point
      end

      # Use st_within to check containment
      filter expr(^st_within(^arg(:point), boundary))
    end
  end
end
```

### 8. Distance Calculations

```elixir
defmodule MyApp.Store do
  use Ash.Resource, data_layer: AshPostgres.DataLayer

  import AshGeo.Postgis

  attributes do
    attribute :name, :string
    attribute :location, :geometry do
      constraints geo_types: :point
    end
  end

  calculations do
    # Calculate distance to a reference point
    calculate :distance_to_office, :decimal do
      argument :office_location, :geo_any do
        constraints geo_types: :point
      end

      # Returns distance in meters
      calculation expr(
        ^st_distance_in_meters(location, ^arg(:office_location))
      )
    end
  end
end
```

### 9. Spatial Indexes for Performance

```elixir
defmodule MyApp.Location do
  use Ash.Resource, data_layer: AshPostgres.DataLayer

  attributes do
    uuid_primary_key :id
    attribute :name, :string
    attribute :position, :geometry
  end

  postgres do
    repo MyApp.Repo
    table "locations"

    custom_indexes do
      # Add spatial index using AshGeo helper
      import AshGeo.Postgis
      gis_index(:position)
    end
  end
end
```

### 10. Custom Geometry Type with Constraints

```elixir
# Define a custom constrained type
defmodule MyApp.Type.Point26918 do
  use AshGeo.Geometry,
    storage_type: :"geometry(Point,26918)",
    geo_types: :point
end

# Use in resource
defmodule MyApp.Resource.PointOfInterest do
  use Ash.Resource, data_layer: AshPostgres.DataLayer

  alias MyApp.Type.Point26918

  attributes do
    attribute :name, :string
    attribute :location, Point26918, allow_nil?: false
  end

  actions do
    create :create do
      argument :location, Point26918 do
        allow_nil? false
        constraints [force_srid: 26918]
      end

      change set_attribute(:location, arg(:location))
    end
  end
end
```

## Key Concepts

### SRIDs (Spatial Reference Systems)

An SRID defines the coordinate system for geospatial data:

- **4326 (WGS84)** - GPS coordinates, latitude/longitude, most common for global data
- **3857 (Web Mercator)** - Used in web mapping (Google Maps, OpenStreetMap)
- **26918 (UTM Zone 18N)** - Local coordinate system for specific regions

**When to use constraints:**
- `force_srid`: Automatically set SRID on incoming data
- `check_srid`: Validate that data has the expected SRID

### Geometry Types

AshGeo supports all Geo library types:

**Basic Types:**
- `Geo.Point` - Single coordinate point
- `Geo.LineString` - Connected series of points (paths, routes)
- `Geo.Polygon` - Closed area with boundaries

**Extended Types:**
- `Geo.PointZ`, `Geo.PointM`, `Geo.PointZM` - Points with elevation/measurement
- `Geo.MultiPoint`, `Geo.MultiLineString`, `Geo.MultiPolygon` - Collections
- `Geo.GeometryCollection` - Mixed geometry types

**Example structures:**
```elixir
# Point (lat/lng for San Francisco)
%Geo.Point{coordinates: {-122.4194, 37.7749}, srid: 4326}

# LineString (route)
%Geo.LineString{
  coordinates: [{-122.4, 37.7}, {-122.5, 37.8}],
  srid: 4326
}

# Polygon (area - must close the ring)
%Geo.Polygon{
  coordinates: [[
    {-122.4, 37.7},
    {-122.5, 37.7},
    {-122.5, 37.8},
    {-122.4, 37.8},
    {-122.4, 37.7}  # First and last point must match
  ]],
  srid: 4326
}
```

### Type Shorthands vs Full Types

**Use shorthands (recommended):**
```elixir
attribute :location, :geometry  # Shorthand
attribute :geo_data, :geo_any   # Shorthand
```

**Instead of full module names:**
```elixir
attribute :location, AshGeo.Geometry  # Verbose
attribute :geo_data, AshGeo.GeoAny    # Verbose
```

Shorthands are cleaner and configured in `config.exs`.

### PostGIS Functions

Common spatial functions available in `AshGeo.Postgis`:

**Distance:**
- `st_distance_in_meters(geom1, geom2)` - Distance between geometries
- `st_dwithin_in_meters(geom1, geom2, distance)` - Within distance check

**Spatial Relationships:**
- `st_within(geom1, geom2)` - Is geom1 inside geom2?
- `st_contains(geom1, geom2)` - Does geom1 contain geom2?
- `st_intersects(geom1, geom2)` - Do they intersect?
- `st_touches(geom1, geom2)` - Do they touch?

**Measurements:**
- `st_area(geom)` - Area of polygon
- `st_length(geom)` - Length of line string

**Conversions:**
- `st_as_text(geom)` - Convert to WKT
- `st_as_binary(geom)` - Convert to WKB

### Input Format Types

AshGeo provides specialized types for different input formats:

- **`:geo_any`** - Auto-detects JSON, WKT, or WKB (most flexible)
- **`:geo_json`** - GeoJSON format only
- **`:geo_wkt`** - Well-Known Text only
- **`:geo_wkb`** - Well-Known Binary only
- **`:geometry`** - Direct Geo struct (most strict)

Use `:geo_any` for user-facing APIs to accept flexible input.

## Common Patterns

### Pattern: Store Location from Lat/Lng

```elixir
actions do
  create :create do
    argument :name, :string
    argument :latitude, :decimal
    argument :longitude, :decimal

    change fn changeset, _context ->
      if lat = Ash.Changeset.get_argument(changeset, :latitude) do
        lng = Ash.Changeset.get_argument!(changeset, :longitude)
        point = %Geo.Point{coordinates: {lng, lat}, srid: 4326}

        changeset
        |> Ash.Changeset.force_change_attribute(:location, point)
      else
        changeset
      end
    end
  end
end
```

### Pattern: Find Nearest Locations

```elixir
actions do
  read :nearest do
    argument :to_point, :geo_any do
      allow_nil? false
      constraints geo_types: :point
    end

    argument :limit, :integer, default: 10

    prepare fn query, _context ->
      # Order by distance (closest first)
      Ash.Query.sort(query,
        st_distance_in_meters: [
          arguments: %{geometry: arg(:to_point)},
          direction: :asc
        ]
      )
      |> Ash.Query.limit(arg(:limit))
    end
  end
end
```

### Pattern: Validate Geometry Type

```elixir
# In action
actions do
  create :create do
    argument :location, :geo_any

    validate is_point(:location)  # From AshGeo.Validation
  end
end
```

Available validations:
- `is_point`, `is_point_z`, `is_point_m`, `is_point_zm`
- `is_line_string`, `is_polygon`
- `is_multi_point`, `is_multi_line_string`, `is_multi_polygon`
- `is_geometry_collection`

### Pattern: Spatial Relationship Validation

```elixir
# Validate that a point is within a boundary
actions do
  create :add_point do
    argument :point, :geo_any
    argument :boundary, :geo_any

    validate within(:point, :boundary)  # From AshGeo.Validation
  end
end
```

Available relationship validations:
- `contains(geom_a, geom_b)` - A contains B
- `within(geom_a, geom_b)` - A is within B
- `intersects(geom_a, geom_b)` - A intersects B
- `disjoint(geom_a, geom_b)` - A doesn't overlap B
- `equals(geom_a, geom_b)` - A equals B

## Reference Files

This skill includes comprehensive documentation in `references/`:

### Ash.Geo Documentation (PRIMARY)

**types.md** - Geometry types and configuration:
- `AshGeo.Geometry` - Base geometry type
- `AshGeo.GeoJson` - GeoJSON input/output
- `AshGeo.GeoWkt` - Well-Known Text format
- `AshGeo.GeoWkb` - Well-Known Binary format
- `AshGeo.GeoAny` - Auto-detecting format
- `AshGeo.Validation` - Geometry validation helpers
- Type constraints (`geo_types`, `force_srid`, `check_srid`)
- Custom type creation with `use AshGeo.Geometry`

**postgis.md** - PostGIS functions for Ash.Expr:
- `st_within` - Point in polygon
- `st_distance_in_meters` - Geographic distance
- `st_dwithin_in_meters` - Distance comparison
- `st_area`, `st_intersects`, `st_touches`
- `st_as_text`, `st_as_binary` - Format conversion
- Spatial indexes with `gis_index`

**functions.md** - Installation and usage guide:
- Installation instructions
- Configuration setup (config.exs, runtime.exs)
- Basic usage examples
- Dependency management

**other.md** - Additional reference material:
- `AshGeo.Validation.Topo` - Topo-based validations
- Change log
- API reference overview
- Utility functions

### Geo Library Documentation (FALLBACK REFERENCE ONLY)

Located in `references/geo-fallback/` - **consult only when Ash.Geo docs don't cover something**:

- **types.md** - Geo.Point, Geo.LineString, Geo.Polygon structures
- **encoding.md** - WKT, WKB, GeoJSON encoding/decoding
- **api.md** - Geo module API reference

**⚠️ Remember:** Only reference Geo library docs for understanding underlying structures. Always implement using Ash.Geo types.

## Working with This Skill

### For Beginners

**Start here:**
1. Review the "Installation and Dependencies" example (#1)
2. Set up configuration (#2)
3. Create a basic resource with geometry (#3)
4. Try a simple spatial query (#6 - nearby locations)

**Key files to reference:**
- `references/functions.md` - Installation guide
- `references/types.md` - Basic type usage

### For Intermediate Users

**Focus on:**
1. Type constraints (#4 - constrained geometry)
2. Flexible input formats (#5 - :geo_any)
3. Spatial indexes (#9)
4. Distance calculations (#8)

**Key files to reference:**
- `references/types.md` - Advanced type configuration
- `references/postgis.md` - All PostGIS functions

### For Advanced Users

**Explore:**
1. Custom geometry types (#10)
2. Complex spatial queries (combining multiple PostGIS functions)
3. Topo validations (`references/other.md`)
4. Performance optimization with spatial indexes

**Key files to reference:**
- `references/postgis.md` - All PostGIS functions
- `references/other.md` - Topo validations
- `references/types.md` - Custom type creation

### Navigation Tips

**Finding functions:**
- All PostGIS functions are in `references/postgis.md`
- Search for "st_" to find spatial functions

**Understanding types:**
- Type definitions and constraints: `references/types.md`
- Input format types (GeoJSON, WKT, WKB): Search for specific format in `types.md`

**Validation:**
- Geometry type validation: `references/types.md` → AshGeo.Validation
- Spatial relationship validation: `references/other.md` → AshGeo.Validation.Topo

## Troubleshooting

### Common Issues

**1. SRID Mismatch Errors**
- Problem: "geometries must have the same SRID"
- Solution: Use `force_srid` constraint or ensure all geometries use the same SRID (usually 4326)

**2. Type Shorthands Not Working**
- Problem: `:geometry` not recognized
- Solution: Add type shorthands to `config/config.exs` (see example #2)

**3. PostGIS Extension Missing**
- Problem: Database errors about missing functions
- Solution: Enable PostGIS extension in PostgreSQL: `CREATE EXTENSION IF NOT EXISTS postgis;`

**4. Distance Functions Return Unexpected Values**
- Problem: Distances in wrong units
- Solution: Use `st_distance_in_meters` for geography-based calculations (handles Earth's curvature)

**5. Polygon Won't Validate**
- Problem: Polygon validation fails
- Solution: Ensure first and last coordinates are identical (close the ring)

## Notes

- **Version:** This skill covers ash_geo v0.3.0
- **Dependencies:** Requires `geo`, `geo_postgis`, and PostGIS extension
- **Ash.Geo First:** ALWAYS use Ash.Geo types - Geo library docs are for fallback reference only
- **PostGIS Required:** Must have PostGIS extension installed in PostgreSQL
- **SRID Matters:** Always specify SRID 4326 for GPS coordinates
- **Coordinate Order:** In Geo types, coordinates are `{longitude, latitude}` not `{latitude, longitude}`

## Resources

### Official Documentation
- [AshGeo HexDocs](https://hexdocs.pm/ash_geo/) - PRIMARY reference
- [Geo Library HexDocs](https://hexdocs.pm/geo/) - Fallback reference only
- [PostGIS Documentation](https://postgis.net/docs/) - Database functions

### Related Ash Extensions
- `AshPostgres` - PostgreSQL data layer (required)
- `Ash.Type` - Custom type system
- `Ash.Query` - Query building
- `Ash.Changeset` - Data changes

### Community
- [Ash Framework Discord](https://discord.gg/D7FNG2q) - Community support
- [AshGeo GitHub](https://github.com/sevensidedmarble/ash_geo) - Source code and issues
