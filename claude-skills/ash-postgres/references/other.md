# Ash-Postgres - Other

**Pages:** 16

---

## AshPostgres.Ltree (ash_postgres v2.6.23)

**URL:** https://hexdocs.pm/ash_postgres/AshPostgres.Ltree.html

**Contents:**
- AshPostgres.Ltree (ash_postgres v2.6.23)
- Postgres Extension
- Constraints
- Summary
- Types
- Functions
- Types
- segment()
- t()
- Functions

Ash Type for postgres ltree, a hierarchical tree-like data type.

To be able to use the ltree type, you'll have to enable the postgres ltree extension first.

:escape? (boolean/0) - Escape the ltree segments to make it possible to include characters that are either . (the separation character) or any other unsupported character like - (Postgres <= 15).If the option is enabled, any characters besides [0-9a-zA-Z] will be replaced with _[HEX Ascii Code].Additionally the type will no longer take strings as user input since it's impossible to decide between . being a separator or part of a segment.If the option is disabled, any string will be relayed directly to postgres. If the segments are provided as a list, they can't contain . since postgres would split the segment.

:min_length (non_neg_integer/0) - A minimum length for the tree segments.

:max_length (non_neg_integer/0) - A maximum length for the tree segments.

Get shared root of given ltrees.

Get shared root of given ltrees.

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
iex> Ltree.shared_root(["1", "2"], ["1", "1"])
["1"]

iex> Ltree.shared_root(["1", "2"], ["2", "1"])
[]
```

---

## 

**URL:** https://hexdocs.pm/ash_postgres/ash_postgres.epub

---

## Polymorphic Resources

**URL:** https://hexdocs.pm/ash_postgres/polymorphic-resources.html

**Contents:**
- Polymorphic Resources
- Table specific actions
- Migrations

To support leveraging the same resource backed by multiple tables (useful for things like polymorphic associations), AshPostgres supports setting the data_layer.table context for a given resource. For this example, lets assume that you have a MyApp.Post resource and a MyApp.Comment resource. For each of those resources, users can submit reactions. However, you want a separate table for post_reactions and comment_reactions. You could accomplish that like so:

Then, in your related resources, you set the table context like so:

With this, when loading or editing related data, ash will automatically set that context. For managing related data, see Ash.Changeset.manage_relationship/4 and other relationship functions in Ash.Changeset

To make actions use a specific table, you can use the set_context query preparation/change.

When a migration is marked as polymorphic? true, the migration generator will look at all resources that are related to it, that set the %{data_layer: %{table: "table"}} context. For each of those, a migration is generated/managed automatically. This means that adding reactions to a new resource is as easy as adding the relationship and table context, and then running mix ash.codegen.

Hex Package Hex Preview (current file) Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
defmodule MyApp.Reaction do
  use Ash.Resource,
    domain: MyDomain,
    data_layer: AshPostgres.DataLayer

  postgres do
    polymorphic? true # Without this, `table` is a required configuration
  end

  attributes do
    attribute :resource_id, :uuid, public?: true
  end

  ...
end
```

Example 2 (unknown):
```unknown
defmodule MyApp.Post do
  use Ash.Resource,
    domain: MyDomain,
    data_layer: AshPostgres.DataLayer

  ...

  relationships do
    has_many :reactions, MyApp.Reaction,
      relationship_context: %{data_layer: %{table: "post_reactions"}},
      destination_attribute: :resource_id
  end
end

defmodule MyApp.Comment do
  use Ash.Resource,
    domain: MyDomain,
    data_layer: AshPostgres.DataLayer

  ...

  relationships do
    has_many :reactions, MyApp.Reaction,
      relationship_context: %{data_layer: %{table: "comment_reactions"}},
      destination_attribute: :resource_id
  end
end
```

Example 3 (unknown):
```unknown
defmodule MyApp.Reaction do
  # ...
  actions do
    read :for_comments do
      prepare set_context(%{data_layer: %{table: "comment_reactions"}})
    end

    read :for_posts do
      prepare set_context(%{data_layer: %{table: "post_reactions"}})
    end
  end
end
```

---

## AshPostgres.Statement (ash_postgres v2.6.23)

**URL:** https://hexdocs.pm/ash_postgres/AshPostgres.Statement.html

