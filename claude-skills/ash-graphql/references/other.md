# Ash-Graphql - Other

**Pages:** 15

---

## Handling Errors

**URL:** https://hexdocs.pm/ash_graphql/handle-errors.html

**Contents:**
- Handling Errors
- Showing raised errors
- Root level errors
- Error Handler
  - Error handler in resources
  - Filtering by action
- Custom Errors

There are various options that can be set on the Domain module to determine how errors behave and/or are shown in the GraphQL.

For security purposes, if an error is raised as opposed to returned somewhere, the error is hidden. Set this to true in dev/test environments for an easier time debugging.

By default, action errors are simply shown in the errors field for mutations. Set this to true to return them as root level errors instead.

Setting an error handler allows you to use things like gettext to translate errors and/or modify errors in some way. This error handler will take the error object to be returned, and the context. See the absinthe docs for adding to the absinthe context (i.e for setting a locale).

Keep in mind, that you will want to ensure that any custom error handler you add performs the logic to replace variables in error messages.

This is what the default error handler looks like, for example:

Error handlers can also be specified in a resource. For examples:

If both an error handler for the resource and one for the domain are defined, they both take action: first the resource handler and then the domain handler.

If an action on a resource calls other actions (e.g. with a manage_relationships) the errors are handled by the primary resource that called the action.

The error handler carries in the context the name of the primary action that returned the error down the line. With that one can set different behaviors depending on the specific action that triggered the error. For example consider the following resource with :create, :custom_create and :update actions:

The error handler MyApp.Resource.GraphqlErrorHandler can in this case set different behaviors depending on the specific action that caused the error:

If you created your own Errors as described in the Ash Docs you also need to implement the protocol for it to be displayed in the Api.

Hex Package Hex Preview (current file) Search HexDocs Download ePub version

Built using ExDoc (v0.38.2) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
graphql do
  show_raised_errors? true
end

# or it can be done in config
# make sure you've set `otp_app` in your domain, i.e use Ash.Domain, otp_app: :my_app

config :my_app, YourDomain, [
  graphql: [
    show_raised_errors?: true
  ]
]
```

Example 2 (unknown):
```unknown
graphql do
  root_level_errors? true
end
```

Example 3 (unknown):
```unknown
graphql do
  error_handler {MyApp.GraphqlErrorHandler, :handle_error, []}
