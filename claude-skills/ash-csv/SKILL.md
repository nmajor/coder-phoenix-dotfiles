---
name: ash-csv
description: CSV file operations and data import/export. Use when working with CSV file reading, CSV imports, CSV exports, CSV as data source, CSV parsing, or bulk data operations with CSV files.
---

# Ash-Csv Skill

Comprehensive assistance with ash-csv development, generated from official documentation.

## When to Use This Skill

This skill should be triggered when:
- Setting up CSV as a data layer for Ash resources
- Reading data from CSV files in an Ash application
- Configuring CSV file paths, headers, or separators
- Importing or exporting CSV data in Ash resources
- Working with static or reference data stored in CSV files
- Troubleshooting CSV data layer configurations
- Querying CSV-based resources using Ash.Query
- Defining Ash resources that use CSV files as their backing store

## Key Concepts

### What is AshCsv?
AshCsv is a data layer for the Ash Framework that allows you to use CSV files as a data source. Instead of storing data in a database, you can read (and optionally write) data from CSV files. This is particularly useful for:
- Static reference data (countries, states, tags, etc.)
- Small datasets that don't require a database
- Data import/export scenarios
- Prototyping before setting up a database

### Core Components
- **Data Layer**: `AshCsv.DataLayer` - The main module that implements the Ash data layer interface
- **Configuration DSL**: The `csv` block in your resource definition
- **File Options**: Configure file path, headers, separators, and column mapping

## Quick Reference

### Basic CSV Resource Setup

```elixir
defmodule MyApp.Tag do
  use Ash.Resource,
    domain: MyApp.Domain,
    data_layer: AshCsv.DataLayer

  csv do
    file "priv/data/tags.csv"
    header? true
    separator ","
    columns [:id, :name]
  end

  attributes do
    uuid_primary_key :id
    attribute :name, :string, allow_nil?: false
  end

  actions do
    defaults [:read]
  end
end
```

### CSV Resource with Create Support

```elixir
defmodule MyApp.Country do
  use Ash.Resource,
    domain: MyApp.Domain,
    data_layer: AshCsv.DataLayer

  csv do
    file "priv/data/countries.csv"
    create? true  # Allow creating new records
    header? true
    columns [:code, :name, :continent]
  end

  attributes do
    attribute :code, :string, primary_key?: true
    attribute :name, :string, allow_nil?: false
    attribute :continent, :string
  end

  actions do
    defaults [:read, :create]
  end
end
```

### Custom Separator Configuration

```elixir
csv do
  file "priv/data/custom.csv"
  separator ';'  # Use semicolon instead of comma
  header? true
  columns [:id, :field1, :field2]
end
```

### CSV Without Headers

```elixir
csv do
  file "priv/data/no_headers.csv"
  header? false  # CSV file has no header row
  columns [:id, :name, :value]
end
```

### Reading CSV Data with Ash.Query

```elixir
# Read all records
MyApp.Tag
|> Ash.Query.new()
|> Ash.read!()

# Filter CSV data
MyApp.Country
|> Ash.Query.filter(continent == "Europe")
|> Ash.read!()

# Sort CSV data
MyApp.Tag
|> Ash.Query.sort(name: :asc)
|> Ash.read!()
```

### Creating Records in CSV

```elixir
# Create a new record (if create? is enabled)
MyApp.Country
|> Ash.Changeset.for_create(:create, %{
  code: "US",
  name: "United States",
  continent: "North America"
})
|> Ash.create!()
```

### Accessing CSV Configuration

```elixir
# Get file path
AshCsv.DataLayer.file(MyApp.Tag)
# => "priv/data/tags.csv"

# Check if headers are enabled
AshCsv.DataLayer.header?(MyApp.Tag)
# => true

# Get separator
AshCsv.DataLayer.separator(MyApp.Tag)
# => ","

# Get column mapping
AshCsv.DataLayer.columns(MyApp.Tag)
# => [:id, :name]
```

## Reference Files

This skill includes comprehensive documentation in `references/`:

