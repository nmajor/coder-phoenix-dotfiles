---
name: ash-json-api
description: Building REST APIs with JSON:API specification. Use when building RESTful endpoints, JSON APIs, REST resources, or when user mentions REST, JSON:API, API endpoints, or RESTful patterns.
---

# Ash-Json-Api Skill

Comprehensive assistance with ash-json-api development, generated from official documentation.

## When to Use This Skill

This skill should be triggered when:
- Building JSON:API compliant REST endpoints for Ash resources
- Setting up routes (GET, POST, PATCH, DELETE) for Ash domains or resources
- Implementing JSON:API features like filtering, sorting, pagination, sparse fieldsets
- Working with relationship endpoints and relationship arguments
- Configuring OpenAPI/Swagger documentation for Ash APIs
- Handling includes, compound documents, and resource relationships
- Implementing custom query parameters (filter_included, sort_included, field_inputs)
- Setting up composite primary keys in JSON:API routes
- Configuring authorization for JSON:API endpoints
- Debugging JSON:API serialization or routing issues

## Key Concepts

### JSON:API Compliance
AshJsonApi provides a JSON:API specification-compliant REST API layer for Ash Framework. It handles:
- Standard CRUD operations with proper JSON:API formatting
- Relationship management (includes, compound documents)
- Filtering, sorting, pagination
- Sparse fieldsets
- Error handling per JSON:API spec

### Routes
Routes can be defined either on the **domain** (recommended) or directly on the **resource**. Domain-level routes use `base_route` to scope resources.

### Relationship Arguments
Use `relationship_arguments` to accept relationship data in the `data.relationships` key (JSON:API compliant) instead of `attributes`.

## Quick Reference

### Pattern 1: Basic Route Setup on Domain

```elixir
defmodule Helpdesk.Support do
  use Ash.Domain, extensions: [AshJsonApi.Domain]

  json_api do
    routes do
      # base_route acts like a scope
      base_route "/tickets", Helpdesk.Support.Ticket do
        get :read
        index :read
        post :open
        patch :update
        delete :destroy
      end
    end
  end
end
```

### Pattern 2: Resource Configuration

```elixir
defmodule Helpdesk.Support.Ticket do
  use Ash.Resource, extensions: [AshJsonApi.Resource]

  json_api do
    type "ticket"
  end

  # ... attributes, actions, etc.
end
```

### Pattern 3: Filtering Included Resources

```
# Filter included comments by author_id
posts?include=comments&filter_included[comments][author_id]=1
```

### Pattern 4: Sorting Included Resources

```
# Sort included comments by author username (ascending) and created_at (descending)
posts?include=comments&sort_included[comments]=author.username,-created_at
```

### Pattern 5: Field Inputs for Calculations

```
# Provide input parameters to calculations
blogs?fields[blog]=title,monthly_engagement&field_inputs[blog][monthly_engagement][yyyy_mm]=2024.06
```

### Pattern 6: Relationship Arguments (JSON:API Compliant)

```elixir
# In the resource
json_api do
  routes do
    patch :update, relationship_arguments: [:authors]
  end
end

# In the action
actions do
  update :update do
    argument :authors, {:array, :map}, allow_nil?: false
    change manage_relationship(:authors, type: :append_and_remove)
  end
end
```

Then send data in the relationships key:

```json
{
  "data": {
    "attributes": {},
    "relationships": {
      "authors": {
        "data": [
          {"type": "author", "id": 1},
          {"type": "author", "id": 2, "meta": {"role": "contributor"}}
        ]
      }
    }
  }
}
```

### Pattern 7: Dedicated Relationship Routes

```elixir
routes do
  # Use post_to_relationship when the operation is additive
  post_to_relationship :add_author, action: :add_author

  # Use patch_relationship when both additive and subtractive
  patch_relationship :update_authors, action: :update_authors

  # Use delete_from_relationship when subtractive
  delete_from_relationship :remove_author, action: :remove_author
end
```

### Pattern 8: OpenAPI Setup with Phoenix

```elixir
# In your domain router
use AshJsonApi.Router,
  domains: [MyApp.Accounts, MyApp.Blog],
  open_api: "/open_api"

# In your Phoenix router
forward "/api/swaggerui",
  OpenApiSpex.Plug.SwaggerUI,
  path: "/api/open_api",
  default_model_expand_depth: 4

forward "/api/redoc",
  Redoc.Plug.RedocUI,
  spec_url: "/api/open_api"

forward "/api", MyAppWeb.JsonApiRouter
```

### Pattern 9: Composite Primary Keys

