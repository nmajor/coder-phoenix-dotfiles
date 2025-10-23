# Ash-Core - Other

**Pages:** 88

---

## Ash.Type.Map (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Ash.Type.Map.html

**Contents:**
- Ash.Type.Map (ash v3.7.6)
  - Constraints
- Summary
- Functions
- Functions
- handle_change?()
- prepare_change?()

Represents a map stored in the database.

In postgres, for example, this represents binary encoded json

A builtin type that can be referenced via :map

:type (an Ash.Type) - Required.

:allow_nil? (boolean/0) - The default value is true.

:description (String.t/0)

:constraints (keyword/0) - The default value is [].

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
fields:  [
  amount: [
    type: :integer,
    description: "The amount of the transaction",
    constraints: [
      max: 10
    ]
  ],
  currency: [
    type: :string,
    allow_nil?: false,
    description: "The currency code of the transaction",
    constraints: [
      max_length: 3
    ]
  ]
]
```

---

## Multitenancy

**URL:** https://hexdocs.pm/ash/multitenancy.html

**Contents:**
- Multitenancy
- Setting Tenant
  - Using Ash.PlugHelpers.set_tenant
  - Using Ash.Scope
- Attribute Multitenancy
- Tenant-Aware Identities
- Context Multitenancy
- Possible Values for tenant

Multitenancy is the splitting up your data into discrete areas, typically by customer. One of the most common examples of this, is the idea of splitting up a postgres database into "schemas" one for each customer that you have. Then, when making any queries, you ensure to always specify the "schema" you are querying, and you never need to worry about data crossing over between customers. The biggest benefits of this kind of strategy are the simplification of authorization logic, and better performance. Instead of all queries from all customers needing to use the same large table, they are each instead all using their own smaller tables. Another benefit is that it is much easier to delete a single customer's data on request.

In Ash, there are two strategies for implementing multitenancy. The first (and simplest) strategy works for any data layer that supports filtering, and requires little maintenance/mental overhead. It is done via expecting a given attribute to line up with the tenant, and is called the :attribute strategy. The second, is based on the data layer backing your resource, and is called the :context strategy. For information on context based multitenancy, see the documentation of your data layer. For example, AshPostgres uses postgres schemas. While the :attribute strategy is simple to implement, it offers fewer advantages, primarily acting as another way to ensure your data is filtered to the correct tenant.

You can use Ash.PlugHelpers.set_tenant/2 in your plug pipeline to set the tenant for all operations:

Example usage of the above:

Important: If you're using ash_authentication with Multitenant User or Token resources, the Ash.PlugHelpers.set_tenant plug must be placed before any authentication plugs in your pipeline. This ensures the tenant is available when authentication operations need to query or create user/token records.

You can also use Ash.Scope to you can group up actor/tenant/context into one struct and pass that around.

Example usage of the above:

In this case, if you were to try to run a query without specifying a tenant, you would get an error telling you that the tenant is required.

Setting the tenant is done via Ash.Query.set_tenant/2 and Ash.Changeset.set_tenant/2. If you are using a code interface, you can pass tenant: in the options list (the final parameter). If you are using an extension, such as AshJsonApi or AshGraphql the method of setting tenant context is explained in that extension's documentation.

Exampl

*[Content truncated]*

**Examples:**

Example 1 (unknown):
```unknown
conn
|> Ash.PlugHelpers.set_tenant(tenant)
```

Example 2 (unknown):
```unknown
scope = %MyApp.Scope{current_user: user, current_tenant: tenant, locale: "en"}
MyApp.Blog.create_post!("new post", scope: scope)
```

Example 3 (unknown):
```unknown
defmodule MyApp.Users do
  use Ash.Resource, ...

  multitenancy do
    strategy :attribute
    attribute :organization_id
  end

  ...

  relationships do
    belongs_to :organization, MyApp.Organization
  end
end
```

Example 4 (unknown):
```unknown
# Error when not setting a tenant
MyApp.Users
|> Ash.Query.filter(name == "fred")
|> Ash.read!()
** (Ash.Error.Invalid)

* "Queries against the Helpdesk.Accounts.User resource require a tenant to be specified"
    (ash 1.22.0) lib/ash/domain/domain.ex:944: Ash.Domain.unwrap_or_raise!/2

# Automatically filtering by `organization_id == 1`
MyApp.Users
|> Ash.Query.filter(name == "fred")
|> Ash.Query.set_tenant(1)
|> Ash.read!()

[...]

# Automatically setting `organization_id` to `1`
MyApp.Users
|> Ash.Changeset.for_create(:create, %{name: "fred"})
|> Ash.Changeset.set_tenant(1)
|> Ash.create!()
...
```

---

## Ash.Error.Invalid exception (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Ash.Error.Invalid.html

**Contents:**
- Ash.Error.Invalid exception (ash v3.7.6)
- Summary
- Types
- Functions
- Types
- t()
- Functions
- exception(args)
- Keys
- message(map)

The top level invalid error

Create an Elixir.Ash.Error.Invalid without raising it.

Callback implementation for Exception.message/1.

Create an Elixir.Ash.Error.Invalid without raising it.

Callback implementation for Exception.message/1.

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## Ash.Error.Unknown exception (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Ash.Error.Unknown.html

**Contents:**
- Ash.Error.Unknown exception (ash v3.7.6)
- Summary
- Types
- Functions
- Types
- t()
- Functions
- exception(args)
- message(map)

The top level unknown error container

Construction an exception using the arguments passed in. You can see Elixir's doc on Exception/1 for more information.

Callback implementation for Exception.message/1.

Construction an exception using the arguments passed in. You can see Elixir's doc on Exception/1 for more information.

Callback implementation for Exception.message/1.

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## Ash.Type.DurationName (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Ash.Type.DurationName.html

**Contents:**
- Ash.Type.DurationName (ash v3.7.6)
- Summary
- Types
- Functions
- Types
- t()
- Functions
- handle_change?()
- prepare_change?()

An interval of time, primarily meant to be used in expression functions

Valid intervals are (as strings or atoms): [:year, :month, :week, :day, :hour, :minute, :second, :millisecond, :microsecond]

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## Ash.Type.Keyword (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Ash.Type.Keyword.html

**Contents:**
- Ash.Type.Keyword (ash v3.7.6)
- Summary
- Functions
- Functions
- handle_change?()
- prepare_change?()

Represents a keyword list, stored as a :map in the database.

A builtin type that can be referenced via :keyword_list

:type (an Ash.Type) - Required.

:description (String.t/0)

:allow_nil? (boolean/0) - The default value is true.

:constraints (keyword/0) - The default value is [].

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
fields:  [
  amount: [
    type: :integer,
    description: "The amount of the transaction",
    constraints: [
      max: 10
    ]
  ],
  currency: [
    type: :string,
    allow_nil?: false,
    description: "The currency code of the transaction",
    constraints: [
      max_length: 3
    ]
  ]
]
```

---

## What is Ash?

**URL:** https://hexdocs.pm/ash/what-is-ash.html

**Contents:**
- What is Ash?
- Why Ash?
- Built for Flexibility
- Essential Context
  - Elixir Developers
  - Non-Elixir Developers
  - New Programmers
  - Business Leaders
- Resources and Actions: The Core Abstractions
- Beyond Simple CRUD

Ash is an opinionated, declarative application framework that brings the batteries-included experience to Elixir. It shines when building web apps, APIs and services, but can be used for any kind of Elixir application. It integrates with the best that the Elixir ecoystem has to offer, often used with Phoenix and PostgreSQL, slotting directly into a standard Elixir codebase. Ash is built for velocity at day 1, but also for maintainability at year 5, a place where many frameworks and tools leave you high and dry.

Through its declarative extensibility, Ash delivers more than you'd expect: Powerful APIs with filtering/sorting/pagination/calculations/aggregations, pub/sub, authorization, rich introspection, GraphQL... It's what empowers this solo developer to build an ambitious ERP!

— Frank Dugan III, System Specialist, SunnyCor Inc.

At its heart, Ash is a framework for modeling your application's domain through Resources and their Actions. These are the fundamental abstractions that everything else builds upon.

If you've ever built software professionally, you've almost certainly experienced one or more of the following:

Ash's solution: Model your application's behavior first, as data, and derive everything else automatically. Ash resources center around actions that represent domain logic. Instead of exposing raw data models, you define meaningful operations like :publish_post, :approve_order, or :calculate_shipping_cost that encapsulate your business logic, validation, and authorization rules. This is coupled with a rich suite of extensions to fill the most common needs of Elixir applications.

Ash fills the gap that brings Phoenix up to feature parity with a batteries included framework like Django. Ash Admin (Django admin), Ash Resource & Domain (Django models & ORM), AshJsonApi (Django REST Framework), Ash Authentication (Django Allauth), Ash Phoenix (Django Forms), Ash Policies (Django Permissions)

But you aren't required to use Phoenix with an Ash project. Ash will happily work as a standalone CLI, terminal app or some other Elixir web framework that comes out tomorrow.

Scott Woodall - Principal Software Engineer, Microsoft

Ash was born out of the battle-scars from inflexible abstractions that eventually paint you into a corner. That's why Ash is designed with multi-tiered configurability and escape hatches all the way down. Instead of deciding that abstraction was bad, we decided that it just needed to be done better. Elixir & the BEAM have our

*[Content truncated]*

**Examples:**

Example 1 (unknown):
```unknown
# lib/my_blog/blog.ex
defmodule MyBlog.Blog do
  use Ash.Domain

  resources do
    resource MyBlog.Blog.Post do
      # Defines the `analyze_text/1` function which calls
      # the action of the same name on the Post resource.
      define :analyze_text, args: [:text]
    end
  end
end

# lib/my_blog/blog/post.ex
defmodule MyBlog.Blog.Post do
  use Ash.Resource

  actions do
    # Start with pure behavior - a simple action that processes text
    action :analyze_text, :map do
      argument :text, :string, allow_nil?: false

      run fn input, _context ->
        text = input.arguments.text
...
```

Example 2 (javascript):
```javascript
{:ok, analysis} = MyBlog.Blog.analyze_text("This is some sample blog content to analyze.")
# => {:ok, %{word_count: 9, character_count: 49, estimated_reading_time: 1}}
```

Example 3 (unknown):
```unknown
# lib/my_blog/blog.ex
defmodule MyBlog.Blog do
  use Ash.Domain

  resources do
    resource MyBlog.Blog.Post do
      define :analyze_text, args: [:text]
      define :create_post, action: :create, args: [:title, :content]
    end
  end
end

# lib/my_blog/blog/post.ex
defmodule MyBlog.Blog.Post do
  use Ash.Resource,
    domain: MyBlog.Blog,
    data_layer: AshPostgres.DataLayer # data_layer tells Ash where to store data

  postgres do
    table "posts"
    repo MyBlog.Repo
  end

  attributes do
    uuid_primary_key :id
    attribute :title, :string, allow_nil?: false, public?: true
    attr
...
```

Example 4 (unknown):
```unknown
# Behavior still works exactly the same
{:ok, analysis} = MyBlog.Blog.analyze_text("Some text to analyze")

# Now we can also persist state
{:ok, post} = MyBlog.Blog.create_post("My First Post", "This is some content")
```

---

## Ash.Type.Decimal (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Ash.Type.Decimal.html

**Contents:**
- Ash.Type.Decimal (ash v3.7.6)
  - Constraints
- Summary
- Functions
- Functions
- handle_change?()
- prepare_change?()

Represents a decimal.

A builtin type that can be referenced via :decimal

:precision - Enforces a maximum number of significant digits. Set to :arbitrary for no limit. The default value is :arbitrary.

:scale - Enforces a maximum number of decimal places. Set to :arbitrary for no limit. The default value is :arbitrary.

:max - Enforces a maximum on the value

:min - Enforces a minimum on the value

:greater_than - Enforces a minimum on the value (exclusive)

:less_than - Enforces a maximum on the value (exclusive)

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## Ash.Type.Vector (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Ash.Type.Vector.html

**Contents:**
- Ash.Type.Vector (ash v3.7.6)
  - Constraints
