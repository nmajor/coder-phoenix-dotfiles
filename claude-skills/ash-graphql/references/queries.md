# Ash-Graphql - Queries

**Pages:** 8

---

## AshGraphql.Resource

**URL:** https://hexdocs.pm/ash_graphql/dsl-ashgraphql-resource.html

**Contents:**
- AshGraphql.Resource
- graphql
  - Nested DSLs
  - Examples
  - Options
  - graphql.queries
  - Nested DSLs
  - Examples
  - graphql.queries.get
  - Examples

This Ash resource extension adds configuration for exposing a resource in a graphql.

Configuration for a given resource in graphql

Queries (read actions) to expose for the resource.

A query to fetch a record by primary key

Target: AshGraphql.Resource.Query

A query to fetch a record

Target: AshGraphql.Resource.Query

A query to fetch a list of records

Target: AshGraphql.Resource.Query

Runs a generic action

Target: AshGraphql.Resource.Action

Mutations (create/update/destroy actions) to expose for the resource.

A mutation to create a record

Target: AshGraphql.Resource.Mutation

A mutation to update a record

Target: AshGraphql.Resource.Mutation

A mutation to destroy a record

Target: AshGraphql.Resource.Mutation

Runs a generic action

Target: AshGraphql.Resource.Action

Subscriptions (notifications) to expose for the resource.

A subscription to listen for changes on the resource

Target: AshGraphql.Resource.Subscription

Generates input objects for manage_relationship arguments on resource actions.

Configures the behavior of a given managed_relationship for a given action.

If there are type conflicts (for example, if the input could create or update a record, and the create and update actions have an argument of the same name but with a different type), a warning is emitted at compile time and the first one is used. If that is insufficient, you will need to do one of the following:

1.) provide the :types option to the managed_relationship constructor (see that option for more) 2.) define a custom type, with a custom input object (see the custom types guide), and use that custom type instead of :map 3.) change your actions to not have overlapping inputs with different types

Since managed relationships can ultimately call multiple actions, there is the possibility of field type conflicts. Use the types option to determine the type of fields and remove the conflict warnings.

For non_null use {:non_null, type}, and for a list, use {:array, type}, for example:

{:non_null, {:array, {:non_null, :string}}} for a non null list of non null strings.

To remove a key from the input object, simply pass nil as the type.

Use ignore?: true to skip this type generation.

Target: AshGraphql.Resource.ManagedRelationship

Hex Package Hex Preview (current file) Search HexDocs Download ePub version

Built using ExDoc (v0.38.2) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
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
```

Example 2 (unknown):
```unknown
queries do
  get :get_post, :read
  read_one :current_user, :current_user
  list :list_posts, :read
end
```

Example 3 (unknown):
```unknown
get name, action
```

Example 4 (unknown):
```unknown
get :get_post, :read
```

---

## Getting Started With GraphQL

**URL:** https://hexdocs.pm/ash_graphql/getting-started-with-graphql.html

**Contents:**
- Getting Started With GraphQL
- Get familiar with Ash resources
- Installation
  - Using Igniter (recommended)
  - Manual
    - Bring in the ash_graphql dependency
    - Setting up your schema
    - Connect your schema
      - Using Phoenix
  - Whats up with Module.concat/1?

If you haven't already, read the Ash Getting Started Guide. This assumes that you already have resources set up, and only gives you the steps to add AshGraphql to your resources/domains.

If you don't have an absinthe schema, you can create one just for ash. Replace helpdesk in the examples with your own application name.

See the SDL file guide for more information on using the SDL file, or remove the generate_sdl_file option to skip generating it on calls to mix ash.codegen.

in lib/helpdesk/schema.ex

Add the following code to your Phoenix router. It's useful to set up the Absinthe playground for trying things out, but it's optional.

This Module.concat/1 prevents a compile-time dependency from this router module to the schema module. It is an implementation detail of how forward/2 works that you end up with a compile-time dependency on the schema, but there is no need for this dependency, and that dependency can have drastic impacts on your compile times in certain scenarios.

If you started with mix new ... instead of mix phx.new ... and you want to still use Phoenix, the fastest path that way is typically to just create a new Phoenix application and copy your resources/config over.

If you are unfamiliar with how plug works, this guide will be helpful for understanding it. It also guides you through adding plug to your application.

Then you can use a Plug.Router and forward to your plugs similar to how it is done for phoenix:

For information on why we are using Module.concat/1, see the note above in the Phoenix section.

In the use AshGraphql call in your schema, you specify which domains you want to expose in your GraphQL API. Add any domains that will have AshGraphql queries/mutations to the domains list. For example:

Some example queries/mutations are shown below. If no queries/mutations are added, nothing will show up in the GraphQL API, so be sure to set one up if you want to try it out.

Here we show queries and mutations being added to the domain, but you can also define them on the resource. See below for an equivalent definition. Prefer to add to the domain so your interface is defined in one place.

Hex Package Hex Preview (current file) Search HexDocs Download ePub version

Built using ExDoc (v0.38.2) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
mix igniter.install ash_graphql
```

