# Ash-Json-Api - Serialization

**Pages:** 19

---

## AshJsonApi.Domain.Info (ash_json_api v1.4.45)

**URL:** https://hexdocs.pm/ash_json_api/AshJsonApi.Domain.Info.html

**Contents:**
- AshJsonApi.Domain.Info (ash_json_api v1.4.45)
- Summary
- Functions
- Functions
- authorize?(domain)
- group_by(domain)
- include_nil_values?(domain)
- log_errors?(domain)
- prefix(domain)
- router(domain)

Introspection helpers for AshJsonApi.Domain

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## Non-Spec query parameters

**URL:** https://hexdocs.pm/ash_json_api/non-spec-query-parameters.html

**Contents:**
- Non-Spec query parameters
- filter_included
- sort_included
  - included is unsorted!
- field_inputs

AshJsonApi supports a few non-spec query parameters that enhance the capabilities of your API.

These are currently not exposed in the generated OpenAPI spec. PRs welcome!

Includes can be filtered via the filter_included query parameter. To do this, you provide the path to the included resource and the filter to apply.

posts?include=comments&filter_included[comments][author_id]=1

Includes can be sorted via the sort_included query parameter. To do this, you provide the path to the included resource and the sort to apply.

posts?include=comments&sort_included[comments]=author.username,-created_at

Keep in mind that the records in the top level included key will not be reliably sorted. This is because multiple relationships could include the same record. When sorting includes, look at the data.relationships.name key for the order instead.

The field_inputs parameter allows you to pass values to calculations that require user input. This is particularly useful when you need to provide context-specific values for dynamic calculations.

The syntax follows this pattern: field_inputs[resource_type][calculation_name][parameter_name]=value

You can use this in combination with sparse fieldsets to request specific calculations:

blogs?fields[blog]=title,views,monthly_engagement&field_inputs[blog][monthly_engagement][yyyy_mm]=2024.06

This would request the title, views, and monthly_engagement attributes for blogs, while providing the input parameter yyyy_mm with value 2024.06 to the monthly_engagement calculation.

When you need to provide input for multiple calculations or multiple parameters, specify each field_inputs parameter in its full form:

blogs?fields[blog]=title,views,monthly_engagement,quarterly_stats&field_inputs[blog][monthly_engagement][yyyy_mm]=2024.06&field_inputs[blog][quarterly_stats][quarter]=Q2&field_inputs[blog][quarterly_stats][year]=2024

Hex Package Hex Preview (current file) Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## Composite Primary Keys

**URL:** https://hexdocs.pm/ash_json_api/composite-primary-keys.html

**Contents:**
- Composite Primary Keys
- Defining Composite Primary Keys
  - Important Considerations for Delimiters
- Enabling Composite Key Parsing in Routes
- How It Works
- Example Usage
- Without Opt-In Parsing
- Error Handling

When working with resources that have composite primary keys (multiple fields that together form the unique identifier), AshJsonApi provides special support for encoding and decoding these keys in URLs.

First, define your composite primary key in the JSON API configuration:

When choosing a delimiter, ensure it won't appear in your actual data:

To enable automatic parsing of composite primary keys in URL paths, you must opt-in by specifying the path_param_is_composite_key option on your routes:

With the above configuration:

If you don't specify path_param_is_composite_key on a route, the path parameter will be treated as a regular single value, even if your resource has composite primary keys defined. This ensures backward compatibility and prevents unexpected behavior.

If the composite key format is invalid (wrong number of parts after splitting), AshJsonApi will return a 404 Not Found error with appropriate JSON:API error formatting.

Hex Package Hex Preview (current file) Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
defmodule MyApp.Bio do
  use Ash.Resource,
    extensions: [AshJsonApi.Resource]

  attributes do
    attribute :author_id, :uuid, primary_key?: true, public?: true
    attribute :category, :string, primary_key?: true, public?: true
    attribute :content, :string, public?: true
  end

  json_api do
    type "bio"
    
    primary_key do
      keys [:author_id, :category]
      delimiter "|"  # Use a delimiter that won't conflict with your data
    end
  end