- Summary
- Functions
- Functions
- handle_change?()
- prepare_change?()

A builtin type that can be referenced via :vector.

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## Ash.Page (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Ash.Page.html

**Contents:**
- Ash.Page (ash v3.7.6)
- Summary
- Types
- Types
- page()
- type()

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## Ash.Notifier.PubSub.Publication (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Ash.Notifier.PubSub.Publication.html

**Contents:**
- Ash.Notifier.PubSub.Publication (ash v3.7.6)
- Summary
- Functions
- Functions
- publish_all_schema()
- schema()

Represents a configured publication from the pubsub notifier on an Ash.Resource

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## Ash.Type.String (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Ash.Type.String.html

**Contents:**
- Ash.Type.String (ash v3.7.6)
  - Constraints
- Summary
- Functions
- Functions
- handle_change?()
- prepare_change?()

Stores a string in the database.

A built-in type that can be referenced via :string.

By default, values are trimmed and empty values are set to nil. You can use the allow_empty? and trim? constraints to change these behaviors.

:max_length (non_neg_integer/0) - Enforces a maximum length on the value

:min_length (non_neg_integer/0) - Enforces a minimum length on the value

:match (Regex.t/0) - Enforces that the string matches a passed in regex

:trim? (boolean/0) - Trims the value. The default value is true.

:allow_empty? (boolean/0) - If false, the value is set to nil if it's empty. The default value is false.

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## Ash.Type.Date (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Ash.Type.Date.html

**Contents:**
- Ash.Type.Date (ash v3.7.6)
- Summary
- Functions
- Functions
- handle_change?()
- prepare_change?()

Represents a date in the database

A builtin type that can be referenced via :date

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## Ash.Type.Boolean (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Ash.Type.Boolean.html

**Contents:**
- Ash.Type.Boolean (ash v3.7.6)
- Summary
- Functions
- Functions
- handle_change?()
- prepare_change?()

Represents a boolean.

A builtin type that can be referenced via :boolean

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## Ash.Type.File.Source protocol (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Ash.Type.File.Source.html

**Contents:**
- Ash.Type.File.Source protocol (ash v3.7.6)
- Usage
- Summary
- Types
- Functions
- Types
- t()
- Functions
- implementation(file)

Protocol for allowing the casting of something into an Ash.Type.File.

All the types that implement this protocol.

Detect Implementation of the file.

All the types that implement this protocol.

Detect Implementation of the file.

Returns an :ok tuple with the implementation module if the file is supported and :error otherwise.

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

**Examples:**

Example 1 (python):
```python
defmodule MyStruct do
  defstruct [:path]

  @behavior Ash.Type.File.Implementation

  @impl Ash.Type.File.Implementation
  def path(%__MODULE__{path: path}), do: {:ok, path}

  @impl Ash.Type.File.Implementation
  def open(%__MODULE__{path: path}, modes), do: File.open(path, modes)

  defimpl Ash.Type.File.Source do
    def implementation(%MyStruct{} = struct), do: {:ok, MyStruct}
  end
end
```

---

## Ash.Error (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Ash.Error.html

**Contents:**
- Ash.Error (ash v3.7.6)
- Summary
- Types
- Functions
- Types
- ash_error()
- ash_error_subject()
- class()
- class_module()
- error_class()

Tools and utilities used by Ash to manage and conform errors

Returns whether or not a term is an Ash.Error type.

Converts errors into a single String.t.

This function prepends the provided path to any existing path on the errors.

Converts a value to an Ash exception.

Converts a value to an Ash.Error type.

Raises an error if the result is an error, otherwise returns the result

Returns whether or not a term is an Ash.Error type.

Converts errors into a single String.t.

This function prepends the provided path to any existing path on the errors.

Converts a value to an Ash exception.

The supported inputs to this function can be provided to various places, like Ash.Query.add_error/2, Ash.Changeset.add_error/2 and Ash.ActionInput.add_error/2.

Additionally, any place that you can return an error you can return instead a valid error input.

See the error handling guide for more.

Converts a value to an Ash.Error type.

Raises an error if the result is an error, otherwise returns the result

Alternatively, you can use the defsplode macro, which does this automatically.

def function!(arg) do

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
case do_something(arg) do
  :success -> :ok
  {:success, result} -> {:ok, result}
  {:error, error} -> {:error, error}
end
```

Example 2 (unknown):
```unknown
YourErrors.unwrap!(function(arg))
```

---

## Ash.TypedStruct (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Ash.TypedStruct.html

**Contents:**
- Ash.TypedStruct (ash v3.7.6)
- Example
- Field Options
- Constructor Functions
- Overriding new/1
  - Options

A DSL for defining typed structs with field validation and constraints.

Ash.TypedStruct provides a convenient way to define a struct type in Ash.

Under the hood, it creates an Ash.Type.NewType with subtype_of: :struct and the appropriate constraints.

The generated module includes:

You can override the new/1 function to add custom logic:

:extensions (list of module that adopts Spark.Dsl.Extension) - A list of DSL extensions to add to the Spark.Dsl

:otp_app (atom/0) - The otp_app to use for any application configurable options

:fragments (list of module/0) - Fragments to include in the Spark.Dsl. See the fragments guide for more.

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
defmodule MyApp.UserProfile do
  use Ash.TypedStruct

  typed_struct do
    field :username, :string, allow_nil?: false
    field :email, :string, constraints: [match: ~r/@/]
    field :age, :integer, constraints: [min: 0, max: 150]
    field :bio, :string, default: ""
    field :verified, :boolean, default: false
  end
end

# Creating instances
{:ok, profile} = MyApp.UserProfile.new(username: "john", email: "john@example.com")

# Using new! for raising on errors
profile = MyApp.UserProfile.new!(username: "jane", email: "jane@example.com", age: 25)

# Can be used as an Ash type
defmodule MyApp
...
```

Example 2 (python):
```python
defmodule MyApp.CustomStruct do
  use Ash.TypedStruct

  typed_struct do
    field :name, :string, allow_nil?: false
    field :created_at, :utc_datetime
  end

  def new(params) do
    params = Map.put_new(params, :created_at, DateTime.utc_now())
    super(params)
  end
end
```

---

## Ash.Type.CiString (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Ash.Type.CiString.html

**Contents:**
- Ash.Type.CiString (ash v3.7.6)
  - Constraints
- Summary
- Functions
- Functions
- handle_change?()
- prepare_change?()

Stores a case insensitive string in the database

See Ash.CiString for more information.

A builtin type that can be referenced via :ci_string

:max_length (non_neg_integer/0) - Enforces a maximum length on the value

:min_length (non_neg_integer/0) - Enforces a minimum length on the value

:match (Regex.t/0) - Enforces that the string matches a passed in regex

:trim? (boolean/0) - Trims the value. The default value is true.

:allow_empty? (boolean/0) - Sets the value to nil if it's empty. The default value is false.

:casing - Lowercases or uppercases the value, fully discarding case information.For example, if you don't set this, a value of FrEd could be saved to the data layer. FrEd and fReD would still compare as equal, but the original casing information is retained. In many cases, this is what you want. In some cases, however, you want to remove all case information. For example, in an email, you may want to support a user inputting an upper case letter, but discard it when saved. Valid values are :upper, :lower, nil The default value is nil.

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## Generators

**URL:** https://hexdocs.pm/ash/generators.html

**Contents:**
- Generators
- Installer
  - install hex archives
- Generators
- Patchers

Ash comes with multiple generators, packages as mix tasks, to help you generate and make modifications to your applications.

See the documentation for each mix task for more information. What is presented here is merely an overview.

Ash can be installed into a project using igniter. Some examples of how this can work:

Install Ash & AshPostgres into your current project

Create a new mix project with Ash & AshPostgres installed

Create a new phoenix project with Ash & AshPostgres installed

The archives have to be installed to use them. This only needs to be done once, until you change elixir versions.

Hex Package Hex Preview (current file) Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
mix igniter.install ash ash_postgres
```

Example 2 (unknown):
```unknown
mix archive.install hex igniter_new
mix igniter.new my_project --install ash,ash_postgres
```

Example 3 (unknown):
```unknown
mix igniter.new my_project --install ash,ash_postgres,ash_phoenix --with phx.new
```

Example 4 (unknown):
```unknown
mix archive.install hex igniter_new
mix archive.install hex phx_new
```

---

## Ash.Type.Struct (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Ash.Type.Struct.html

**Contents:**
- Ash.Type.Struct (ash v3.7.6)
- Alternative: Ash.TypedStruct
- Constraints
- Summary
- Functions
- Functions
- handle_change?()
- prepare_change?()

Use the instance_of constraint to specify that it must be an instance of a specific struct.

This cannot be loaded from a database unless the instance_of constraint is provided. If not, it can only be used to cast input, i.e for arguments.

For simpler use cases where you want to define a struct with typed fields inline, consider using Ash.TypedStruct. It provides a DSL for defining structs with:

Ash.TypedStruct automatically creates an Ash.Type.Struct with the appropriate constraints under the hood.

:instance_of (atom/0) - The module the struct should be an instance of

:preserve_nil_values? (boolean/0) - If set to true, when storing, nil values will be kept. Otherwise, nil values will be omitted. The default value is false.

:fields (keyword/0) - The types of the fields in the struct, and their constraints.For example:

allow_nil? is true by default

:type (an Ash.Type) - Required.

:allow_nil? (boolean/0) - The default value is true.

:description (String.t/0)

:constraints (keyword/0) - The default value is [].

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
defmodule MyStruct do
  use Ash.TypedStruct
  typed_struct do
    field :name, :string, allow_nil?: false
    field :age, :integer, constraints: [min: 0]
    field :email, :string, default: nil
  end
end
```

Example 2 (unknown):
```unknown
fields:  [
  amount: [
    type: :integer,
    description: "The amount of the transaction",
    constraints: [
      max: 10
    ]
  ],
  currency: [
    type: :string,
    allow_nil?: false,
    description: "The currency code of the transaction",
    constraints: [
      max_length: 3
    ]
  ]
]
```

---

## Ash.CiString (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Ash.CiString.html

**Contents:**
- Ash.CiString (ash v3.7.6)
- Summary
- Types
- Functions
- Types
- casing()
- string_type()
- t()
- Functions
- compare(left, right)

Represents a case insensitive string

While some data layers are aware of case insensitive string types, in order for values of this type to be used in other parts of Ash Framework, it has to be embedded in a module this allows us to implement the Comparable protocol for it.

For the type implementation, see Ash.Type.CiString

Compares an Elixir String or Ash.CiString. It will return :eq if equal, :lt, if the string is ordered alphabetically before the second string, and :gt if after.

Returns a Ash.CiString from a String, or nil if the value is nil.

Creates a case insensitive string

Returns the downcased value, only downcasing if it hasn't already been done

Converts a Ash.CiString into a normal Elixir String.

Compares an Elixir String or Ash.CiString. It will return :eq if equal, :lt, if the string is ordered alphabetically before the second string, and :gt if after.

Returns a Ash.CiString from a String, or nil if the value is nil.

Creates a case insensitive string

Returns the downcased value, only downcasing if it hasn't already been done

Converts a Ash.CiString into a normal Elixir String.

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## Ash.Type.DateTime (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Ash.Type.DateTime.html

**Contents:**
- Ash.Type.DateTime (ash v3.7.6)
  - Constraints
- Summary
- Functions
- Functions
- handle_change?()
- prepare_change?()

Represents a datetime, with configurable precision and timezone.

A builtin type that can be referenced via :datetime

:precision - Valid values are :microsecond, :second The default value is :second.

:cast_dates_as - Valid values are :start_of_day, :error The default value is :start_of_day.

:timezone - Valid values are :utc The default value is :utc.

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## Ash.Type.Module (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Ash.Type.Module.html

**Contents:**
- Ash.Type.Module (ash v3.7.6)
  - Constraints
- Summary
- Functions
- Functions
- handle_change?()
- prepare_change?()

Stores a module as a string in the database.

A builtin type that can be referenced via :module.

:behaviour (atom/0) - Allows constraining the module a one which implements a behaviour