**Contents:**
- AshPostgres.Statement (ash_postgres v2.6.23)
- Summary
- Functions
- Functions
- fields()
- schema()

Represents a custom statement to be run in generated migrations

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## mix ash_postgres.drop (ash_postgres v2.6.23)

**URL:** https://hexdocs.pm/ash_postgres/Mix.Tasks.AshPostgres.Drop.html

**Contents:**
- mix ash_postgres.drop (ash_postgres v2.6.23)
- Examples
- Command line options

Drop the storage for the given repository.

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
mix ash_postgres.drop
mix ash_postgres.drop --domains MyApp.Domain1,MyApp.Domain2
```

---

## Expressions

**URL:** https://hexdocs.pm/ash_postgres/expressions.html

**Contents:**
- Expressions
- Fragments
  - Examples
    - Simple expressions
    - Calling functions
    - Using entire queries
  - a last resort
    - In calculations
    - In migrations
- Like and ILike

In addition to the expressions listed in the Ash expressions guide, AshPostgres provides the following expressions

Fragments allow you to use arbitrary postgres expressions in your queries. Fragments can often be an escape hatch to allow you to do things that don't have something officially supported with Ash.

Using entire queries as shown above is a last resort, but can sometimes be the best way to accomplish a given task.

These wrap the postgres builtin like and ilike operators.

Please be aware, these match patterns not raw text. Use contains/1 if you want to match text without supporting patterns, i.e % and _ have semantic meaning!

To use this expression, you must have the pg_trgm extension in your repos installed_extensions list.

This calls the similarity function from that extension. See more in the pgtrgm guide

Hex Package Hex Preview (current file) Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
fragment("? / ?", points, count)
```

Example 2 (unknown):
```unknown
fragment("repeat('hello', 4)")
```

Example 3 (unknown):
```unknown
fragment("points > (SELECT SUM(points) FROM games WHERE user_id = ? AND id != ?)", user_id, id)
```

Example 4 (unknown):
```unknown
calculations do
  calculate :lower_name, :string, expr(
    fragment("LOWER(?)", name)
  )
end
```

---

## AshPostgres.DataLayer (ash_postgres v2.6.23)

**URL:** https://hexdocs.pm/ash_postgres/AshPostgres.DataLayer.html

**Contents:**
- AshPostgres.DataLayer (ash_postgres v2.6.23)
- Summary
- Functions
- Functions
- add_known_binding(query, data, known_binding)
- codegen(args)
- from_ecto(other)
- install(igniter, _, _, _)
- install(igniter, module, arg, path, argv)
- migrate(args)

A postgres data layer that leverages Ecto's postgres capabilities.

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## Home

**URL:** https://hexdocs.pm/ash_postgres/readme.html

**Contents:**
- Home
- AshPostgres
- Tutorials
- Topics
  - Resources
  - Development
  - Advanced
- Reference

Welcome! AshPostgres is the PostgreSQL data layer for Ash Framework.

Minimum required PostgreSQL version: 13.0

Hex Package Hex Preview (current file) Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## AshPostgres.Functions.VectorCosineDistance (ash_postgres v2.6.23)

**URL:** https://hexdocs.pm/ash_postgres/AshPostgres.Functions.VectorCosineDistance.html

**Contents:**
- AshPostgres.Functions.VectorCosineDistance (ash_postgres v2.6.23)
- Summary
- Functions
- Functions
- args()
- has_partial_evaluate?()

Maps to the vector cosine distance operator. Requires vector extension to be installed.

Callback implementation for Ash.Query.Function.args/0.

Callback implementation for Ash.Query.Function.args/0.

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## AshPostgres.CustomExtension behaviour (ash_postgres v2.6.23)

**URL:** https://hexdocs.pm/ash_postgres/AshPostgres.CustomExtension.html

**Contents:**
- AshPostgres.CustomExtension behaviour (ash_postgres v2.6.23)
- Summary
- Callbacks
- Callbacks
- install(version)
- uninstall(version)

A custom extension implementation.

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## Testing with AshPostgres

**URL:** https://hexdocs.pm/ash_postgres/testing.html

**Contents:**
- Testing with AshPostgres

