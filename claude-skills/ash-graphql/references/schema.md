# Ash-Graphql - Schema

**Pages:** 2

---

## Use Enums with GraphQL

**URL:** https://hexdocs.pm/ash_graphql/use-enums-with-graphql.html

**Contents:**
- Use Enums with GraphQL
  - Using custom absinthe types

If you define an Ash.Type.Enum, that enum type can be used both in attributes and arguments. You will need to add graphql_type/0 to your implementation. AshGraphql will ensure that a single type is defined for it, which will be reused across all occurrences. If an enum type is referenced, but does not have graphql_type/0 defined, it will be treated as a string input.

You can implement a custom enum by first adding the enum type to your absinthe schema (more here). Then you can define a custom Ash type that refers to that absinthe enum type.

Hex Package Hex Preview (current file) Search HexDocs Download ePub version

Built using ExDoc (v0.38.2) for the Elixir programming language

**Examples:**

Example 1 (python):
```python
defmodule AshPostgres.Test.Types.Status do
  @moduledoc false
  use Ash.Type.Enum, values: [:open, :closed]

  def graphql_type(_), do: :ticket_status

  # Optionally, remap the names used in GraphQL, for instance if you have a value like `:"10"`
  # that value is not compatible with GraphQL

  def graphql_rename_value(:"10"), do: :ten
  def graphql_rename_value(value), do: value

  # You can also provide descriptions for the enum values, which will be exposed in the GraphQL
  # schema.
  # Remember to have a fallback clause that returns nil if you don't provide descriptions for all
  # values
...
```

Example 2 (unknown):
```unknown
# In your absinthe schema:

enum :status do
  value(:open, description: "The post is open")
  value(:closed, description: "The post is closed")
end
```

Example 3 (python):
```python
# Your custom Ash Type
defmodule AshGraphql.Test.Status do
  use Ash.Type.Enum, values: [:open, :closed]

  use AshGraphql.Type

  @impl true
  # tell Ash not to define the type for that enum
  def graphql_define_type?(_), do: false
end
```

---

## Custom Queries & Mutations

**URL:** https://hexdocs.pm/ash_graphql/custom-queries-and-mutations.html

**Contents:**
- Custom Queries & Mutations
  - You probably don't need this!
- Using AshGraphql's types

You can define your own queries and mutations in your schema, using Absinthe's tooling. See their docs for more.

You can define generic actions in your resources which can return any type that you want, and those generic actions will automatically get all of the goodness of AshGraphql, with automatic data loading and type derivation, etc. See the generic actions guide for more.

If you want to return resource types defined by AshGraphql, however, you will need to use AshGraphql.load_fields_on_query/2 to ensure that any requested fields are loaded.

Alternatively, if you have records already that you need to load data on, use AshGraphql.load_fields/3:

Hex Package Hex Preview (current file) Search HexDocs Download ePub version

Built using ExDoc (v0.38.2) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
require Ash.Query

query do
  field :custom_get_post, :post do
    arg(:id, non_null(:id))

    resolve(fn %{id: post_id}, resolution ->
      MyApp.Blog.Post
      |> Ash.Query.filter(id == ^post_id)
      |> AshGraphql.load_fields_on_query(resolution)
      |> Ash.read_one(not_found_error?: true)
      |> AshGraphql.handle_errors(MyApp.Blog.Post, resolution)
    end)
  end
end
```

Example 2 (unknown):
```unknown
query do
  field :custom_get_post, :post do
    arg(:id, non_null(:id))

    resolve(fn %{id: post_id}, resolution ->
      with {:ok, post} when not is_nil(post) <- Ash.get(MyApp.Blog.Post, post_id) do
        AshGraphql.load_fields(post, MyApp.Blog.Post, resolution)
      end
      |> AshGraphql.handle_errors(MyApp.Blog.Post, resolution)
    end)
  end
end
```

---
