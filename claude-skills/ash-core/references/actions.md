# Ash-Core - Actions

**Pages:** 38

---

## Create Actions

**URL:** https://hexdocs.pm/ash/create-actions.html

**Contents:**
- Create Actions
- Bulk creates
  - Check the docs!
- Performance
- Returning a Stream
  - Be careful with streams
- Upserts
  - Upserts do not use an update action
    - Targeting Upserts
  - What is ^actor(:id) ?

Create actions are used to create new records in the data layer. For example:

Here we have a create action called :open that allows setting the title, and sets the status to :open. It could be called like so:

For a full list of all of the available options for configuring create actions, see the Ash.Resource.Dsl documentation.

See the Code Interface guide for creating an interface to call the action more elegantly, like so:

Bulk creates take a list or stream of inputs for a given action, and batches calls to the underlying data layer.

Given our example above, you could call Ash.bulk_create like so:

Make sure to thoroughly read and understand the documentation in Ash.bulk_create/4 before using. Read each option and note the default values. By default, bulk creates don't return records or errors, and don't emit notifications.

Generally speaking, all regular Ash create actions are compatible (or can be made to be compatible) with bulk create actions. However, there are some important considerations.

Ash.Resource.Change modules can be optimized for bulk actions by implementing batch_change/3, before_batch/3 and after_batch/3. If you implement batch_change/3, the change function will no longer be called, and you should swap any behavior implemented with before_action and after_action hooks to logic in the before_batch and after_batch callbacks.

Actions that reference arguments in changes, i.e change set_attribute(:attr, ^arg(:arg)) will prevent us from using the batch_change/3 behavior. This is usually not a problem, for instance that change is lightweight and would not benefit from being optimized with batch_change/3

If your action uses after_action hooks, or has after_batch/3 logic defined for any of its changes, then we must ask the data layer to return the records it inserted. Again, this is not generally a problem because we throw away the results of each batch by default. If you are using return_records?: true then you are already requesting all of the results anyway.

Returning a stream allows you to work with a bulk action as an Elixir Stream. For example:

Because streams are lazily evaluated, if you were to do something like this:

What would happen is that we would insert 200 records. The stream would end after we process the first two batches of 100. Be sure you aren't using things like Stream.take or Enum.take to limit the amount of things pulled from the stream, unless you actually want to limit the number of records created.

Upserting 

*[Content truncated]*

**Examples:**

Example 1 (unknown):
```unknown
# on a ticket resource
create :open do
  accept [:title]
  change set_attribute(:status, :open)
end
```

Example 2 (unknown):
```unknown
Ticket
|> Ash.Changeset.for_create(:open, %{title: "Need help!"})
|> Ash.create!()
```

Example 3 (unknown):
```unknown
Support.open_ticket!("Need help!")
```

Example 4 (unknown):
```unknown
Ash.bulk_create([%{title: "Foo"}, %{title: "Bar"}], Ticket, :open)
```

---

## Ash.Expr (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Ash.Expr.html

**Contents:**
- Ash.Expr (ash v3.7.6)
- Summary
- Types
- Functions
- Types
- t()
- Functions
- actor(value)
- arg(name)
- atomic_ref(expr)

Tools to build Ash expressions

A template helper for using actor values in filter templates

A template helper for using action arguments in filter templates

A template helper for referring to the most recent atomic expression applied to an update field

Creates an expression calculation for use in sort and distinct statements.

A template helper for creating a reference

A template helper for using query context in filter templates

Evaluate an expression. This function only works if you have no references, or if you provide the record option.

Evaluate an expression. See eval/2 for more.

Creates an expression. See the Expressions guide for more.

Returns true if the value is or contains an expression

A template helper for creating a parent reference

A template helper for creating a reference

A template helper for creating a reference to a related path

Whether or not a given template contains an actor reference

A template helper for using the tenant in filter templates

Prepares a filter for comparison

A template helper for using actor values in filter templates

A template helper for using action arguments in filter templates

A template helper for referring to the most recent atomic expression applied to an update field

Creates an expression calculation for use in sort and distinct statements.

A template helper for creating a reference

A template helper for using query context in filter templates

An atom will get the value for a key, and a list will be accessed via get_in.

Evaluate an expression. This function only works if you have no references, or if you provide the record option.

Evaluate an expression. See eval/2 for more.

Creates an expression. See the Expressions guide for more.

Returns true if the value is or contains an expression

A template helper for creating a parent reference

A template helper for creating a reference

A template helper for creating a reference to a related path

Whether or not a given template contains an actor reference

A template helper for using the tenant in filter templates

Prepares a filter for comparison

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
Ash.Query.sort(query, [
  {calc(string_upcase(name), :asc},
  {calc(count_nils([field1, field2]), type: :integer), :desc})
])
```

---

## Pagination

**URL:** https://hexdocs.pm/ash/pagination.html

**Contents:**
- Pagination
- Pagination in Ash
  - Default Pagination Type
  - Check the updated query return type!
- Offset Pagination
  - Pros of offset pagination
  - Cons of offset pagination
- Keyset Pagination
  - Keysets are directly tied to the sorting applied to the query
  - Pros of keyset pagination

Ash has built-in support for two kinds of pagination: offset and keyset. You can perform pagination by passing the :page option to read actions, or using Ash.Query.page/2 on the query. The page options vary depending on which kind of pagination you want to perform.

Pagination support is configured on a per-action basis. A single action can support both kinds of pagination if desired, but typically you would use one or the other. Read actions generated with defaults [:read] support both offset and keyset pagination, for other read actions you have to configure the pagination section.

When an action supports both pagination types, the behavior depends on your application configuration. See the "Default Pagination Behavior" section below for details on how Ash determines which type to use.

Pagination will modify the return type of calling the query action.

Without pagination, Ash will return a list of records.

But with pagination, Ash will return an Ash.Page.Offset struct (for offset pagination) or Ash.Page.Keyset struct (for keyset pagination). Both structs contain the list of records in the results key of the struct.

Offset pagination is done via providing a limit and an offset when making queries.

Keyset pagination, also known as cursor pagination, is done via providing an after or before option, as well as a limit.

You can't change the sort applied to a request being paginated, and use the same keyset. If you want to change the sort, but keep the record who's keyset you are using in the before or after option, you must first request the individual record, with the new sort applied. Then, you can use the new keyset.

When calling an action that uses pagination, the full count of records can be requested by adding the option count: true to the page options. Note that this will perform a second query to fetch the count, which can be expensive on large data sets.

In addition to paginating root data, Ash is also capable of paginating relationships when you load them. To do this, pass a custom query in the load and call Ash.Query.page/2 on it.

This can be leveraged by extensions to provide arbitrarily nested pagination, or it can be used directly in code to split data processing when dealing with relationship with a high cardinality.

When you define a custom read action (instead of using the default generated by defaults [:read]), pagination is not enabled by default. This means features like streaming, offset, or keyset pagination will not work unle

*[Content truncated]*

**Examples:**

Example 1 (unknown):
```unknown
Mix.install([{:ash, "~> 3.0"}], consolidate_protocols: false)
Logger.configure(level: :warning)
```

Example 2 (unknown):
```unknown
read :read do
  primary? true
  pagination required? false, offset? true, keyset? true