When using AshPostgres resources in tests, you will likely want to include use a test case similar to the following. This will ensure that your repo runs everything in a transaction.

This should be coupled with to make sure that Ash does not spawn any tasks.

Hex Package Hex Preview (current file) Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
defmodule MyApp.DataCase do
  @moduledoc """
  This module defines the setup for tests requiring
  access to the application's data layer.

  You may define functions here to be used as helpers in
  your tests.

  Finally, if the test case interacts with the database,
  we enable the SQL sandbox, so changes done to the database
  are reverted at the end of every test. If you are using
  PostgreSQL, you can even run database tests asynchronously
  by setting `use AshHq.DataCase, async: true`, although
  this option is not recommended for other databases.
  """

  use ExUnit.CaseTemplate

  usin
...
```

Example 2 (unknown):
```unknown
config :ash, :disable_async?, true
```

---

## AshPostgres.Extensions.ImmutableRaiseError (ash_postgres v2.6.23)

**URL:** https://hexdocs.pm/ash_postgres/AshPostgres.Extensions.ImmutableRaiseError.html

**Contents:**
- AshPostgres.Extensions.ImmutableRaiseError (ash_postgres v2.6.23)
- Summary
- Functions
- Functions
- extension()

An extension that installs an immutable version of ash_raise_error.

This can be used to improve compatibility with Postgres sharding extensions like Citus, which requires functions used in CASE or COALESCE expressions to be immutable.

The new ash_raise_error_immutable functions add an additional row-dependent argument to ensure the planner doesn't constant-fold error expressions.

To install, add this module to your repo's installed_extensions list:

And run mix ash_postgres.generate_migrations to generate the migrations.

Once installed, you can control whether the immutable function is used by adding this to your repo:

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
def installed_extensions do
  ["ash-functions", AshPostgres.Extensions.ImmutableRaiseError]
end
```

Example 2 (python):
```python
def immutable_expr_error?, do: true
```

---

## mix ash_postgres.gen.resources (ash_postgres v2.6.23)

**URL:** https://hexdocs.pm/ash_postgres/Mix.Tasks.AshPostgres.Gen.Resources.html

**Contents:**
- mix ash_postgres.gen.resources (ash_postgres v2.6.23)
- Example
- Domain
- Options
- Tables

Generates resources based on a database schema

mix ash_postgres.gen.resources MyApp.MyDomain

The domain will be generated if it does not exist. If you aren't sure, we suggest using something like MyApp.App.

When specifying tables to include with --tables, you can specify the table name, or the schema and table name separated by a period. For example, users will generate resources for the users table in the public schema, but accounts.users will generate resources for the users table in the accounts schema.

To include all tables in a given schema, add a period only with no table name, i.e schema., i.e accounts..

When skipping tables with --skip-tables, the same rules apply, except that the schema. format is not supported.

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## Manual Relationships

**URL:** https://hexdocs.pm/ash_postgres/manual-relationships.html

**Contents:**
- Manual Relationships
- Example
- Recursive Relationships
  - Use ltree

See Manual Relationships for an idea of manual relationships in general. Manual relationships allow for expressing complex/non-typical relationships between resources in a standard way. Individual data layers may interact with manual relationships in their own way, so see their corresponding guides.

Manual relationships can be very powerful, as they can leverage the full power of Ecto to do arbitrarily complex things. Here is an example of a recursive relationship that loads all employees under the purview of a given manager using a recursive CTE.

While the below is very powerful, if at all possible we suggest using ltree for hierarchical data. Its built in to postgres and AshPostgres has built in support for it. For more, see: AshPostgres.Ltree.

Keep in mind this is an example of a very advanced use case, not something you'd typically need to do.

With the above definition, employees could have a relationship like this:

And you could then use it in calculations and aggregates! For example, to see the count of employees managed by each employee:

Hex Package Hex Preview (current file) Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

**Examples:**

Example 1 (javascript):
```javascript
# in the resource

relationships do
  has_many :tickets_above_threshold, Helpdesk.Support.Ticket do
    manual Helpdesk.Support.Ticket.Relationships.TicketsAboveThreshold
  end
end

# implementation
defmodule Helpdesk.Support.Ticket.Relationships.TicketsAboveThreshold do
  use Ash.Resource.ManualRelationship
  use AshPostgres.ManualRelationship

  require Ash.Query
  require Ecto.Query

  def load(records, _opts, %{query: query, actor: actor, authorize?: authorize?}) do
    # Use existing records to limit resultds
    rep_ids = Enum.map(records, & &1.id)
     # Using Ash to get the destination
...
```