Example 2 (python):
```python
def deps()
  [
    ...
    {:ash_graphql, "~> 1.8.3"}
  ]
end
```

Example 3 (unknown):
```unknown
defmodule Helpdesk.GraphqlSchema do
  use Absinthe.Schema

  # Add your domains here
  use AshGraphql,
    domains: [Your.Domains]

  query do
    # Custom absinthe queries can be placed here
    @desc "Remove me once you have a query of your own!"
    field :remove_me, :string do
      resolve fn _, _, _ ->
        {:ok, "Remove me!"}
      end
    end
  end

  mutation do
    # Custom absinthe mutations can be placed here
  end
end
```

Example 4 (unknown):
```unknown
pipeline :graphql do
  plug AshGraphql.Plug
end

scope "/gql" do
  pipe_through [:graphql]

  forward "/playground",
          Absinthe.Plug.GraphiQL,
          schema: Module.concat(["Helpdesk.GraphqlSchema"]),
          interface: :playground

  forward "/",
    Absinthe.Plug,
    schema: Module.concat(["Helpdesk.GraphqlSchema"])
end
```

---

## Home

**URL:** https://hexdocs.pm/ash_graphql/readme.html

**Contents:**
- Home
- AshGraphql
- Tutorials
- Topics
- Reference

Welcome! This is the extension for building GraphQL APIs with Ash. The generated GraphQL APIs are powered by Absinthe. Generate a powerful Graphql API in minutes!

Hex Package Hex Preview (current file) Search HexDocs Download ePub version

Built using ExDoc (v0.38.2) for the Elixir programming language

---

## GraphQL Query Generation

**URL:** https://hexdocs.pm/ash_graphql/graphql-generation.html

**Contents:**
- GraphQL Query Generation
- Fetch Data by ID
- Filter Data With Arguments
- Mutations and Enums
- More GraphQL Docs

Following where we left off from Getting Started with GraphQL, this guide explores what the GraphQL requests and responses look like for different queries defined with the AshGraphql DSL.

All of the following examples apply to queries & mutations places on the domain as well.

For the get_ticket query defined above, the corresponding GraphQL would look like this:

And the response would look similar to this:

Let's look at an example of querying a list of things.

This time, we've added list :list_tickets, :read, to generate a GraphQL query for listing tickets. The request would look something like this:

And the response would look similar to this:

Now, let's say we want to add query parameters to listTickets. How do we do that? Consider list :list_tickets, :read and the actions section:

The second argument to list :list_tickets, :read is the action that will be called when the query is run. In the current example, the action is :read, which is the generic Read action. Let's create a custom action in order to define query parameters for the listTickets query.

We'll call this action :query_tickets:

In the graphql section, the list/2 call has been changed, replacing the :read action with :query_tickets.

The GraphQL request would look something like this:

Now, let's look at how to create a ticket by using a GraphQL mutation.

Let's say you have a Resource that defines an enum-like attribute:

Above, the following changes have been added:

The :status attribute is an enum that is constrained to the values [:open, :closed]. When used in conjunction with AshGraphql, a GraphQL enum type called TicketStatus will be generated for this attribute. The possible GraphQL values for TicketStatus are OPEN and CLOSED. See Use Enums with GraphQL for more information.