end
```

Example 2 (unknown):
```unknown
json_api do
  type "bio"
  
  primary_key do
    keys [:author_id, :category]
    delimiter "|"
  end
  
  routes do
    base "/bios"
    
    # Enable composite key parsing for the :id parameter
    get :read, path_param_is_composite_key: :id
    patch :update, path_param_is_composite_key: :id
    delete :destroy, path_param_is_composite_key: :id
    
    # Other routes that don't need composite key parsing
    index :read
    post :create
  end
end
```

Example 3 (unknown):
```unknown
# Creating a bio
POST /bios
{
  "data": {
    "type": "bio",
    "attributes": {
      "author_id": "550e8400-e29b-41d4-a716-446655440000",
      "category": "sports",
      "content": "Author bio for sports category"
    }
  }
}

# Retrieving the bio using composite key
GET /bios/550e8400-e29b-41d4-a716-446655440000|sports

# Updating the bio
PATCH /bios/550e8400-e29b-41d4-a716-446655440000|sports
{
  "data": {
    "type": "bio", 
    "attributes": {
      "content": "Updated bio content"
    }
  }
}

# Deleting the bio
DELETE /bios/550e8400-e29b-41d4-a716-446655440000|sports
```

---

## AshJsonApi.Resource (ash_json_api v1.4.45)

**URL:** https://hexdocs.pm/ash_json_api/AshJsonApi.Resource.html

**Contents:**
- AshJsonApi.Resource (ash_json_api v1.4.45)
- Summary
- Functions
- Functions
- base_route(resource)
- encode_primary_key(record)
- includes(resource)
- install(igniter, module, arg, path, argv)
- json_api(body)
- only_primary_key?(resource, field)

The entrypoint for adding JSON:API behavior to a resource"

See AshJsonApi.Resource.Info.base_route/1.

See AshJsonApi.Resource.Info.includes/1.

See AshJsonApi.Resource.Info.primary_key_delimiter/1.

See AshJsonApi.Resource.Info.primary_key_fields/1.

See AshJsonApi.Resource.Info.routes/2.

See AshJsonApi.Resource.Info.type/1.

See AshJsonApi.Resource.Info.base_route/1.

See AshJsonApi.Resource.Info.includes/1.

See AshJsonApi.Resource.Info.primary_key_delimiter/1.

See AshJsonApi.Resource.Info.primary_key_fields/1.

See AshJsonApi.Resource.Info.routes/2.

See AshJsonApi.Resource.Info.type/1.

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## Relationships

**URL:** https://hexdocs.pm/ash_json_api/relationships.html

**Contents:**
- Relationships
- Creating related resources without the id
- Relationship Manipulation Routes

You can specify which arguments will modify relationships using relationship_arguments, but there are some things to keep in mind.

relationship_arguments is a list of arguments that can be edited in the data.relationships input.

This is primarily useful for those who want to keep their relationship changes in compliance with the JSON:API spec. If you are not focused on building a fully compliant JSON:API, it is likely far simpler to simply accept arguments in the attributes key and ignore the data.relationships input.

If the argument's type is {:array, _}, a list of data will be expected. Otherwise, it will expect a single item.

Everything in this guide applies to routs defined on the domain as well.

You can then send the value for authors in the relationships key, e.g

If you do not include :authors in the relationship_arguments key, you would supply its value in attributes, e.g:

Non-map argument types, e.g argument :author, :integer (expecting an author id) work with manage_relationship, but not with JSON:API, because it expects {"type": _type, "id" => id} for relationship values. To support non-map arguments in relationship_arguments, instead of :author, use {:id, :author}. This works for {:array, _} type arguments as well, so the value would be a list of ids.

This feature is useful for creating relationships without requiring two separate API calls and without needing to associate resources with an ID first. This is an escape hatch from the standard approach and is not JSON:API spec compliant, but it is completely possible to implement.

This way, when requesting to create a location, leads will be automatically created as well.

Note that the related data won't be returned unless included with the include query parameter. For the JSON:API specification on the include parameter, see json api fetching includes.

You can also specify routes that are dedicated to manipulating relationships. We generally suggest the above approach, but JSON:API spec also allows for dedicated relationship routes. For example:

This will use an action on the source resource, (by default the primary update), and expects it to take an argument with the corresponding name. Additionally, it must have a change manage_relationship that uses that attribute. For example:

Hex Package Hex Preview (current file) Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
# On a tweets resource

# With a patch route that references the `authors` argument
json_api do
  routes do
    patch :update, relationship_arguments: [:authors]
  end
end

# And an argument by that name in the action
actions do
  update :update do
    argument :authors, {:array, :map}, allow_nil?: false

    change manage_relationship(:authors, type: :append_and_remove) # Use the authors argument to allow changing the related authors on update
  end
end
```

