---
name: ash-postgres
description: Database operations and data persistence. Use for ANY database work, migrations, queries, constraints, indexes, custom SQL, database schema, and data storage with PostgreSQL.
---

# Ash-Postgres Skill

Comprehensive assistance with AshPostgres development - the PostgreSQL data layer for the Ash Framework. This skill helps you leverage Ecto's PostgreSQL capabilities through Ash's declarative DSL.

## When to Use This Skill

Trigger this skill when you need help with:

- **Database Configuration**: Setting up repos, configuring tables, schemas, and multitenancy
- **Migration Management**: Generating, running, or customizing database migrations
- **Foreign Key Configuration**: Configuring references, on_delete behaviors, and cascade rules
- **PostgreSQL-Specific Features**: Using fragments, custom indexes, check constraints, exclusion constraints
- **Query Optimization**: Leveraging trigram similarity, full-text search, and PostgreSQL functions
- **Polymorphic Resources**: Setting up resources backed by multiple tables
- **Advanced Queries**: Using LIKE/ILIKE operators, custom SQL fragments, and PostgreSQL-specific expressions
- **Read Replicas**: Configuring multiple repos for improved performance
- **Data Layer Customization**: Custom migration types, storage types, and calculated SQL

## Quick Reference

### Basic Resource Setup

Configure a resource to use PostgreSQL:

```elixir
defmodule MyApp.Support.Ticket do
  use Ash.Resource,
    domain: MyApp.Support,
    data_layer: AshPostgres.DataLayer

  postgres do
    table "tickets"
    repo MyApp.Repo
  end

  attributes do
    uuid_primary_key :id
    attribute :subject, :string, allow_nil?: false
    attribute :status, :atom, constraints: [one_of: [:open, :closed]]
  end
end
```

### Configuring the Repo

Create a repo with installed extensions:

```elixir
# lib/my_app/repo.ex
defmodule MyApp.Repo do
  use AshPostgres.Repo, otp_app: :my_app

  def installed_extensions do
    # Ash installs functions needed for migrations
    ["ash-functions", "uuid-ossp", "pg_trgm"]
  end
end
```

### Foreign Key References

Configure foreign key behavior:

```elixir
postgres do
  table "comments"
  repo MyApp.Repo

  references do
    reference :post,
      on_delete: :delete,     # Delete comments when post is deleted
      on_update: :update,     # Update foreign key when post ID changes
      name: "comments_to_posts_fkey"
  end
end
```

**Reference Options:**
- `on_delete: :nothing` - Prevent deletion (default)
- `on_delete: :restrict` - Immediately prevent deletion
- `on_delete: :delete` - Cascade delete
- `on_delete: :nilify` - Set foreign key to nil
- `on_delete: {:nilify, [:column1, :column2]}` - Set specific columns to nil (Postgres 15+)

### Custom Indexes

Define custom database indexes:

```elixir
postgres do
  table "users"
  repo MyApp.Repo

  custom_indexes do
    index [:email], unique: true
    index [:status, :created_at], where: "status = 'active'"
    index [:name], using: "GIN", name: "users_name_trgm_idx"
  end
end
```

### PostgreSQL Fragments

Use raw SQL expressions in queries and calculations:

```elixir
# Simple division
calculations do
  calculate :win_rate, :float, expr(
    fragment("? / ?", wins, total_games)
  )
end

# Call PostgreSQL function
calculations do
  calculate :lower_name, :string, expr(
    fragment("LOWER(?)", name)
  )
end

# Use in migrations
create table(:managers, primary_key: false) do
  add :id, :uuid,
    null: false,
    default: fragment("UUID_GENERATE_V4()"),
    primary_key: true
end
```

### Pattern Matching with LIKE/ILIKE

Search with pattern matching:

```elixir
# Case-sensitive search
Ash.Query.filter(User, like(name, "%obo%"))

# Case-insensitive search
Ash.Query.filter(User, ilike(name, "%ObO%"))

# Note: % and _ have special meaning in patterns
# Use contains/1 for literal text matching
```

### Trigram Similarity Search

Fuzzy text matching using PostgreSQL's pg_trgm extension:

```elixir
# Must have pg_trgm in repo's installed_extensions
Ash.Query.filter(User, trigram_similarity(first_name, "fred") > 0.8)
```

### Polymorphic Resources

Share a resource across multiple tables:

