# Ash-Postgres - Configuration

**Pages:** 7

---

## AshPostgres.Extensions.Vector (ash_postgres v2.6.23)

**URL:** https://hexdocs.pm/ash_postgres/AshPostgres.Extensions.Vector.html

**Contents:**
- AshPostgres.Extensions.Vector (ash_postgres v2.6.23)
- Summary
- Functions
- Functions
- decode(arg1)
- encode(_)
- format(_)
- init(opts)
- matching(_)

An extension that adds support for the vector type.

Create a file with these contents, not inside of a module:

And then ensure that you refer to these types in your repo configuration, i.e

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
Postgrex.Types.define(<YourApp>.PostgrexTypes, [AshPostgres.Extensions.Vector] ++ Ecto.Adapters.Postgres.extensions(), [])
```

Example 2 (unknown):
```unknown
config :my_app, YourApp.Repo,
  types: <YourApp>.PostgrexTypes
```

---

## mix ash_postgres.rollback (ash_postgres v2.6.23)

**URL:** https://hexdocs.pm/ash_postgres/Mix.Tasks.AshPostgres.Rollback.html

**Contents:**
- mix ash_postgres.rollback (ash_postgres v2.6.23)
- Examples
- Command line options

Reverts applied migrations in the given repository. Migrations are expected at "priv/YOUR_REPO/migrations" directory of the current application but it can be configured by specifying the :priv key under the repository configuration. Runs the latest applied migration by default. To roll back to a version number, supply --to version_number. To roll back a specific number of times, use --step n. To undo all applied migrations, provide --all.

This is only really useful if your domains only use a single repo. If you have multiple repos and you want to run a single migration and/or migrate/roll them back to different points, you will need to use the ecto specific task, mix ecto.migrate and provide your repo name.

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
mix ash_postgres.rollback
mix ash_postgres.rollback -r Custom.Repo
mix ash_postgres.rollback -n 3
mix ash_postgres.rollback --step 3
mix ash_postgres.rollback -v 20080906120000
mix ash_postgres.rollback --to 20080906120000
```

---

## Using Multiple Repos

**URL:** https://hexdocs.pm/ash_postgres/using-multiple-repos.html

**Contents:**
- Using Multiple Repos
- Setup Read Replicas
- Configure AshPostgres

When scaling PostgreSQL you may want to setup read replicas to improve performance and availability. This can be achieved by configuring multiple repositories in your application.

Following the ecto docs, change your Repo configuration:

Now change the repo argument for your postgres block as such:

Hex Package Hex Preview (current file) Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

**Examples:**

Example 1 (python):
```python
defmodule MyApp.Repo do
  use Ecto.Repo,
    otp_app: :my_app,
    adapter: Ecto.Adapters.Postgres

  @replicas [
    MyApp.Repo.Replica1,
    MyApp.Repo.Replica2,
    MyApp.Repo.Replica3,
    MyApp.Repo.Replica4
  ]

  def replica do
    Enum.random(@replicas)
  end

  for repo <- @replicas do
    defmodule repo do
      use Ecto.Repo,
        otp_app: :my_app,
        adapter: Ecto.Adapters.Postgres,
        read_only: true
    end
  end
end
```

Example 2 (unknown):
```unknown
defmodule MyApp.MyDomain.MyResource do
  use Ash.Resource,
    date_layer: AshPostgres.DataLayer

  postgres do
    table "my_resources"
    repo fn
      _resource, :read -> MyApp.Repo.replica()
      _resource, :mutate -> MyApp.Repo
    end
  end
end
```

---

## AshPostgres.Functions.TrigramSimilarity (ash_postgres v2.6.23)

**URL:** https://hexdocs.pm/ash_postgres/AshPostgres.Functions.TrigramSimilarity.html

**Contents:**
- AshPostgres.Functions.TrigramSimilarity (ash_postgres v2.6.23)
- Summary
- Functions
- Functions
- args()
- has_partial_evaluate?()

Maps to the builtin postgres trigram similarity function. Requires pgtrgm extension to be installed.

See the postgres docs on trigram for more information.

Requires the pg_trgm extension. Configure which extensions you have installed in your AshPostgres.Repo

Callback implementation for Ash.Query.Function.args/0.

Callback implementation for Ash.Query.Function.args/0.

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
# Example