Example 2 (javascript):
```javascript
{
  data: {
    attributes: {
      ...
    },
    relationships: {
      authors: {
        data: [
          {type: "author", id: 1}, // the `type` key is removed when the value is placed into the action, so this input would be `%{"id" => 1}` (`type` is required by `JSON:API` specification)
          {type: "author", id: 2, meta: {arbitrary: 1, keys: 2}}, <- `meta` is JSON:API spec freeform data, so this input would be `%{"id" => 2, "arbitrary" => 1, "keys" => 2}`
        ]
      }
    }
  }
}
```

Example 3 (unknown):
```unknown
{
  data: {
    attributes: {
      authors: {
        {id: 1},
        {id: 2, arbitrary: 1, keys: 2},
      }
    }
  }
}
```

Example 4 (unknown):
```unknown
# With a post route that references the `leads` argument, this will mean that
# locations will have the ability to create Lead resources when called from 
# the API
  json_api do
    routes do
      base_route "/location", Marketplace.Location do
        post :create, relationship_arguments: [:leads]
      end

      base_route "/lead", Marketplace.Lead do
        post :create
      end
    end
  end


# In the leads resource you will have the following:
  actions do
    create :create do
      primary?(true)
      accept([:type, :description, :priority, :location_id])
    end
  end

  relatio
...
```

---

## Authorize with AshJsonApi

**URL:** https://hexdocs.pm/ash_json_api/authorize-with-json-api.html

**Contents:**
- Authorize with AshJsonApi
- Setting the actor manually

By default, authorize? in the domain is set to true. To disable authorization entirely for a given domain in json_api, use:

This is typically only necessary for testing purposes.

If you are doing authorization, you'll need to provide an actor.

If you are using AshAuthentication, this will be done for you. To set the actor for authorization, you'll need to add an actor key to the conn. Typically, you would have a plug that fetches the current user and uses Ash.PlugHelpers.set_actor/2 to set the actor in the conn (likewise with Ash.PlugHelpers.set_tenant/2).

Hex Package Hex Preview (current file) Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
json_api do
  authorize? false
end
```

Example 2 (python):
```python
defmodule MyAppWeb.Router do
  pipeline :api do
    # ...
    plug :get_actor_from_token
  end

  def get_actor_from_token(conn, _opts) do
     with ["" <> token] <- get_req_header(conn, "authorization"),
         {:ok, user, _claims} <- MyApp.Guardian.resource_from_token(token) do
      conn
      |> Ash.PlugHelpers.set_actor(user)
    else
    _ -> conn
    end
  end
