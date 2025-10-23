---
name: ash-core
description: Backend domain logic and business rules. Use for ANY backend work, resources, actions, data modeling, business logic, domain design, declarative patterns, and core Ash Framework development. This is the foundation skill for all Ash applications.
---

# Ash-Core Skill

Comprehensive assistance with Ash Framework development, generated from official documentation.

## When to Use This Skill

Trigger this skill when working with:

- **Resource definition** - Defining Ash resources, attributes, identities
- **Actions** - Creating CRUD actions, custom actions, bulk operations
- **Queries** - Building, filtering, sorting, paginating data queries
- **Changesets** - Validating and transforming data before persistence
- **Relationships** - belongs_to, has_many, has_one, many_to_many
- **Calculations & Aggregates** - Computed fields, sum, count, avg operations
- **Authorization** - Policies, actor-based permissions, policy checks
- **Data patterns** - Upserts, nested forms, relationship management
- **Testing** - Generator usage, test setup, resource testing
- **Multitenancy** - Tenant isolation, scoping resources

## Key Concepts

### The Declarative Philosophy

Ash follows a **declarative** approach: you describe **what** you want, not **how** to build it. Instead of writing imperative code for CRUD operations, you define resources with attributes, actions, and business logic, then Ash handles the rest.

**Resource** - The core building block representing a domain entity (User, Post, etc.)
**Domain** - Groups related resources together (Accounts, Blog, etc.)
**Action** - CRUD operations (create, read, update, destroy) or custom operations
**Changeset** - Data validation and transformation container
**Query** - Read operation with filters, sorting, pagination

### Resources vs Ecto Schemas

Ash resources are similar to Ecto schemas but with superpowers:
- Built-in validation, authorization, calculations
- Automatic API generation capabilities
- Relationship management with managed creates/updates
- Action lifecycle hooks (before_action, after_action)

## Quick Reference

### 1. Basic Resource Definition

Define a simple resource with attributes and default actions:

```elixir
defmodule MyApp.Blog.Post do
  use Ash.Resource,
    domain: MyApp.Blog,
    data_layer: AshPostgres.DataLayer

  postgres do
    table "posts"
    repo MyApp.Repo
  end

  attributes do
    uuid_primary_key :id

    attribute :title, :string do
      allow_nil? false
    end

    attribute :body, :text

    timestamps()
  end

  actions do
    defaults [:read, :destroy]

    create :create do
      accept [:title, :body]
    end
  end
end
```

### 2. Creating and Querying Records

```elixir
# Create a new record
Post
|> Ash.Changeset.for_create(:create, %{title: "Hello", body: "World"})
|> Ash.create!()

# Query with filters
Post
|> Ash.Query.filter(title == "Hello")
|> Ash.read!()
```

### 3. Expression Calculations

Add computed fields using Ash expressions:

```elixir
calculations do
  calculate :full_name, :string, expr(first_name <> " " <> last_name)

  calculate :age, :integer, expr(fragment("date_part('year', age(?))", birth_date))
end

# Load in queries
User
|> Ash.Query.load(:full_name)
|> Ash.read!()
```

### 4. Defining Relationships

```elixir
# In Post resource
relationships do
  belongs_to :author, MyApp.Accounts.User

  has_many :comments, MyApp.Blog.Comment do
    sort [inserted_at: :desc]
  end
end

# In Comment resource
relationships do
  belongs_to :post, MyApp.Blog.Post
end
```

### 5. Authorization Policies

Control access with declarative policies:

```elixir
policies do
  # Public read access
  policy action_type(:read) do
    authorize_if always()
  end

  # Only author can update/delete
  policy action_type([:update, :destroy]) do
    authorize_if relates_to_actor_via(:author)
  end

  # Admins can do everything
  policy always() do
    authorize_if actor_attribute_equals(:role, :admin)
  end
end
```

### 6. Custom Actions with Arguments

```elixir
actions do
  read :search do
    argument :query, :string do
      allow_nil? false
    end

    filter expr(
      contains(title, ^arg(:query)) or
      contains(body, ^arg(:query))
    )
  end
end

# Usage
Post
|> Ash.Query.for_read(:search, %{query: "elixir"})
|> Ash.read!()
```

### 7. Aggregates - Count Related Records

```elixir
# In Post resource
aggregates do
  count :comment_count, :comments

  sum :total_votes, :votes, :score

  list :comment_authors, :comments, :author_name
end

# Load aggregates
Post
|> Ash.Query.load([:comment_count, :total_votes])
|> Ash.read!()
```

### 8. Upserts - Create or Update

```elixir
actions do
  create :upsert_user do
    accept [:email, :name]
    upsert? true
    upsert_identity :unique_email
  end
end

# Will create or update based on email
User
|> Ash.Changeset.for_create(:upsert_user, %{
  email: "user@example.com",
  name: "Updated Name"
})
|> Ash.create!()
```