end
```

Example 3 (unknown):
```unknown
Invalid Error
* ...read had no matching bulk strategy that could be used.
Requested strategies: [:stream]
...
Action ... does not support streaming with one of [:keyset].
```

Example 4 (unknown):
```unknown
Logger.configure(level: :debug)
```

---

## Ash.Reactor.Dsl.Action (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Ash.Reactor.Dsl.Action.html

**Contents:**
- Ash.Reactor.Dsl.Action (ash v3.7.6)
- Summary
- Types
- Types
- t()

The action entity for the Ash.Reactor reactor extension.

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## Ash.Generator (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Ash.Generator.html

**Contents:**
- Ash.Generator (ash v3.7.6)
- Using Ash.Generator
- About Generators
- Summary
- Types
- Functions
- Types
- overrides()
- stream_data()
- Functions

Tools for generating input to Ash resource actions and for generating seed data.

To define generators for your tests, use Ash.Generator, and define functions that use changeset_generator/3 and/or seed_generator/2.

Then, in your tests, you can import YourApp.Generator, and use generate/1 and generate_many/1 to generate data. For example:

These generators are backed by StreamData, and are ready for use with property testing via ExUnitProperties

Many functions in this module support "overrides", which allow passing down either constant values or your own StreamData generators.

A map or keyword of data generators or constant values to use in place of defaults.

An instance of StreamData, gotten from one of the functions in that module.

Generate input meant to be passed into a resource action.

Creates the input for the provided action with action_input/3, and creates a changeset for that action with that input.

A generator of changesets which call their specific actions when passed to generate/1 or generate_many/2.

Takes one value from a changeset or seed generator and calls Ash.create! or Ash.update! on it.

Takes count values from a changeset or seed generator and passes their inputs into Ash.bulk_create! or Ash.Seed.seed! respectively.

Starts and links an agent for a once/2, or returns the existing agent pid if it already exists.

Starts and links an agent for a sequence, or returns the existing agent pid if it already exists.

Generate count changesets and return them as a list.

Generate count queries and return them as a list.

Creates a generator of maps where all keys are required except the list provided

Gets the next value for a given sequence identifier.

Run the provided function or enumerable (i.e generator) only once.

Creates the input for the provided action with action_input/3, and returns a query for that action with that input.

Gets input using seed_input/2 and passes it to Ash.Seed.seed!/2, returning the result

A generator of seedable records, to be passed to generate/1 or generate_many/1

Generate input meant to be passed into Ash.Seed.seed!/2.

Generates an input n times, and passes them all to seed, returning the list of seeded items.

Generate globally unique values.

Stops the agent for a once/2.

Stops the agent for a sequence.

A map or keyword of data generators or constant values to use in place of defaults.

Many functions in Ash.Generator support overrides, allowing to customize the default generated values.

An insta

*[Content truncated]*

**Examples:**

Example 1 (python):
```python
defmodule YourApp.Generator do
  use Ash.Generator

  # using `seed_generator`, bypasses the action and saves directly to the data layer
  def blog_post(opts \\ []) do
    seed_generator(
      %MyApp.Blog.Post{
        name: sequence(:title, &"My Blog Post #{&1}")
        text: StreamData.repeatedly(fn -> Faker.Lorem.paragraph() end)
      },
      overrides: opts
    )
  end

  # using `changeset_generator`, calls the action when passed to `generate`
  def blog_post_comment(opts \\ []) do
    blog_post_id = opts[:blog_post_id] || once(:default_blog_post_id, fn -> generate(blog_post()).id end
...
```

Example 2 (unknown):
```unknown
import YourApp.Generator

test "`comment_count` on blog_post shows the count of comments" do
  blog_post = generate(blog_post())
  assert Ash.load!(blog_post, :comment_count).comment_count == 0

  generate_many(blog_post_comment(blog_post_id: blog_post.id), 10)

  assert Ash.load!(blog_post, :comment_count).comment_count == 10
end
```

Example 3 (unknown):
```unknown
# All generated posts will have text as `"text"`. Equivalent to providing `StreamData.constant("text")`.
Ash.Generator.seed_input(Post, %{text: "text"})
```

Example 4 (unknown):
```unknown
iex> changeset_generator(MyApp.Blog.Post, :create, defaults: [title: sequence(:blog_post_title, &"My Blog Post #{&1}")]) |> generate()
%Ash.Changeset{...}
```

---

## Validations

**URL:** https://hexdocs.pm/ash/validations.html

**Contents:**
- Validations
- Builtin Validations
  - Query Support
- Custom Validations
  - Supporting Queries in Custom Validations
- Anonymous Function Validations
- Where
  - Examples
- Action vs Global Validations
  - Running on destroy actions

Validations are similar to changes, except they cannot modify the changeset. They can only continue, or add an error.

Validations work on all action types. When used on queries and generic actions, they validate the arguments to ensure they meet your requirements before processing.

There are a number of builtin validations that can be used, and are automatically imported into your resources. See Ash.Resource.Validation.Builtins for more.

The following builtin validations support both changesets and queries:

Some examples of usage of builtin validations

To make a custom validation work on both changesets and queries, implement the supports/1 callback:

This could then be used in a resource via:

You can also use anonymous functions for validations. Keep in mind, these cannot be made atomic. This is great for prototyping, but we generally recommend using a module, both for organizational purposes, and to allow adding atomic behavior.

The where can be used to perform validations conditionally.

The value of the where option can either be a validation or a list of validations. All of the where-validations must first pass for the main validation to be applied. For expressing complex conditionals, passing a list of built-in validations to where can serve as an alternative to writing a custom validation module.

You can place a validation in any create, update, or destroy action. For example:

Or you can use the global validations block to validate on all actions of a given type. Where statements can be used in either. Note the warning about running on destroy actions below.

The validations section allows you to add validations across multiple actions of a changeset

By default, validations in the global validations block will run on create and update only. Many validations don't make sense in the context of destroys. To make them run on destroy, use on: [:create, :update, :destroy]

Use the only_when_valid? option to skip validations when the changeset or query is already invalid. This is useful for expensive validations that should only run if other validations have passed.

To make a validation atomic, you have to implement the Ash.Resource.Validation.atomic/3 callback. This callback returns an atomic instruction, or a list of atomic instructions, or an error/indication that the validation cannot be done atomically. For our IsPrime example above, this would look something like:

In some cases, validations operate on arguments only and therefore have no 

*[Content truncated]*

**Examples:**

Example 1 (unknown):
```unknown
# Works on both changesets and queries
validate match(:email, "@")

validate compare(:age, greater_than_or_equal_to: 18) do
  message "must be over 18 to sign up"
end

validate present(:last_name) do
  where [present(:first_name), present(:middle_name)]
  message "must also be supplied if setting first name and middle_name"
end

# Example for read actions
actions do
  read :search do
    argument :email, :string
    argument :role, :string
    
    validate match(:email, ~r/^[^\s]+@[^\s]+\.[^\s]+$/)
    validate one_of(:role, ["admin", "user", "moderator"])
  end
  
  # Example for generic act
...
```

Example 2 (python):
```python
defmodule MyApp.Validations.IsPrime do
  # transform and validate opts

  use Ash.Resource.Validation

  @impl true
  def init(opts) do
    if opts[:field] != nil && is_atom(opts[:field]) do
      {:ok, opts}
    else
      {:error, "field must be an atom!"}
    end
  end

  @impl true
  def supports(_opts), do: [Ash.Changeset]

  @impl true
  def validate(changeset, opts, _context) do
    value = Ash.Changeset.get_attribute(changeset, opts[:field])
    # this is a function I made up for example
    if is_nil(value) || Math.is_prime?(value) do
      :ok
    else
      # The returned error will
...
```

Example 3 (python):
```python
defmodule MyApp.Validations.ValidEmail do
  use Ash.Resource.Validation

  @impl true
  def init(opts) do
    {:ok, opts}
  end

  @impl true
  def supports(_opts), do: [Ash.Changeset, Ash.Query]

  @impl true
  def validate(subject, opts, _context) do
    value = get_value(subject, opts[:field])
    
    if is_nil(value) || valid_email?(value) do
      :ok
    else
      {:error, field: opts[:field], message: "must be a valid email"}
    end
  end

  defp get_value(%Ash.Changeset{} = changeset, attribute) do
    Ash.Changeset.get_argument_or_attribute(changeset, attribute)
  end

  defp get_v
...
```

Example 4 (unknown):
```unknown
validate {MyApp.Validations.IsPrime, attribute: :foo}
```

---

## Generic Actions

**URL:** https://hexdocs.pm/ash/generic-actions.html

**Contents:**
- Generic Actions
  - No return? No problem!
- Calling Generic Actions
- Why use generic actions?
- Return types and constraints
    - Returning resource instances
- Calling Generic Actions
  - Example Usage
  - Using Code Interface
- Validations and Preparations

Generic actions are so named because there are no special rules about how they work. A generic action takes arguments and returns a value. The struct used for building input for a generic action is Ash.ActionInput.

A generic action declares its arguments, return type, and implementation, as illustrated above.

Generic actions can omit a return type, in which case running them returns :ok if successful.

For a full list of all of the available options for configuring generic actions, see the Ash.Resource.Dsl documentation.

The basic formula for calling a generic action looks like this:

See the code interface guide guide for how to define idiomatic and convenient functions that call your actions.

The example above could be written as a normal function in elixir, i.e

The benefit of using generic actions instead of defining normal functions:

If you don't need any of the above, then there is no problem with writing regular Elixir functions!

Generic actions do not cast their return types. It is expected that the action return a valid value for the type that they declare. However, declaring additional constraints can inform API usage, and make the action more clear. For example:

It sometimes happens that you want to make a generic action which returns an instance or instances of the resource. It's natural to assume that you can set your action's return type to the name of your resource. This won't work as resources do not define a type, unless they are embedded. In embedded resources, this won't work because the module is still being compiled, so referencing yourself as a type causes a compile error. Instead, use the :struct type and the instance_of constraint, like so:

For returning many instances of the resource, you can set your action's return type to {:array, :struct} and set the items constraint to the name of your resource.

To execute a generic action in Ash, follow these steps:

Consider an Ash.Resource with the action :say_hello:

You can also use Code Interfaces to call actions:

Given a definition like:

Generic actions support validations and preparations, allowing you to add business logic and input validation to your actions.

Validations in generic actions work similarly to those in other action types. They validate the action input before the action logic runs.

You can also use custom validation modules:

Preparations allow you to modify the action input before the action runs. This is useful for setting computed values or applying busi

*[Content truncated]*

**Examples:**

Example 1 (unknown):
```unknown
action :say_hello, :string do
  argument :name, :string, allow_nil?: false

  run fn input, _ ->
    {:ok, "Hello: #{input.arguments.name}"}
  end
end
```

Example 2 (unknown):
```unknown
action :schedule_job do
  argument :job_name, :string, allow_nil?: false
  run fn input, _ ->
    # Schedule the job
    :ok
  end
end
```

Example 3 (unknown):
```unknown
Resource
|> Ash.ActionInput.for_action(:action_name, %{argument: :value}, ...opts)
|> Ash.run_action!()
```

Example 4 (python):
```python
def say_hello(name), do: "Hello: #{name}"
```

---

## Ash.Error.Forbidden exception (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Ash.Error.Forbidden.html

**Contents:**
- Ash.Error.Forbidden exception (ash v3.7.6)
- Summary
- Types
- Functions
- Types
- t()
- Functions
- exception(args)
- Keys
- message(map)

Used when authorization for an action fails

Create an Elixir.Ash.Error.Forbidden without raising it.

Callback implementation for Exception.message/1.

Create an Elixir.Ash.Error.Forbidden without raising it.

Callback implementation for Exception.message/1.

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## Ash.Reactor.Dsl.BulkCreate (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Ash.Reactor.Dsl.BulkCreate.html

**Contents:**
- Ash.Reactor.Dsl.BulkCreate (ash v3.7.6)
- Summary
- Types
- Types
- t()

The bulk_create entity for the Ash.Reactor reactor extension.

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## Manual Actions

**URL:** https://hexdocs.pm/ash/manual-actions.html

**Contents:**
- Manual Actions
- Manual Creates/Updates/Destroy
- Manual Read Actions
  - Modifying the query

Manual actions allow you to control how an action is performed instead of dispatching to a data layer. To do this, specify the manual option with a module that adopts the appropriate behavior.

Manual actions are a way to implement an action in a fully custom way. This can be a very useful escape hatch when you have something that you are finding difficult to model with Ash's builtin tools.

For manual create, update and destroy actions, a module is passed that uses one of the following (Ash.Resource.ManualCreate, Ash.Resource.ManualUpdate and Ash.Resource.ManualDestroy).

The underlying record can be retrieved from changeset.data for update and destroy manual actions. The changeset given to the manual action will be after any before_action hooks, and before any after_action hooks.

Manual read actions work the same, except the will also get the "data layer query". For AshPostgres, this means you get the ecto query that would have been run. You can use Ash.Query.apply_to/3 to apply a query to records in memory. This allows you to fetch the data in a way that is not possible with the data layer, but still honor the query that was provided to.

In addition to returning query results, you can return a t:Ash.Resource.ManualRead.extra_info(). This contains a full_count key, which can be used when paginating to set the total count of records.

As an alternative to manual read actions, you can also provide the modify_query option, which takes an MFA and allows low level manipulation of the query just before it is dispatched to the data layer.

This can be used as a last-resort escape hatch when you want to still use resource actions but need to do something that you can't do easily with Ash tools. As with any low level escape hatch, here be dragons.

Hex Package Hex Preview (current file) Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

**Examples:**

Example 1 (python):
```python
create :special_create do
  manual MyApp.DoCreate
end

# The implementation
defmodule MyApp.DoCreate do
  use Ash.Resource.ManualCreate

  def create(changeset, _, _) do
    record = create_the_record(changeset)
    {:ok, record}

    # An `{:error, error}` tuple should be returned if something failed
  end
end
```

Example 2 (python):
```python
# in the resource
actions do
  read :action_name do
    manual MyApp.ManualRead
    # or `{MyApp.ManualRead, ...opts}`
  end
end

# the implementation
defmodule MyApp.ManualRead do
  use Ash.Resource.ManualRead

  def read(ash_query, ecto_query, _opts, _context) do
    ...
    {:ok, query_results} | {:error, error}
  end
end
```

Example 3 (javascript):
```javascript
defmodule MyApp.ManualRead do
  use Ash.Resource.ManualRead

  def read(ash_query, ecto_query, _opts, _context) do
    %{"data" => data, "count" => count} = make_some_api_request(...)
    if ash_query.page[:count] do
      {:ok, query_results}
    else
      {:ok, query_results, %{full_count: count}} 
    end
  end
end
```

Example 4 (python):
```python
read :read do
  modify_query {MyApp.ModifyQuery, :modify, []}
end

defmodule MyApp.ModifyQuery do
  def modify(ash_query, data_layer_query) do
    {:ok, modify_data_layer_query(data_layer_query)}
  end
end
```

---

## Actors & Authorization

**URL:** https://hexdocs.pm/ash/actors-and-authorization.html

**Contents:**
- Actors & Authorization
- Setting actor and authorize?
  - Set the actor on the query/changeset/input
- Default value of authorize?
- Authorizers
- Domain Authorization Configuration
  - Ash.Domain.Dsl.authorization.require_actor?
  - Ash.Domain.Dsl.authorization.authorize

Authorization in Ash involves three things:

All functions in Ash that may perform authorization and/or wish to use the actor accept an actor and an authorize? option. For example:

Building a changeset/query/input is the best time to provide the actor option

If calling a function without changeset/query/input, you can provide the actor option at that point.

Functions created with the code interface also accept an actor option.

The hooks on a query/changeset/input to an action may need to know the actor, so you need to set the actor when building them, not when calling the action.

The default value of authorize? is determined by the authorization configuration of the relevant domain. By default, authorize? is set to true (and so can be omitted in all of the examples above). If a resource has no authorizers, then all requests will be allowed.

Authorizers are in control of what happens during authorization. Generally, you won't need to create your own authorizer, as the builtin policy authorizer Ash.Policy.Authorizer works well for any use case. See the Policies guide for more.

Requires that an actor is set for all requests.

Important: nil is still a valid actor, so this won't prevent providing actor: nil. It only requires that the option itself is provided.

When to run authorization for a given request.

Hex Package Hex Preview (current file) Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
Ash.Changeset.for_create(Post, %{title: "Post Title"}, actor: current_user, authorize?: true)
```

Example 2 (unknown):
```unknown
Ash.count!(Post, actor: current_user, authorize?: true)
```

Example 3 (unknown):
```unknown
MyDomain.create_post!(Post, authorize?: true)
```

Example 4 (unknown):
```unknown
# DO THIS

Post
|> Ash.Query.for_read(:read, %{}, actor: current_user)
|> Ash.read!()

# DON'T DO THIS

Post
|> Ash.Query.for_read!(:read)
|> Ash.read!(actor: current_user)
```

---

## Ash.Reactor.Dsl.Destroy (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Ash.Reactor.Dsl.Destroy.html

**Contents:**
- Ash.Reactor.Dsl.Destroy (ash v3.7.6)
- Summary
- Types
- Types
- t()

The destroy entity for the Ash.Reactor reactor extension.

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## Ash.Reactor.Dsl.Read (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Ash.Reactor.Dsl.Read.html

**Contents:**
- Ash.Reactor.Dsl.Read (ash v3.7.6)
- Summary
- Types
- Types
- t()

The read entity for the Ash.Reactor reactor extension.

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## Ash.Error.Framework exception (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Ash.Error.Framework.html

**Contents:**
- Ash.Error.Framework exception (ash v3.7.6)
- Summary
- Types
- Functions
- Types
- t()
- Functions
- exception(args)
- Keys
- message(map)

Used when an unknown/generic framework error occurs

Create an Elixir.Ash.Error.Framework without raising it.

Callback implementation for Exception.message/1.

Create an Elixir.Ash.Error.Framework without raising it.

Callback implementation for Exception.message/1.

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## Ash.Policy.Authorizer (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Ash.Policy.Authorizer.html

**Contents:**
- Ash.Policy.Authorizer (ash v3.7.6)
- Summary
- Types
- Functions
- Types
- t()
- Functions
- alter_sort(sort, authorizer, context)
- expr_check(expr)
- field_policies(body)

An authorization extension for ash resources.

To add this extension to a resource, add it to the list of authorizers like so:

A resource can be given a set of policies, which are enforced on each call to a resource action.

For reads, policies can be configured to filter out data that the actor shouldn't see, as opposed to resulting in a forbidden error.

See the policies guide for practical examples.

Policies are solved/managed via a boolean satisfiability solver. To read more about boolean satisfiability, see this page: https://en.wikipedia.org/wiki/Boolean_satisfiability_problem. At the end of the day, however, it is not necessary to understand exactly how Ash takes your authorization requirements and determines if a request is allowed. The important thing to understand is that Ash may or may not run any/all of your authorization rules as they may be deemed unnecessary. As such, authorization checks should have no side effects. Ideally, the checks built-in to ash should cover the bulk of your needs.

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
use Ash.Resource,
  ...,
  authorizers: [
    Ash.Policy.Authorizer
  ]
```

---

## Ash.Error.Forbidden.CannotFilterCreates exception (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Ash.Error.Forbidden.CannotFilterCreates.html

**Contents:**
- Ash.Error.Forbidden.CannotFilterCreates exception (ash v3.7.6)
- Summary
- Functions
- Functions
- exception(args)
- Keys

Used when a create action would be filtered

Create an Elixir.Ash.Error.Forbidden.CannotFilterCreates without raising it.

Create an Elixir.Ash.Error.Forbidden.CannotFilterCreates without raising it.

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## Ash.Reactor.Dsl.Create (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Ash.Reactor.Dsl.Create.html

**Contents:**
- Ash.Reactor.Dsl.Create (ash v3.7.6)
- Summary
- Types
- Types
- t()

The create entity for the Ash.Reactor reactor extension.

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## Ash.Reactor.Dsl.Update (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Ash.Reactor.Dsl.Update.html

**Contents:**
- Ash.Reactor.Dsl.Update (ash v3.7.6)
- Summary
- Types
- Types
- t()

The update entity for the Ash.Reactor reactor extension.

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## Preparations

**URL:** https://hexdocs.pm/ash/preparations.html

**Contents:**
- Preparations
- Builtin Preparations
- Custom Preparations
- Anonymous Function Queries
- Action vs Global Preparations
- Where Clauses
- only_when_valid? Option

Preparations are the primary way of customizing read action behavior, and are also supported by generic actions. If you are familiar with Plug, you can think of an Ash.Resource.Preparation as the equivalent of a Plug for queries and action inputs. At its most basic, a preparation will take a query or action input and return a new query or action input. Preparations can be simple, like adding a filter or a sort, or more complex, attaching hooks to be executed within the lifecycle of the action.

There are builtin preparations that can be used, and are automatically imported into your resources. See Ash.Resource.Preparation.Builtins for more.

The primary preparation you will use is build/1, which passes the arguments through to Ash.Query.build/2 when the preparation is run. See that function for what options can be provided.

Some examples of usage of builtin preparations

This could then be used in a resource via:

You can also use anonymous functions for preparations. This is great for prototyping, but we generally recommend using a module for organizational purposes.

You can place a preparation on a read action, like so:

Or you can use the global preparations block to apply to all read actions.

The preparations section allows you to add preparations across multiple actions of a resource.

Use where clauses to conditionally apply preparations based on validations:

Use the only_when_valid? option to skip preparations when the query is already invalid. This is useful for expensive preparations that should only run if validations have passed.

Hex Package Hex Preview (current file) Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
# sort by inserted at descending
prepare build(sort: [inserted_at: :desc])

# only show the top 5 results
prepare build(sort: [total_points: :desc], limit: 5)

# conditional preparation with where clause
prepare build(filter: [active: true]) do
  where argument_equals(:include_inactive, false)
end

# skip preparation if query is invalid
prepare expensive_preparation() do
  only_when_valid? true
end
```

Example 2 (python):
```python
defmodule MyApp.Preparations.Top5 do
  use Ash.Resource.Preparation

  # transform and validate opts
  @impl true
  def init(opts) do
    if is_atom(opts[:attribute]) do
      {:ok, opts}
    else
      {:error, "attribute must be an atom!"}
    end
  end

  @impl true
  def prepare(query, opts, _context) do
    attribute = opts[:attribute]

    query
    |> Ash.Query.sort([{attribute, :desc}])
    |> Ash.Query.limit(5)
  end
end
```

Example 3 (unknown):
```unknown
prepare {MyApp.Preparations.Top5, attribute: :foo}
```

Example 4 (unknown):
```unknown
prepare fn query, _context ->
  # put your code here
end
```

---

## Notifiers

**URL:** https://hexdocs.pm/ash/notifiers.html

**Contents:**
- Notifiers
- What are notifiers for?
  - When you really need an event to happen
  - Including a notifier in a resource
- Built-in Notifiers
- Creating your own notifier
  - Notifier performance
  - Example notifier
- Transactions

Notifiers allow you to tap into create, update and destroy actions on a resource. Notifiers are called after the current transaction is committed, which solves a lot of problems that can happen from performing a certain kind of side effect in your action code.

A common example of one such issue is using Phoenix PubSub to notify another part of your app (often a LiveView or phoenix channel) of a change. If you send a message to another process while your transaction is still open, and that process tries to look up a record you just created, it won't find it yet, because your transaction is still open!

Notifiers are a solution for a certain kind of side effect, what we call "at most once" effects. An example is sending an event to an analytics system, or our pubsub example above. It is "okay" if the event is fired and some error in that process prevents it from being sent.

In these cases you are looking for something other than a notifier. For example, you may want to look into integrating https://hexdocs.pm/oban into your application, allowing you to commit a "job" in the same transaction as your changes, to be processed later.

Alternatively, you could look into using Reactor, which is designed for writing "sagas" and has first-class support for Ash via the AshReactor extension.

If the notifier is also an extension, include it in the notifiers key:

Configuring a notifier for a specific action or actions can be a great way to avoid complexity in the implementation of a notifier. It allows you to avoid doing things like pattern matching on the action, and treat it more like a change module, that does its work whenever it is called.

When your notifier is not an extension, and you want it to run on all actions, include it this way to avoid unnecessary compile time dependencies:

Ash comes with a builtin pub_sub notifier: Ash.Notifier.PubSub. See the module documentation for more.

A notifier is a simple extension that must implement a single callback notify/1. Notifiers do not have to implement an Ash DSL extension, but they may in order to configure how that notifier should behave. See Ash.Notifier.Notification for the currently available fields on a notification.

For more information on creating a DSL extension to configure your notifier, see the docs for Spark.Dsl.Extension.

Notifiers should not do intensive synchronous work. If any heavy work needs to be done, they should delegate to something else to handle the notification, like sending it to a G

*[Content truncated]*

**Examples:**

Example 1 (unknown):
```unknown
defmodule MyResource do
  use Ash.Resource,
    notifiers: [ExampleNotifier]
end
```

Example 2 (unknown):
```unknown
create :create do
  notifiers [ExampleNotifier]
end
```

Example 3 (unknown):
```unknown
defmodule MyResource do
  use Ash.Resource,
    simple_notifiers: [ExampleNotifier]
end
```

Example 4 (python):
```python
defmodule ExampleNotifier do
  use Ash.Notifier

  def notify(%Ash.Notifier.Notification{resource: resource, action: %{type: :create}, actor: actor}) do
    if actor do
      Logger.info("#{actor.id} created a #{resource}")
    else
      Logger.info("A non-logged in user created a #{resource}")
    end
  end
end
```

---

## Ash.Error.Changes.StaleRecord exception (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Ash.Error.Changes.StaleRecord.html

**Contents:**
- Ash.Error.Changes.StaleRecord exception (ash v3.7.6)
- Summary
- Functions
- Functions
- exception(args)
- Keys

Used when a stale record is attempted to be updated or deleted

Create an Elixir.Ash.Error.Changes.StaleRecord without raising it.

Create an Elixir.Ash.Error.Changes.StaleRecord without raising it.

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## Ash.Reactor.Dsl.ActionLoad (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Ash.Reactor.Dsl.ActionLoad.html

**Contents:**
- Ash.Reactor.Dsl.ActionLoad (ash v3.7.6)
- Summary
- Types
- Types
- t()

Add a load statement to an action.

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## Ash.Reactor.Dsl.ReadOne (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Ash.Reactor.Dsl.ReadOne.html

**Contents:**
- Ash.Reactor.Dsl.ReadOne (ash v3.7.6)
- Summary
- Types
- Types
- t()

The read_one entity for the Ash.Reactor reactor extension.

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## Code Interface

**URL:** https://hexdocs.pm/ash/code-interfaces.html

**Contents:**
- Code Interface
- Code interfaces on the resource
- Using the code interface
  - get_by functions
- Calculations
- Bulk & atomic actions
  - Bulk Updates & Destroys
  - Valid inputs
  - Bulk Creates
  - Valid inputs

One of the ways that we interact with our resources is via hand-written code. The general pattern for that looks like building a query or a changeset for a given action, and calling it via functions like Ash.read/2 and Ash.create/2. This, however, is just one way to use Ash, and is designed to help you build tools that work with resources, and to power things like AshPhoenix.Form, AshGraphql.Resource and AshJsonApi.Resource. When working with your resources in code, we generally want something more idiomatic and simple. For example, on a domain called Helpdesk.Support.

This simple setup now allows you to open a ticket with Helpdesk.Support.open_ticket(subject). You can cause it to raise errors instead of return them with Helpdesk.Support.open_ticket!(subject). For information on the options and additional inputs these defined functions take, look at the generated function documentation, which you can do in iex with h Helpdesk.Support.open_ticket. For more information on the code interface, read the DSL documentation: Ash.Domain.Dsl.resources.resource.define.

You can define a code interface on individual resources as well, using the code_interface block. The DSL is the same as the DSL for defining it in the domain. For example:

These will then be called on the resource itself, i.e Helpdesk.Support.Ticket.open(subject).

If the action is an update or destroy, it will take a record or a changeset as its first argument. If the action is a read action, it will take a starting query as an opt in the last argument.

All functions will have an optional last argument that accepts options. See Ash.Resource.Interface for valid options.

They will also have an optional second to last argument that is a freeform map to provide action input. It must be a map. If it is a keyword list, it will be assumed that it is actually options (for convenience). This allows for the following behaviour:

For a full list of options, see the functions in Ash.Resource.Interface, or use iex help on your generated functions, i.e

A common pattern in Ash applications is the "get by" function for retrieving individual records. This pattern provides a clean alternative to using Ash.get!/2 directly in your web modules.

This is similar to using Repo.get/2 and Repo.preload/2 directly outside of context modules, which is generally considered a bad practice.

Use this pattern instead:

The get_by option automatically creates a function that:

Dynamic loading and filtering:

Code interfaces aut

*[Content truncated]*

**Examples:**

Example 1 (unknown):
```unknown
resources do
  resource Ticket do
    define :open_ticket, args: [:subject], action: :open
  end
end
```

Example 2 (unknown):
```unknown
code_interface do
  # the action open can be omitted because it matches the function name
  define :open, args: [:subject]
end
```

Example 3 (unknown):
```unknown
# Because the 3rd argument is a keyword list, we use it as options
Accounts.register_user(username, password, [tenant: "organization_22"])
# Because the 3rd argument is a map, we use it as action input
Accounts.register_user(username, password, %{key: "val"})
# When all arguments are provided it is unambiguous
Accounts.register_user(username, password, %{key: "val"}, [tenant: "organization_22"])
```

Example 4 (unknown):
```unknown
iex> h Accounts.register_user/3
```

---

## Actions

**URL:** https://hexdocs.pm/ash/actions.html

**Contents:**
- Actions
- Primary Actions
- Accepting Inputs
  - Using accept in specific actions
  - Using default_accept for all actions
    - Using module attributes for action specific accept lists
- Context
  - :private
  - :shared
  - Careful with shared

In Ash, actions are the primary way to interact with your resources. There are five types of actions:

All actions can be run in a transaction. Create, update and destroy actions are run in a transaction by default, whereas read and generic actions require opting in with transaction? true in the action definition. Each action has its own set of options, ways of calling it, and ways of customizing it. See the relevant guide for specifics on each action type. This topic focuses on idiomatic ways to use actions, and concepts that cross all action types.

Primary actions are a way to inform the framework which actions should be used in certain "automated" circumstances, or in cases where an action has not been specified. If a primary action is attempted to be used but does not exist, you will get an error about it at runtime.

The place you typically need primary actions is when Managing Relationships. When using the defaults option to add default actions, they are marked as primary.

A simple example where a primary action would be used:

To mark an action as primary, add the option, i.e

Create and Update actions can accept attributes as input. There are two primary ways that you annotate this.

Each action can define what it accepts, for example:

You could then pass in %{name: "a name", description: "a description"} to this action.

The resource can have a default_accept, declared in its actions block, which will be used as the accept list for create and update actions, if they don't define one.

In the example above, you can provide %{name: "a name", description: "a description"} to both the :create and :update actions, but only %{something_else: "some_value"} to :special_update.

You can also use module attributes to define the accept list. This is useful if you have a lot of attributes and different variations for different actions.

This is extremely simple example

There are two kinds of contexts in Ash:

Actions accept a free-form map of context, which can be used for whatever you like. Whenever context is set, it is deep merged. I.e if you do changeset |> Ash.Changeset.set_context(%{a: %{b: 1}}) |> Ash.Changeset.set_context(%{a: %{c: 2}}), the resulting context will be %{a: %{b: 1, c: 2}}. Structs are not merged.

There are some special keys in context to note:

The :private key is reserved for use by Ash itself. You shouldn't read from or write to it.

The :shared key will be passed to all nested actions built by Ash, and should be passed by you to

*[Content truncated]*

**Examples:**

Example 1 (unknown):
```unknown
# No action is specified, so we look for a primary read.
Ash.get!(Resource, "8ba0ab56-c6e3-4ab0-9c9c-df70e9945281")
```

Example 2 (unknown):
```unknown
read :action_name do
  primary? true
end
```

Example 3 (unknown):
```unknown
create :create do
  accept [:name, :description]
end
```

Example 4 (unknown):
```unknown
actions do
  default_accept [:name, :description]

  create :create
  update :update

  update :special_update do
    accept [:something_else]
  end
end
```

---

## Ash.Reactor.Dsl.BulkUpdate (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Ash.Reactor.Dsl.BulkUpdate.html

**Contents:**
- Ash.Reactor.Dsl.BulkUpdate (ash v3.7.6)
- Summary
- Types
- Types
- t()

The bulk_update entity for the Ash.Reactor reactor extension.

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## Prevent concurrent writes

**URL:** https://hexdocs.pm/ash/prevent-concurrent-writes.html

**Contents:**
- Prevent concurrent writes
- Introduction
- Add Optimistic Locking
- Examples
- Triggering a StaleRecord error
- Refetching a record to get the latest version

Often, when working with resources, we want to ensure that a record has not been edited since we last read it. We may want this for UX reasons, or for ensuring data consistency, etc.

To ensure that a record hasn't been updated since the last time we read it, we use Optimistic Locking.

For more information, see the documentation for Ash.Resource.Change.OptimisticLock.

Hex Package Hex Preview (current file) Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
Mix.install([{:ash, "~> 3.0"}], consolidate_protocols: false)
# Set to `:debug` if you want to see ETS logs
Logger.configure(level: :warning)
```

Example 2 (unknown):
```unknown
defmodule Address do
  use Ash.Resource,
    domain: Domain,
    data_layer: Ash.DataLayer.Ets

  attributes do
    uuid_primary_key :id
    attribute :version, :integer, allow_nil?: false, default: 1
    attribute :state, :string, allow_nil?: false
    attribute :county, :string, allow_nil?: false
  end

  actions do
    defaults [:read, create: [:state, :county]]

    update :update do
      accept [:state, :county]
      change optimistic_lock(:version)
    end
  end

  # apply to all actions
  # changes do
  #   change optimistic_lock(:version), on: [:create, :update, :destroy]
  # end

  
...
```

Example 3 (unknown):
```unknown
{:module, Domain, <<70, 79, 82, 49, 0, 2, 1, ...>>,
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

Example 4 (unknown):
```unknown
address = Domain.create_address!("FL", "Pinellas")
Domain.update_address!(address, %{state: "NC", county: "Guilford"})

# `address` still has a version of `1`, so our optimistic lock should catch it!
Domain.update_address(address, %{county: "Miami-Dade"})
```

---

## Read Actions

**URL:** https://hexdocs.pm/ash/read-actions.html

**Contents:**
- Read Actions
- Calling Read Actions
- Ash.get!
- Ash.read_one!
- Pagination
  - Pagination configuration on default vs custom read actions
- What happens when you call Ash.Query.for_read/4
- What happens when you run the action
- Customizing Queries When Calling Actions
    - User Input Safety

Read actions operate on an Ash.Query. Read actions always return lists of data. The act of pagination, or returning a single result, is handled as part of the interface, and is not a concern of the action itself. Here is an example of a read action:

For a full list of all of the available options for configuring read actions, see the Ash.Resource.Dsl documentation.

The basic formula for calling a read action looks like this:

See below for variations on action calling, and see the code interface guide guide for how to define idiomatic and convenient functions that call your actions.

The Ash.get! function is a convenience function for running a read action, filtering by a unique identifier, and expecting only a single result. It is equivalent to the following code:

The Ash.read_one! function is a similar convenience function to Ash.get!, but it does not take a unique identifier. It is useful when you expect an action to return only a single result, and want to enforce that and return a single result.

Ash provides built-in support for pagination when reading resources and their relationships. You can find more information about this in the pagination guide.

The default read action supports keyset pagination automatically. You need to explicitly enable pagination strategies you want to support when defining your own read actions.

The following steps are performed when you call Ash.Query.for_read/4.

Add errors for missing required arguments | Ash.Resource.Dsl.actions.read.argument.allow_nil?

Run query preparations and validations (in definition order) | Ash.Resource.Dsl.actions.read.prepare and Ash.Resource.Dsl.actions.read.validate

Add action filter | Ash.Resource.Dsl.actions.read.filter

These steps are trimmed down, and are aimed at helping users understand the general flow. Some steps are omitted.

The following steps happen while(asynchronously) or after the main data layer query has been run

When calling read actions through code interfaces, you can customize the query using the query option. This allows you to filter, sort, limit, and otherwise modify the results without manually building queries.

When accepting query parameters from untrusted sources (like web requests), always use the _input variants (sort_input, filter_input) instead of the regular options. These functions only allow access to public fields and provide safe parsing of user input.

The query option accepts all the options that Ash.Query.build/2 accepts:

When accepting que

*[Content truncated]*

**Examples:**

Example 1 (unknown):
```unknown
# Giving your actions informative names is always a good idea
read :ticket_queue do
  # Use arguments to take in values you need to run your read action.
  argument :priorities, {:array, :atom} do
    constraints items: [one_of: [:low, :medium, :high]]
  end

  # This action may be paginated,
  # and returns a total count of records by default
  pagination offset: true, countable: :by_default

  # Arguments can be used in preparations and filters
  filter expr(status == :open and priority in ^arg(:priorities))
end
```

Example 2 (unknown):
```unknown
Resource
|> Ash.Query.for_read(:action_name, %{argument: :value}, ...opts)
|> Ash.read!()
```

Example 3 (unknown):
```unknown
# action can be omitted to use the primary read action
Ash.get!(Resource, 1, action: :read_action)

# is roughly equivalent to

Resource
|> Ash.Query.filter(id == 1)
|> Ash.Query.limit(2)
|> Ash.Query.for_read(:read_action, %{})
|> Ash.read!()
|> case do
  [] -> # raise not found error
  [result] -> result
  [_, _] -> # raise too many results error
end
```

Example 4 (unknown):
```unknown
Ash.read_one!(query)

# is roughly equivalent to

query
|> Ash.Query.limit(2)
|> Ash.read!()
|> case do
  [] -> nil
  [result] -> result
  [_, _] -> # raise too many results error
end
```

---

## Ash.Error.Invalid.NoSuchInput exception (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Ash.Error.Invalid.NoSuchInput.html

**Contents:**
- Ash.Error.Invalid.NoSuchInput exception (ash v3.7.6)
- Summary
- Functions
- Functions
- exception(args)
- Keys

Used when an input is provided to an action or calculation that is not accepted

Create an Elixir.Ash.Error.Invalid.NoSuchInput without raising it.

Create an Elixir.Ash.Error.Invalid.NoSuchInput without raising it.

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## Destroy Actions

**URL:** https://hexdocs.pm/ash/destroy-actions.html

**Contents:**
- Destroy Actions
- Soft Destroy
- Calling Destroy Actions
- Returning the destroyed record
  - Loading on destroyed records
- Bulk Destroys
- Atomic
  - Example
- Atomic Batches
  - Example

Destroy actions are comparatively simple. They expect to remove a given record, and by default return :ok in the successful case.

Most destroy actions are one-liners, for example:

You can mark a destroy action as soft? true, in which case it is handled by the update action logic.

For a full list of all of the available options for configuring destroy actions, see the Ash.Resource.Dsl documentation.

The basic formula for calling a destroy action looks like this:

See below for variations on action calling, and see the code interface guide guide for how to define idiomatic and convenient functions that call your actions.

You can use the return_destroyed? option to return the destroyed record.

Keep in mind that using Ash.load on destroyed data will produced mixed results. Relationships may appear as empty, or may be loaded as expected (depending on the data layer/relationship implementation) and calculations/aggregates may show as nil if they must be run in the data layer.

There are three strategies for bulk destroying data. They are, in order of preference: :atomic, :atomic_batches, and :stream. When calling Ash.bulk_destroy/4, you can provide a strategy or strategies that can be used, and Ash will choose the best one available. The capabilities of the data layer determine what strategies can be used.

Atomic bulk destroys are used when the subject of the bulk destroy is a query and the data layer supports destroying a query. They map to a single statement to the data layer to destroy all matching records.

If using a SQL data layer, this would produce a query along the lines of

Atomic batches are used when the subject of the bulk destroy is an enumerable (i.e list or stream) of records and the data layer supports destroying a query. The records are pulled out in batches, and then each batch follows the logic described above. The batch size is controllable by the batch_size option.

If using a SQL data layer, this would produce ten queries along the lines of

Stream is used when the data layer does not support destroying a query. If a query is given, it is run and the records are used as an enumerable of inputs. If an enumerable of inputs is given, each one is destroyed individually. There is nothing inherently wrong with doing this kind of destroy, but it will naturally be slower than the other two strategies. The benefit of having a single interface (Ash.bulk_destroy/4) is that the caller doesn't need to change based on the performance implications

*[Content truncated]*

**Examples:**

Example 1 (unknown):
```unknown
destroy :destroy
# Can be added with the defaults
defaults [:read, :destroy]
```

Example 2 (unknown):
```unknown
destroy :archive do
  soft? true
  change set_attribute(:archived_at, &DateTime.utc_now/0)
end
```

Example 3 (unknown):
```unknown
record
|> Ash.Changeset.for_destroy(:action_name, %{argument: :value}, ...opts)
|> Ash.destroy!()
```

Example 4 (javascript):
```javascript
# when a resource is passed, or a query w/ no action, the primary destroy action is used.
ticket = Ash.get!(Ticket, 1)
Ash.destroy!(ticket)
# => :ok
ticket = Ash.get!(Ticket, 2)
Ash.destroy!(ticket, return_destroyed?: true)
# => {:ok, %Ticket{}}
```

---

## Ash.Error.Forbidden.Policy exception (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Ash.Error.Forbidden.Policy.html

**Contents:**
- Ash.Error.Forbidden.Policy exception (ash v3.7.6)
- Summary
- Functions
- Functions
- exception(args)
- Keys
- get_breakdown(facts, filter, policies, opts \\ [])
- report(forbidden)
- report(error, opts \\ [])

Raised when policy authorization for an action fails

Create an Elixir.Ash.Error.Forbidden.Policy without raising it.

Print a report of an authorization failure from authorization information.

Print a report of an authorization failure from a forbidden error

Create an Elixir.Ash.Error.Forbidden.Policy without raising it.

Print a report of an authorization failure from authorization information.

Print a report of an authorization failure from a forbidden error

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## Ash.ActionInput (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Ash.ActionInput.html

**Contents:**
- Ash.ActionInput (ash v3.7.6)
- Summary
- Types
- Functions
- Types
- after_action_fun()
- after_transaction_fun()
- around_transaction_fun()
- before_action_fun()
- before_transaction_fun()

Input for a custom action

Much like an Ash.Query and Ash.Changeset are used to provide inputs into CRUD actions, this struct provides the inputs required to execute a generic action.

Function type for after action hooks.

Function type for after transaction hooks.

Function type for around transaction hooks.

Function type for before action hooks.

Function type for before transaction hooks.

An action input struct for generic (non-CRUD) actions.

Adds an error to the errors list and marks the action input as invalid.

Adds an after_action hook to the action input.

Adds an after transaction hook to the action input.

Adds an around transaction hook to the action input.

Adds a before_action hook to the action input.

Adds a before transaction hook to the action input.

Deletes one or more arguments from the subject.

Fetches the value of an argument provided to the input.

Creates a new input for a generic action.

Gets the value of an argument provided to the input.

Creates a new action input from a resource.

Sets an argument value on the action input.

Deep merges the provided map into the input context.

Sets a private argument value on the action input.

Sets the tenant to use when calling the action.

Function type for after action hooks.

Receives the action input and the result of the action, and can return the result optionally with notifications, or an error.

Function type for after transaction hooks.

Receives the action input and the result of the transaction, and returns the result (potentially modified) or an error.

Function type for around transaction hooks.

Receives an action input and a callback function that executes the transaction, and returns the result of calling the callback or an error.

Function type for before action hooks.

Receives an action input and returns a modified action input, optionally with notifications.

Function type for before transaction hooks.

Receives an action input and returns a modified action input or an error.

An action input struct for generic (non-CRUD) actions.

Contains all the information needed to execute a generic action including arguments, context, tenant information, validation state, and lifecycle hooks. Built using for_action/4 and modified with functions like set_argument/3 and set_context/2.

Adds an error to the errors list and marks the action input as invalid.

This function allows you to add validation errors or other issues to the action input. Once an error is added, the input wi

*[Content truncated]*

**Examples:**

Example 1 (unknown):
```unknown
# Add a simple string error
iex> input = MyApp.Post
...> |> Ash.ActionInput.for_action(:send_notification, %{})
...> |> Ash.ActionInput.add_error("Missing required configuration")
iex> input.valid?
false

# Add an error with a specific path
iex> input = MyApp.Post
...> |> Ash.ActionInput.for_action(:process_data, %{})
...> |> Ash.ActionInput.add_error("Invalid format", [:data, :format])
iex> input.errors |> List.first() |> Map.get(:path)
[:data, :format]

# Add multiple errors
iex> input = MyApp.Post
...> |> Ash.ActionInput.for_action(:complex_action, %{})
...> |> Ash.ActionInput.add_error(["E
...
```

Example 2 (unknown):
```unknown
# Transform the result after action
iex> MyApp.Post
...> |> Ash.ActionInput.for_action(:calculate_stats, %{data: [1, 2, 3]})
...> |> Ash.ActionInput.after_action(fn input, result ->
...>   enhanced_result = Map.put(result, :calculated_at, DateTime.utc_now())
...>   {:ok, enhanced_result}
...> end)

# Log successful actions
iex> MyApp.Post
...> |> Ash.ActionInput.for_action(:important_action, %{})
...> |> Ash.ActionInput.after_action(fn inp, result ->
...>   Logger.info("Action completed successfully")
...>   {:ok, result}
...> end)

# Return notifications
iex> MyApp.Post
...> |> Ash.ActionInpu
...
```

Example 3 (unknown):
```unknown
# Add cleanup after transaction
iex> input
...> |> Ash.ActionInput.after_transaction(fn input, result ->
...>   cleanup_resources()
...>   result
...> end)
```

Example 4 (unknown):
```unknown
# Add retry logic around transaction
iex> input
...> |> Ash.ActionInput.around_transaction(fn input, callback ->
...>   case callback.(input) do
...>     {:ok, result} -> {:ok, result}
...>     {:error, %{retryable?: true}} -> callback.(input) # Retry once
...>     error -> error
...>   end
...> end)
```

---

## Reactor

**URL:** https://hexdocs.pm/ash/reactor.html

**Contents:**
- Reactor
- Usage
- Running Reactors as an action
  - Example
  - Resources can just have generic actions
- Example
- Actions
  - Action inputs
    - Example
- Handling failure

Ash.Reactor is an extension for Reactor which adds explicit support for interacting with resources via their defined actions.

See Getting started with Reactor to understand the core Reactor concepts first. Then return to this guide to see how Ash.Reactor adds conveniences for using Reactor from Ash.

You can either add the Ash.Reactor extension to your existing reactors eg:

or for your convenience you can use use Ash.Reactor which expands to exactly the same as above.

Ash's generic actions support providing a Reactor module directly as their run option. This is the preferred way for you to initiate reactors in your application. These actions could be defined on your existing resources, your you could even have a resource w/ a single action on it that runs a reactor, and no attributes/data layer etc. for example.

Below is a fully valid resource in its entirety. Not all resources need to have state/data layers associated with them

An example is worth 1000 words of prose:

For each action type there is a corresponding step DSL, which needs a name (used to refer to the result of the step by other steps), a resource and optional action name (defaults to the primary action if one is not provided).

Actions have several common options and some specific to their particular type. See the DSL documentation for details.

Ash actions take a map of input parameters which are usually a combination of resource attributes and action arguments. You can provide these values as a single map using the inputs DSL entity with a map or keyword list which refers to Reactor inputs, results and hard-coded values via Reactor's predefined template functions.

For action types that act on a specific resource (ie update and destroy) you can provide the value using the initial DSL option.

Reactor is a saga executor, which means that when failure occurs it tries to clean up any intermediate state left behind. By default the create, update and destroy steps do not specify any behaviour for what to do when there is a failure downstream in the reactor. This can be changed by providing both an undo_action and changing the step's undo option to either :outside_transaction or :always depending on your resource and datalayer semantics.

The behaviour of the undo_action is action specific:

You can use the transaction step type to wrap a group of steps inside a data layer transaction, however the following caveats apply:

Because a reactor has transaction-like semantics notifications are a

*[Content truncated]*

**Examples:**

Example 1 (unknown):
```unknown
defmodule MyExistingReactor do
  use Reactor, extensions: [Ash.Reactor]
end
```

Example 2 (unknown):
```unknown
defmodule MyApp.Blog.Actions do
  use Ash.Resource

  action :create_post, :struct do
    constraints instance_of: MyBlog.Post

    argument :blog_title, :string, allow_nil?: false
    argument :blog_body, :string, allow_nil?: false
    argument :author_email, :ci_string, allow_nil?: false

    run MyApp.Blog.Reactors.CreatePost
  end
end
```

Example 3 (unknown):
```unknown
defmodule ExampleReactor do
  use Ash.Reactor

  ash do
    default_domain ExampleDomain
  end

  input :customer_name
  input :customer_email
  input :plan_name
  input :payment_nonce

  create :create_customer, Customer do
    inputs %{name: input(:customer_name), email: input(:customer_email)}
  end

  read_one :get_plan, Plan, :get_plan_by_name do
    inputs %{name: input(:plan_name)}
    fail_on_not_found? true
  end

  action :take_payment, PaymentProvider do
    inputs %{
      nonce: input(:payment_nonce),
      amount: result(:get_plan, [:price])
    }
  end

  create :subscription, S
...
```

Example 4 (unknown):
```unknown
input :blog_title
input :blog_body
input :author_email

read :get_author, MyBlog.Author, :get_author_by_email do
  inputs %{email: input(:author_email)}
end

create :create_post, MyBlog.Post, :create do
  inputs %{
    title: input(:blog, [:title]),
    body: input(:blog, [:body]),
    author_id: result(:get_author, [:email])
  }
end

update :author_post_count, MyBlog.Author, :update_post_count do
  wait_for :create_post
  initial result(:get_author)
end

return :create_post
```

---

## Ash.Reactor

**URL:** https://hexdocs.pm/ash/dsl-ash-reactor.html

**Contents:**
- Ash.Reactor
- ash
  - Options
  - reactor.action
    - Undo behaviour
  - Nested DSLs
  - Arguments
  - Options
  - reactor.action.actor
  - Arguments

Ash.Reactor is a Reactor extension which provides steps for working with Ash resources and actions.

See the Ash Reactor Guide for more information.

Ash-related configuration for the Ash.Reactor extension

Declares a step that will call a generic action on a resource.

This step has three different modes of undo.

Specifies the action actor

Target: Ash.Reactor.Dsl.Actor

A map to be merged into the action's context

Target: Ash.Reactor.Dsl.Context

Provides a flexible method for conditionally executing a step, or replacing it's result.

Expects a two arity function which takes the step's arguments and context and returns one of the following:

Target: Reactor.Dsl.Guard

Only execute the surrounding step if the predicate function returns true.

This is a simple version of guard which provides more flexibility at the cost of complexity.

Target: Reactor.Dsl.Where

Specify the inputs for an action

Target: Ash.Reactor.Dsl.Inputs

Specifies the action tenant

Target: Ash.Reactor.Dsl.Tenant

Wait for the named step to complete before allowing this one to start.

Desugars to argument :_, result(step_to_wait_for)

Target: Reactor.Dsl.WaitFor

Target: Ash.Reactor.Dsl.Action

Specifies a Ash.Reactor step.

This is basically a wrapper around Reactor.step, in order to handle any returned notifications from the run step/function.

See the Reactor.Step behaviour for more information.

Specifies an argument to a Reactor step.

Each argument is a value which is either the result of another step, or an input value.

Individual arguments can be transformed with an arbitrary function before being passed to any steps.

Target: Reactor.Dsl.Argument

Wait for the named step to complete before allowing this one to start.

Desugars to argument :_, result(step_to_wait_for)

Target: Reactor.Dsl.WaitFor

Provides a flexible method for conditionally executing a step, or replacing it's result.

Expects a two arity function which takes the step's arguments and context and returns one of the following:

Target: Reactor.Dsl.Guard

Only execute the surrounding step if the predicate function returns true.

This is a simple version of guard which provides more flexibility at the cost of complexity.

Target: Reactor.Dsl.Where

Target: Ash.Reactor.Dsl.AshStep

Declares a step which will call a create action on a resource with a collection of inputs.

Make sure to thoroughly read and understand the documentation in Ash.bulk_create/4 before using. Read each option and note the default values

*[Content truncated]*

**Examples:**

Example 1 (unknown):
```unknown
action name, resource, action \\ nil
```

Example 2 (unknown):
```unknown
actor source
```

Example 3 (unknown):
```unknown
context context
```

Example 4 (unknown):
```unknown
step :read_file_via_cache do
  argument :path, input(:path)
  run &File.read(&1.path)
  guard fn %{path: path}, %{cache: cache} ->
    case Cache.get(cache, path) do
      {:ok, content} -> {:halt, {:ok, content}}
      _ -> :cont
    end
  end
end
```

---

## Ash.Policy.Authorizer

**URL:** https://hexdocs.pm/ash/dsl-ash-policy-authorizer.html

**Contents:**
- Ash.Policy.Authorizer
- policies
  - Nested DSLs
  - Examples
  - Options
  - policies.policy
  - Nested DSLs
  - Arguments
  - Options
  - policies.policy.authorize_if

An authorization extension for ash resources.

To add this extension to a resource, add it to the list of authorizers like so:

A resource can be given a set of policies, which are enforced on each call to a resource action.

For reads, policies can be configured to filter out data that the actor shouldn't see, as opposed to resulting in a forbidden error.

See the policies guide for practical examples.

Policies are solved/managed via a boolean satisfiability solver. To read more about boolean satisfiability, see this page: https://en.wikipedia.org/wiki/Boolean_satisfiability_problem. At the end of the day, however, it is not necessary to understand exactly how Ash takes your authorization requirements and determines if a request is allowed. The important thing to understand is that Ash may or may not run any/all of your authorization rules as they may be deemed unnecessary. As such, authorization checks should have no side effects. Ideally, the checks built-in to ash should cover the bulk of your needs.

A section for declaring authorization policies.

Each policy that applies must pass independently in order for the request to be authorized.

See the policies guide for more.

A policy has a name, a condition, and a list of checks.

Checks apply logically in the order they are specified, from top to bottom. If no check explicitly authorizes the request, then the request is forbidden. This means that, if you want to "blacklist" instead of "whitelist", you likely want to add an authorize_if always() at the bottom of your policy, like so:

If the policy should always run, use the always() check, like so:

See the policies guide for more.

If the check is true, the request is authorized, otherwise run remaining checks.

Target: Ash.Policy.Check

If the check is true, the request is forbidden, otherwise run remaining checks.

Target: Ash.Policy.Check

If the check is true, run remaining checks, otherwise the request is authorized.

Target: Ash.Policy.Check

If the check is true, run remaining checks, otherwise the request is forbidden.

Target: Ash.Policy.Check

Target: Ash.Policy.Policy

Groups a set of policies together by some condition.

If the condition on the policy group does not apply, then none of the policies within it apply.

This is primarily syntactic sugar. At compile time, the conditions from the policy group are added to each policy it contains, and the list is flattened out. This exists primarily to make it easier to reason about and write po

*[Content truncated]*

**Examples:**

Example 1 (unknown):
```unknown
use Ash.Resource,
  ...,
  authorizers: [
    Ash.Policy.Authorizer
  ]
```

Example 2 (unknown):
```unknown
policies do
  # Anything you can use in a condition, you can use in a check, and vice-versa
  # This policy applies if the actor is a super_user
  # Additionally, this policy is declared as a `bypass`. That means that this check is allowed to fail without
  # failing the whole request, and that if this check *passes*, the entire request passes.
  bypass actor_attribute_equals(:super_user, true) do
    authorize_if always()
  end

  # This will likely be a common occurrence. Specifically, policies that apply to all read actions
  policy action_type(:read) do
    # unless the actor is an active 
...
```

Example 3 (unknown):
```unknown
policy condition \\ nil
```

Example 4 (unknown):
```unknown
policy action_type(:read) do
forbid_if not_logged_in()
forbid_if user_is_denylisted()
forbid_if user_is_in_denylisted_group()

authorize_if always()
end
```

---

## Ash.Reactor.Dsl.Transaction (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Ash.Reactor.Dsl.Transaction.html

**Contents:**
- Ash.Reactor.Dsl.Transaction (ash v3.7.6)
- Summary
- Types
- Types
- t()

The transaction entity for the Ash.Reactor reactor extension.

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## Glossary

**URL:** https://hexdocs.pm/ash/glossary.html

**Contents:**
- Glossary
- Action
- Actor
- Aggregate
- Attribute
- Authorizer
- Calculation
- Changeset
- Domain
- Extension

An action describes an operation that can be performed for a given resource; it is the verb to a resource's noun. Examples of actions:

Ash supports five different types of actions. create, read, update and destroy (collectively often abbreviated as CRUD), and action, referring to a generic action with a custom return type. A resource can define multiple actions per action type, eg. a publish action would be considered an update because it is updating an existing instance of a resource. Actions are much more flexible than simple CRUD, but these five action types serve as templates for anything you might want to do.

See the Actions guide for more.

The entity that performs an action.

Most actions are run on direct user request, eg. if a user presses a Create button on a page then the actor is the user.

The actor can be anything that you want it to be. It is most typically a map or a struct containing information about the "entity" that is performing the action. In the vast majority of cases, the actor will be something like %MyApp.Accounts.User{}. We recommend that the actor be a struct, but it could also be a map or any other kind of value.

Some example actor types used in practice:

Actors can be used in a number of places, from modifying the behavior of an action to auditing who did what in your system. They are most prominent, however, when writing policies.

See the Actors & Authorization guide for more.

An aggregate is a special type of field for a resource, one that summarizes related information of the record. A more specialized type of a calculation.

If a Project resource has_many Ticket resources, an example of an aggregate on the Project might be to count the tickets associated to each project.

See the Aggregates guide for more.

A piece of data belonging to a resource. The most basic building block; an attribute has a type and a value. For resources backed by a data layer, they typically represent a column in a database table, or a key in an object store, for example.

See the Attributes guide for more.

An authorizer is an extension that can be added to a resource that will be given the opportunity to modify and/or prevent requests to a resource. In practice, you will almost always be using Ash.Policy.Authorizer, but you can still write your own if you need to.

See the Actors & Authorization and Policies guides for more.

A calculation is a special type of field for a resource, one that is not directly stored in the data layer but gener

*[Content truncated]*

---

## Update Actions

**URL:** https://hexdocs.pm/ash/update-actions.html

**Contents:**
- Update Actions
- Atomics
  - Atomics are not stored with other changes
  - atomic_ref/1
- Fully Atomic updates
  - What does atomic mean?
- What makes an action not atomic?
  - Types that can't be atomically casted
  - Changes without an atomic callback
  - Validations without an atomic callback

Update actions are used to update records in the data layer. For example:

Here we have an update action called :close that allows setting the close_reason, and sets the status to :closed. It could be called like so:

For a full list of all of the available options for configuring update actions, see the Ash.Resource.Dsl documentation.

See the Code Interface guide for creating an interface to call the action more elegantly, like so:

Atomic updates can be added to a changeset, which will update the value of an attribute given by an expression. Atomics can be a very powerful way to model updating data in a simple way. An action does not have to be fully atomic in order to leverage atomic updates. For example:

Changing attributes in this way makes them safer to use in concurrent environments, and is typically more performant than doing it manually in memory.

While we recommend using atomics wherever possible, it is important to note that they are stored in their own map in the changeset, i.e changeset.atomics, meaning if you need to do something later in the action with the new value for an attribute, you won't be able to access the new value. This is because atomics are evaluated in the data layer. You can, however, access "the old or new value" in a similar way to Ash.Changeset.get_attribute, using the template expression, atomic_ref(:name). See the section below for more.

Lets say that you have an action that may perform multiple atomic update on a single column, or for some other reason needs to refer to the new value. The only way to access that new value is also in an atomic update, change, or validation, using atomic_ref/1. There is no way to access the new value prior to the action being run with something like Ash.Changeset.get_attribute/2.

For example, lets say you have a postgres function that will slugify a string, and you want to make sure to always set it to the slugified version of name, whenever name is changing.

By using atomic_ref/1 here, you are always referring to the new value of name, even if another atomic update has been made that modifies name.

Because the validation changing/1 can be done atomically, and the change atomic_update/2 (naturally) can be done atomically, this is a fully atomic update. Lets say that you paired this with an action like this:

and would produce a SQL update along the lines of:

This is a fully atomic update, because all changes are done atomically in the data layer. We now have the benefits of compos

*[Content truncated]*

**Examples:**

Example 1 (unknown):
```unknown
# on a ticket resource
update :close do
  accept [:close_reason]
  change set_attribute(:status, :closed)
end
```

Example 2 (unknown):
```unknown
ticket # providing an initial ticket to close
|> Ash.Changeset.for_update(:close, %{close_reason: "I figured it out."})
|> Ash.update!()
```

Example 3 (unknown):
```unknown
Support.close_ticket!(ticket, "I figured it out.")
# You can also provide an id
Support.close_ticket!(ticket.id, "I figured it out.")
```

Example 4 (unknown):
```unknown
update :add_to_name do
  argument :to_add, :string, allow_nil? false
  change atomic_update(:name, expr("#{name}_#{to_add}"))
end
```

---