end
```

---

## AshJsonApi.Resource.Info (ash_json_api v1.4.45)

**URL:** https://hexdocs.pm/ash_json_api/AshJsonApi.Resource.Info.html

**Contents:**
- AshJsonApi.Resource.Info (ash_json_api v1.4.45)
- Summary
- Functions
- Functions
- action_names_in_schema(resource)
- always_include_linkage(resource)
- base_route(resource)
- default_fields(resource)
- derive_filter?(resource)
- derive_sort?(resource)

Introspection helpers for AshJsonApi.Resource

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## AshJsonApi.Domain

**URL:** https://hexdocs.pm/ash_json_api/dsl-ashjsonapi-domain.html

**Contents:**
- AshJsonApi.Domain
- json_api
  - Nested DSLs
  - Examples
  - Options
  - json_api.open_api
  - Examples
  - Options
  - json_api.routes
  - Nested DSLs

The entrypoint for adding JSON:API behavior to an Ash domain

Global configuration for JSON:API

OpenAPI configurations

Configure the routes that will be exposed via the JSON:API

Sets a prefix for a list of contained routes

A GET route to retrieve a single record

Target: AshJsonApi.Resource.Route

A GET route to retrieve a list of records

Target: AshJsonApi.Resource.Route

A POST route to create a record

Target: AshJsonApi.Resource.Route

A PATCH route to update a record

Target: AshJsonApi.Resource.Route

A DELETE route to destroy a record

Target: AshJsonApi.Resource.Route

A GET route to read the related resources of a relationship

Target: AshJsonApi.Resource.Route

A READ route to read the relationship, returns resource identifiers.

Target: AshJsonApi.Resource.Route

A POST route to create related entities using resource identifiers

Target: AshJsonApi.Resource.Route

A PATCH route to update a relationship using resource identifiers

Target: AshJsonApi.Resource.Route

A DELETE route to remove related entities using resource identifiers

Target: AshJsonApi.Resource.Route

A route for a generic action.

Target: AshJsonApi.Resource.Route

Target: AshJsonApi.Domain.BaseRoute

A GET route to retrieve a single record

Target: AshJsonApi.Resource.Route

A GET route to retrieve a list of records

Target: AshJsonApi.Resource.Route

A POST route to create a record

Target: AshJsonApi.Resource.Route

A PATCH route to update a record

Target: AshJsonApi.Resource.Route

A DELETE route to destroy a record

Target: AshJsonApi.Resource.Route

A GET route to read the related resources of a relationship

Target: AshJsonApi.Resource.Route

A READ route to read the relationship, returns resource identifiers.

Target: AshJsonApi.Resource.Route

A POST route to create related entities using resource identifiers

Target: AshJsonApi.Resource.Route

A PATCH route to update a relationship using resource identifiers

Target: AshJsonApi.Resource.Route

A DELETE route to remove related entities using resource identifiers

Target: AshJsonApi.Resource.Route

A route for a generic action.

Target: AshJsonApi.Resource.Route

Hex Package Hex Preview (current file) Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
json_api do
  prefix "/json_api"
  log_errors? true
end
```

Example 2 (unknown):
```unknown
json_api do
  ...
  open_api do
    tag "Users"
    group_by :api
  end
end
```

Example 3 (unknown):
```unknown
routes do
  base "/posts"

  get :read
  get :me, route: "/me"
  index :read
  post :confirm_name, route: "/confirm_name"
  patch :update
  related :comments, :read
  relationship :comments, :read
  post_to_relationship :comments
  patch_relationship :comments
  delete_from_relationship :comments
end
```

Example 4 (unknown):
```unknown
base_route route, resource \\ nil
```

---

## AshJsonApi.Error (ash_json_api v1.4.45)

**URL:** https://hexdocs.pm/ash_json_api/AshJsonApi.Error.html

**Contents:**
- AshJsonApi.Error (ash_json_api v1.4.45)
- Summary
- Types
- Functions
- Types
- t()
- Functions
- class_to_status(arg1)
- format_log(error)
- new(opts)

Represents an AshJsonApi Error

Turns an error class into an HTTP status code

Turns an error class into an HTTP status code

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## Getting started with AshJsonApi

**URL:** https://hexdocs.pm/ash_json_api/getting-started-with-ash-json-api.html

**Contents:**
- Getting started with AshJsonApi
- Installing AshJsonApi
  - Using Igniter (recommended)
  - Manually
    - Add the ash_json_api dependency
    - Accept json_api content type
    - Create a router
    - Add AshJsonApi.Plug.Parser to your endpoint
    - Add the routes from your domain module(s)
- Configure your Resources and Domain and expose actions

This manual setup branches off from the Getting Started with Ash guide. If you aren't starting from there, replace the application name, Helpdesk, with your application name, and replace the Ash.Domain name, Helpdesk.Support with a domain or domains from your own application.

In your mix.exs, add the Ash JSON API dependency:

Add the following to your config/config.exs.

This configuration is required to support working with the JSON:API custom mime type.

After adding the configuration above, compiling the project might throw an error:

This can happen if :mime was already compiled before the configuration was changed and can be fixed by running