end
```

Example 4 (python):
```python
defmodule AshGraphql.DefaultErrorHandler do
  @moduledoc "Replaces any text in message or short_message with variables"

  def handle_error(
        %{message: message, short_message: short_message, vars: vars} = error,
        _context
      ) do
    %{
      error
      | message: replace_vars(message, vars),
        short_message: replace_vars(short_message, vars)
    }
  end

  def handle_error(other, _), do: other

  defp replace_vars(string, vars) do
    vars =
      if is_map(vars) do
        vars
      else
        List.wrap(vars)
      end

    Enum.reduce(vars, string, fn {key, value
...
```

---

## AshGraphql.Resource.ManagedRelationship (ash_graphql v1.8.3)

**URL:** https://hexdocs.pm/ash_graphql/AshGraphql.Resource.ManagedRelationship.html

**Contents:**
- AshGraphql.Resource.ManagedRelationship (ash_graphql v1.8.3)
- Summary
- Functions
- Functions
- schema()

Represents a managed relationship configuration on a mutation

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.2) for the Elixir programming language

---

## Use Unions with GraphQL

**URL:** https://hexdocs.pm/ash_graphql/use-unions-with-graphql.html

**Contents:**
- Use Unions with GraphQL
- Bypassing type generation for a union

Unions must be defined with Ash.Type.NewType:

By default, the type you would get for this on input and output would look something like this:

We do this by default to solve for potentially ambiguous types. An example of this might be if you had multiple different types of strings in a union, and you wanted the client to be able to tell exactly which type of string they'd been given. i.e {social: {value: "555-55-5555"}} | {phone_number: {value: "555-5555"}}.

However, you can clean the type in cases where you have no such conflicts by by providing

Which, in this case, would yield:

Add the graphql_define_type?/1 callback, like so, to skip Ash's generation (i.e if you're defining it yourself)

Hex Package Hex Preview (current file) Search HexDocs Download ePub version

Built using ExDoc (v0.38.2) for the Elixir programming language

**Examples:**

Example 1 (python):
```python
defmodule MyApp.Armor do
  use Ash.Type.NewType, subtype_of: :union, constraints: [
    types: [
      plate: [
        # This is an embedded resource, with its own fields
        type: MyApp.Armor.Plate
      ],
      chain_mail: [
        # And so is this
        type: MyApp.Armor.ChainMail
      ],
      custom: [
        type: :string
      ]
    ]
  ]

  use AshGraphql.Type

  # Add this to define the union in ash_graphql
  def graphql_type(_), do: :armor
end
```

Example 2 (unknown):
```unknown
type Armor = {plate: {value: Plate}} | {chain_mail: {value: ChainMail}} | {custom: {value: String}}
```

Example 3 (python):
```python
# Put anything in here that does not need to be named/nested with `{type_name: {value: value}}`
def graphql_unnested_unions(_constraints), do: [:plate, :chain_mail]
```

Example 4 (unknown):
```unknown
type Armor = Plate | ChainMail | {custom: {value: String}}
```

---

## AshGraphql.Plug (ash_graphql v1.8.3)

**URL:** https://hexdocs.pm/ash_graphql/AshGraphql.Plug.html

**Contents:**
- AshGraphql.Plug (ash_graphql v1.8.3)
- Summary
- Functions
- Functions
- call(conn, opts)
- init(opts)

Automatically set up the GraphQL actor and tenant.

Adding this plug to your pipeline will automatically set the actor and tenant if they were previously put there by Ash.PlugHelpers.set_actor/2 or Ash.PlugHelpers.set_tenant/2.

Callback implementation for Plug.call/2.

Callback implementation for Plug.init/1.

Callback implementation for Plug.call/2.

Callback implementation for Plug.init/1.

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.2) for the Elixir programming language

---

## Monitoring

**URL:** https://hexdocs.pm/ash_graphql/monitoring.html

**Contents:**
- Monitoring
- Traces
- Telemetry

Please read the Ash monitoring guide for more information. Here we simply cover the additional traces & telemetry events that we publish from this extension.

A tracer can be configured in the domain. It will fallback to the global tracer configuration config :ash, :tracer, Tracer

Each graphql resolver, and batch resolution of the underlying data loader, will produce a span with an appropriate name. We also set a source: :graphql metadata if you want to filter them out or annotate them in some way.

AshGraphql emits the following telemetry events, suffixed with :start and :stop. Start events have system_time measurements, and stop events have system_time and duration measurements. All times will be in the native time unit.

[:ash, <domain_short_name>, :gql_mutation] - The execution of a mutation. Use resource_short_name and mutation (or action) metadata to break down measurements.

[:ash, <domain_short_name>, :gql_query] - The execution of a mutation. Use resource_short_name and query (or action) metadata to break down measurements.

[:ash, <domain_short_name>, :gql_relationship] - The resolution of a relationship. Use resource_short_name and relationship metadata to break down measurements.

[:ash, <domain_short_name>, :gql_calculation] - The resolution of a calculation. Use resource_short_name and calculation metadata to break down measurements.

[:ash, <domain_short_name>, :gql_relationship_batch] - The resolution of a batch of relationships by the data loader. Use resource_short_name and relationship metadata to break down measurements.

[:ash, <domain_short_name>, :gql_calculation_batch] - The resolution of a batch of calculations by the data loader. Use resource_short_name and calculation metadata to break down measurements.

Hex Package Hex Preview (current file) Search HexDocs Download ePub version

Built using ExDoc (v0.38.2) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
graphql do
  trace MyApp.Tracer
end
```

---

## Using the SDL File

**URL:** https://hexdocs.pm/ash_graphql/sdl-file.html

**Contents:**
- Using the SDL File
  - Ensure your schema is up to date, gitignored, or not generated
- Generating on Recompilation
- Why generate the SDL file?
  - Documentation
  - Code Generation
  - Validating Changes

By passing the generate_sdl_file to use AshGraphql, AshGraphql will generate a schema file when you run mix ash.codegen. For example:

We suggest first adding mix ash.codegen --check to your CI/CD pipeline to ensure the schema is always up-to-date. Alternatively you can add the file to your .gitignore, or you can remove the generate_sdl_file option to skip generating the file.

With the generate_sdl_file option, calls to mix ash.codegen <name> will generate a .graphql file at the specified path.

By specifying the auto_generate_sdl_file? option, the sdl file will be generated any time the schema recompiles.

Some things that you can use this SDL file for:

The schema file itself represents your entire GraphQL API definition, and examining it can be very useful.

You can use tools like GraphQL codegen to generate a client for your GraphQL API.

Use the SDL file to check for breaking changes in your schema, especially if you are exposing a public API. A plug and play github action for this can be found here: https://the-guild.dev/graphql/inspector/docs/products/action

Hex Package Hex Preview (current file) Search HexDocs Download ePub version

Built using ExDoc (v0.38.2) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
use AshGraphql,
  domains: [Domain1, Domain2],
  generate_sdl_file: "priv/schema.graphql"
```

Example 2 (unknown):
```unknown
use AshGraphql,
  domains: [Domain1, Domain2],
  generate_sdl_file: "priv/schema.graphql",
  auto_generate_sdl_file?: true
```

---

## Authorize with GraphQL

**URL:** https://hexdocs.pm/ash_graphql/authorize-with-graphql.html

**Contents:**
- Authorize with GraphQL
  - Using AshAuthentication
  - Using Something Else
- Policy Breakdowns
- Field Policies
  - nullability

AshGraphql uses three special keys in the absinthe context:

By default, authorize? in the domain is set to true. To disable authorization for a given domain in graphql, use:

If you are doing authorization, you'll need to provide an actor.

If you have not yet installed AshAuthentication, you can install it with igniter:

If you've already set up AshGraphql before adding AshAuthentication, you will just need to make sure that your :graphql scope in your router looks like this:

To set the actor for authorization, you'll need to add an actor key to the absinthe context. Typically, you would have a plug that fetches the current user and uses Ash.PlugHelpers.set_actor/2 to set the actor in the conn (likewise with Ash.PlugHelpers.set_tenant/2).

Just add AshGraphql.Plug somewhere after that in the pipeline and the your GraphQL APIs will have the correct authorization.

By default, unauthorized requests simply return forbidden in the message. If you prefer to show policy breakdowns in your GraphQL errors, you can set the config option:

Be careful, as this can be an attack vector in some systems (i.e "here is exactly what you need to make true to do what you want to do").

Field policies in AshGraphql work by producing a null value for any forbidden field, as well as an error in the errors list.

Any fields with field policies on them should be nullable. If they are not nullable, the parent object will also be null (and considered in an error state), because null is not a valid type for that field.

To make fields as nullable even if it is not nullable by its definition, use the nullable_fields option.

Hex Package Hex Preview (current file) Search HexDocs Download ePub version

Built using ExDoc (v0.38.2) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
graphql do
  authorize? false
end
```

Example 2 (unknown):
```unknown
# installs ash_authentication & ash_authentication_phoenix
mix igniter.install ash_authentication_phoenix
```

Example 3 (unknown):
```unknown
pipeline :graphql do
  plug :load_from_bearer
  plug :set_actor, :user
  plug AshGraphql.Plug
end
```

Example 4 (python):
```python
defmodule MyAppWeb.Router do
  pipeline :api do
    # ...
    plug :get_actor_from_token
    plug AshGraphql.Plug
  end

  scope "/" do
    forward "/gql", Absinthe.Plug, schema: YourSchema

    forward "/playground",
          Absinthe.Plug.GraphiQL,
          schema: YourSchema,
          interface: :playground
  end

  def get_actor_from_token(conn, _opts) do
     with ["" <> token] <- get_req_header(conn, "authorization"),
         {:ok, user, _claims} <- MyApp.Guardian.resource_from_token(token) do
      conn
      |> set_actor(user)
    else
    _ -> conn
    end
  end
end
```

---

## Generic Actions

**URL:** https://hexdocs.pm/ash_graphql/generic-actions.html

**Contents:**
- Generic Actions
- Examples

Generic actions allow us to build any interface we want in Ash. AshGraphql has full support for generic actions, from type generation to data loading.

This means that you can write actions that return records or lists of records and those will have all of their fields appropriately loadable, or you can have generic actions that return simple scalars, like integers or strings.

Here we have a simple generic action returning a scalar value.

And here we have a generic action returning a list of records.

Hex Package Hex Preview (current file) Search HexDocs Download ePub version

Built using ExDoc (v0.38.2) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
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

Example 2 (unknown):
```unknown
graphql do
  type :post

  queries do
    action :random_ten, :random_ten
  end
end

actions do
  action :random_ten, {:array, :struct} do
    constraints items: [instance_of: __MODULE__]

    run fn input, context ->
      # This is just an example, not an efficient way to get
      # ten random records
      with {:ok, records} <-  Ash.read(__MODULE__) do
        {:ok, Enum.take_random(records, 10)}
      end
    end
  end
end
```

---

## Use Maps with GraphQL

**URL:** https://hexdocs.pm/ash_graphql/use-maps-with-graphql.html

**Contents:**
- Use Maps with GraphQL
- Bypassing type generation for an map

If you define an Ash.Type.NewType that is a subtype of :map, and you add the fields constraint which specifies field names and their types, AshGraphql will automatically derive an appropriate GraphQL type for it.

Add the graphql_define_type?/1 callback, like so, to skip Ash's generation (i.e if you're defining it yourself)

Hex Package Hex Preview (current file) Search HexDocs Download ePub version

Built using ExDoc (v0.38.2) for the Elixir programming language

**Examples:**

Example 1 (python):
```python
defmodule MyApp.Types.Metadata do
  @moduledoc false
  use Ash.Type.NewType, subtype_of: :map, constraints: [
    fields: [
      title: [
        type: :string
      ],
      description: [
        type: :string
      ]
    ]
  ]

  def graphql_type(_), do: :metadata
end
```

Example 2 (python):
```python
@impl true
def graphql_define_type?(_), do: false
```

---

## AshGraphql.Resource.Action (ash_graphql v1.8.3)

**URL:** https://hexdocs.pm/ash_graphql/AshGraphql.Resource.Action.html

**Contents:**
- AshGraphql.Resource.Action (ash_graphql v1.8.3)

Represents a configured generic action

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.2) for the Elixir programming language

