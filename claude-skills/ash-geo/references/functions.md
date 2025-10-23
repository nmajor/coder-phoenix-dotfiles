# Ash-Geo - Functions

**Pages:** 1

---

## AshGeo

**URL:** https://hexdocs.pm/ash_geo/readme.html

**Contents:**
- AshGeo
  - All your Ash resources, in space!
- Installation
- Configuration
  - config/config.exs:
  - config/runtime.exs:
- Usage
- Roadmap
- Developing
- Contributing

AshGeo contains tools for using geospatial data in Ash resources and expressions, backed by PostGIS, Geo, Geo.PostGIS and [Topo].

This package provides a collection of non-overlapping functionality based on several dependencies, not all of which may be necessary your application. Therefore, the dependencies for the functionality you wish to use must be added alongside :ash_geo.

The full documentation can be found on HexDocs.

To get set up with the development environment, you will need a Postgres instance with support for the PostGIS extensions listed in test/support/repo.ex (the postgis/postgis image works nicely) and a superuser account ash_geo_test credentialed according to config/config.exs.

You may now generate and apply the test migrations:

AshGeo uses ex_check to bundle the test configuration, and simply running mix check should closely follow the configuration used in CI.

If you have ideas or come across any bugs, feel free to open a pull request or an issue. You can also find me on the Ash Discord as @\.

Copyright (c) 2023 bcksl

See LICENSE.md for details.

Hex Package Hex Preview (current file) Search HexDocs Download ePub version

Built using ExDoc (v0.34.2) for the Elixir programming language

**Examples:**

Example 1 (python):
```python
def deps do
  [
    {:ash_geo, "~> 0.3.0"},
  ]
end
```

Example 2 (unknown):
```unknown
# Geo.PostGIS: Use Jason coder
config :geo_postgis, json_library: Jason

# Ash: Type shorthands
config :ash, :custom_types, [
  geometry: AshGeo.Geometry,
  geo_json: AshGeo.GeoJson,
  geo_wkt: AshGeo.GeoWkt,
  geo_wkb: AshGeo.GeoWkb,
  geo_any: AshGeo.GeoAny,
  # You may add shorthands for any narrowed types here
  #point26918: CoolApp.Type.GeometryPoint26918,
]
```

Example 3 (unknown):
```unknown
# Postgrex: Geo.PostGIS types
Postgrex.Types.define(CoolApp.PostgresTypes,
  [Geo.PostGIS.Extension | Ecto.Adapters.Postgres.extensions()],
  json: Jason)

# Ecto: Geo.PostGIS types
config :cool_app, CoolApp.Repo, types: CoolApp.PostgresTypes
```

Example 4 (unknown):
```unknown
defmodule Area do
  use Ash.Resource, data_layer: AshPostgres.DataLayer

  import AshGeo.Postgis

  attributes do
    uuid_primary_key :id,
    attribute :geom, :geometry, allow_nil?: false
  end

  actions do
    create :create do
      argument :geom, :geo_any

      change set_attribute(:geom, arg(:geom))
    end

    read :containing do
      argument :geom, :geo_any do
        allow_nil? false
        constraints geo_types: :point
      end

      filter expr(^st_within(^arg(:geom), geom))
    end
  end

  code_interface do
    define_for Area
    define :create, args: [:geom]
    define 
...
```

---
