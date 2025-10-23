# Geo-Elixir - Encoding

**Pages:** 5

---

## Geo.JSON (Geo v4.1.0)

**URL:** https://hexdocs.pm/geo/Geo.JSON.html

**Contents:**
- Geo.JSON (Geo v4.1.0)
- Examples
- Summary
- Functions
- Functions
- decode(geo_json)
- decode!(geo_json)
- encode(geom)
- encode(geom, opts)
- encode!(geom)

Converts Geo structs to and from a map representing GeoJSON.

You are responsible to encoding and decoding of JSON. This is so that you can use any JSON parser you want as well as making it so that you can use the resulting GeoJSON structure as a property in larger JSON structures.

Note that, per the GeoJSON spec, all geometries are assumed to use the WGS 84 datum (SRID 4326) by default.

Takes a map representing GeoJSON and returns a Geometry.

Takes a map representing GeoJSON and returns a Geometry.

Takes a Geometry and returns a map representing the GeoJSON.

See Geo.JSON.Encoder.encode/2.

Takes a Geometry and returns a map representing the GeoJSON.

See Geo.JSON.Encoder.encode!/2.

Takes a map representing GeoJSON and returns a Geometry.

Takes a map representing GeoJSON and returns a Geometry.

Takes a Geometry and returns a map representing the GeoJSON.

See Geo.JSON.Encoder.encode/2.

Takes a Geometry and returns a map representing the GeoJSON.

See Geo.JSON.Encoder.encode!/2.

Hex Package Hex Preview Search HexDocs

Built using ExDoc (v0.38.4) for the Elixir programming language

**Examples:**

Example 1 (javascript):
```javascript
# Using JSON or Jason as the JSON parser for these examples

iex> json = "{ \"type\": \"Point\", \"coordinates\": [100.0, 0.0] }"
...> json |> (if Code.ensure_loaded?(JSON), do: JSON, else: Jason).decode!() |> Geo.JSON.decode!()
%Geo.Point{coordinates: {100.0, 0.0}, srid: 4326}

iex> geom = %Geo.Point{coordinates: {100.0, 0.0}, srid: nil}
...> (if Code.ensure_loaded?(JSON), do: JSON, else: Jason).encode!(geom)
"{\"coordinates\":[100.0,0.0],\"type\":\"Point\"}"

iex> geom = %Geo.Point{coordinates: {100.0, 0.0}, srid: nil}
...> Geo.JSON.encode!(geom)
%{"type" => "Point", "coordinates" => [100.0,
...
```

---

## Geo.WKB (Geo v4.1.0)

**URL:** https://hexdocs.pm/geo/Geo.WKB.html

**Contents:**
- Geo.WKB (Geo v4.1.0)
- Examples
- Summary
- Functions
- Functions
- decode(wkb)
- decode!(wkb)
- encode(geom, endian \\ :xdr)
- encode!(geom, endian \\ :xdr)
- encode_to_iodata(geom, endian \\ :xdr)

Converts to and from WKB and EWKB.

It supports WKB both as base-16 encoded strings or as binaries.

Takes a WKB, either as a base-16 encoded string or a binary, and returns a Geometry.

Takes a WKB, either as a base-16 encoded string or a binary, and returns a Geometry.

Takes a Geometry and returns a base-16 encoded WKB string.

Takes a Geometry and returns a base-16 encoded WKB string.

Takes a Geometry and returns WKB as iodata (a sequence of bytes).

Takes a WKB, either as a base-16 encoded string or a binary, and returns a Geometry.

Takes a WKB, either as a base-16 encoded string or a binary, and returns a Geometry.

Takes a Geometry and returns a base-16 encoded WKB string.

The endian decides what the byte order will be.

Takes a Geometry and returns a base-16 encoded WKB string.

The endian decides what the byte order will be.

Takes a Geometry and returns WKB as iodata (a sequence of bytes).

The endian decides what the byte order will be.

Hex Package Hex Preview Search HexDocs

Built using ExDoc (v0.38.4) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
iex> {:ok, point} = Geo.WKB.decode("0101000000000000000000F03F000000000000F03F")
Geo.Point[coordinates: {1, 1}, srid: nil]

iex> Geo.WKT.encode!(point)
"POINT(1 1)"

iex> point = Geo.WKB.decode!("0101000020E61000009EFB613A637B4240CF2C0950D3735EC0")
Geo.Point[coordinates: {36.9639657, -121.8097725}, srid: 4326]
```

---

## Geo.WKT (Geo v4.1.0)

**URL:** https://hexdocs.pm/geo/Geo.WKT.html

**Contents:**
- Geo.WKT (Geo v4.1.0)
- Examples
- Summary
- Functions
- Functions
- decode(wkt)
- decode!(wkt)
- encode(geom)
- encode!(geom)

Converts to and from WKT and EWKT

Takes a WKT string and returns a Geo.geometry struct or list of Geo.geometry.

Takes a WKT string and returns a Geo.geometry struct or list of Geo.geometry.

Takes a Geometry and returns a WKT string.

Takes a Geometry and returns a WKT string.

Takes a WKT string and returns a Geo.geometry struct or list of Geo.geometry.

Takes a WKT string and returns a Geo.geometry struct or list of Geo.geometry.

Takes a Geometry and returns a WKT string.

Takes a Geometry and returns a WKT string.

Hex Package Hex Preview Search HexDocs

Built using ExDoc (v0.38.4) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
iex> {:ok, point} = Geo.WKT.decode("POINT(30 -90)")
Geo.Point[coordinates: {30, -90}, srid: nil]

iex> Geo.WKT.encode!(point)
"POINT(30 -90)"

iex> point = Geo.WKT.decode!("SRID=4326;POINT(30 -90)")
Geo.Point[coordinates: {30, -90}, srid: 4326]
```

---

## Geo.JSON.Encoder.EncodeError exception (Geo v4.1.0)

**URL:** https://hexdocs.pm/geo/Geo.JSON.Encoder.EncodeError.html

**Contents:**
- Geo.JSON.Encoder.EncodeError exception (Geo v4.1.0)
- Summary
- Types
- Types
- t()

Hex Package Hex Preview Search HexDocs

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## Geo.JSON.Decoder.DecodeError exception (Geo v4.1.0)

**URL:** https://hexdocs.pm/geo/Geo.JSON.Decoder.DecodeError.html

**Contents:**
- Geo.JSON.Decoder.DecodeError exception (Geo v4.1.0)
- Summary
- Types
- Types
- t()

Hex Package Hex Preview Search HexDocs

Built using ExDoc (v0.38.4) for the Elixir programming language

---