We can now create a ticket with the createTicket mutation:

The resulting ticket data is wrapped in AshGraphql's result object.

Validation errors are wrapped in a list of error objects under errors, also specified in the query. AshGraphql does this by default instead of exposing errors in GraphQL's standard errors array. This behavior can be changed by setting root_level_errors? true in the graphql section of your Ash domain module:

If we were to run this mutation in a test, it would look something like this:

Notice that the status attribute is set to "OPEN" and not "open". It is important that the value of the status be uppercase. This is required by GraphQL enums. AshGraphql will automatically con

*[Content truncated]*

**Examples:**

Example 1 (unknown):
```unknown
defmodule Helpdesk.Support.Ticket do
  use Ash.Resource,
    ...,
    extensions: [
      AshGraphql.Resource
    ]

  attributes do
    # Add an autogenerated UUID primary key called `:id`.
    uuid_primary_key :id

    # Add a string type attribute called `:subject`
    attribute :subject, :string
  end

  actions do
    # Add a set of simple actions. You'll customize these later.
    defaults [:read, :update, :destroy]
  end

  graphql do
    type :ticket

    queries do
      # create a field called `get_ticket` that uses the `read` read action to fetch a single ticket
      get :get_ticke
...
```

Example 2 (unknown):
```unknown
query ($id: ID!) {
  getTicket(id: $id) {
    id
    subject
  }
}
```

Example 3 (unknown):
```unknown
{
  "data": {
    "getTicket": {
      "id": "",
      "subject": ""
    }
  }
}
```

Example 4 (unknown):
```unknown
graphql do
    type :ticket

    queries do
      # create a field called `get_ticket` that uses the `read` read action to fetch a single ticket
      get :get_ticket, :read

      # create a field called `list_tickets` that uses the `read` read action to fetch a list of tickets
      list :list_tickets, :read
    end
  end
```

---

## AshGraphql.Resource.Query (ash_graphql v1.8.3)

**URL:** https://hexdocs.pm/ash_graphql/AshGraphql.Resource.Query.html

**Contents:**
- AshGraphql.Resource.Query (ash_graphql v1.8.3)
- Summary
- Functions
- Functions
- get_schema()
- list_schema()
- read_one_schema()

Represents a configured query on a resource

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.2) for the Elixir programming language

---

## AshGraphql (ash_graphql v1.8.3)

**URL:** https://hexdocs.pm/ash_graphql/AshGraphql.html

**Contents:**
- AshGraphql (ash_graphql v1.8.3)
- Summary
- Functions
- Functions
- handle_errors(result, resource, resolution, opts \\ [])
- Options
- load_fields(data, resource, resolution, opts \\ [])
- Determining required fields
- Options
- load_fields_on_query(query, resolution, opts \\ [])

AshGraphql is a GraphQL extension for the Ash framework.

For more information, see the getting started guide

Applies AshGraphql's error handling logic if the value is an {:error, error} tuple, otherwise returns the value

Use this to load any requested fields for a result when it is returned from a custom resolver or mutation.

The same as load_fields/4, but modifies the provided query to load the required fields.

Applies AshGraphql's error handling logic if the value is an {:error, error} tuple, otherwise returns the value

Useful for automatically handling errors in custom queries

Use this to load any requested fields for a result when it is returned from a custom resolver or mutation.

If you have a custom query/mutation that returns the record at a "path" in the response, then specify the path. In the example below, path would be ["record"]. This is how we know what fields to load.

The same as load_fields/4, but modifies the provided query to load the required fields.