```elixir
# Polymorphic resource definition
defmodule MyApp.Reaction do
  use Ash.Resource,
    domain: MyApp.Domain,
    data_layer: AshPostgres.DataLayer

  postgres do
    polymorphic? true  # No table required
  end

  attributes do
    attribute :resource_id, :uuid, public?: true
  end
end

# Use different tables per relationship
defmodule MyApp.Post do
  relationships do
    has_many :reactions, MyApp.Reaction,
      relationship_context: %{data_layer: %{table: "post_reactions"}},
      destination_attribute: :resource_id
  end
end

defmodule MyApp.Comment do
  relationships do
    has_many :reactions, MyApp.Reaction,
      relationship_context: %{data_layer: %{table: "comment_reactions"}},
      destination_attribute: :resource_id
  end
end
```

### Table-Specific Actions

Define actions that target specific tables:

```elixir
defmodule MyApp.Reaction do
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

### Check Constraints

Add database-level validation:

```elixir
postgres do
  table "products"
  repo MyApp.Repo

  check_constraints do
    check_constraint :price_positive,
      message: "Price must be positive",
      check: "price > 0"
  end
end
```

### Read Replicas

Configure multiple repos for read/write splitting:

```elixir
defmodule MyApp.Repo do
  use Ecto.Repo,
    otp_app: :my_app,
    adapter: Ecto.Adapters.Postgres

  @replicas [
    MyApp.Repo.Replica1,
    MyApp.Repo.Replica2
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

# Use in resource
postgres do
  table "my_resources"
  repo fn
    _resource, :read -> MyApp.Repo.replica()
    _resource, :mutate -> MyApp.Repo
  end
end
```

## Key Concepts

### References (Foreign Keys)

AshPostgres allows you to configure how foreign keys behave at the database level. This happens **directly in PostgreSQL**, bypassing Ash's authorization and validation layers.

**on_delete behavior:**
- `:nothing` (default) - Allows deferred constraint checking (within transaction)
- `:restrict` - Immediately prevents deletion
- `:delete` - Cascade delete
- `:nilify` - Set foreign key to NULL
- `{:nilify, [:col1, :col2]}` - Set specific columns to NULL (Postgres 15+)

**on_update behavior:**
- `:nothing` (default) - Allows deferred constraint checking
- `:restrict` - Immediately prevents update
- `:update` - Cascade update
- `:nilify` - Set foreign key to NULL

### Polymorphic Resources

A single Ash resource can be backed by multiple database tables. This is useful for:
- Polymorphic associations (comments on posts, images, etc.)
- Partitioning large datasets
- Multi-tenant architectures

When `polymorphic? true` is set, migrations are auto-generated for each table context.

### PostgreSQL Extensions

AshPostgres leverages PostgreSQL extensions for advanced functionality:

- `ash-functions` - Required for Ash's migration generator
- `uuid-ossp` - UUID generation
- `pg_trgm` - Trigram similarity search (fuzzy matching)
- `pgvector` - Vector similarity search (embeddings)

Configure extensions in your repo's `installed_extensions/0` callback.

### Fragments

Fragments are escape hatches for using PostgreSQL features not directly supported by Ash:
- Custom SQL expressions
- PostgreSQL-specific functions
- Subqueries (use sparingly)

They can be used in calculations, migrations, and query filters.

### Custom Indexes

While Ash auto-generates indexes for identities, custom indexes allow:
- Partial indexes with WHERE clauses
- Multi-column indexes for query optimization
- Special index types (GIN, GIST, BRIN)
- Custom index names

## Reference Files

This skill includes comprehensive documentation organized by topic:

### **configuration.md**
Repository setup, extensions, read replicas, and data layer configuration. Covers:
- Setting up `AshPostgres.Repo`
- Configuring installed extensions
- Using multiple repos (read/write splitting)
- Vector type support
- Migration and rollback commands

### **constraints.md**
Foreign key references, check constraints, and constraint configuration. Includes:
- Reference configuration (on_delete/on_update behavior)
- Check constraint setup
- Custom constraint names
- Constraint error handling

### **getting_started.md**
Initial setup, first resource, and migration basics. Walks through:
- Installing AshPostgres
- Creating your first repo
- Configuring resources with postgres tables
- Generating and running migrations
- Basic CRUD operations

### **migrations.md**
Migration generation, customization, and advanced migration patterns. Covers:
- Auto-generating migrations with `mix ash.codegen`
- Custom migration types
- Polymorphic resource migrations
- Schema-based multitenancy
- Migration rollback

### **other.md**
Miscellaneous topics including:
- Polymorphic resources
- Table-specific actions
- Setting up with existing databases
- Edge cases and advanced patterns

### **queries.md**
PostgreSQL-specific query expressions and optimization. Includes:
- SQL fragments
- LIKE/ILIKE operators
- Trigram similarity search
- Custom calculations
- Query performance tips

## Working with This Skill

### For Beginners

Start with **getting_started.md** to:
1. Install and configure AshPostgres
2. Create your first resource with a postgres table
3. Generate and run your first migration
4. Understand the basic postgres DSL options

### For Intermediate Users

Focus on **constraints.md** and **queries.md** to:
- Configure foreign key behaviors
- Add check constraints for data validation
- Use PostgreSQL-specific query features
- Optimize queries with custom indexes

### For Advanced Users

Explore **configuration.md** and **migrations.md** for:
- Read replica configuration
- Polymorphic resource patterns
- Custom migration strategies
- Complex multitenancy setups
- Performance optimization techniques

### Quick Navigation

- Need to configure foreign keys? → **constraints.md** → "References" section
- Want to use raw SQL? → **queries.md** → "Fragments" section
- Setting up a new project? → **getting_started.md** → Start to finish
- Polymorphic associations? → **other.md** → "Polymorphic Resources"
- Custom indexes? → Look for `custom_indexes` examples in **constraints.md**

## Common Patterns

### Pattern 1: Basic Resource with Timestamps

```elixir
postgres do
  table "posts"
  repo MyApp.Repo
end

attributes do
  uuid_primary_key :id
  attribute :title, :string, allow_nil?: false
  create_timestamp :inserted_at
  update_timestamp :updated_at
end
```

### Pattern 2: Cascade Delete Relationship

```elixir
# Comments are deleted when the post is deleted
postgres do
  table "comments"
  repo MyApp.Repo

  references do
    reference :post, on_delete: :delete
  end
end

relationships do
  belongs_to :post, MyApp.Post
end
```

### Pattern 3: Fuzzy Search with Trigram

```elixir
# 1. Add pg_trgm to repo
def installed_extensions do
  ["ash-functions", "pg_trgm"]
end

# 2. Query with similarity threshold
require Ash.Query
User
|> Ash.Query.filter(trigram_similarity(email, "exmaple@gmial.com") > 0.5)
|> Ash.read!()
```

### Pattern 4: Partial Unique Index

```elixir
postgres do
  table "users"
  repo MyApp.Repo

  custom_indexes do
    # Only active users must have unique emails
    index [:email],
      unique: true,
      where: "status = 'active'"
  end
end
```

### Pattern 5: Calculated Field with SQL

```elixir
calculations do
  # Calculate full name in database
  calculate :full_name, :string, expr(
    fragment("? || ' ' || ?", first_name, last_name)
  )

  # Calculate age from birthdate
  calculate :age, :integer, expr(
    fragment(
      "EXTRACT(YEAR FROM AGE(?))",
      birthdate
    )
  )
end
```

## Migration Workflow

```bash
# 1. Define resources with postgres configuration
# 2. Generate migrations
mix ash.codegen add_users_table

# 3. Review generated migration in priv/repo/migrations/
# 4. Run migrations
mix ash.setup

# Or separately:
mix ash_postgres.create  # Create database
mix ash_postgres.migrate # Run migrations

# Rollback if needed
mix ash_postgres.rollback
mix ash_postgres.rollback --step 2  # Rollback 2 migrations
```

## Troubleshooting

### Common Issues

**Migration not generated:**
- Ensure `migrate? true` in postgres block (default)
- Check that resource is in a domain's resource list
- Verify repo is configured in config.exs

**Foreign key constraint errors:**
- Check reference configuration matches relationship
- Ensure referenced table exists
- Verify `on_delete`/`on_update` behavior is correct

**Query performance:**
- Add custom indexes for frequently filtered columns
- Use `explain: true` in queries to see execution plan
- Consider read replicas for read-heavy workloads

**Extension not found errors:**
- Add extension to repo's `installed_extensions/0`
- Run `mix ash.codegen` to generate extension installation migration
- Run `mix ash_postgres.migrate`

## Resources

- **Official Docs**: https://hexdocs.pm/ash_postgres
- **Ash Framework**: https://hexdocs.pm/ash
- **Ecto**: https://hexdocs.pm/ecto
- **PostgreSQL**: https://www.postgresql.org/docs/

## Notes

- AshPostgres is built on Ecto - all Ecto features are available
- Migrations are generated automatically but should be reviewed
- Foreign key behaviors happen at database level (no Ash authorization)
- Reference configuration is only needed for one relationship per foreign key
- Polymorphic resources enable powerful patterns but require careful planning