Create a separate Router Module to work with your Domains. It will generate the routes for your Resources and provide the functions you would usually have in a Controller.

We will later forward requests from your Applications primary (Phoenix) Router to you Ash JSON API Router.

Additionally, your Resource requires a type, a base route and a set of allowed HTTP methods and what action they will trigger.

This handles any file uploads, if you have resource actions with the :file type.

You don't have to add this if you don't plan on doing any file uploads, but there is no cost to adding it, even if you don't use it.

To make your Resources accessible to the outside world, forward requests from your Phoenix router to the router you created for your domains.

These examples are based off of the Getting Started with Ash guide.

To set up an existing resource of your own with AshJsonApi, run:

And to your resource:

Routes can be defined on the resource or the domain. If you define them on the domain (which is our default recommendation), the resource in question must still use the AshJsonApi.Resource extension, and define its own type.

And then add the extension and type to the resource:

Here we show an example of defining routes on the resource.

Check out the AshJsonApi.Resource documentation on Hex for more information.

From here on out its the standard Phoenix behavior. Start your application with mix phx.server and your API should be ready to try out. Should you be wondering what routes are available, you can print all available routes for each Resource:

Make sure that all requests you make to the API use the application/vnd.api+json type in both the Accept and Content-Type (where applicable) headers. The Accept header may be omitted.

If you want to expose your API via Swagger UI or Redoc, see the open ap

*[Content truncated]*

**Examples:**

Example 1 (unknown):
```unknown
mix igniter.install ash_json_api
```

Example 2 (unknown):
```unknown
defp deps do
    [
      # .. other dependencies
      {:ash_json_api, "~> 1.0"},
    ]
  end
```

Example 3 (javascript):
```javascript
# config/config.exs
config :mime,
  extensions: %{"json" => "application/vnd.api+json"},
  types: %{"application/vnd.api+json" => ["json"]}
```

Example 4 (unknown):
```unknown
ERROR! the application :mime has a different value set for key :types during runtime compared to compile time.
```

---

## AshJsonApi.ToJsonApiError protocol (ash_json_api v1.4.45)

**URL:** https://hexdocs.pm/ash_json_api/AshJsonApi.ToJsonApiError.html

**Contents:**
- AshJsonApi.ToJsonApiError protocol (ash_json_api v1.4.45)
- Example
- Summary
- Types
- Functions
- Types
- t()
- Functions
- to_json_api_error(struct)

A protocol for turning an Ash exception into an AshJsonApi.Error

To use, implement the protocol for a builtin Ash exception type or for your own custom Ash exception.

All the types that implement this protocol.

All the types that implement this protocol.

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

**Examples:**

Example 1 (python):
```python
defmodule NotAvailable do
  use Ash.Error.Exception

  use Splode.Error,
    fields: [],
    class: :invalid

  defimpl AshJsonApi.ToJsonApiError do
    def to_json_api_error(error) do
      %AshJsonApi.Error{
        id: Ash.UUID.generate(),
        status_code: 409,
        code: "not_available",
        title: "not_available",
        detail: "Not available"
      }
    end
  end
end
```

---

## Home

**URL:** https://hexdocs.pm/ash_json_api/readme.html

**Contents:**
- Home
- AshJsonApi
- Tutorials
- Topics
- Reference

Welcome! This is the extension for building JSON:API spec compliant APIs with Ash. Generate a powerful JSON API in minutes!

Hex Package Hex Preview (current file) Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## AshJsonApi.Domain (ash_json_api v1.4.45)

**URL:** https://hexdocs.pm/ash_json_api/AshJsonApi.Domain.html

**Contents:**
- AshJsonApi.Domain (ash_json_api v1.4.45)
- Summary
- Functions
- Functions
- install(igniter, module, arg, path, argv)
- json_api(body)

The entrypoint for adding JSON:API behavior to an Ash domain

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## Authenticating with AshJsonApi

**URL:** https://hexdocs.pm/ash_json_api/authenticate-with-json-api.html

**Contents:**
- Authenticating with AshJsonApi
- The route

Authenticating with AshJsonApi requires a few things. The first thing to note is that this is not something that is provided for you out of the box by ash_authentication.