---

## Use JSON with GraphQL

**URL:** https://hexdocs.pm/ash_graphql/use-json-with-graphql.html

**Contents:**
- Use JSON with GraphQL

AshGraphql provides two JSON types that may be used. They are the same except for how the type is serialized in responses.

By default, :json_string is used. The configuration for this is (uncharacteristically) placed in application config, for example:

Hex Package Hex Preview (current file) Search HexDocs Download ePub version

Built using ExDoc (v0.38.2) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
config :ash_graphql, :json_type, :json
```

---

## AshGraphql.Domain (ash_graphql v1.8.3)

**URL:** https://hexdocs.pm/ash_graphql/AshGraphql.Domain.html

**Contents:**
- AshGraphql.Domain (ash_graphql v1.8.3)
- Summary
- Functions
- Functions
- authorize?(domain)
- global_type_definitions(schema, env)
- graphql(body)
- install(igniter, module, arg, path, argv)
- root_level_errors?(domain)
- show_raised_errors?(domain)

The entrypoint for adding GraphQL behavior to an Ash domain

See AshGraphql.Domain.Info.authorize?/1.

See AshGraphql.Domain.Info.root_level_errors?/1.

See AshGraphql.Domain.Info.show_raised_errors?/1.

See AshGraphql.Domain.Info.authorize?/1.

See AshGraphql.Domain.Info.root_level_errors?/1.

See AshGraphql.Domain.Info.show_raised_errors?/1.

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.2) for the Elixir programming language

---

## Modifying the Resolution

**URL:** https://hexdocs.pm/ash_graphql/modifying-the-resolution.html

**Contents:**
- Modifying the Resolution
  - as_mutation?

Using the modify_resolution option, you can alter the Absinthe.Resolution.

modify_resolution is an MFA that will be called with the resolution, the query, and the result of the action as the first three arguments. Must return a new Absinthe.Resolution.

This can be used to implement things like setting cookies based on resource actions. A method of using resolution context for that is documented in Absinthe.Plug

If you are modifying the context in a query, then you should also set as_mutation? to true and represent this in your graphql as a mutation. See as_mutation? for more.

Hex Package Hex Preview (current file) Search HexDocs Download ePub version

Built using ExDoc (v0.38.2) for the Elixir programming language

---

## 

**URL:** https://hexdocs.pm/ash_graphql/ash_graphql.epub

---

## Upgrading to 1.0

**URL:** https://hexdocs.pm/ash_graphql/upgrade.html

**Contents:**
- Upgrading to 1.0
- :datetime is now the default representation for datetimes
- allow_non_null_mutation_arguments? is now true always
- Automagic atom/union/map types are no more
  - What you'll need to change
- The managed_relationships.auto? option now defaults to true
- Ash.Api is now Ash.Domain in Ash 3.0

AshGraphql 1.0 is a major release that introduces 3.0 support as well as a few breaking changes for AshGraphql itself.

For backwards compatibility, pre-1.0 we had users configure :utc_datetime_type to :datetime as part of the getting started guide. This is now the default. The configuration remains, but has been renamed. It was improperly config :ash, :utc_datetime_type, and it is now config :ash_graphql, :utc_datetime_type. If you are a user who is relying on the original behavior that had it default to :naive_datetime, you can set the following configuration:

Otherwise, if you have the following in your config, you can remove it.

You can remove this code from your config.

Pre 1.0, the input argument for mutations was always allowed to be null. In 1.0, it will be required if there are any non-null inputs inside of the object. You may need to address clients that are expecting to be able to send null. Even if they were sending null in those cases, it would have been an error, so it is unlikely that you will have to make any changes here.

Pre 1.0: AshGraphql automatically generated types for attributes/arguments that were atom/union/map types, giving them a name like postStatus, for an attribute status on a resource post. While convenient, this incurred significant internal complexity, and had room for strange ambiguity. For example, if you had two actions, that each had an argument called :status, and that :status was an enum with different values, you would get a conflict at compile time due to conflicting type names.

AshGraphql will now only generate types for types defined using Ash.Type.NewType or Ash.Type.Enum. For example, if you had:

in 3.0 this attribute would display as a :string. To fix this, you would define an Ash.Type.Enum:

Then you could use it in your attribute:

The same goes for map types with the :fields constraint, as well as union types, except you must define those using Ash.Type.NewType. For example:

Here you would get a compile error, indicating that we cannot determine a type for :union. To resolve this, you would define an Ash.Type.NewType, like so:

Then you could use it in your application like so:

Pre 1.0, you would need to either configure managed_relationships manually, for example:

Or set auto? to true, which would derive appropriate configurations for any action that had arguments with corresponding manage_relationship changes for them. This is unnecessarily verbose and there isn't really a time where you wouldn't

*[Content truncated]*

**Examples:**

Example 1 (unknown):
```unknown
config :ash_graphql, :utc_datetime_type, :naive_datetime
```

Example 2 (unknown):
```unknown
config :ash, :utc_datetime_type, :datetime
```

Example 3 (unknown):
```unknown
config :ash_graphql, :allow_non_null_mutation_arguments?, true
```

Example 4 (unknown):
```unknown
attribute :post_status, :atom, constraints: [one_of: [:active, :archived]]
```

---
