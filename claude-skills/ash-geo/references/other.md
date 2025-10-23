# Ash-Geo - Other

**Pages:** 5

---

## AshGeo.Validation.Topo (AshGeo v0.3.0)

**URL:** https://hexdocs.pm/ash_geo/AshGeo.Validation.Topo.html

**Contents:**
- AshGeo.Validation.Topo (AshGeo v0.3.0)
  - Options
  - See also

Validate that the specified Topo function return true.

:function - Required. Topo function to use for comparison Valid values are :contains?, :disjoint?, :equals?, :intersects?, :within?

:geometry_a (atom/0) - Required. Geometry A

:geometry_b (atom/0) - Required. Geometry B

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.34.2) for the Elixir programming language

---

## Change Log

**URL:** https://hexdocs.pm/ash_geo/changelog.html

**Contents:**
- Change Log
- v0.3.0 (2024-07-31)
  - Breaking Changes:
- v0.2.0 (2023-08-09)
  - Features:
  - Bug Fixes:
  - Improvements:
- v0.1.3 (2023-07-31)
  - Bug Fixes:
- v0.1.2 (2023-06-07)

All notable changes to this project will be documented in this file. See Conventional Commits for commit guidelines.

make topo also an optional dependency

missing expr on fragment

remove reduntant docs task from mix check

ensure ci gets triggered on release

adapt ci workflow from ash, plus coveralls and more

Hex Package Hex Preview (current file) Search HexDocs Download ePub version

Built using ExDoc (v0.34.2) for the Elixir programming language

---

## 

**URL:** https://hexdocs.pm/ash_geo/AshGeo.epub

---

## 

**URL:** https://hexdocs.pm/ash_geo/

---

## AshGeo (AshGeo v0.3.0)

**URL:** https://hexdocs.pm/ash_geo/AshGeo.html

**Contents:**
- AshGeo (AshGeo v0.3.0)
- Summary
- Functions
- Functions
- geo_type_aliases()
- geo_types()
- is_geo(struct)
- module_suffix_to_snake(module)
- topo_functions()

Base module containing common utility functions

This module contains some things used internally that may also be useful outside of AshGeo itself, but depending upon what you what to do, you should probably be using one of:

Type aliases for Geo types, auto-generated from the module names

Macro to check whether a module is a Geo type, suitable for use in guards

Transform the last element of a module path into a snake-cased atom.

List of Topo functions

Type aliases for Geo types, auto-generated from the module names

For example, the alias derived from Geo.PointZM is :point_zm.

Macro to check whether a module is a Geo type, suitable for use in guards

Transform the last element of a module path into a snake-cased atom.

List of Topo functions

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.34.2) for the Elixir programming language

---