### configuration.md
Installation guide and basic setup instructions for AshCsv. Start here to add the dependency to your project and understand the basic DSL configuration options.

**Contains:**
- Installation instructions
- Dependency configuration
- Link to DSL documentation

### reading.md
Overview of the AshCsv package and links to tutorials and reference materials.

**Contains:**
- Package introduction
- Links to tutorials
- Navigation to reference documentation

### other.md
Complete API reference for AshCsv modules and functions.

**Contains:**
- `AshCsv` - Main module overview
- `AshCsv.DataLayer` - Data layer implementation details
- `AshCsv.DataLayer.Info` - Introspection helper functions
- DSL reference with all configuration options
- Function signatures and usage

## Working with This Skill

### For Beginners
1. Start with `references/configuration.md` to understand installation
2. Review the basic CSV resource setup example in Quick Reference
3. Create a simple CSV file in `priv/data/` with your data
4. Define your first CSV-backed resource
5. Use `Ash.read!()` to query your CSV data

### For Specific Features
- **File Configuration**: See `references/other.md` for DSL options (file, header?, separator, columns)
- **Querying CSV Data**: Use standard `Ash.Query` functions - filtering, sorting, and selecting work on CSV resources
- **Creating Records**: Enable `create? true` in the csv block and use standard Ash create actions
- **Custom Separators**: Use the `separator` option for tab, semicolon, or other delimiters
- **Column Mapping**: Use the `columns` option to map CSV columns to resource attributes

### For Advanced Usage
- Use `AshCsv.DataLayer.Info` functions to introspect CSV configuration at runtime
- Combine CSV resources with other data layers in the same application
- Use CSV resources for seed data or reference tables
- Implement custom validations and calculations on CSV-backed attributes

### Common Patterns

**Static Reference Data Pattern**
```elixir
# Great for data that rarely changes
csv do
  file "priv/data/us_states.csv"
  header? true
  columns [:code, :name]
end
```

**Import/Export Pattern**
```elixir
# Enable create? for data export scenarios
csv do
  file "priv/data/export.csv"
  create? true
  header? true
  columns [:timestamp, :event, :data]
end
```

**Prototype Pattern**
```elixir
# Use CSV during development, swap to Postgres later
# The beauty of Ash: just change the data_layer!
data_layer: AshCsv.DataLayer  # Dev
# data_layer: AshPostgres.DataLayer  # Production
```

## Resources

### Installation
Add to your `mix.exs`:
```elixir
{:ash_csv, "~> 0.9.7-rc.0"}
```

### References Directory
- **configuration.md** - Installation and getting started guide
- **reading.md** - Package overview and documentation navigation
- **other.md** - Complete API reference for all modules and functions

### Example CSV File Format
```csv
id,name,active
1,Tag One,true
2,Tag Two,false
3,Tag Three,true
```

## Important Notes

- CSV files are **read into memory** - not suitable for large datasets
- **Limited query capabilities** compared to database data layers (no complex joins, aggregations may be slower)
- **create?** option enables writing new records back to the CSV file
- **header?** should match whether your CSV file has a header row
- **columns** must match the order of columns in your CSV file
- All standard Ash.Query operations work (filter, sort, limit, offset)
- Can be mixed with other data layers in the same application
- Perfect for static/reference data that doesn't change frequently

## Troubleshooting

### Common Issues

**File not found errors**
- Ensure the file path is relative to your project root
- Check that the CSV file exists at the specified path
- Use `File.exists?("priv/data/yourfile.csv")` to verify

**Data not loading**
- Verify `header?` matches your CSV file structure
- Check that `columns` list matches the order in your CSV
- Ensure attribute types match the data in your CSV

**Create operations failing**
- Verify `create? true` is set in the csv block
- Check file permissions for write access
- Ensure your CSV file exists before trying to create records

## Updating

This skill was automatically generated from official AshCsv documentation (v0.9.7). To refresh with updated documentation, re-run the scraper with the same configuration.