:protocol (atom/0) - Allows constraining the module a one which implements a protocol

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## mix ash.gen.preparation (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Mix.Tasks.Ash.Gen.Preparation.html

**Contents:**
- mix ash.gen.preparation (ash v3.7.6)
- Example

Generates a custom preparation

See Custom Preparations for more.

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
mix ash.gen.preparation MyApp.Preparations.Top5
```

---

## Ash.DataLayer.Mnesia

**URL:** https://hexdocs.pm/ash/dsl-ash-datalayer-mnesia.html

**Contents:**
- Ash.DataLayer.Mnesia
- mnesia
  - Examples
  - Options

An Mnesia backed Ash Datalayer.

In your application initialization, you will need to call Mnesia.create_schema([node()]).

Additionally, you will want to create your mnesia tables there.

This data layer is unoptimized, fetching all records from a table and filtering them in memory. For that reason, it is not recommended to use it with large amounts of data. It can be great for prototyping or light usage, though.

A section for configuring the mnesia data layer

Hex Package Hex Preview (current file) Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
mnesia do
  table :custom_table
end
```

---

## Ash.Type.UtcDatetime (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Ash.Type.UtcDatetime.html

**Contents:**
- Ash.Type.UtcDatetime (ash v3.7.6)
- Summary
- Functions
- Functions
- handle_change?()
- prepare_change?()

Represents a utc datetime, with 'second' precision. A wrapper around :datetime for backwards compatibility.

A builtin type that can be referenced via :utc_datetime

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## Ash.TypedStruct.Field (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Ash.TypedStruct.Field.html

**Contents:**
- Ash.TypedStruct.Field (ash v3.7.6)
- Summary
- Types
- Types
- t()

Represents a field on a typed struct

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## Upgrade

**URL:** https://hexdocs.pm/ash/upgrade.html

**Contents:**
- Upgrade

This document has been moved.

Hex Package Hex Preview (current file) Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## mix ash.generate_policy_charts (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Mix.Tasks.Ash.GeneratePolicyCharts.html

**Contents:**
- mix ash.generate_policy_charts (ash v3.7.6)
- Prerequisites
- Command line options
- Summary
- Functions
- Functions
- run(argv)

Generates a Mermaid Flow Chart for a given resource's policies.

This mix task requires the Mermaid CLI to be installed on your system.

See https://github.com/mermaid-js/mermaid-cli

Generates a Mermaid Flow Chart for a given resource's policies.

Generates a Mermaid Flow Chart for a given resource's policies.

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## Ash.Type.UUIDv7 (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Ash.Type.UUIDv7.html

**Contents:**
- Ash.Type.UUIDv7 (ash v3.7.6)
- Summary
- Functions
- Functions
- handle_change?()
- prepare_change?()

A builtin type that can be referenced via :uuid_v7

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## Ash.Context (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Ash.Context.html

**Contents:**
- Ash.Context (ash v3.7.6)
- Summary
- Types
- Functions
- Types
- context_keyword_list()
- Functions
- to_opts(map, opts \\ [])

Functions for working with the context provided to various callbacks in Ash.

Copies keys from the given context map into a keyword list. Does not copy the :domain key.

Copies keys from the given context map into a keyword list. Does not copy the :domain key.

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## Ash.DataLayer.Mnesia (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Ash.DataLayer.Mnesia.html

**Contents:**
- Ash.DataLayer.Mnesia (ash v3.7.6)
- Summary
- Functions
- Functions
- bulk_create(resource, stream, options)
- mnesia(body)
- start(domain, resources \\ [])

An Mnesia backed Ash Datalayer.

In your application initialization, you will need to call Mnesia.create_schema([node()]).

Additionally, you will want to create your mnesia tables there.

This data layer is unoptimized, fetching all records from a table and filtering them in memory. For that reason, it is not recommended to use it with large amounts of data. It can be great for prototyping or light usage, though.

Bulk create records in the database.

Creates the table for each mnesia resource in a domain

Bulk create records in the database.

This function is used to create multiple records in a single transaction.

If you are NOT setting the upsert? = true option, this will be optimized by creating a single transaction and bulk creating all of the entries. The way :mnesia.write works, will effectively do an upsert, but you cannot control which fields are updated and the only identity you are matching on is the primary key.

If you are using an upsert? it will be unoptimized and will load all records into memory before performing the upsert operation.

Creates the table for each mnesia resource in a domain

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## Ash.Type.Term (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Ash.Type.Term.html

**Contents:**
- Ash.Type.Term (ash v3.7.6)
- Summary
- Functions
- Functions
- handle_change?()
- prepare_change?()

Represents a raw elixir term in the database

A builtin type that can be referenced via :binary

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## Ash.Type.Atom (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Ash.Type.Atom.html

**Contents:**
- Ash.Type.Atom (ash v3.7.6)
  - Constraints
- Summary
- Functions
- Functions
- handle_change?()
- prepare_change?()

Stores an atom as a string in the database

A builtin type that can be referenced via :atom

:one_of (term/0) - Allows constraining the value of an atom to a pre-defined list

:unsafe_to_atom? (boolean/0) - Allows casting to atoms that don't yet exist in the system. See https://security.erlef.org/secure_coding_and_deployment_hardening/atom_exhaustion.html for more. The default value is false.

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## Ash.Type.NewType behaviour (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Ash.Type.NewType.html

**Contents:**
- Ash.Type.NewType behaviour (ash v3.7.6)
- Options
- Summary
- Types
- Callbacks
- Functions
- Types
- t()
- Callbacks
- lazy_init?()

Allows defining a new type that is the combination of an existing type and custom constraints

A subtle difference between this type and its supertype (one that will almost certainly not matter in any case) is that we use the apply_constraints logic of the underlying type in the same step as cast_input. We do this because new types like these are, generally speaking, considering the constraint application as part of the core type. Other types, if you simply do Ash.Type.cast_input/3 you will not be also applying their constraints.

Whether or not the type is lazy initialized (so needs to be initialized when fetching constraints)

Returns the underlying subtype constraints

Returns the type that the NewType is a subtype of.

Returns the modified NewType constraints

Returns the constraints schema.

Returns true if the corresponding type is an Ash.Type.NewType

Returns the type that the given newtype is a subtype of

Whether or not the type is lazy initialized (so needs to be initialized when fetching constraints)

Returns the underlying subtype constraints

Returns the type that the NewType is a subtype of.

Returns the modified NewType constraints

Returns the constraints schema.

Returns true if the corresponding type is an Ash.Type.NewType

Returns the type that the given newtype is a subtype of

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
defmodule MyApp.Types.SSN do
  use Ash.Type.NewType, subtype_of: :string, constraints: [match: ~r/regex for ssn/]
end

defmodule MyApp.Types.Metadata do
  use Ash.Type.NewType, subtype_of: :union, constraints: [types: [
    foo: [...],
    bar: [...]
  ]]
end
```

---

## Error Handling

**URL:** https://hexdocs.pm/ash/error-handling.html

**Contents:**
- Error Handling
- Error Classes
- Error Handlers
- Generating Errors
  - Use exception modules
- Examples of using non standard errors
  - Keyword list (Ash.Error.Changes.InvalidChanges)
  - String (Ash.Error.Unknown.UnknownError)
- Using an exception module
  - Using a Custom Exception

As of 3.0, Ash uses Splode to as our basis for errors. The documentation below still applies, but it is powered by Splode under the hood.

There is a difficult balance to cut between informative errors and enabling simple reactions to those errors. Since many extensions may need to work with and/or adapt their behavior based on errors coming from Ash, we need rich error messages. However, when you have a hundred different exceptions to represent the various kinds of errors a system can produce, it becomes difficult to say something like "try this code, and if it is invalid, do x, if it is forbidden, do y. To this effect, exceptions in Ash have one of four classes mapping to the top level exceptions.

Since many actions can be happening at once, we want to support the presence of multiple errors as a result of a request to Ash. We do this by grouping up the errors into one before returning or raising. We choose an exception based on the order of the exceptions listed above. If there is a single forbidden, we choose Ash.Error.Forbidden, if there is a single invalid, we choose Ash.Error.Invalid and so on. The actual errors will be included in the errors key on the exception. The exception's message will contain a bulleted list of all the underlying exceptions that occurred. This makes it easy to react to specific kinds of errors, as well as to react to any/all of the errors present.

An example of a single error being raised, representing multiple underlying errors:

This allows easy rescuing of the major error classes, as well as inspection of the underlying cases

This pattern does add some additional overhead when you want to rescue specific kinds of errors. For example, you may need to do something like this:

Create, update and destroy actions can be provided with an error_handler, which can be used to modify the errors before they are returned. This is not an error recovery mechanism, rather a way to control the shape of errors that are returned. For more information on the callback itself, see Ash.Changeset.handle_errors/2.

When returning errors from behaviors or adding errors to a changeset/query/action input, multiple formats are supported. You can return a simple String, which will be converted into an Ash.Error.Unknown exception. You can also return a keyword list containing field or fields and message, which will be used to construct an Ash.Error.Invalid.InvalidChanges error. Finally, you can pass an exception directly, which will be used as is i

*[Content truncated]*

**Examples:**

Example 1 (unknown):
```unknown
AshExample.Representative
|> Ash.Changeset.for_create(:create, %{employee_id: "the best"})
|> Ash.create!()
 ** (Ash.Error.Invalid) Invalid Error
 * employee_id: must be absent.
 * first_name, last_name: at least 1 must be present.
```

Example 2 (unknown):
```unknown
try do
  AshExample.Representative
  |> Ash.Changeset.for_create(:create, %{employee_id: "dabes"})
  |> Ash.create!()
rescue
  e in Ash.Error.Invalid ->
    "Encountered #{Enum.count(e.errors)} errors"
end

"Encountered 2 errors"
```

Example 3 (unknown):
```unknown
try do
  AshExample.Representative
  |> Ash.Changeset.for_create(:create, %{employee_id: "dabes"})
  |> Ash.create!()
rescue
  e in Ash.Error.Invalid ->
    case Enum.find(e.errors, &(&1.__struct__ == A.Specific.Error)) do
      nil ->
        ...handle errors
      error ->
        ...handle specific error you found
    end
end
```

Example 4 (unknown):
```unknown
create :upsert_article_by_slug do
  upsert? true
  accept [:slug, :title, :body]
  upsert_identity :unique_slug
  upsert_condition expr(user_id == ^actor(:id))
  error_handler fn 
    _changeset, %Ash.Error.Changes.StaleRecord{} ->
      Ash.Error.Changes.InvalidChanges.exception(field: :slug, message: "has already been taken")

    _ changeset, other ->
      # leave other errors untouched
      other
  end
end
```

---

## Ash.Type.NaiveDatetime (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Ash.Type.NaiveDatetime.html

**Contents:**
- Ash.Type.NaiveDatetime (ash v3.7.6)
- Summary
- Functions
- Functions
- handle_change?()
- prepare_change?()

Represents a Naive datetime

A builtin type that can be referenced via :naive_datetime

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## Ash.Type.File (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Ash.Type.File.html

**Contents:**
- Ash.Type.File (ash v3.7.6)
    - Persistence
- Valid values to cast
- Summary
- Types
- Functions
- Types
- t()
- Functions
- from_io(device)

A type that represents a file on the filesystem.

This type does not support persisting via Ash.DataLayer.

It is mainly intended to be used in arguments.

This type can cast multiple types of values:

Create a file from an IO.device()

Create a file from a path.

Open the file with the given modes.

Returns the path to the file.

Create a file from an IO.device()

Create a file from a path.

Open the file with the given modes.

This function will delegate to the open/2 function on the implementation.

For details on the modes argument, see the File.open/2 documentation.

Returns the path to the file.

Not every implementation will support this operation. If the implementation does not support this operation, then {:error, :not_supported} will be returned. In this case, use the open/2 function to access the file.

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
iex> path = "README.md"
...> {:ok, device} = File.open(path)
...> Ash.Type.File.from_io(device)
%Ash.Type.File{source: device, implementation: Ash.Type.File.IO}
```