This allows doing the loading in a single query rather than two separate queries.

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.2) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
query something() {
  result {
    record { # <- this is the instance
      id
      name
    }
  }
}
```

---

## AshGraphql.Domain

**URL:** https://hexdocs.pm/ash_graphql/dsl-ashgraphql-domain.html

**Contents:**
- AshGraphql.Domain
- graphql
  - Nested DSLs
  - Examples
  - Options
  - graphql.queries
  - Nested DSLs
  - Examples
  - graphql.queries.get
  - Examples

The entrypoint for adding GraphQL behavior to an Ash domain

Domain level configuration for GraphQL

Queries to expose for the resource.

A query to fetch a record by primary key

Target: AshGraphql.Resource.Query

A query to fetch a record

Target: AshGraphql.Resource.Query

A query to fetch a list of records

Target: AshGraphql.Resource.Query

Runs a generic action

Target: AshGraphql.Resource.Action

Mutations (create/update/destroy actions) to expose for the resource.

A mutation to create a record

Target: AshGraphql.Resource.Mutation

A mutation to update a record

Target: AshGraphql.Resource.Mutation

A mutation to destroy a record

Target: AshGraphql.Resource.Mutation

Runs a generic action

Target: AshGraphql.Resource.Action

Subscriptions to expose for the resource.

A subscription to listen for changes on the resource

Target: AshGraphql.Resource.Subscription

Hex Package Hex Preview (current file) Search HexDocs Download ePub version

Built using ExDoc (v0.38.2) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
graphql do
  authorize? false # To skip authorization for this domain
end
```

Example 2 (unknown):
```unknown
queries do
  get Post, :get_post, :read
  read_one User, :current_user, :current_user
  list Post, :list_posts, :read
end
```

Example 3 (unknown):
```unknown
get resource, name, action
```

Example 4 (unknown):
```unknown
get :get_post, :read
```

---

## Using Subscriptions

**URL:** https://hexdocs.pm/ash_graphql/use-subscriptions-with-graphql.html

**Contents:**
- Using Subscriptions
- Subscription DSL (beta)
  - Subscription response order
  - Deduplication

You can do this with Absinthe directly, and use AshGraphql.Subscription.query_for_subscription/3. Here is an example of how you could do this for a subscription for a single record. This example could be extended to support lists of records as well.

The subscription DSL is currently in beta and before using it you have to enable them in your config.

The order in which the subscription responses are sent to the client is not guaranteed to be the same as the order in which the mutations were executed.

First you'll need to do some setup, follow the the setup guide in the absinthe docs, but instead of using Absinthe.Pheonix.Endpoint use AshGraphql.Subscription.Endpoint.

By default subscriptions are resolved synchronously as part of the mutation. This means that a resolver is run for every subscriber that is not deduplicated. If you have a lot of subscribers you can add the AshGraphql.Subscription.Batcher to your supervision tree, which batches up notifications and runs subscription resolution out-of-band.

Afterwards, add an empty subscription block to your schema module.

Now you can define subscriptions on your resource or domain

For further Details checkout the DSL docs for resource and domain

By default, Absinthe will deduplicate subscriptions based on the context_id. We use the some of the context like actor and tenant to create a context_id for you.

If you want to customize the deduplication you can do so by adding a actor function to your subscription. This function will be called with the actor that subscribes and you can return a more generic actor, this way you can have one actor for multiple users, which will lead to less resolver executions.

Hex Package Hex Preview (current file) Search HexDocs Download ePub version

Built using ExDoc (v0.38.2) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
# in your absinthe schema file
subscription do
  field :field, :type_name do
    config(fn
      _args, %{context: %{current_user: %{id: user_id}}} ->
        {:ok, topic: user_id, context_id: "user/#{user_id}"}

      _args, _context ->
        {:error, :unauthorized}
    end)

    resolve(fn args, _, resolution ->
      # loads all the data you need
      AshGraphql.Subscription.query_for_subscription(
        YourResource,
        YourDomain,
        resolution
      )
      |> Ash.Query.filter(id == ^args.id)
      |> Ash.read(actor: resolution.context.current_user)
    end)
  end
end
```

Example 2 (unknown):
```unknown
config :ash_graphql, :subscriptions, true
```

Example 3 (python):
```python
@impl true
  def start(_type, _args) do
    children = [
      ...,
      {Absinthe.Subscription, MyAppWeb.Endpoint},
      AshGraphql.Subscription.Batcher
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: MyAppWeb.Supervisor]
    Supervisor.start_link(children, opts)
  end
```

Example 4 (unknown):
```unknown
defmodule MyAppWeb.Schema do
  ...

  subscription do
  end
end
```

---