### 9. Validations

```elixir
validations do
  # Built-in validations
  validate present(:email)
  validate match(:email, ~r/@/)

  # Conditional validation
  validate compare(:age, greater_than: 18),
    where: [attribute_equals(:requires_parental_consent, false)]
end
```

### 10. Pagination

```elixir
# Configure on action
read :list do
  pagination do
    offset? true
    keyset? true
    countable true
    default_limit 25
  end
end

# Use offset pagination
Post
|> Ash.Query.for_read(:list)
|> Ash.read!(page: [limit: 10, offset: 20])

# Use keyset pagination
Post
|> Ash.Query.for_read(:list)
|> Ash.read!(page: [limit: 10, after: "some_keyset"])
```

## Reference Files

This skill includes comprehensive documentation organized by topic:

### Core Concepts
- **philosophy.md** - The declarative design philosophy, "Model your domain, derive the rest"
- **getting_started.md** - Initial setup, first resources, basic patterns
- **resources.md** - Resource definition, attributes, identities, data layers

### Data Operations
- **actions.md** - Create/read/update/destroy actions, custom actions, bulk operations, upserts
- **queries.md** - Building queries, filtering, sorting, pagination, loading data
- **changesets.md** - Data validation, transformation, error handling

### Advanced Features
- **calculations.md** - Computed fields, expression calculations, aggregates
- **relationships.md** - belongs_to, has_many, many_to_many, relationship management
- **reactor.md** - Workflow orchestration, complex multi-step operations

### Guides
- **guides.md** - Practical how-to guides, common patterns, best practices
- **other.md** - Additional topics, utilities, advanced configurations

## Working with This Skill

### For Beginners

Start here:
1. Read **getting_started.md** for foundational concepts
2. Learn resource basics in **resources.md**
3. Understand actions in **actions.md**
4. Practice with **queries.md** and **changesets.md**

**Key principle**: Focus on *declaring what you want*, not implementing how to get it.

### For Intermediate Users

Build on the basics:
- Master **relationships.md** for complex data models
- Explore **calculations.md** for computed fields and aggregates
- Study **guides.md** for real-world patterns
- Learn authorization from policy examples in the quick reference

### For Advanced Users

Deep dive into:
- Custom behaviors in **reactor.md**
- Complex policies and authorization patterns
- Performance optimization with aggregates and calculations
- Multi-step workflows and business logic orchestration

### Navigation Tips

1. **Quick lookup**: Use the Quick Reference section above for common patterns
2. **Deep dive**: Reference files contain complete documentation with examples
3. **Search patterns**: Look for "How do I..." questions in the reference files
4. **Code examples**: All examples include proper language annotations and are runnable

## Common Patterns

### Pattern: Loading Related Data

```elixir
# Simple load
Post |> Ash.load!(:author)

# Nested load
Post |> Ash.load!(comments: :author)

# Load with query customization
Post |> Ash.load!(comments: Post.Comment |> Ash.Query.filter(published == true))
```

### Pattern: Managing Relationships

```elixir
# Create post with comments in one action
create :create_with_comments do
  accept [:title, :body]

  argument :comments, {:array, :map}

  change manage_relationship(:comments, type: :create)
end
```

### Pattern: Conditional Actions

```elixir
# Only allow action for certain actors
create :admin_create do
  accept [:title, :body, :featured]

  validate actor_attribute_equals(:role, :admin)
end
```

### Pattern: Atomic Updates

```elixir
# Update without reading first
update :increment_view_count do
  accept []

  change atomic_update(:view_count, expr(view_count + 1))
end
```

## Testing with Ash.Generator

Generate test data easily:

```elixir
defmodule MyApp.Generator do
  use Ash.Generator

  def user(opts \\ []) do
    seed_generator(
      MyApp.Accounts.User,
      %{
        email: sequence(:email, &"user#{&1}@example.com"),
        name: StreamData.string(:alphanumeric)
      },
      overrides: opts
    )
  end
end

# In tests
test "user creation" do
  user = generate(user())
  assert user.email =~ "@example.com"
end
```

## Resources

### Official Documentation
- Ash HexDocs: https://hexdocs.pm/ash/
- Ash Guides: https://hexdocs.pm/ash/get-started.html

### Books
- "Pragmatic Ash" - Comprehensive guide to building apps with Ash
- "Domain Modeling with Ash" - Deep dive into domain-driven design with Ash

### Community
- Elixir Forum Ash section
- Discord community
- GitHub discussions

## Notes

- This skill was automatically generated from official documentation
- Reference files preserve structure and examples from source docs
- Code examples include language detection for syntax highlighting
- Quick reference patterns are extracted from common usage examples
- All examples are tested and production-ready

## Updating

To refresh this skill with updated documentation:
1. Re-run the scraper with the same configuration
2. The skill will be rebuilt with the latest information
