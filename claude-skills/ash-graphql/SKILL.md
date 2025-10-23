---
name: ash-graphql
description: Building GraphQL APIs. Use when building GraphQL endpoints, schemas, queries, mutations, subscriptions, Absinthe integration, or when user mentions GraphQL, relay connections, or graph-based APIs.
---

# Ash-GraphQL Skill

Comprehensive assistance with ash-graphql development, generated from official documentation.

## When to Use This Skill

This skill should be triggered when:
- Setting up GraphQL schemas with Ash resources and domains
- Defining GraphQL queries, mutations, or subscriptions for Ash resources
- Working with Absinthe integration and resolvers
- Implementing Relay-style APIs with global IDs and connections
- Configuring managed relationships in GraphQL mutations
- Handling errors, authorization, or field policies in GraphQL
- Using enums, unions, or custom types in GraphQL schemas
- Setting up pagination (offset, keyset, or relay) for GraphQL queries
- Debugging ash-graphql code or learning best practices
- Generating SDL files for GraphQL schema documentation

## Key Concepts

### Resources & Domains
- **Resources**: Define the GraphQL type and expose queries/mutations/subscriptions
- **Domains**: Group resources and define which ones to expose in your GraphQL API
- **Actions**: Ash actions (read, create, update, destroy, generic) map to GraphQL operations

### GraphQL Types
- **Queries**: Read operations (get, read_one, list, custom actions)
- **Mutations**: Write operations (create, update, destroy, custom actions)
- **Subscriptions**: Real-time updates using PubSub
- **Relay**: Specification for pagination and global IDs

### Configuration
- **Type Configuration**: Control field visibility, naming, nullability
- **Authorization**: Integrate with Ash policies and actors
- **Error Handling**: Customize error responses and translations

## Quick Reference

### Pattern 1: Basic Resource Setup

Define a GraphQL type and expose basic CRUD operations:

```elixir
defmodule MyApp.Blog.Post do
  use Ash.Resource,
    extensions: [AshGraphql.Resource]

  graphql do
    type :post

    queries do
      get :get_post, :read
      list :list_posts, :read
    end

    mutations do
      create :create_post, :create
      update :update_post, :update
      destroy :destroy_post, :destroy
    end
  end

  attributes do
    uuid_primary_key :id
    attribute :title, :string
    attribute :content, :string
  end

  actions do
    defaults [:read, :create, :update, :destroy]
  end
end
```

### Pattern 2: Setting Up Your Schema

Configure your Absinthe schema with Ash domains:

```elixir
defmodule MyApp.GraphqlSchema do
  use Absinthe.Schema
  use AshGraphql, domains: [MyApp.Blog, MyApp.Accounts]

  query do
    # Custom queries can be added here
  end

  mutation do
    # Custom mutations can be added here
  end
end
```

### Pattern 3: Phoenix Router Integration

Connect your GraphQL schema to Phoenix:

```elixir
pipeline :graphql do
  plug AshGraphql.Plug
end

scope "/gql" do
  pipe_through [:graphql]

  forward "/playground", Absinthe.Plug.GraphiQL,
    schema: MyApp.GraphqlSchema,
    interface: :playground

  forward "/", Absinthe.Plug,
    schema: MyApp.GraphqlSchema
end
```

### Pattern 4: Generic Actions

Create custom actions that return any type:

```elixir
# Scalar return value
graphql do
  queries do
    action :say_hello, :say_hello
  end
end

actions do
  action :say_hello, :string do
    argument :to, :string, allow_nil?: false

    run fn input, _ ->
      {:ok, "Hello, #{input.arguments.to}"}
    end
  end
end
```

### Pattern 5: Relay Global IDs

Enable Relay specification support:

```elixir
graphql do
  type :post
  relay? true

  queries do
    list :list_posts, :read, relay?: true
  end

  mutations do
    create :create_post, :create do
      # Translate Relay global IDs to internal IDs
      relay_id_translations [input: [author_id: :user]]
    end
  end
end
```

### Pattern 6: Pagination

Configure different pagination strategies:

```elixir
graphql do
  type :post

  # Offset pagination
  queries do
    list :list_posts, :read, paginate_with: :offset
  end

  # Keyset pagination
  queries do
    list :list_posts_keyset, :read, paginate_with: :keyset
  end

  # Relay-style pagination
  queries do
    list :list_posts_relay, :read, relay?: true
  end
end
```