Example 2 (python):
```python
defmodule MyApp.Employee.ManagedEmployees do
  @moduledoc """
  A manual relationship which uses a recursive CTE to find all employees managed by a given employee.
  """

  use Ash.Resource.ManualRelationship
  use AshPostgres.ManualRelationship
  alias MyApp.Employee
  alias MyApp.Repo
  import Ecto.Query

  @doc false
  @impl true
  @spec load([Employee.t()], keyword, map) ::
          {:ok, %{Ash.UUID.t() => [Employee.t()]}} | {:error, any}
  def load(employees, _opts, context) do
    relationship_name = context.relationship.name

    employee_ids = Enum.map(employees, & &1.id)

    all_des
...
```

Example 3 (unknown):
```unknown
has_many :managed_employees, MyApp.Employee do
  manual MyApp.Employee.ManagedEmployees
end
```

Example 4 (unknown):
```unknown
aggregates do
  count :count_of_managed_employees, :managed_employees
end
```

---

## Upgrading to 2.0

**URL:** https://hexdocs.pm/ash_postgres/upgrading-to-2-0.html

**Contents:**
- Upgrading to 2.0
- AshPostgres officially supports only postgresql version 14 or higher
- gen_random_uuid() is now the default for generated uuids
- utc datetimes that default to &DateTime.now/0 are now cast to UTC

There are only three breaking changes in this release, one of them is very significant, the other two are minor.

A new callback min_pg_version/0 has been added to the repo, but a default implementation is set up that reads the version from postgres directly, the first time it is required. It is cached until the repo is reinitialized, at which point it is looked up again.

While most things will work with versions as low as 9, we are relying on features of newer postgres versions and intend to do so more in the future. We will not be testing against versions lower than 14, and we will not be supporting them. If you are using an older version of postgres, you will need to upgrade.

If you must use an older version, the only thing that you'll need to change in the short term is to handle the fact that we now use gen_random_uuid() as the default for generated uuids (see below), which is only available after postgres 13. Additionally, if you are on postgres 12 or earlier, you will need to replace ANYCOMPATIBLE with ANYELEMENT in the ash-functions extension migration.

In the past, we used uuid_generate_v4() as the default for generated uuids. This function is part of the uuid-ossp extension, which is not installed by default in postgres. gen_random_uuid() is a built-in function that is available in all versions of postgres 13 and higher. If you are using an older version of postgres, you will need to install the uuid-ossp extension and change the default in your migrations.

This is a layer of safety to ensure consistency in the default values of a database and the datetimes that are sent to/from the database. When you generate migrations you will notice your timestamps change from defaulting to now() in your migrations to now() AT TIMESTAMP 'utc'. You are free to undo this change, by setting migration_defaults in your resource, or simply by deleting the generated migration.

Hex Package Hex Preview (current file) Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## What is AshPostgres?

**URL:** https://hexdocs.pm/ash_postgres/what-is-ash-postgres.html

**Contents:**
- What is AshPostgres?
  - What versions are supported?

AshPostgres is the PostgreSQL Ash.DataLayer for Ash Framework. This is the most fully-featured Ash data layer, and unless you need a specific characteristic or feature of another data layer, you should use AshPostgres.

Any version higher than 13 is fully supported. Versions lower than this can be made to work, but certain edge cases may need to be manually handled. This becomes more and more true the further back in versions that you go.

Use this to persist records in a PostgreSQL table or view. For example, the resource below would be persisted in a table called tweets:

The table might look like this:

Creating records would add to the table, destroying records would remove from the table, and updating records would update the table.

Hex Package Hex Preview (current file) Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
defmodule MyApp.Tweet do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer

  attributes do
    integer_primary_key :id
    attribute :text, :string
  end

  relationships do
    belongs_to :author, MyApp.User
  end

  postgres do
    table "tweets"
    repo MyApp.Repo
  end
end
```

---