```elixir
defmodule MyApp.Bio do
  use Ash.Resource, extensions: [AshJsonApi.Resource]

  attributes do
    attribute :author_id, :uuid, primary_key?: true, public?: true
    attribute :category, :string, primary_key?: true, public?: true
  end

  json_api do
    type "bio"

    primary_key do
      keys [:author_id, :category]
      delimiter "|"
    end

    routes do
      base "/bios"
      get :read, path_param_is_composite_key: :id
      patch :update, path_param_is_composite_key: :id
    end
  end
end
```

Access via: `GET /bios/550e8400-e29b-41d4-a716-446655440000|sports`

### Pattern 10: Creating Related Resources Without ID

```elixir
# Location resource
actions do
  create :create do
    accept [:name, :location, :images]
    argument :leads, {:array, :map}, allow_nil?: false
    change manage_relationship(:leads, type: :create)
  end
end

# API call
{
  "data": {
    "type": "location",
    "attributes": {
      "name": "Test Location"
    },
    "relationships": {
      "leads": {
        "data": [
          {
            "type": "lead",
            "meta": {
              "type": "Roof",
              "description": "roofing has 3 holes to fix",
              "priority": "high"
            }
          }
        ]
      }
    }
  }
}
```

## Reference Files

This skill includes comprehensive documentation in `references/`:

### **endpoints.md**
Complete guide to endpoint configuration, including:
- Route definitions (get, index, post, patch, delete)
- Base routes and route scoping
- Relationship routes (related, relationship, post_to_relationship, etc.)
- Composite primary key handling
- OpenAPI integration

### **serialization.md**
In-depth coverage of JSON:API serialization:
- Resource serialization format
- Including related resources
- Sparse fieldsets
- Filtering and sorting includes
- Field inputs for calculations
- Custom query parameters
- Authorization with AshJsonApi

### **book-domain-modeling.md** & **book-pragmatic-ash.md**
Excerpts from official Ash books covering:
- Domain modeling concepts
- Resource design patterns
- Best practices for Ash applications

Use the `Read` tool to view specific reference files when you need detailed information.

## Working with This Skill

### For Beginners
1. Start by understanding the basic route setup (Pattern 1-2)
2. Review `endpoints.md` for route configuration basics
3. Learn how resources expose a `type` for JSON:API
4. Understand the difference between domain-level and resource-level routes

### For Building APIs
1. Define your routes on the domain (recommended approach)
2. Configure resource types with `json_api do type "..." end`
3. Use relationship arguments for JSON:API compliant relationship management
4. Implement filtering, sorting, and pagination as needed
5. Add OpenAPI documentation for API discoverability

### For Advanced Features
1. Implement composite primary keys for multi-field identifiers
2. Use custom query parameters (filter_included, sort_included, field_inputs)
3. Set up dedicated relationship manipulation routes
4. Configure authorization with policies
5. Customize serialization with includes and sparse fieldsets

### Navigation Tips
- For route setup: Check `endpoints.md` → "AshJsonApi.Domain" section
- For relationship handling: See `serialization.md` → "Relationships" section
- For query parameters: See `serialization.md` → "Non-Spec query parameters"
- For OpenAPI: Check `endpoints.md` → "Open API" section

## Common Use Cases

### Setting Up a Basic API
```elixir
# 1. Add extension to domain
use Ash.Domain, extensions: [AshJsonApi.Domain]

# 2. Configure routes
json_api do
  routes do
    base_route "/posts", MyApp.Blog.Post do
      index :read
      get :read
      post :create
    end
  end
end

# 3. Configure resource
use Ash.Resource, extensions: [AshJsonApi.Resource]
json_api do
  type "post"
end
```

### Managing Relationships
```elixir
# Accept relationship data in JSON:API format
patch :update, relationship_arguments: [:comments]

# Or use dedicated relationship routes
post_to_relationship :add_comments, action: :add_comments
```

### Adding OpenAPI Documentation
```elixir
# In domain
json_api do
  open_api do
    tag "Blog"
    group_by :domain
  end
  routes do
    # ...
  end
end

# In router
use AshJsonApi.Router,
  domains: [...],
  open_api: "/open_api"
```

## Installation

Using Igniter (recommended):
```bash
mix igniter.install ash_json_api
```

Manual setup:
```elixir
# mix.exs
{:ash_json_api, "~> 1.0"}

# config/config.exs - Accept JSON:API content type
config :mime,
  extensions: %{"json" => "application/vnd.api+json"},
  types: %{"application/vnd.api+json" => ["json"]}
```

## Notes

- Routes defined on the domain are the **recommended approach**
- Resources must still use `AshJsonApi.Resource` extension and define a `type`
- The `type` is used in JSON:API responses and relationships
- Non-spec query parameters (filter_included, sort_included, field_inputs) enhance API capabilities
- Always use proper JSON:API content type: `application/vnd.api+json`
- Relationship arguments provide JSON:API spec compliance for relationship management

## Updating

This skill was automatically generated from official documentation. To refresh with updated documentation, re-run the scraper with the same configuration.