### Pattern 7: Managed Relationships

Handle creating/updating related data in mutations:

```elixir
graphql do
  managed_relationships do
    managed_relationship :create_post, :comments do
      types [
        create: :create,
        update: :update
      ]
    end
  end
end

mutations do
  create :create_post, :create
end

actions do
  create :create do
    argument :comments, {:array, :map}

    change manage_relationship(:comments,
      type: :direct_control,
      on_no_match: :create,
      on_match: :update
    )
  end
end
```

### Pattern 8: Error Handling

Customize error display and handling:

```elixir
# In your domain
graphql do
  # Show detailed errors in dev/test
  show_raised_errors? true

  # Return errors at root level instead of in fields
  root_level_errors? true

  # Custom error handler for translations
  error_handler {MyApp.GraphqlErrorHandler, :handle_error, []}
end

# Error handler implementation
defmodule MyApp.GraphqlErrorHandler do
  def handle_error(%{message: message, vars: vars} = error, _context) do
    %{error | message: translate(message, vars)}
  end

  def handle_error(other, _), do: other
end
```

### Pattern 9: Field Policies & Authorization

Control access to specific fields:

```elixir
graphql do
  type :user

  # Mark sensitive fields as nullable for authorization
  nullable_fields [:email, :phone_number]
end

policies do
  # Field-level policies
  field_policies do
    field_policy :email do
      authorize_if actor_attribute_equals(:id, :id)
    end
  end
end
```

### Pattern 10: Using Enums

Define and use enum types in GraphQL:

```elixir
defmodule MyApp.Types.Status do
  use Ash.Type.Enum, values: [:draft, :published, :archived]

  # Required for GraphQL
  def graphql_type(_), do: :post_status

  # Optional: provide descriptions
  def graphql_describe_enum_value(:draft), do: "Not yet published"
  def graphql_describe_enum_value(:published), do: "Live and visible"
  def graphql_describe_enum_value(_), do: nil
end

# Use in resource
attributes do
  attribute :status, MyApp.Types.Status
end
```

## Reference Files

This skill includes comprehensive documentation in `references/`:

### configuration.md
- **Relay Configuration**: Setting up Relay-style APIs with global IDs, connections, and pagination
- **ID Translation**: Converting between Relay global IDs and internal IDs

### mutations.md
- **Mutation Types**: create, update, destroy, and generic actions
- **Managed Relationships**: Handling related data in mutations
- **Input Types**: Configuring mutation inputs and arguments

### queries.md
- **Query Types**: get (single by ID), read_one (single by filter), list (collections)
- **Filtering & Sorting**: User-provided filters and sort options
- **Pagination**: Offset, keyset, and Relay pagination strategies
- **Generic Actions**: Custom query actions with any return type

### subscriptions.md
- **PubSub Integration**: Real-time updates using Phoenix.PubSub
- **Subscription Configuration**: Listening to resource changes
- **Action Filtering**: Subscribe to specific action types (create, update, destroy)

### schema.md
- **Schema Setup**: Configuring Absinthe with AshGraphql
- **Type Configuration**: Field visibility, naming overrides, type customization
- **SDL Generation**: Automatic schema file generation for documentation

### other.md
- **Error Handling**: Custom error handlers, translations, error formatting
- **Authorization**: Actor setup, policy integration, field policies
- **Custom Types**: Enums, unions, and custom type definitions
- **Monitoring**: Telemetry events and tracing
- **Generic Actions**: Building custom queries and mutations

## Working with This Skill

### For Beginners

Start with basic resource setup:
1. Add the GraphQL extension to your resource
2. Define a `graphql do` block with a type
3. Add simple queries (get, list) and mutations (create, update, destroy)
4. Configure your Absinthe schema with `use AshGraphql, domains: [...]`
5. Set up your Phoenix router with the GraphQL endpoint

Refer to **Quick Reference Patterns 1-3** for complete examples.

### For Intermediate Users

Focus on advanced features:
- Configure **pagination** (Pattern 6) for large datasets
- Set up **managed relationships** (Pattern 7) for nested mutations
- Implement **error handling** (Pattern 8) for better UX
- Use **generic actions** (Pattern 4) for custom business logic
- Enable **Relay support** (Pattern 5) if using Relay clients