Example 2 (unknown):
```unknown
iex> path = "README.md"
...> Ash.Type.File.from_path(path)
%Ash.Type.File{source: "README.md", implementation: Ash.Type.File.Path}
```

Example 3 (javascript):
```javascript
iex> path = "README.md"
...> file = Ash.Type.File.from_path(path)
...> Ash.Type.File.open(file, [:read])
...> # => {:ok, #PID<0.109.0>}
```

Example 4 (unknown):
```unknown
iex> path = "README.md"
...> file = Ash.Type.File.from_path(path)
...> Ash.Type.File.path(file)
{:ok, "README.md"}
```

---

## Ash.Type.Enum behaviour (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Ash.Type.Enum.html

**Contents:**
- Ash.Type.Enum behaviour (ash v3.7.6)
- Custom input values
  - Caveats
- Value labels and descriptions
- Summary
- Callbacks
- Callbacks
- description(arg1)
- details(arg1)
- label(arg1)

A type for abstracting enums into a single type.

For example, your existing attribute might look like:

But as that starts to spread around your system, you may find that you want to centralize that logic. To do that, use this module to define an Ash type easily:

Then, you can rewrite your original attribute as follows:

If you need to accept inputs beyond those described above while still mapping them to one of the enum values, you can override the match/1 callback.

For example, if you want to map both the :half_empty and :half_full states to the same enum value, you could implement it as follows:

In the provided example, if no additional value is matched, super(value) is called, invoking the default implementation of match/1. This approach is typically suitable if you only aim to extend default matching rather than completely reimplementing it.

Additional input values are not exposed in derived interfaces. For example, HALF_EMPTY will not be present as a possible enum value when using ash_graphql.

Moreover, only explicitly matched values are mapped to the enum value. For instance, "HaLf_emPty" would not be accepted by the code provided earlier. If case normalization is needed for additional values, it must be explicitly implemented.

It's possible to associate a label and/or description for each value.

Adding labels and descriptions can be helpful when displaying the Enum values to users.

This can be used by extensions to provide detailed descriptions of enum values.

The description of a value can be retrieved with description/1:

The label of a value can be retrieved with label/1:

A default label is generated based on the value.

Both the description and label can be retrieved with details/1

The description of the value, if existing

The value detail map, if existing

The label of the value, if existing

finds the valid value that matches a given input term

true if a given term matches a value

The list of valid values (not all input types that match them)

The description of the value, if existing

The value detail map, if existing

The label of the value, if existing

finds the valid value that matches a given input term

true if a given term matches a value

The list of valid values (not all input types that match them)

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
attribute :status, :atom, constraints: [one_of: [:open, :closed]]
```

Example 2 (unknown):
```unknown
defmodule MyApp.TicketStatus do
  use Ash.Type.Enum, values: [:open, :closed]
end
```

Example 3 (unknown):
```unknown
attribute :status, MyApp.TicketStatus
```

Example 4 (python):
```python
defmodule MyApp.GlassState do
  use Ash.Type.Enum, values: [:empty, :half_full, :full]

  def match(:half_empty), do: {:ok, :half_full}
  def match("half_empty"), do: {:ok, :half_full}
  def match(value), do: super(value)
end
```

---

## Ash.Notifier behaviour (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Ash.Notifier.html

**Contents:**
- Ash.Notifier behaviour (ash v3.7.6)
- Summary
- Callbacks
- Functions
- Callbacks
- notify(t)
- requires_original_data?(t, action)
- Functions
- notify(resource_notifications)

A notifier is an extension that receives various events

Sends any notifications that can be sent, and returns the rest.

Sends any notifications that can be sent, and returns the rest.

A notification can only be sent if you are not currently in a transaction for the resource in question.

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## Wrap External APIs

**URL:** https://hexdocs.pm/ash/wrap-external-apis.html

**Contents:**
- Wrap External APIs
- Introduction
- Wrapping External APIs
- Example
- Now we can use this like any other Ash resource

Wrapping external APIs in Ash resources can allow you to leverage the rich and consistent interface provided by Ash.Resource for interactions with external services.

There are a few approaches to how you might do this, including the still in progress AshJsonApiWrapper. Here we will leverage "manual actions" as this is fully supported by Ash, and is the commonly used approach.

This approach is most appropriate when you are working with an API that exposes some data, like entities, list of entities, etc. For this example, we will be interacting with https://openlibrary.org, which allows for us to search and list books.

This guide covers reading data from the external API, not creating/updating it. This can be implemented using manual actions of a different type, or generic actions.

In the example below, we are calling to a paginated API, and we want to continue fetching results until we have reached the amount of results requested by the Ash.Query. We show this to illustrate that you can do all kinds of creative things when working with external APIs in manual actions.

Hex Package Hex Preview (current file) Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
Mix.install(
  [
    {:ash, "~> 3.0"},
    {:req, "~> 0.4.0"}
  ],
  consolidate_protocols: false
)
```

Example 2 (unknown):
```unknown
defmodule Doc do
  use Ash.Resource,
    domain: Domain

  attributes do
    uuid_primary_key :id
    attribute :author_name, :string
    attribute :title, :string
    attribute :type, :string
  end

  actions do
    read :search do
      primary? true
      argument :query, :string, allow_nil?: false
      prepare fn query, _ ->
        # We require that they limit the results to some reasonable set
        # (because this API is huge)
        cond do
          query.limit && query.limit > 250 ->
            Ash.Query.add_error(query, "must supply a limit that is less than or equal to 250")
 
...
```

Example 3 (unknown):
```unknown
{:module, Domain, <<70, 79, 82, 49, 0, 0, 250, ...>>,
 [
   Ash.Domain.Dsl.Resources.Resource,
   Ash.Domain.Dsl.Resources.Options,
   Ash.Domain.Dsl,
   %{opts: [], entities: [...]},
   Ash.Domain.Dsl,
   Ash.Domain.Dsl.Resources.Options,
   ...
 ]}
```

Example 4 (python):
```python
defmodule Doc.Actions.Read do
  use Ash.Resource.ManualRead

  def read(query, _, _opts, _context) do
    # we aren't handling these query options to keep the example simple
    # but you could on your own
    if query.sort != [] || query.offset != 0 do
      {:error, "Cannot sort or offset documents"}
    end

    if query.sort && query.sort != [] do
      raise "Cannot apply a sort to docs read"
    end

    if query.offset && query.offset != 0 do
      raise "Cannot apply a sort to docs read"
    end

    limit = query.limit || :infinity

    query = Ash.Query.unset(query, :limit)

    quer
...
```

---

## Ash.UUIDv7 (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Ash.UUIDv7.html

**Contents:**
- Ash.UUIDv7 (ash v3.7.6)
- Examples
- Summary
- Types
- Functions
- Types
- raw()
- t()
- Functions
- bingenerate()

Helpers for working with UUIDs version 7.