You may also need to add a policy bypass to your resource, to make the action accessible via a non-AshAuthenticationPhoenix liveview.

In this example, we will use the standard :sign_in_with_password action that is created by ash_authentication under the hood, and we will return the token as part of the response metadata.

This will add the token to the meta key in a successful API response, eg.

Hex Package Hex Preview (current file) Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
# In your User module
defmodule <YourApp>.<YourDomain>.User do
  json_api do
    routes do
      # Read actions that return *only one resource* are allowed to be used with
      # `post` routes.
      post :sign_in_with_password do
        route "/sign_in"

        # Given a successful request, we will modify the response to include the
        # generated token
        metadata fn _subject, user, _request ->
          %{token: user.__metadata__.token}
        end
      end
    end
  end
end
```

Example 2 (unknown):
```unknown
{
  {
  "data": {
    "attributes": { ... },
    ...
  },
  "meta": {
    "token": "eyJhbGc..."
  }
}
```

---

## Upgrading to AshJsonApi to 1.0

**URL:** https://hexdocs.pm/ash_json_api/upgrade.html

**Contents:**
- Upgrading to AshJsonApi to 1.0
- Errors
- Relationship Routes
- Ash.Api is now Ash.Domain in Ash 3.0

Two major things have changed in AshJsonApi 1.0.

The error handling has been revamped to be more in line with patterns around Ash and AshGraphql. To implement custom errors, or to enable additional Ash errors to be displayed by AshJsonApi, you will implement the AshJsonApi.ToJsonApiError protocol. Here is how its done for one of the builtin errors:

Previously, AshJsonApi called Ash.Changeset.manage_relationship on the changeset built for the action. Now, you have to define the argument and manage_relationship yourself. See the relationships guide for more.

Your Router module file (the module that has use AshJsonApi.Router in it) will need all references to api updated to be domain. eg.

Hex Package Hex Preview (current file) Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

**Examples:**

Example 1 (python):
```python
defimpl AshJsonApi.ToJsonApiError, for: Ash.Error.Changes.InvalidChanges do
  def to_json_api_error(error) do
    %AshJsonApi.Error{
      id: Ash.UUID.generate(),
      status_code: AshJsonApi.Error.class_to_status(error.class),
      code: "invalid",
      title: "Invalid",
      source_parameter: to_string(error.field),
      detail: error.message,
      meta: Map.new(error.vars)
    }
  end
end
```

Example 2 (unknown):
```unknown
defmodule MyApp.MyApi.Router do
  use AshJsonApi.Router,
    domains: [MyApp.Domain1, MyApp.Domain2],
    ...
```

---

## 

**URL:** https://hexdocs.pm/ash_json_api/ash_json_api.epub

---

## Links

**URL:** https://hexdocs.pm/ash_json_api/links.html

**Contents:**
- Links
- Self links to routes
- Pagination links on index routes
- Self links on individual entities
- Related links
  - Relationship Self Links
  - Relationship Related Links

In JSON:API, there are various pre-specified links.

Whenever you hit a route, there will be a self link in the top-level links object that points to the current request url.

There will be first, last, prev, and next links on paginatable index routes, allowing clients to navigate through the pages of results.

In order to get a self link generated for an individual entity, you must designate one of your get routes as primary? true. For example:

Then, each entity will have a self link in its links key.

Relationship self links are links to endpoints that return only the linkage, not the actual data of the related entities. To generate a relationship self link for a relationship, mark one of your relationship routes as primary? true. For example:

Relationship related links, on the other hand, are endpoints that return the related entities themselves, acting as modified index routes over the destination of the relationship. To generate one of these, mark one of your related routes as primary? true. For example:

Hex Package Hex Preview (current file) Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
get :read, primary?: true
```

Example 2 (unknown):
```unknown
relationship :comments, :read, primary?: true
```

Example 3 (unknown):
```unknown
related :comments, :read, primary?: true
```

---

## AshJsonApi.Plug.Parser (ash_json_api v1.4.45)

**URL:** https://hexdocs.pm/ash_json_api/AshJsonApi.Plug.Parser.html

**Contents:**
- AshJsonApi.Plug.Parser (ash_json_api v1.4.45)
- Examples
- Protocol
    - Conflicting Part names
- Example HTTP Message

Extracts ash multipart request body.

For use with Plug.Parsers, as in the example below.

Should be used with Plug.Parsers:

To use files in your request, send a multipart with the content type multipart/x.ash+form-data. The request MUST contain a JSON object with the key data and the value of the object you want to send.

The request MAY contain other keys with the value of the file you want to send. The parser will walk through all of the data JSON and replace each string equal to a part name with the content of the part. This means that if you have a part named users_csv and a key in the data JSON object with the value users_csv, the parser will replace the string with the content of the part.

Ensure that each part name is unique and does not naturally occur inside as a string in the data JSON object. If a part name is found in the data JSON object, the parser will replace it with the content of the part.

It is recommended to use a unique value like a UUID as the part name.

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
plug Plug.Parsers,
  parsers: [:urlencoded, :multipart, :json, AshJsonApi.Plug.Parser],
  pass: ["*/*"],
  json_decoder: Jason
```

Example 2 (unknown):
```unknown
POST /action
Host: example.com
Content-Length: 2740
Content-Type: multipart/x.ash+form-data; boundary=abcde12345
--abcde12345
Content-Disposition: form-data; name="data"
Content-Type: application/vnd.api+json

{"users": "users_csv", "meatdata": "metadata_json"}
--abcde12345
Content-Disposition: form-data; name="users_csv"; filename="users.csv"
Content-Type: text/csv

[file content goes here]
--abcde12345
Content-Disposition: form-data; name="metadata_json"; filename="metadata.json"
Content-Type: application/json

[file content goes there]
--abcde12345--
```

---

## AshJsonApi.Resource

**URL:** https://hexdocs.pm/ash_json_api/dsl-ashjsonapi-resource.html

**Contents:**
- AshJsonApi.Resource
- json_api
  - Nested DSLs
  - Examples
  - Options
  - json_api.routes
  - Nested DSLs
  - Examples
  - Options
  - json_api.routes.get

The entrypoint for adding JSON:API behavior to a resource"

Configure the resource's behavior in the JSON:API

Configure the routes that will be exposed via the JSON:API

A GET route to retrieve a single record

Target: AshJsonApi.Resource.Route

A GET route to retrieve a list of records

Target: AshJsonApi.Resource.Route

A POST route to create a record

Target: AshJsonApi.Resource.Route

A PATCH route to update a record

Target: AshJsonApi.Resource.Route

A DELETE route to destroy a record

Target: AshJsonApi.Resource.Route

A GET route to read the related resources of a relationship

Target: AshJsonApi.Resource.Route

A READ route to read the relationship, returns resource identifiers.

Target: AshJsonApi.Resource.Route

A POST route to create related entities using resource identifiers

Target: AshJsonApi.Resource.Route

A PATCH route to update a relationship using resource identifiers

Target: AshJsonApi.Resource.Route

A DELETE route to remove related entities using resource identifiers

Target: AshJsonApi.Resource.Route

A route for a generic action.

Target: AshJsonApi.Resource.Route

Encode the id of the JSON API response from selected attributes of a resource

Hex Package Hex Preview (current file) Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
json_api do
  type "post"
  includes [
    friends: [
      :comments
    ],
    comments: []
  ]

  routes do
    base "/posts"

    get :read
    get :me, route: "/me"
    index :read
    post :confirm_name, route: "/confirm_name"
    patch :update
    related :comments, :read
    relationship :comments, :read
    post_to_relationship :comments
    patch_relationship :comments
    delete_from_relationship :comments
  end
end
```

Example 2 (unknown):
```unknown
routes do
  base "/posts"

  get :read
  get :me, route: "/me"
  index :read
  post :confirm_name, route: "/confirm_name"
  patch :update
  related :comments, :read
  relationship :comments, :read
  post_to_relationship :comments
  patch_relationship :comments
  delete_from_relationship :comments
end
```

Example 3 (unknown):
```unknown
get :read, path_param_is_composite_key: :id
```

Example 4 (unknown):
```unknown
index action
```

---