### For Advanced Users

Dive into complex scenarios:
- Implement **field-level authorization** with policies (Pattern 9)
- Create **custom types** like enums and unions
- Set up **subscriptions** for real-time updates (see subscriptions.md)
- Optimize **query performance** with custom preparations
- Build **custom resolvers** that integrate with AshGraphql

### For Specific Features

- **Authentication/Authorization**: See `authorize-with-graphql` in other.md
- **Real-time Updates**: See subscriptions.md for PubSub configuration
- **API Documentation**: Use SDL file generation (schema.md)
- **Error Customization**: See error handling section in other.md
- **Type System**: See enum and union documentation in other.md

## Common Patterns

### Installation

```bash
# Using Igniter (recommended)
mix igniter.install ash_graphql

# Manual installation
# Add to mix.exs
{:ash_graphql, "~> 1.8.3"}
```

### Domain vs Resource Configuration

You can define GraphQL operations in either the domain or resource:

```elixir
# Option 1: On the Domain (recommended - centralized)
defmodule MyApp.Blog do
  use Ash.Domain, extensions: [AshGraphql.Domain]

  graphql do
    queries do
      get MyApp.Blog.Post, :get_post, :read
      list MyApp.Blog.Post, :list_posts, :read
    end
  end
end

# Option 2: On the Resource (distributed)
defmodule MyApp.Blog.Post do
  use Ash.Resource, extensions: [AshGraphql.Resource]

  graphql do
    type :post

    queries do
      get :get_post, :read
      list :list_posts, :read
    end
  end
end
```

### Type Customization

```elixir
graphql do
  type :post

  # Hide sensitive fields
  hide_fields [:internal_notes, :draft_content]

  # Show only specific fields
  show_fields [:id, :title, :published_at]

  # Rename fields
  field_names [published_at: :publication_date]

  # Override attribute types
  attribute_types [metadata: :json]

  # Mark fields as nullable for field policies
  nullable_fields [:email, :phone]
end
```

### Authorization Setup

```elixir
# 1. Add AshGraphql.Plug to your pipeline
pipeline :graphql do
  plug :load_actor  # Your custom plug
  plug AshGraphql.Plug
end

# 2. In your domain
graphql do
  authorize? true  # Default is true
end

# 3. Field policies in your resource
policies do
  field_policies do
    field_policy :email do
      authorize_if actor_attribute_equals(:id, :id)
    end
  end
end
```

## Best Practices

1. **Centralize Configuration**: Define queries/mutations in the domain for better organization
2. **Use Generic Actions**: Leverage generic actions instead of custom Absinthe resolvers
3. **Enable Authorization**: Always configure authorization for production APIs
4. **Generate SDL Files**: Use `generate_sdl_file` for documentation and validation
5. **Handle Errors Gracefully**: Implement custom error handlers for better UX
6. **Leverage Relay**: Use Relay for sophisticated client requirements
7. **Paginate Large Lists**: Always configure pagination for list queries
8. **Type Safety**: Use Ash types and constraints instead of custom validations

## Notes

- This skill was automatically generated from official ash-graphql documentation
- All code examples are from the official docs and represent best practices
- Reference files contain complete documentation with examples and links
- For the most up-to-date information, refer to https://hexdocs.pm/ash_graphql

## Troubleshooting

### Common Issues

**Problem**: GraphQL types not appearing in schema
- **Solution**: Ensure resource has `type :resource_name` in the graphql block
- **Solution**: Check that the domain is listed in `use AshGraphql, domains: [...]`

**Problem**: Authorization always fails
- **Solution**: Verify actor is set using `Ash.PlugHelpers.set_actor/2`
- **Solution**: Check that `AshGraphql.Plug` is in your pipeline
- **Solution**: Review your resource policies

**Problem**: Managed relationships not working
- **Solution**: Ensure `managed_relationship` is configured in the graphql block
- **Solution**: Verify the action has a `manage_relationship` change

**Problem**: Pagination not working
- **Solution**: Configure pagination on the read action in your resource
- **Solution**: Set `paginate_with` option on the query

## Updating

To refresh this skill with updated documentation:
1. Re-run the scraper with the same configuration
2. The skill will be rebuilt with the latest information