Used for generating UUIDs version 7 with increased clock precision for better monotonicity, as described by method 3 of the [Section 6.2](https://www.rfc-editor.org/rfc/rfc9562#name-monotonicity-and-counters

Inspired by the work of Ryan Winchester on uuidv7

A raw binary representation of a UUID.

A hex-encoded UUID string.

Generates a version 7 UUID in the binary format.

Decode a string representation of a UUID to the raw binary version.

Encode a raw UUID to the string representation.

Extract the millisecond timestamp from the UUID.

Generates a version 7 UUID using submilliseconds for increased clock precision.

A raw binary representation of a UUID.

A hex-encoded UUID string.

Generates a version 7 UUID in the binary format.

Decode a string representation of a UUID to the raw binary version.

Encode a raw UUID to the string representation.

Extract the millisecond timestamp from the UUID.

Generates a version 7 UUID using submilliseconds for increased clock precision.

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
iex> UUIDv7.generate()
"018e90d8-06e8-7f9f-bfd7-6730ba98a51b"

iex> UUIDv7.bingenerate()
<<1, 142, 144, 216, 6, 232, 127, 159, 191, 215, 103, 48, 186, 152, 165, 27>>
```

Example 2 (unknown):
```unknown
iex> UUIDv7.bingenerate()
<<1, 142, 144, 216, 6, 232, 127, 159, 191, 215, 103, 48, 186, 152, 165, 27>>
```

Example 3 (unknown):
```unknown
iex> UUIDv7.decode("018e90d8-06e8-7f9f-bfd7-6730ba98a51b")
<<1, 142, 144, 216, 6, 232, 127, 159, 191, 215, 103, 48, 186, 152, 165, 27>>
```

Example 4 (unknown):
```unknown
iex> UUIDv7.encode(<<1, 142, 144, 216, 6, 232, 127, 159, 191, 215, 103, 48, 186, 152, 165, 27>>)
"018e90d8-06e8-7f9f-bfd7-6730ba98a51b"
```

---

## Monitoring

**URL:** https://hexdocs.pm/ash/monitoring.html

**Contents:**
- Monitoring
- Packages
- Telemetry
  - Important
  - Events
- Tracing
  - Trace types
- After/Before Action Hooks

Monitoring in Ash has two primary components, Ash.Tracer and :telemetry. Monitoring might also be referred to as observability and instrumentation.

If you want to integrate with Appsignal, use the AshAppsignal package, which is maintained by the core team. We believe that Appsignal is a great way to get started quickly, is relatively cost effective, and provides a great user experience.

Ash emits the following telemetry events, suffixed with :start and :stop. Start events have system_time measurements, and stop events have system_time and duration measurements. All times will be in the native time unit.

Note the mention of :start and :stop suffixes. The event below [:ash, (domain_short_name), :create], is actually referring to two events, [:ash, (domain_short_name), :create, :start] and [:ash, (domain_short_name), :create, :stop].

_Replace (domain_short_name) with your domain short name, from Ash.Domain.Info.short_name.

Tracing is very similar to telemetry, but gives you some additional hooks to set_span_context() and get_span_context(). This allows you to "move" some piece of context between two processes. Ash will call this whenever it starts a new process to do anything. What this means is that if you are using a tracing tool or library you can ensure that any processes spawned by Ash are properly included in the trace. Additionally, you should be able to integrate a tracing library to include Ash actions/spans relatively easily by implementing the other callbacks.

A tracer can be configured globally in application config.

Additionally, one can be provide when creating changesets or calling an action, i.e

For customizing the names created for each span, see:

These are the list of trace types.

Due to the way before/after action hooks run, their execution time won't be included in the span created for the change. In practice, before/after action hooks are where the long running operations tend to be. We start a corresponding span and emit a telemetry event for before and after hooks, but they are only so useful. In a trace, they can highlight that "some hook" took a long time. In telemetry metrics they are of even less use. The cardinality of the metric would be extremely high, and we don't have a "name" or anything to distinguish them. To that end, you can use the macros & functions available in Ash.Tracer to create custom spans and/or emit custom telemetry events from your hooks. They automatically handle cases where the provided tracer is nil

*[Content truncated]*

**Examples:**

Example 1 (unknown):
```unknown
config :ash, :tracer, MyApp.Tracer
```

Example 2 (unknown):
```unknown
Resource
# better to put it here, as changesets are traced as well. It will be carried over to the domain action
|> Ash.Changeset.for_create(:create, %{}, tracer: MyApp.Tracer)
# but you can also pass it here.
|> Ash.create!(tracer: MyApp.Tracer)
```

Example 3 (python):
```python
defmodule MyApp.CustomChange do
  use Ash.Resource.Change

  require Ash.Tracer

  def change(changeset, _, _) do
    changeset
    |> Ash.Changeset.before_action(fn changeset ->
      Ash.Tracer.span(:custom, "custom name", changeset.context[:private][:tracer]) do
        # optionally set some metadata
        metadata = %{...}
        Ash.Tracer.set_metadata(changeset.context[:private][:tracer], :custom, metadata)
        # will get `:start` and `:stop` suffixed events emitted
        Ash.Tracer.telemetry_span([:telemetry, :event, :name], metadata) do
          ## Your logic here
        end
...
```

---

## Ash.Scope.ToOpts protocol (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Ash.Scope.ToOpts.html

**Contents:**
- Ash.Scope.ToOpts protocol (ash v3.7.6)
- Summary
- Types
- Functions
- Types
- t()
- Functions
- get_actor(scope)
- get_authorize?(scope)
- get_context(scope)

Extracts the actor from the scope

Extracts the authorize? option from the scope

Extracts the context from the scope

Extracts the tenant from the scope

Extracts the tracer(s) from the scope

Extracts the actor from the scope

Extracts the authorize? option from the scope

Extracts the context from the scope

Extracts the tenant from the scope

Extracts the tracer(s) from the scope

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## Ash.Type.Duration (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Ash.Type.Duration.html

**Contents:**
- Ash.Type.Duration (ash v3.7.6)
- Summary
- Functions
- Functions
- handle_change?()
- prepare_change?()

Represents a Duration

A builtin type that can be referenced via :duration

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## Ash.ToTenant protocol (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Ash.ToTenant.html

**Contents:**
- Ash.ToTenant protocol (ash v3.7.6)
- Summary
- Types
- Functions
- Types
- t()
- Functions
- to_tenant(value, resource)

Converts a value to a tenant. To add this to a resource, implement the protocol like so:application

What this should do is entirely dependent on how you've set up your tenants. This example assumes that you want the tenant to be org_#{organization_id}, but it could also be something like organization.schema.

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

**Examples:**

Example 1 (python):
```python
defmodule MyApp.Organization do
  use Ash.Resource, ...

  ...

  defimpl Ash.ToTenant do
    def to_tenant(%{id: id}, _resource), do: "org_#{id}"
  end
end
```

---

## Testing

**URL:** https://hexdocs.pm/ash/testing.html

**Contents:**
- Testing
- Async tests
- Missed notifications

Take a look at the how-to guide for a practical look at writing tests

The configuration you likely want to add to your config/test.exs is:

Each option is explained in more detail below.

The first thing you will likely want to do, especially if you are using AshPostgres, is to add the following config to your config/test.exs.

This ensures that Ash does not spawn tasks when executing your requests, which is necessary for doing transactional tests with AshPostgres.

If you are using Ecto's transactional features to ensure that your tests all run in a transaction, Ash will detect that it had notifications to send (if you have any notifiers set up) but couldn't because it was still in a transaction. The default behavior when notifications are missed is to warn. However, this can get pretty noisy in tests. So we suggest adding the following config to your config/test.exs.

Hex Package Hex Preview (current file) Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
# config/test.exs
config :ash, :disable_async?, true
config :ash, :missed_notifications, :ignore
```

Example 2 (unknown):
```unknown
# config/test.exs
config :ash, :disable_async?, true
```

Example 3 (unknown):
```unknown
# config/test.exs
config :ash, :missed_notifications, :ignore
```

---

## Ash.Error.Framework.AssumptionFailed exception (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Ash.Error.Framework.AssumptionFailed.html

**Contents:**
- Ash.Error.Framework.AssumptionFailed exception (ash v3.7.6)
- Summary
- Functions
- Functions
- exception(msg)
- Keys

Used when unreachable code/conditions are reached in the framework

Create an Elixir.Ash.Error.Framework.AssumptionFailed without raising it.

Create an Elixir.Ash.Error.Framework.AssumptionFailed without raising it.

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## Backwards Compatibility Config

**URL:** https://hexdocs.pm/ash/backwards-compatibility-config.html

**Contents:**
- Backwards Compatibility Config
- allow_forbidden_field_for_relationships_by_default?
  - Old Behavior
  - New Behavior
- include_embedded_source_by_default?
  - Old Behavior
  - New Behavior
- show_keysets_for_all_actions?
  - Old Behavior
  - New Behavior

All of these configurations are potentially breaking changes when applied to your application. However, we highly encourage setting as many of them as possible. In 4.0, some will be removed entirely, and any that remain will have their defaults changed to the new value.

The ash installer automatically sets all of these.

Loaded relationships that produced a Forbidden error would fail the entire request. i.e in Ash.load(post, [:comments, :author]), if author returned a Forbidden error, the entire request would fail with a forbidden error.

Now the relationships that produced a forbidden error are instead populated with %Ash.ForbiddenField{}.

When working with embedded types, the __source__ constraint is populated with the original changeset. This can be very costly in terms of memory when working with large sets of embedded resources.

Now, the source is only included when you say constraints: [include_source?: true] on the embedded resource's usage.

For all actions, the records would be returned with __metadata__.keyset populated with a keyset computed for the sort that was used to produce those records. This is expensive as it requires loading all things that are used by the sort.

Only when actually performing keyset pagination will the __metadata__.keyset be computed.

When an action supports both offset and keyset pagination, and a page is requested with only limit set (i.e., page: [limit: 10]), Ash defaulted to offset pagination and returned an %Ash.Page.Offset{}.

With the current default configuration, Ash will now return an %Ash.Page.Keyset{} when the pagination type is ambiguous (only limit is provided).

For detailed pagination behavior documentation, see the pagination guide.

On read action policies, we can often tell statically that they cannot pass, for example:

In these cases, you would get an Ash.Error.Forbidden, despite the fact that the default access_type for a policy is :filter. If you instead had:

You would get a filter. This made it difficult to predict when you would get a forbidden error and when the query results would be filtered.

Now, we always filter the query even if we know statically that the request would be forbidden. For example the following policy:

would yield filter: false. This makes the behavior consistent and predictable. You can always annotate that a given policy should result in a forbidden error by setting access_type :strict in the policy.

If you had an action with a preparation, or a global preparation 

*[Content truncated]*

**Examples:**

Example 1 (unknown):
```unknown
config :ash, allow_forbidden_field_for_relationships_by_default?: true
```

Example 2 (unknown):
```unknown
config :ash, include_embedded_source_by_default?: false
```

Example 3 (unknown):
```unknown
config :ash, show_keysets_for_all_actions?: false
```

Example 4 (unknown):
```unknown
config :ash, default_page_type: :keyset
```

---

## Ash.UUID (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Ash.UUID.html

**Contents:**
- Ash.UUID (ash v3.7.6)
- Summary
- Types
- Functions
- Types
- raw()
- t()
- Functions
- generate()

Helpers for working with UUIDs

A raw binary representation of a UUID.

A hex-encoded UUID string.

A raw binary representation of a UUID.

A hex-encoded UUID string.

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## Ash.Tracer behaviour (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Ash.Tracer.html

**Contents:**
- Ash.Tracer behaviour (ash v3.7.6)
- Summary
- Types
- Callbacks
- Functions
- Types
- metadata()
- span_type()
- t()
- Callbacks

A behaviour for implementing tracing for an Ash application.

Set metadata for the current span.

Set metadata for the current span.

This may be called multiple times per span, and should ideally merge with previous metadata.

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## Ash.BulkResult (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Ash.BulkResult.html

**Contents:**
- Ash.BulkResult (ash v3.7.6)
- Summary
- Types
- Types
- t()

The return value for bulk actions.

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## Ash.Type.Function (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Ash.Type.Function.html

**Contents:**
- Ash.Type.Function (ash v3.7.6)
  - Constraints
- Summary
- Functions
- Functions
- handle_change?()
- prepare_change?()

Represents a function.

If the type would be dumped to a native format, :erlang.term_to_binary(term, [:safe]) is used.

Please keep in mind, this is NOT SAFE to use with external input.

More information available here: https://erlang.org/doc/man/erlang.html#binary_to_term-2

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## Ash.TypedStruct

**URL:** https://hexdocs.pm/ash/dsl-ash-typedstruct.html

**Contents:**
- Ash.TypedStruct
- typed_struct
  - Nested DSLs
  - typed_struct.field
  - Arguments
  - Options
  - Introspection

Describe the fields of the struct

A field on the struct

Target: Ash.TypedStruct.Field

Hex Package Hex Preview (current file) Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
field name, type
```

---

## Ash.Type.Integer (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Ash.Type.Integer.html

**Contents:**
- Ash.Type.Integer (ash v3.7.6)
  - Constraints
- Summary
- Functions
- Functions
- handle_change?()
- prepare_change?()

Represents a simple integer

A builtin type that can be referenced via :integer

:max - Enforces a maximum on the value

:min - Enforces a minimum on the value

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## Ash.Type.File.Implementation behaviour (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Ash.Type.File.Implementation.html

**Contents:**
- Ash.Type.File.Implementation behaviour (ash v3.7.6)
- Summary
- Types
- Callbacks
- Types
- error()
- source()
- t()
- Callbacks
- open(file, modes)

Behaviour for file implementations that are compatible with Ash.Type.File.

Errors returned by the implementation.

The source of the file the implementation operates on.

Any module() implementing the Ash.Type.File.Implementation behaviour.

Open IO.device() for the file.

Return path of the file on disk.

Errors returned by the implementation.

The source of the file the implementation operates on.

Any module() implementing the Ash.Type.File.Implementation behaviour.

Open IO.device() for the file.

See Ash.Type.File.open/2

The return pid must point to a process following the Erlang I/O Protocol like StringIO or File.

Return path of the file on disk.

See: Ash.Type.File.path/1

This callback is optional. If the file is not stored on disk, this callback can be omitted.

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## 

**URL:** https://hexdocs.pm/ash/

---

## 

**URL:** https://hexdocs.pm/ash/ash.epub

---

## Ash.Type.TimeUsec (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Ash.Type.TimeUsec.html

**Contents:**
- Ash.Type.TimeUsec (ash v3.7.6)
- Summary
- Functions
- Functions
- handle_change?()
- prepare_change?()

Represents a time with microsecond precision.

A builtin type that can be referenced via :time_usec

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## Ash.Type.Float (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Ash.Type.Float.html

**Contents:**
- Ash.Type.Float (ash v3.7.6)
  - Constraints
- Summary
- Functions
- Functions
- handle_change?()
- prepare_change?()

Represents a float (floating point number)

A builtin type that be referenced via :float

:max - Enforces a maximum on the value

:min - Enforces a minimum on the value

:greater_than - Enforces a minimum on the value (exclusive)

:less_than - Enforces a maximum on the value (exclusive)

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## Ash.Notifier.PubSub (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Ash.Notifier.PubSub.html

**Contents:**
- Ash.Notifier.PubSub (ash v3.7.6)
- Example
- Debugging PubSub
- Topic Templates
- Important
- Template parts
- Custom Delimiters
- Named Pubsub modules
- Broadcast Types
- Summary

A builtin notifier to help you publish events over any kind of pub-sub tooling.

This is plug and play with Phoenix.PubSub, but could be used with any pubsub system.

You configure a module that defines a broadcast/3 function, and then add some "publications" which configure under what conditions an event should be sent and what the topic should be.

It can be quite frustrating when setting up pub_sub when everything appears to be set up properly, but you aren't receiving events. This usually means some kind of mismatch between the event names produced by the resource/config of your publications, and you can use the following flag to display debug information about all pub sub events.

Often you want to include some piece of data in the thing being changed, like the :id attribute. This is done by providing a list as the topic, and using atoms which will be replaced by their corresponding values. They will ultimately be joined with :.

This might publish a message to "user:created:1" for example.

For updates, if the field in the template is being changed, a message is sent to both values. So if you change user 1 to user 2, the same message would be published to user:updated:1 and user:updated:2. If there are multiple attributes in the template, and they are all being changed, a message is sent for every combination of substitutions.

If the previous value was nil or the field was not selected on the data passed into the action, then a notification is not sent for the previous value.

If the new value is nil then a notification is not sent for the new value.

Templates may contain lists, in which case all combinations of values in the list will be used. Add nil to the list if you want to produce a pattern where that entry is omitted.

The atom :_tenant may be used. If the changeset has a tenant set on it, that value will be used, otherwise that combination of values is ignored.

The atom :_pkey may be used. It will be a stringified, concatenation of the primary key fields, or just the primary key if there is only one primary key field.

The atom nil may be used. It only makes sense to use it in the context of a list of alternatives, and adds a pattern where that part is skipped.

Would produce the following messages, given a team_id of 1, a tenant of org_1, and an id of 50:

It's possible to change the default delimiter used when generating topics. This is useful when working with message brokers like RabbitMQ, which rely on a different set of delimiters fo

*[Content truncated]*

**Examples:**

Example 1 (unknown):
```unknown
defmodule MyApp.User do
  use Ash.Resource,
    # ...
    notifiers: [Ash.Notifier.PubSub]

  # ...

  pub_sub do
    module MyAppWeb.Endpoint

    prefix "user"
    publish :update, ["updated", :_pkey]
  end
end
```

Example 2 (unknown):
```unknown
config :ash, :pub_sub, debug?: true
```

Example 3 (unknown):
```unknown
prefix "user"

publish :create, ["created", :user_id]
```

Example 4 (unknown):
```unknown
publish :updated, [[:team_id, :_tenant], "updated", [:id, nil]]
```

---

## Comparable protocol (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Comparable.html

**Contents:**
- Comparable protocol (ash v3.7.6)
- Summary
- Types
- Functions
- Types
- ord()
- t()
- Functions
- compare(left_and_right)

Protocol which describes ordering relation for pair of types

Accepts struct with fields :left and :right and returns ord value

Accepts struct with fields :left and :right and returns ord value

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## Ash.Type.Time (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Ash.Type.Time.html

**Contents:**
- Ash.Type.Time (ash v3.7.6)
  - Constraints
- Summary
- Functions
- Functions
- handle_change?()
- prepare_change?()

Represents a time in the database, with a 'second' precision

A builtin type that can be referenced via :time

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## Alternatives

**URL:** https://hexdocs.pm/ash/alternatives.html

**Contents:**
- Alternatives
- Application Frameworks
- Application Design
- Building APIs
- Working with Data
- Authentication
- Authorization
- Validation

There aren't really any alternatives to Ash that we are aware of that do all of the same things, but there are many different packages out there that do some of the things that Ash does.

This is a living document, and is not comprehensive. We are not vouching for any of these packages, but rather listing them here for your convenience to investigate on your own.

Want to add or edit this list? Open a pull request. Want a more comprehensive list? Check out the Awesome Elixir.

These frameworks have similar overarching goals of helping you build your application layer.

Hex Package Hex Preview (current file) Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## Ash.Type.Tuple (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Ash.Type.Tuple.html

**Contents:**
- Ash.Type.Tuple (ash v3.7.6)
- Summary
- Functions
- Functions
- handle_change?()
- prepare_change?()

Represents a tuple stored in the data layer as a map.

A builtin type that can be referenced via :tuple

:type (an Ash.Type) - Required.

:allow_nil? (boolean/0) - The default value is true.

:description (String.t/0)

:constraints (keyword/0) - The default value is [].

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
constraints: fields:  [
              amount: [
                type: :integer,
                description: "The amount of the transaction",
                constraints: [
                  max: 10
                ]
              ],
              currency: [
                type: :string,
                allow_nil?: false,
                description: "The currency code of the transaction",
                constraints: [
                  max_length: 3
                ]
              ]
            ]
```

---

## Ash.DataLayer.Ets

**URL:** https://hexdocs.pm/ash/dsl-ash-datalayer-ets.html

**Contents:**
- Ash.DataLayer.Ets
- ets
  - Examples
  - Options

An ETS (Erlang Term Storage) backed Ash Datalayer, for testing and lightweight usage.

Remember, this does not have support for transactions! This is not recommended for production use, especially in multi-user applications. It can, however, be great for prototyping.

A section for configuring the ets data layer

Hex Package Hex Preview (current file) Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
ets do
  # Used in testing
  private? true
end
```

---

## Ash.Type.Union (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Ash.Type.Union.html

**Contents:**
- Ash.Type.Union (ash v3.7.6)
- Basic Usage
- Tagged Unions
  - Tag Options
- Untagged Unions
- Mixed Tagged and Untagged Types
- Storage Modes
  - :type_and_value (default)
  - :map_with_tag
- Embedded Resources

A union between multiple types, distinguished with a tag or by attempting to validate.

Union types allow you to define attributes that can hold values of different types. There are two main strategies for distinguishing between types:

Define a union type in an attribute:

Values are wrapped in an %Ash.Union{} struct with :type and :value fields:

Tagged unions use a discriminator field to identify the type. This is more reliable but requires the data to include the tag field:

Input data must include the tag field:

When cast_tag?: false, the tag field is removed from the final value.

Without tags, union types attempt to cast values against each type in order:

Order matters! The first successful cast wins:

You can mix tagged and untagged types within a single union. Tagged types are checked first by their tag values, and if no tagged type matches, untagged types are tried in order:

This allows for both explicit type identification (via tags) and fallback casting:

Union values can be stored in different formats:

Stores as a map with explicit type and value fields:

Stores the value directly (requires all types to have tags):

Union types work seamlessly with embedded resources:

Union types support arrays using the standard {:array, :union} syntax:

Union types support multiple input formats for flexibility:

Unions can contain other union types. All type names must be unique across the entire nested structure:

Union types support loading related data when member types are loadable (like embedded resources):

Union casting provides detailed error information:

Create reusable union types with Ash.Type.NewType:

:storage - How the value will be stored when persisted.:type_and_value will store the type and value in a map like so {type: :type_name, value: the_value} :map_with_tag will store the value directly. This only works if all types have a tag and tag_value configured. Valid values are :type_and_value, :map_with_tag The default value is :type_and_value.

:include_source? (boolean/0) - Whether to include the source changeset in the context. Defaults to the value of config :ash, :include_embedded_source_by_default, or true. In 4.x, the default will be false. The default value is true.

:types - The types to be unioned, a map of an identifier for the enum value to its configuration.When using tag and tag_value we are referring to a map key that must equal a certain value in order for the value to be considered an instance of that type.For example:


*[Content truncated]*

**Examples:**

Example 1 (unknown):
```unknown
attribute :content, :union,
  constraints: [
    types: [
      text: [type: :string],
      number: [type: :integer],
      flag: [type: :boolean]
    ]
  ]
```

Example 2 (unknown):
```unknown
# Reading union values
%Ash.Union{type: :text, value: "Hello"}
%Ash.Union{type: :number, value: 42}
```

Example 3 (unknown):
```unknown
attribute :data, :union,
  constraints: [
    types: [
      user: [
        type: :map,
        tag: :type,
        tag_value: "user"
      ],
      admin: [
        type: :map,
        tag: :type,
        tag_value: "admin"
      ]
    ]
  ]
```

Example 4 (unknown):
```unknown
# Valid inputs
%{type: "user", name: "John", email: "john@example.com"}
%{type: "admin", name: "Jane", permissions: ["read", "write"]}
```

---

## Ash.Type.UrlEncodedBinary (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Ash.Type.UrlEncodedBinary.html

**Contents:**
- Ash.Type.UrlEncodedBinary (ash v3.7.6)
- Summary
- Functions
- Functions
- handle_change?()
- prepare_change?()

Represents a binary that attempts to decode input strings as a url encoded base64 string.

A builtin type that can be referenced via :url_encoded_binary

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## Ash.Authorizer behaviour (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Ash.Authorizer.html

**Contents:**
- Ash.Authorizer behaviour (ash v3.7.6)
- Summary
- Types
- Callbacks
- Functions
- Types
- context()
- state()
- Callbacks
- add_calculations(arg1, state, context)

The interface for an ash authorizer

These will typically be implemented by an extension, but a custom one can be implemented by defining an extension that also adopts this behaviour.

Then you can extend a resource with authorizers: [YourAuthorizer]

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## Ash.Type.UUID (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Ash.Type.UUID.html

**Contents:**
- Ash.Type.UUID (ash v3.7.6)
- Summary
- Functions
- Functions
- handle_change?()
- prepare_change?()

A builtin type that can be referenced via :uuid

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## Ash.Scope (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Ash.Scope.html

**Contents:**
- Ash.Scope (ash v3.7.6)
  - Scope is left at the front door
- Setup
- Passing scope and options
- Example
- Summary
- Types
- Functions
- Types
- t()

Determines how the actor, tenant and context are extracted from a data structure.

This is inspired by the same feature in Phoenix, however the actor, tenant and context options will always remain available, as they are standardized representations of things that actions can use to do their work.

When you have a scope, you can group up actor/tenant/context into one struct and pass that around, for example:

Your scope is "left at the front door". That is, when you pass a scope to an action, the options are extracted and the scope is removed from those options. Within hooks, you are meant to use the context provided to your functions as the new scope. This is very important, because you don't want a bunch of your code or extension code having to switch on if opts[:scope], extracting the things that it needs, etc.

See the actions guide for more information.

If you are using Phoenix, you will want to assign your scope module in a plug that runs after your plugs that determine actor/tenant/context. Then, you will want to add an on_mount hook for LiveViews that sets your scope assign. This is especially true for AshAuthentication, as it does not currently have a concept of scopes.

For the actor, tenant and authorize?, extracted from scopes, the values from the scope are discarded if also present in opts.

i.e scope: scope, actor: nil will remove the set actor. scope: scope, actor: some_other_actor will set the actor to some_other_actor.

For context, the values are deep merged.

For tracer, the value(s) are concatenated into a single list.

You would implement Ash.Scope.ToOpts for a module like so:

For more on context, and what the shared key is used for, see the actions guide

You could then use this in various places by passing the scope option.

Extensions should not use this option, only end users.

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
scope = %MyApp.Scope{current_user: user, current_tenant: tenant, locale: "en"}

# instead of
MyDomain.create_thing(actor: current_user, tenant: tenant)

# you can do
MyDomain.create_thing(scope: scope)
```

Example 2 (python):
```python
defmodule MyApp.Scope do
  defstruct [:current_user, :current_tenant, :locale]

  defimpl Ash.Scope.ToOpts do
    def get_actor(%{current_user: current_user}), do: {:ok, current_user}
    def get_tenant(%{current_tenant: current_tenant}), do: {:ok, current_tenant}
    def get_context(%{locale: locale}), do: {:ok, %{shared: %{locale: locale}}}
    # You typically configure tracers in config files
    # so this will typically return :error
    def get_tracer(_), do: :error

    # This should likely always return :error
    # unless you want a way to bypass authorization configured in your scope

...
```

Example 3 (python):
```python
scope = %MyApp.Scope{...}
# with code interfaces
MyApp.Blog.create_post!("new post", scope: scope)

# with changesets and queries
MyApp.Blog
|> Ash.Changeset.for_create(:create, %{title: "new post"}, scope: scope)
|> Ash.create!()

# with the context structs that we provide

def change(changeset, _, context) do
  Ash.Changeset.after_action(changeset, fn changeset, result ->
    MyApp.Domain.do_something_else(..., scope: context)
    # if not using as a scope, the alternative is this
    # in the future this will be deprecated
    MyApp.Domain.do_something_else(..., Ash.Context.to_opts(context)
...
```

---

## Ash.Policy.Check behaviour (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Ash.Policy.Check.html

**Contents:**
- Ash.Policy.Check behaviour (ash v3.7.6)
- Summary
- Types
- Callbacks
- Functions
- Types
- actor()
- authorizer()
- check_type()
- context()

A behaviour for declaring checks, which can be used to easily construct authorization rules.

If a check can be expressed simply, i.e as a function of the actor, or the context of the request, see Ash.Policy.SimpleCheck for an easy way to write that check. If a check can be expressed with a filter statement, see Ash.Policy.FilterCheck for an easy way to write that check.

An optional callback, that allows the check to work with policies set to access_type :filter

An optional callback, that allows the check to work with policies set to access_type :runtime

Determine if two check references are mutually exclusive (conflicting).

Describe the check in human readable format, given the options

Expands the description of the check, given the actor and subject

Determine if the first check reference implies the second check reference.

Whether or not the expanded description should replace the basic description in breakdowns

Whether or not your check requires the original data of a changeset (if applicable)

Simplify a check reference into a SAT expression of simpler check references.

Strict checks should be cheap, and should never result in external calls (like database or domain)

The type of the check

An optional callback, that allows the check to work with policies set to access_type :filter

Return a keyword list filter that will be applied to the query being made, and will scope the results to match the rule

An optional callback, that allows the check to work with policies set to access_type :runtime

Takes a list of records, and returns the subset of authorized records.

Determine if two check references are mutually exclusive (conflicting).

This is used by the SAT solver to optimize policy evaluation by understanding when two checks cannot both be true at the same time.

Describe the check in human readable format, given the options

Expands the description of the check, given the actor and subject

Determine if the first check reference implies the second check reference.

This is used by the SAT solver to optimize policy evaluation by understanding when one check being true guarantees another check is also true.

Whether or not the expanded description should replace the basic description in breakdowns

Whether or not your check requires the original data of a changeset (if applicable)

Simplify a check reference into a SAT expression of simpler check references.

This is used by the SAT solver to break down complex checks into simpler component

*[Content truncated]*

---

## Ash.Type.Binary (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Ash.Type.Binary.html

**Contents:**
- Ash.Type.Binary (ash v3.7.6)
- Summary
- Functions
- Functions
- handle_change?()
- prepare_change?()

A builtin type that can be referenced via :binary

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## Ash.Error.Unknown.UnknownError exception (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Ash.Error.Unknown.UnknownError.html

**Contents:**
- Ash.Error.Unknown.UnknownError exception (ash v3.7.6)
- Summary
- Types
- Functions
- Types
- t()
- Functions
- exception(args)
- Keys

Used when an unknown error occurs

Create an Elixir.Ash.Error.Unknown.UnknownError without raising it.

Create an Elixir.Ash.Error.Unknown.UnknownError without raising it.

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## Ash.Type.UtcDatetimeUsec (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Ash.Type.UtcDatetimeUsec.html

**Contents:**
- Ash.Type.UtcDatetimeUsec (ash v3.7.6)
- Summary
- Functions
- Functions
- handle_change?()
- prepare_change?()

Represents a utc datetime with microsecond precision. A wrapper around :datetime for backwards compatibility.

A builtin type that can be referenced via :utc_datetime_usec

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## mix ash.gen.enum (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Mix.Tasks.Ash.Gen.Enum.html

**Contents:**
- mix ash.gen.enum (ash v3.7.6)
- Example
- Options

Generates an Ash.Type.Enum

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
mix ash.gen.enum MyApp.Support.Ticket.Types.Status open,closed --short-name ticket_status
```

---

## Contributing to Ash

**URL:** https://hexdocs.pm/ash/contributing.html

**Contents:**
- Contributing to Ash
- Welcome!
- Contributing to Documentation
  - Protocol for Documentation Improvements
  - Making Documentation Changes
  - Important Note About DSL Documentation
- Rules
- Local Development & Testing
  - Setting Up Your Development Environment
  - Running Tests and Checks

We are delighted to have anyone contribute to Ash, regardless of their skill level or background. We welcome contributions both large and small, from typos and documentation improvements, to bug fixes and features. There is a place for everyone's contribution here. Check the issue tracker or join the ElixirForum/discord server to see how you can help! Make sure to read the rules below as well.

Documentation contributions are one of the most valuable kinds of contributions you can make! Good documentation helps everyone in the community understand and use Ash more effectively.

We prefer Pull Requests over issues for documentation improvements. Here's why and how:

The best way to contribute to documentation is often through GitHub's web interface, which allows you to make changes without having to clone the code locally:

For Module Documentation:

For Function Documentation:

Once you click the </> button, GitHub will:

This workflow makes it incredibly easy to fix typos, clarify explanations, add examples, or improve any part of the documentation you encounter while using Ash.

DSL documentation cannot be edited directly on GitHub. The documentation you see for DSL options (like those for Ash.Resource, Ash.Domain, etc.) is generated from the source code of the DSL definition modules.

For example, if you want to improve documentation for Ash.Resource options, you need to edit the source code in the Ash.Resource.Dsl module, not the generated documentation files. The DSL documentation is automatically generated from the @doc attributes and option definitions in these modules.

To find the right module to edit:

When making DSL documentation improvements, make sure to:

Fork and clone the repository:

Install dependencies:

Before submitting any pull request, please run the full test suite and quality checks locally:

This command runs a comprehensive suite of checks including:

You can also run individual checks:

If you want to test your Ash changes with your own application, you can use Ash as a local dependency. In your application's mix.exs, replace the hex dependency with a path dependency:

Testing in your own application is not sufficient, you must also include automated tests.

Create a feature branch:

Make your changes and write tests

Run the full check suite:

Push and create a pull request

Hex Package Hex Preview (current file) Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
git clone https://github.com/your-username/ash.git
cd ash
```

Example 2 (unknown):
```unknown
mix deps.get
```

Example 3 (unknown):
```unknown
mix compile
```

Example 4 (unknown):
```unknown
defp deps do
  [
    # Replace this:
    # {:ash, "~> 3.0"}

    # With this (adjust path as needed):
    {:ash, path: "../ash"},

    # Your other dependencies...
  ]
end
```

---

## Ash.Page.Offset (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Ash.Page.Offset.html

**Contents:**
- Ash.Page.Offset (ash v3.7.6)
- Summary
- Types
- Functions
- Types
- page_opts()
- page_opts_opts()
- page_opts_type()
- t()
- Functions

A page of results from offset based pagination.

If a resource supports keyset pagination as well, it will also have the keyset metadata.

Creates a new Ash.Page.Offset.t().

Creates a new Ash.Page.Offset.t().

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## Combination Queries

**URL:** https://hexdocs.pm/ash/combination-queries.html

**Contents:**
- Combination Queries
- Overview
- Syntax
- Basic Example
- Using Calculations in Combinations
- Accessing Combination Values
- Sorting and Distinct Operations
- Important Rules and Limitations
- Data Layer Support
- Performance Considerations

Ash Framework provides a powerful feature called "combination queries" that allows you to combine multiple queries into a single result set, giving you the ability to create complex data retrieval patterns with minimal effort. For SQL data-layers, this feature is implemented using SQL's UNION, INTERSECT, and EXCEPT operations.

Combination queries let you:

To use combination queries, you'll work with the following functions:

Where combinations is a list of combination specifications starting with a base query, followed by additional operations:

Here's a simple example that combines users who meet different criteria:

This query would return:

One of the most powerful features of combination queries is the ability to create calculations that can be referenced across the combinations:

When you add calculations to a combination query, they behave differently depending on the name of the calculation. If the name matches the name of an attribute, calculation or aggregate on the resource, then the value is placed in that key. Otherwise, it will be placed into the calculations key.

This example searches for users where either their name or email matches "fred" with a similarity score of at least 0.5, and returns the top 10 matches of each type sorted by their match score.

To access values from combination queries in your main query, use the combinations/1 function in your expressions:

In this example, the combinations(:domain) and combinations(:full_name) references allow the outer query to access the calculation values from the inner combinations.

You can sort and filter the combined results using the calculations from your combinations:

This will return results in the order: Alice, John, and then all other users, thanks to the custom sort_order calculation.

This is an internal power tool: No public interfaces like AshJsonApi/AshGraphql will be updated to allow this sort of query to be built "from the outside". It is designed to be implemented within an action, "under the hood".

Base Combination Required: Your list of combinations must always start with Ash.Query.Combination.base/1.

Field Consistency: All combinations must produce the same set of fields. This means:

Primary Keys: When adding runtime calculations or loading related data with Ash.Query.load/2, all fieldsets must include the primary key of the resource. If this is not the case, the query will fail.

Type Specification: When referencing calculation values with combinations/1, the calcul

*[Content truncated]*

**Examples:**

Example 1 (unknown):
```unknown
Ash.Query.combination_of(query, combinations)
```

Example 2 (unknown):
```unknown
read :best_and_worst_users do
  description """
  Returns the top 10 active users who are not on a losing streak
  (sorted by score descending) and the bottom 10 active users who are not on a
  winning streak (sorted by score ascending)
  """

  filter expr(active == true)

  prepare fn query, _ ->
    Ash.Query.combination_of(query, [
      # Must always begin with a base combination
      Ash.Query.Combination.base(
        filter: expr(not(on_a_losing_streak)),
        sort: [score: :desc],
        limit: 10
      ),
      Ash.Query.Combination.union(
        filter: expr(not(on_a_winning_s
...
```

Example 3 (unknown):
```unknown
query = "fred"

User
|> Ash.Query.filter(active == true)
|> Ash.Query.combination_of([
  Ash.Query.Combination.base(
    filter: expr(trigram_similarity(user_name, ^query) >= 0.5),
    calculations: %{
      match_score: calc(trigram_similarity(user_name, ^query), type: :float)
    },
    sort: [
      {calc(trigram_similarity(user_name, ^query), type: :float), :desc}
    ],
    limit: 10
  ),
  Ash.Query.Combination.union(
    filter: expr(trigram_similarity(email, ^query) >= 0.5),
    calculations: %{
      match_score: calc(trigram_similarity(email, ^query), type: :float)
    },
    sort: [
...
```

Example 4 (unknown):
```unknown
User
|> Ash.Query.combination_of([
  Ash.Query.Combination.base(
    filter: expr(organization.name == "bar"),
    calculations: %{
      domain: calc("bar", type: :string),
      full_name: calc(name <> "@bar", type: :string)
    }
  ),
  Ash.Query.Combination.union_all(
    filter: expr(organization.name == "baz"),
    calculations: %{
      domain: calc("baz", type: :string),
      full_name: calc(name <> "@baz", type: :string)
    }
  )
])
|> Ash.Query.calculate(:email_domain, :string, expr(^combinations(:domain)))
|> Ash.Query.calculate(:display_name, :string, expr(^combinations(:full_nam
...
```

---

## Ash.Policy.SimpleCheck behaviour (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Ash.Policy.SimpleCheck.html

**Contents:**
- Ash.Policy.SimpleCheck behaviour (ash v3.7.6)
- Example
- Summary
- Types
- Callbacks
- Types
- actor()
- context()
- options()
- Callbacks

A type of check that operates only on request context, never on the data

Define match?/3, which gets the actor, request context, and opts, and returns true or false

This is a simple check that checks if the user is changing anything other than the provided list.

You could then use this like

Whether or not the request matches the check

Whether or not the request matches the check

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

**Examples:**

Example 1 (python):
```python
defmodule ChangingNothingExcept do
  use Ash.Policy.SimpleCheck

  def match?(_actor, %{subject: %Ash.Changeset{} = changeset}, opts) do
    allowed = opts[:attributes]
    {:ok, Enum.all?(Map.keys(changeset.attributes), &(&1 in allowed))}
  end

  def match?(_, _, _), do: {:ok, true}
end
```

Example 2 (unknown):
```unknown
policy actor_attribute_equals(:role, :foobar) do
  authorize_if {ChangingNothingExcept, attributes: [:foo, :bar]}
end
```

---

## Ash.DataLayer.Ets (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Ash.DataLayer.Ets.html

**Contents:**
- Ash.DataLayer.Ets (ash v3.7.6)
- Summary
- Functions
- Functions
- do_add_calculations(records, resource, calculations, domain)
- ets(body)
- stop(resource, tenant \\ nil)

An ETS (Erlang Term Storage) backed Ash Datalayer, for testing and lightweight usage.

Remember, this does not have support for transactions! This is not recommended for production use, especially in multi-user applications. It can, however, be great for prototyping.

Stops the storage for a given resource/tenant (deleting all of the data)

Stops the storage for a given resource/tenant (deleting all of the data)

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## Ash.Policy.Policy (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Ash.Policy.Policy.html

**Contents:**
- Ash.Policy.Policy (ash v3.7.6)
- Summary
- Types
- Functions
- Types
- t()
- Functions
- expression(policies, check_context)
- fetch_fact(facts, check)
- fetch_or_strict_check_fact(authorizer, check)

Represents a policy on an Ash.Resource

Default Options for Crux scenarios

Default Options for Crux scenarios

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## Upgrade

**URL:** https://hexdocs.pm/ash/upgrading-to-3-0.html

**Contents:**
- Upgrade
- Other Packages
- Upgrading to 3.0
  - Dependency Changes
    - Ash.Flow
    - Picosat Elixir
  - Ash.Api is now Ash.Domain
    - What you'll need to change
  - DSL Changes
  - Ash.Registry has been removed

Other packages have had a major version bump in addition to Ash core. While all packages have been changed to refer to domain instead of api, they did not receive a major version bump because there were no special breaking changes to account for when using that package. You will also need to factor in the following upgrade guides, if you use those packages.

This section contains each breaking change, and the steps required to address it in your application

If you use Ash.Flow, include {:ash_flow, "~> 0.1.0"} in your application.

In 2.0, Ash had a dependency on picosat_elixir. In 3.0, this is an optional dependency, to help folks handle certain compatibility issues. To upgrade, add {:picosat_elixir, "~> 0.2"} to your mix.exs.

The previous name was often confusing as this is an overloaded term for many. To that end, Ash.Api has been renamed to Ash.Domain, which better fits our usage and concepts.

To make this change you will need to do two things:

code_interface.define_for is now code_interface.domain. Additionally, it is set automatically if the domain option is specified on use Ash.Resource.

domain.execution.timeout used to default to 30 seconds, but now it defaults to :infinity. This is because a timeout requires copying memory across process boundaries, and is an unnecessary expense a vast majority of the time. We recommend putting timeouts on specific actions that may need them.

actions.create.reject, actions.update.reject and actions.destroy.reject have been removed. Blacklisting inputs makes it too easy to make mistakes. Instead, specify an explicit accept list.

relationships.belongs_to.attribute_writable? no longer makes the underlying attribute both public and writable. It defaults to the value of writable? on the relationship (which itself defaults to true), and only controls the generated attributes writable? true property. So now, by default, it will be true, which is safe when coupled with changes to the default_accept, discussed below. Generally, this means you should be safe to remove any occurrences of attribute_writable? true.

relationships.belongs_to.attribute_public? has been added, which controls the underlying attribute's public? value. This, similar to attribute_writable? defaults to the public? attribute of the relationship.

resource.simple_notifiers has been removed, in favor of specifying non-DSL notifiers in the simple_notifiers option to use Ash.Resource.

resource.actions.read.filter can now be specified multiple times.

*[Content truncated]*

**Examples:**

Example 1 (unknown):
```unknown
resources do
  resource Resource1
  resource Resource2
end
```

Example 2 (unknown):
```unknown
change after_action(fn changeset, result -> ... end)
```

Example 3 (unknown):
```unknown
change after_action(fn changeset, result, context -> ... end)
```

Example 4 (python):
```python
defmodule MyCustomError do
  use Splode.Error, class: :invalid, fields: [:foo, :bar]

  def message(error) do
    "Message: #{error.foo} - #{error.bar}"
  end
end
```

---

## Ash.Type behaviour (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Ash.Type.html

**Contents:**
- Ash.Type behaviour (ash v3.7.6)
- Built in types
- Lists/Arrays
- Defining Custom Types
  - Overriding the {:array, type} behaviour
  - Short names
- Composite Types
- Constraints
  - Attribute example
- Summary

The Ash.Type behaviour is used to define a value type in Ash.

To specify a list of values, use {:array, Type}. Arrays are special, and have special constraints:

:items (term/0) - Constraints for the elements of the list. See the contained type's docs for more.

:min_length (non_neg_integer/0) - A minimum length for the items.

:max_length (non_neg_integer/0) - A maximum length for the items.

:nil_items? (boolean/0) - Whether or not the list can contain nil items. The default value is false.

:remove_nil_items? (boolean/0) - Whether or not to remove the nil items from the list instead of adding errors. The default value is false.

:empty_values (list of term/0) - A set of values that, if encountered, will be considered an empty list. The default value is [""].

Generally you add use Ash.Type to your module (it is possible to add @behaviour Ash.Type and define everything yourself, but this is more work and error-prone).

Another option is to use Ash.Type.NewType, which supports defining a new type that is the combination of an existing type and custom constraints. This can be helpful when defining a custom attribute (e.g. struct) for a resource.

Simple example of a float custom type

By defining the *_array versions of cast_input, cast_stored, dump_to_native and apply_constraints, you can override how your type behaves as a collection. This is how the features of embedded resources are implemented. No need to implement them unless you wish to override the default behaviour. Your type is responsible for handling nil values in each callback as well.

All the Ash built-in types are implemented with use Ash.Type so they are good examples to look at to create your own Ash.Type.

You can define short :atom_names for your custom types by adding them to your Ash configuration:

Doing this will require a recompilation of the :ash dependency which can be triggered by calling:

Composite types are composite in the data layer. Many data layers do not support this, but some (like AshPostgres), do. To define a composite type, the following things should be true:

With the above implemented, your composite type can be used in expressions, for example:

And you can also construct composite types in expressions, for example:

Constraints are a way of validating an input type. This validation can be used in both attributes and arguments. The kinds of constraints you can apply depends on the type of data. You can find all types in Ash.Type . Each type has its own page on w

*[Content truncated]*

**Examples:**

Example 1 (python):
```python
defmodule GenTracker.AshFloat do
  use Ash.Type

  @impl Ash.Type
  def storage_type(_), do: :float

  @impl Ash.Type
  def cast_input(nil, _), do: {:ok, nil}
  def cast_input(value, _) do
    Ecto.Type.cast(:float, value)
  end

  @impl Ash.Type
  def cast_stored(nil, _), do: {:ok, nil}
  def cast_stored(value, _) do
    Ecto.Type.load(:float, value)
  end

  @impl Ash.Type
  def dump_to_native(nil, _), do: {:ok, nil}
  def dump_to_native(value, _) do
    Ecto.Type.dump(:float, value)
  end
end
```

Example 2 (unknown):
```unknown
config :ash, :custom_types, [ash_float: GenTracker.AshFloat]
```

Example 3 (unknown):
```unknown
$ mix deps.compile ash --force
```

Example 4 (unknown):
```unknown
Ash.Query.filter(expr(coordinates[:x] == 1))
```

---

## Ash.PlugHelpers (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Ash.PlugHelpers.html

**Contents:**
- Ash.PlugHelpers (ash v3.7.6)
- Summary
- Functions
- Functions
- get_actor(arg1)
- Deprecation warning
- Example
- get_context(arg1)
- Example
- get_tenant(arg1)

Helpers for working with the Plug connection.

Retrieves the actor from the Plug connection.

Retrieves the context from the Plug connection.

Retrieves the tenant from the Plug connection.

Sets the actor inside the Plug connection.

Sets the context inside the Plug connection.

Sets the tenant inside the Plug connection.

Updates the actor inside the Plug connection.

Updates the context inside the Plug connection.

Retrieves the actor from the Plug connection.

The actor is stored inside the connection's private fields.

This function checks to see if the actor is already set in the @actor assign, and if so will emit a deprecation warning.

This is to allow apps using the previous method a chance to update.

Rather than setting the actor in the assigns, please use the set_actor/2 method.

Retrieves the context from the Plug connection.

The context is stored inside the connection's private fields.

Retrieves the tenant from the Plug connection.

The tenant is stored inside the connection's private fields.

This function checks to see if the tenant is already set in the @tenant assign, and if so will emit a deprecation warning.

This is to allow apps using the previous method a chance to update.

Rather than setting the tenant in the assigns, please use the set_tenant/2 method.

Sets the actor inside the Plug connection.

The actor is stored inside the connection's private fields.

Sets the context inside the Plug connection.

Context can be used to store arbitrary data about the user, connection, or anything else you like that doesn't belong as part of the actor or tenant.

The context is stored inside the connection's private fields.

Sets the tenant inside the Plug connection.

The tenant is stored inside the connection's private fields.

Updates the actor inside the Plug connection.

The actor is stored inside the connection's private fields.

Updates the context inside the Plug connection.

The context is stored inside the connection's private fields.

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
iex> actor = build_actor(%{email: "marty@1985.retro"})
...> conn = build_conn() |> put_private(:ash, %{actor: actor})
...> actor = get_actor(conn)
%{email: "marty@1985.retro"} = actor

iex> actor = build_actor(%{email: "marty@1985.retro"})
...> conn = build_conn() |> assign(:actor, actor)
...> actor = get_actor(conn)
%{email: "marty@1985.retro"} = actor
```

Example 2 (unknown):
```unknown
iex> context = %{fraud_score: 0.427}
...> conn = build_conn() |> put_private(:ash, %{context: context})
...> context = get_context(conn)
%{fraud_score: 0.427}
```

Example 3 (unknown):
```unknown
iex> conn = build_conn() |> put_private(:ash, %{tenant: "my-tenant"})
...> tenant = get_tenant(conn)
"my-tenant" = tenant

iex> conn = build_conn() |> assign(:tenant, "my-tenant")
...> tenant = get_tenant(conn)
"my-tenant" = tenant
```

Example 4 (unknown):
```unknown
iex> actor = build_actor(%{email: "marty@1985.retro"})
...> conn = build_conn() |> set_actor(actor)
%Plug.Conn{private: %{ash: %{actor: %{email: "marty@1985.retro"}}}} = conn
```

---

## Ash.Notifier.PubSub

**URL:** https://hexdocs.pm/ash/dsl-ash-notifier-pubsub.html

**Contents:**
- Ash.Notifier.PubSub
- Example
- Debugging PubSub
- Topic Templates
- Important
- Template parts
- Custom Delimiters
- Named Pubsub modules
- Broadcast Types
- pub_sub

A builtin notifier to help you publish events over any kind of pub-sub tooling.

This is plug and play with Phoenix.PubSub, but could be used with any pubsub system.

You configure a module that defines a broadcast/3 function, and then add some "publications" which configure under what conditions an event should be sent and what the topic should be.

It can be quite frustrating when setting up pub_sub when everything appears to be set up properly, but you aren't receiving events. This usually means some kind of mismatch between the event names produced by the resource/config of your publications, and you can use the following flag to display debug information about all pub sub events.

Often you want to include some piece of data in the thing being changed, like the :id attribute. This is done by providing a list as the topic, and using atoms which will be replaced by their corresponding values. They will ultimately be joined with :.

This might publish a message to "user:created:1" for example.

For updates, if the field in the template is being changed, a message is sent to both values. So if you change user 1 to user 2, the same message would be published to user:updated:1 and user:updated:2. If there are multiple attributes in the template, and they are all being changed, a message is sent for every combination of substitutions.

If the previous value was nil or the field was not selected on the data passed into the action, then a notification is not sent for the previous value.

If the new value is nil then a notification is not sent for the new value.

Templates may contain lists, in which case all combinations of values in the list will be used. Add nil to the list if you want to produce a pattern where that entry is omitted.

The atom :_tenant may be used. If the changeset has a tenant set on it, that value will be used, otherwise that combination of values is ignored.

The atom :_pkey may be used. It will be a stringified, concatenation of the primary key fields, or just the primary key if there is only one primary key field.

The atom nil may be used. It only makes sense to use it in the context of a list of alternatives, and adds a pattern where that part is skipped.

Would produce the following messages, given a team_id of 1, a tenant of org_1, and an id of 50:

It's possible to change the default delimiter used when generating topics. This is useful when working with message brokers like RabbitMQ, which rely on a different set of delimiters fo

*[Content truncated]*

**Examples:**

Example 1 (unknown):
```unknown
defmodule MyApp.User do
  use Ash.Resource,
    # ...
    notifiers: [Ash.Notifier.PubSub]

  # ...

  pub_sub do
    module MyAppWeb.Endpoint

    prefix "user"
    publish :update, ["updated", :_pkey]
  end
end
```

Example 2 (unknown):
```unknown
config :ash, :pub_sub, debug?: true
```

Example 3 (unknown):
```unknown
prefix "user"

publish :create, ["created", :user_id]
```

Example 4 (unknown):
```unknown
publish :updated, [[:team_id, :_tenant], "updated", [:id, nil]]
```

---

## Ash.Policy.FieldPolicy (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Ash.Policy.FieldPolicy.html

**Contents:**
- Ash.Policy.FieldPolicy (ash v3.7.6)
- Summary
- Types
- Types
- t()

Represents a field policy in an Ash.Resource

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## Ash.Policy.PolicyGroup (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Ash.Policy.PolicyGroup.html

**Contents:**
- Ash.Policy.PolicyGroup (ash v3.7.6)

Represents a policy group on an Ash.Resource

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

---