filter(query, trigram_similarity(name, "geoff") > 0.4)
```

---

## mix ash_postgres.create (ash_postgres v2.6.23)

**URL:** https://hexdocs.pm/ash_postgres/Mix.Tasks.AshPostgres.Create.html

**Contents:**
- mix ash_postgres.create (ash_postgres v2.6.23)
- Examples
- Command line options

Create the storage for repos in all resources for the given (or configured) domains.

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
mix ash_postgres.create
mix ash_postgres.create --domains MyApp.Domain1,MyApp.Domain2
```

---

## AshPostgres.Repo behaviour (ash_postgres v2.6.23)

**URL:** https://hexdocs.pm/ash_postgres/AshPostgres.Repo.html

**Contents:**
- AshPostgres.Repo behaviour (ash_postgres v2.6.23)
- Installed Extensions
- Transaction Hooks
- Additional Repo Configuration
- Summary
- Callbacks
- Callbacks
- all_tenants()
- create?()
- create_schemas_in_migrations?()

Resources that use AshPostgres.DataLayer use a Repo to access the database.

This repo is a thin wrapper around an Ecto.Repo.

You can use Ecto.Repo's init/2 to configure your repo like normal, but instead of returning {:ok, config}, use super(config) to pass the configuration to the AshPostgres.Repo implementation.

To configure your list of installed extensions, define installed_extensions/0

Extensions can be a string, representing a standard postgres extension, or a module that implements AshPostgres.CustomExtension. That custom extension will be called to generate migrations that serve a specific purpose.

Extensions that are relevant to ash_postgres:

You can define on_transaction_begin/1, which will be invoked whenever a transaction is started for Ash.

This will be invoked with a map containing a type key and metadata.

Because an AshPostgres.Repo is also an Ecto.Repo, it has all of the same callbacks.

In the Ecto.Repo.init/2 callback, you can configure the following additional items:

Return a list of all schema names (only relevant for a multitenant implementation)

Should the repo should be created by mix ash_postgres.create?

Whether or not to create schemas for tables when generating migrations

Determine how constraint names are matched when generating errors.

The default prefix(postgres schema) to use when building queries

Disable atomic actions for this repo

Disable expression errors for this repo

Should the repo should be dropped by mix ash_postgres.drop?

Opt-in to using immutable versions of the expression error functions.

Use this to inform the data layer about what extensions are installed

The path where your migrations are stored

Configure the version of postgres that is being used.

Use this to inform the data layer about the oldest potential postgres version it will be run on.

Allows overriding a given migration type for all fields, for example if you wanted to always use :timestamptz for :utc_datetime fields

Whether or not to explicitly start and close a transaction for each action, even if there are no transaction hooks. Defaults to true.

Whether or not to explicitly start and close a transaction for each atomic update action, even if there are no transaction hooks. Defaults to false.

The path where your tenant migrations are stored (only relevant for a multitenant implementation)

Return a list of all schema names (only relevant for a multitenant implementation)

Should the repo should be created by mix ash_postgres.c

*[Content truncated]*

**Examples:**

Example 1 (unknown):
```unknown
def installed_extensions() do
  ["pg_trgm", "uuid-ossp", "vector", YourCustomExtension]
end
```

Example 2 (unknown):
```unknown
%{type: :create, %{resource: YourApp.YourResource, action: :action}}
```

---

## Setting AshPostgres up with an existing database

**URL:** https://hexdocs.pm/ash_postgres/set-up-with-existing-database.html

**Contents:**
- Setting AshPostgres up with an existing database
- More fine grained control

If you already have a postgres database and you'd like to get started quickly, you can scaffold resources directly from your database.

First, create an application with AshPostgres if you haven't already:

Then, go into your config/dev.exs and configure your repo to use your existing database.

You may want to do multiple passes to separate your application into multiple domains. For example:

See the docs for mix ash_postgres.gen.resources for more information.

Hex Package Hex Preview (current file) Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
mix igniter.new my_app
  --install ash,ash_postgres
  --with phx.new # add this if you will be using phoenix too
```

Example 2 (unknown):
```unknown
mix ash_postgres.gen.resources MyApp.MyDomain --tables table1,table2,table3
```

Example 3 (unknown):
```unknown
mix ash_postgres.gen.resources MyApp.Accounts --tables users,roles,tokens
mix ash_postgres.gen.resources MyApp.Blog --tables posts,comments
```

---
