# Ash-Core - Resources

**Pages:** 78

---

## Ash.Resource.Validation.Context (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Ash.Resource.Validation.Context.html

**Contents:**
- Ash.Resource.Validation.Context (ash v3.7.6)
- Summary
- Types
- Types
- t()

Context for a validation.

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## Development Utilities

**URL:** https://hexdocs.pm/ash/development-utilities.html

**Contents:**
- Development Utilities
- Formatting DSLs
- ElixirSense Plugin
- Formatter plugin
  - Adding the plugin
  - Configuration
    - Minimal config for your Ash Resources
    - If you use a different module than Ash.Resource

All Ash packages that ship with extensions provide exports in their .formatter.exs. This prevents the formatter from turning, for example, attribute :name, :string into attribute(:name, :string). To enable this, add :ash (and any other Ash libraries you are using) to your .formatter.exs file:

Ash uses Spark to build all of our DSLs (like Ash.Resource and Ash.Domain) and to validate options lists to functions. Spark ships with an extension that is automatically picked up by ElixirLS to provide autocomplete for all of our DSLs, and options list. You don't need to do anything to enable this, but it only works with ElixirLS (not other language server tools).

Spark also ships with a formatter plugin that can help you keep your resources formatted consistently. This plugin can sort the sections of your DSL to make your resources more consistent, and it can remove any accidentally added parentheses around DSL code.

Add the following to your .formatter.exs

Hex Package Hex Preview (current file) Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
[
  # ...
  import_deps: [..., :ash],
  # ...
]
```

Example 2 (unknown):
```unknown
[
  plugins: [Spark.Formatter], # <- add the plugin here
  inputs: ...
]
```

Example 3 (unknown):
```unknown
config :spark, :formatter,
  remove_parens?: true,
  "Ash.Domain": [],
  "Ash.Resource": [
    section_order: [
      # any section not in this list is left where it is
      # but these sections will always appear in this order in a resource
      :actions,
      :attributes,
      :relationships,
      :identities
    ]
  ]
```

Example 4 (unknown):
```unknown
config :spark, :formatter,
  [
    "Ash.Resource": [
      section_order: [
        :resource,
        :identities,
        :attributes,
        :relationships,
        ...
      ]
    ],
    # If you use a different module than Ash.Resource
    "MyApp.Resource": [
      type: Ash.Resource,
      # What extensions might be added by your base module
      extensions: [...],
      section_order: [
        :resource,
        :identities,
        :attributes,
        :relationships,
        ...
      ]
    ]
  ]
```

---

## Ash.Resource.Actions.Implementation.Context (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Ash.Resource.Actions.Implementation.Context.html

**Contents:**
- Ash.Resource.Actions.Implementation.Context (ash v3.7.6)
- Summary
- Types
- Types
- t()

The context passed into generic action functions

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## Ash.Policy.Check.Builtins (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Ash.Policy.Check.Builtins.html

**Contents:**
- Ash.Policy.Check.Builtins (ash v3.7.6)
- Summary
- Functions
- Functions
- accessing_from(resource, relationship)
- action(action)
- action_type(action_type)
- actor_absent()
- actor_attribute_equals(attribute, value)
- actor_present()

The global authorization checks built into ash

This check is true when the current action is being run "through" a relationship.

This check is true when the action name matches the provided action name or names.

This check is true when the action type matches the provided type or types.

This check is false when there is an actor specified, and true when the actor is nil.

This check is true when the value of the specified attribute of the actor equals the specified value.

This check is true when there is an actor specified, and false when the actor is nil.

This check always passes.

This check is true when attribute changes correspond to the provided options.

This check is true when the specified relationship is changing

This check is true when the specified relationships are changing

This check is true when the value of the specified key or path in the changeset or query context equals the specified value.

This check is true when the field provided is being referenced anywhere in a filter statement.

This check is true when the field or relationship, or path to field, is being loaded and false when it is not.

This check is true when the specified function returns true

This check never passes.

This check passes if the data relates to the actor via the specified relationship or path of relationships.

This check is true when the specified relationship is being changed to the current actor.

This check is true when the resource name matches the provided resource name or names.

This check is true when the field is being selected and false when it is not.

This check is true when the current action is being run "through" a relationship.

Cases where this happens:

This check is true when the action name matches the provided action name or names.

This is a very common pattern, allowing action-specific policies.

This check is true when the action type matches the provided type or types.

This is useful for writing policies that apply to all actions of a given type.

You can also specify a list of types:

This check is false when there is an actor specified, and true when the actor is nil.

This check is true when the value of the specified attribute of the actor equals the specified value.

This check will never pass if the actor does not have the specified key. For example, actor_attribute_equals(:missing_key, nil)

This check is true when there is an actor specified, and false when the actor is nil.

This check always passes.

Can be useful for

*[Content truncated]*

**Examples:**

Example 1 (unknown):
```unknown
policy action_type(:read) do
  authorize_if relates_to_actor_via(:owner)
end
```

Example 2 (unknown):
```unknown
policy action_type([:read, :update]) do
  authorize_if relates_to_actor_via(:owner)
end
```

Example 3 (unknown):
```unknown
policy action_type(:read) do
  forbid_if actor_attribute_equals(:disabled, true)
  forbid_if actor_attribute_equals(:active, false)
  authorize_if always()
end
```

Example 4 (unknown):
```unknown
# if you are changing both first name and last name
changing_attributes([:first_name, :last_name])

# if you are changing first name to fred
changing_attributes(first_name: [to: "fred"])

# if you are changing last name from bob
changing_attributes(last_name: [from: "bob"])

# if you are changing :first_name at all, last_name from "bob" and middle name from "tom" to "george"
changing_attributes([:first_name, last_name: [from: "bob"], middle_name: [from: "tom", to: "george"]])
```

---

## Authorize Access to Resources

**URL:** https://hexdocs.pm/ash/authorize-access-to-resources.html

**Contents:**
- Authorize Access to Resources
- Introduction
- Writing Policies
- Example
- Interacting with resources that have policies

A key feature of Ash is the ability to build security directly into your resources. We do this with policies.

Because how you write policies is extremely situational, this how-to guide provides a list of "considerations" as opposed to "instructions".

For more context, read the policies guide.

Hex Package Hex Preview (current file) Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
Mix.install(
  [
    {:ash, "~> 3.0"},
    {:simple_sat, "~> 0.1"},
    {:kino, "~> 0.12"}
  ],
  consolidate_protocols: false
)

Logger.configure(level: :warning)
Application.put_env(:ash, :policies, show_policy_breakdowns?: true)
```

Example 2 (unknown):
```unknown
defmodule User do
  use Ash.Resource,
    domain: Domain,
    data_layer: Ash.DataLayer.Ets

  actions do
    defaults [:read, create: [:admin?]]
  end

  attributes do
    uuid_primary_key :id
    attribute :admin?, :boolean do
      allow_nil? false
      default false
    end
  end
end

defmodule Tweet do
  use Ash.Resource,
    domain: Domain,
    data_layer: Ash.DataLayer.Ets,
    authorizers: [Ash.Policy.Authorizer]

  attributes do
    uuid_primary_key :id
    attribute :text, :string do
      allow_nil? false
      constraints max_length: 144
      public? true
    end

    attribute :
...
```

Example 3 (unknown):
```unknown
{:module, Domain, <<70, 79, 82, 49, 0, 2, 117, ...>>,
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
# doing forbidden things produces an `Ash.Error.Forbidden`
user = Domain.create_user!()
other_user = Domain.create_user!()

tweet = Domain.create_tweet!("hello world!", actor: user)
Domain.update_tweet!(tweet, "Goodbye world", actor: other_user)
```

---

## Ash.Resource.Actions.Create (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Ash.Resource.Actions.Create.html

**Contents:**
- Ash.Resource.Actions.Create (ash v3.7.6)
- Summary
- Types
- Types
- t()

Represents a create action on a resource.

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## Ash.Resource.Change.Context (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Ash.Resource.Change.Context.html

**Contents:**
- Ash.Resource.Change.Context (ash v3.7.6)
- Summary
- Types
- Types
- t()

The context for a change.

This is passed into various callbacks for Ash.Resource.Change.

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## mix ash.gen.domain (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Mix.Tasks.Ash.Gen.Domain.html

**Contents:**
- mix ash.gen.domain (ash v3.7.6)
- Example

Generates an Ash.Domain

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
mix ash.gen.domain MyApp.Accounts
```

---

## Ash.Resource.ManualUpdate behaviour (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Ash.Resource.ManualUpdate.html

**Contents:**
- Ash.Resource.ManualUpdate behaviour (ash v3.7.6)
- Summary
- Callbacks
- Callbacks
- bulk_update(changesets, opts, context)
- update(changeset, opts, context)

A module to implement manual update actions.

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## Ash.Resource.Interface.CustomInput.Transform (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Ash.Resource.Interface.CustomInput.Transform.html

**Contents:**
- Ash.Resource.Interface.CustomInput.Transform (ash v3.7.6)

Represents a transformation applied to a custom input

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## Ash.Resource.Actions.Update (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Ash.Resource.Actions.Update.html

**Contents:**
- Ash.Resource.Actions.Update (ash v3.7.6)
- Summary
- Types
- Functions
- Types
- t()
- Functions
- transform(action)

Represents a update action on a resource.

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## Ash.Resource.Actions.Argument (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Ash.Resource.Actions.Argument.html

**Contents:**
- Ash.Resource.Actions.Argument (ash v3.7.6)
- Summary
- Types
- Functions
- Types
- t()
- Functions
- schema()

Represents an argument to an action

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## Ash.Resource.Change.OptimisticLock (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Ash.Resource.Change.OptimisticLock.html

**Contents:**
- Ash.Resource.Change.OptimisticLock (ash v3.7.6)
- What is Optimistic Locking?
  - User Experience
  - Concurrency Safety

Apply an "optimistic lock" on a record being updated or destroyed.

Optimistic Locking is the process of only allowing an update to occur if the version of a record that you have in memory is the same as the version in the database. Otherwise, an error is returned. On success, it increments the version while performing the action.

Optimistic locking may used for two primary purposes:

For example, if a user is editing a form that contains State and County fields, and they change the County, while another user has used the form to change the State, you could end up with a mismatch between State and County.

With optimistic locking, the user will instead get an error message that the record has been changed since they last looked.

Optimistic locking can make actions safe to run concurrently even if they can't be performed in a single query (atomically), by returning an error if the resource in the data layer does not have the same version as the one being edited.

This tells the user that they need to reload and try again.

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## Ash.Domain

**URL:** https://hexdocs.pm/ash/dsl-ash-domain.html

**Contents:**
- Ash.Domain
- domain
  - Examples
  - Options
- resources
  - Nested DSLs
  - Examples
  - Options
  - resources.resource
  - Nested DSLs

General domain configuration

List the resources of this domain

A resource present in the domain

Defines a function with the corresponding name and arguments. See the code interface guide for more.

Define or customize an input to the action.

See the code interface guide for more.

A transformation to be applied to the custom input.

Target: Ash.Resource.Interface.CustomInput.Transform

Target: Ash.Resource.Interface.CustomInput

Target: Ash.Resource.Interface

Defines a function with the corresponding name and arguments, that evaluates a calculation. Use :_record to take an instance of a record. See the code interface guide for more.

Define or customize an input to the action.

See the code interface guide for more.

A transformation to be applied to the custom input.

Target: Ash.Resource.Interface.CustomInput.Transform

Target: Ash.Resource.Interface.CustomInput

Target: Ash.Resource.CalculationInterface

Target: Ash.Domain.Dsl.ResourceReference

Options for how requests are executed using this domain

Options for how requests are authorized using this domain. See the Sensitive Data guide for more.

Hex Package Hex Preview (current file) Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
domain do
  description """
  Resources related to the flux capacitor.
  """
end
```

Example 2 (unknown):
```unknown
resources do
  resource MyApp.Tweet
  resource MyApp.Comment
end
```

Example 3 (unknown):
```unknown
resource resource
```

Example 4 (unknown):
```unknown
resource Foo
```

---

## Ash.Domain.Dsl.ResourceReference (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Ash.Domain.Dsl.ResourceReference.html

**Contents:**
- Ash.Domain.Dsl.ResourceReference (ash v3.7.6)
- Summary
- Types
- Types
- t()

A resource reference in a domain

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## Ash.Resource.Calculation behaviour (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Ash.Resource.Calculation.html

**Contents:**
- Ash.Resource.Calculation behaviour (ash v3.7.6)
- Summary
- Types
- Callbacks
- Functions
- Types
- opts()
- ref()
- t()
- Callbacks

The behaviour for defining a module calculation, and the struct for storing a defined calculation.

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## Ash.Query (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Ash.Query.html

**Contents:**
- Ash.Query (ash v3.7.6)
- Capabilities & Limitations
  - Important Considerations
- Escape Hatches
  - Choose escape hatches wisely
  - Fragments
  - Manual Read Actions
  - Ash.Resource.Dsl.actions.read.modify_query
  - Using Ecto directly
- Summary

A data structure for reading data from a resource.

Queries are run by calling Ash.read/2.

To see more examples of what you can do with Ash.Query and read actions in general, see the writing queries how-to guide.

Ash Framework provides a comprehensive suite of querying tools designed to address common application development needs. While powerful and flexible, these tools are focused on domain-driven design rather than serving as a general-purpose ORM.

Ash's query tools support:

While Ash's query tools often eliminate the need for direct database queries, Ash is not itself designed to be a comprehensive ORM or database query builder.

For specialized querying needs that fall outside Ash's standard capabilities, the framework provides escape hatches. These mechanisms allow developers to implement custom query logic when necessary.

For complex queries that fall outside these tools, consider whether they represent domain concepts that could be modeled differently, or if they truly require custom implementation through escape hatches.

Many of the tools in Ash.Query are surprisingly deep and capable, covering everything you need to build your domain logic. With that said, these tools are not designed to encompass every kind of query that you could possibly want to write over your data. Ash is not an ORM or a database query tool, despite the fact that its query building tools often make those kinds of tools unnecessary in all but the rarest of cases. Not every kind of query that you could ever wish to write can be expressed with Ash.Query. Elixir has a best-in-class library for working directly with databases, called Ecto, and if you end up building a certain type of feature like analytics or reporting dashboards, you may find yourself working directly with Ecto. Data layers like AshPostgres are built on top of Ecto. In fact, every Ash.Resource is an Ecto.Schema!

You should choose to use Ash builtin functionality wherever possible. Barring that, you should choose the least powerful escape hatch that can solve your problem. The options below are presented in the order that you should prefer them, but you should only use any of them if no builtin tooling will suffice.

Fragments only barely count as an escape hatch. You will often find yourself wanting to use a function or operator specific to your data layer, and fragments are purpose built to this end. You can use data-layer-specific expressions in your expressions for filters, calculations, etc. For exam

*[Content truncated]*

**Examples:**

Example 1 (unknown):
```unknown
require Ash.Query

MyApp.Post
|> Ash.Query.filter(likes > 10)
|> Ash.Query.sort([:title])
|> Ash.read!()

MyApp.Author
|> Ash.Query.aggregate(:published_post_count, :posts, query: [filter: [published: true]])
|> Ash.Query.sort(published_post_count: :desc)
|> Ash.Query.limit(10)
|> Ash.read!()

MyApp.Author
|> Ash.Query.load([:post_count, :comment_count])
|> Ash.Query.load(posts: [:comments])
|> Ash.read!()
```

Example 2 (unknown):
```unknown
Resource
|> Ash.Query.filter(expr(fragment("lower(?)", name) == "fred"))
|> Ash.Query.filter(expr(fragment("? @> ?", tags, ["important"])))
```

Example 3 (unknown):
```unknown
actions do
  read :complex_search do
    argument
    modify_query {SearchMod, :modify, []}
  end
end
```

Example 4 (python):
```python
defmodule SearchMod do
  def modify(ash_query, data_layer_query) do
    # Here you can modify the underlying data layer query directly
    # For example, with AshPostgres you get access to the Ecto query
    {:ok, Ecto.Query.where(data_layer_query, [p], fragment("? @@ plainto_tsquery(?)", p.search_vector, ^ash_query.arguments.search_text))}
  end
end
```

---

## Changes

**URL:** https://hexdocs.pm/ash/changes.html

**Contents:**
- Changes
- Builtin Changes
- Custom Changes
- Anonymous Function Changes
- Where
- Action vs Global Changes
  - Running on destroy actions
  - Examples
- Atomic Changes
- Batches

Changes are the primary way of customizing create/update/destroy action behavior. If you are familiar with Plug, you can think of an Ash.Resource.Change as the equivalent of a Plug for changesets. At its most basic, a change will take a changeset and return a new changeset. Changes can be simple, like setting or modifying an attribute value, or more complex, attaching hooks to be executed within the lifecycle of the action.

There are a number of builtin changes that can be used, and are automatically imported into your resources. See Ash.Resource.Change.Builtins for more.

Some examples of usage of builtin changes

This could then be used in a resource via:

You can also use anonymous functions for changes. Keep in mind, these cannot be made atomic, or support batching. This is great for prototyping, but we generally recommend using a module, both for organizational purposes, and to allow adding atomic/batch behavior.

The where can be used to perform changes conditionally. This functions by running the validations in the where, and if the validation returns an error, we discard the error and skip the operation. This means that even custom validations can be used in conditions.

You can place a change on any create, update, or destroy action. For example:

Or you can use the global changes block to apply to all actions of a given type. Where statements can be used in both cases. Use on to determine the types of actions the validation runs on. By default, it only runs on create and update actions.

The changes section allows you to add changes across multiple actions of a resource.

By default, changes in the global changes block will run on create and update only. Many changes don't make sense in the context of destroys. To make them run on destroy, use on: [:create, :update, :destroy]

To make a change atomic, you have to implement the Ash.Resource.Change.atomic/3 callback. This callback returns a map of changes to attributes that should be changed atomically. We will also honor any Ash.Resource.Change.after_batch/3 functionality to run code after atomic changes have been applied (only if atomic/3 callback has also been defined). Note that Ash.Resource.Change.before_batch/3 is not supported in this scenario and will be ignored.

In some cases, changes operate only on arguments or context, or otherwise can do their work regardless of atomicity. In these cases, you can make your atomic callback call the change/3 function

In other cases, a change may not b

*[Content truncated]*

**Examples:**

Example 1 (unknown):
```unknown
# set the `owner` to the current actor
change relate_actor(:owner)

# set `commited_at` to the current timestamp when the action is called
change set_attribute(:committed_at, &DateTime.utc_now/0)

# optimistic lock using the `version` attribute
change optimistic_lock(:version)
```

Example 2 (python):
```python
defmodule MyApp.Changes.Slugify do

  use Ash.Resource.Change

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
  def change(changeset, opts, _context) do
    case Ash.Changeset.fetch_change(changeset, opts[:attribute]) do
      {:ok, new_value} ->
        slug = String.replace(new_value, ~r/\s+/, "-")
        Ash.Changeset.force_change_attribute(changeset, opts[:attribute], slug)
      :error ->
        changeset
    end
  end
end
```

Example 3 (unknown):
```unknown
change {MyApp.Changes.Slugify, attribute: :foo}
```

Example 4 (unknown):
```unknown
change fn changeset, _context ->
  # put your code here
end
```

---

## Ash.Resource.Relationships.HasOne (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Ash.Resource.Relationships.HasOne.html

**Contents:**
- Ash.Resource.Relationships.HasOne (ash v3.7.6)
- Summary
- Types
- Functions
- Types
- t()
- Functions
- transform(relationship)

Represents a has_one relationship on a resource

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## Policies

**URL:** https://hexdocs.pm/ash/policies.html

**Contents:**
- Policies
- Setup
- Policies
  - Anatomy of a Policy
  - The Simplest Policy
  - Policy with condition inside do block
  - How a Decision is Reached
  - Not all policy checks have yes/no answers
  - Read Actions and Filtering Behavior
    - Bypassing this behavior

Policies determine what actions on a resource are permitted for a given actor, and can also filter the results of read actions to restrict the results to only records that should be visible.

To restrict access to specific fields (attributes, aggregates, calculations), see the section on field policies.

Read and understand the Actors & Authorization guide before proceeding, which explains actors, how to set them, and other relevant configurations.

You'll need to add the extension to your resource, like so:

Then you can start defining policies for your resource.

Each policy defined in a resource has two parts -

If more than one policy applies to any given request (eg. an admin actor calls a read action) then all applicable policies must pass for the action to be performed.

A policy will produce one of three results: :forbidden, :authorized, or :unknown. :unknown is treated the same as :forbidden.

Let's start with the simplest (most permissive) policy:

The first argument to policy is the condition. In this case, the condition is always() - a built-in helper always returning true, meaning that the policy applies to every request.

Within this policy we have a single policy check, declared with authorize_if. Checks logically apply from top to bottom, based on their check type. In this case, we'd read the policy as "this policy always applies, and authorizes always".

There are four check types, all of which do what they sound like they do:

If a single check does not explicitly authorize or forbid the whole policy, then the flow moves to the next check. For example, if an authorize_if check does NOT return true, this does not mean the whole policy is forbidden - it means that further checking is required.

A condition or a list of conditions can also be moved inside the policy block.

This can make a really long list of conditions easier to read.

Not every check in a policy must pass! This is described above, but is very important so another example is provided here. Checks go from top to bottom, are evaluated independently of each other, and the first one that reaches a decision determines the overall policy result. For example:

We check those from top to bottom, so the first one of those that returns :authorized or :forbidden determines the entire outcome. For example:

This will be covered in greater detail in Checks, but will be briefly mentioned here.

Ash provides two basic types of policy checks - simple checks and filter checks. Simple checks

*[Content truncated]*

**Examples:**

Example 1 (unknown):
```unknown
use Ash.Resource, authorizers: [Ash.Policy.Authorizer]
```

Example 2 (unknown):
```unknown
policies do
  policy always() do
    authorize_if always()
  end
end
```

Example 3 (unknown):
```unknown
policies do
  policy do
    condition always()
    authorize_if always()
  end
end
```

Example 4 (unknown):
```unknown
policy action_type(:create) do
  authorize_if IsSuperUser
  forbid_if Deactivated
  authorize_if IsAdminUser
  forbid_if RegularUserCanCreate
  authorize_if RegularUserAuthorized
end
```

---

## Ash.Resource.Preparation.Builtins (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Ash.Resource.Preparation.Builtins.html

**Contents:**
- Ash.Resource.Preparation.Builtins (ash v3.7.6)
- Summary
- Functions
- Functions
- after_action(callback)
- Example
- before_action(callback)
- Example
- build(options)
- Examples

Builtin query preparations

Directly attach an after_action function to the query.

Directly attach a before_action function to the query.

Passes the given keyword list to Ash.Query.build/2 with the query being prepared.

Merges the given query context.

Directly attach an after_action function to the query.

This function will be called by Ash.Query.after_action/2, with an additional context argument.

Directly attach a before_action function to the query.

This function will be called by Ash.Query.before_action/2, with an additional context argument.

Passes the given keyword list to Ash.Query.build/2 with the query being prepared.

This allows declaring simple query modifications in-line.

To see the available options, see Ash.Query.build/2

Merges the given query context.

If an MFA is provided, it will be called with the changeset. The MFA should return {:ok, context_to_be_merged} or {:error, term}

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
prepare after_action(fn query, records, _context ->
  Logger.debug("Query for #{query.action.name} on resource #{inspect(query.resource)} returned #{length(records)} records")

  {:ok, records}
end)
```

Example 2 (unknown):
```unknown
prepare before_action(fn query, _context ->
  Logger.debug("About to execute query for #{query.action.name} on #{inspect(query.resource)}")

  query
end)
```

Example 3 (unknown):
```unknown
prepare build(sort: [song_rank: :desc], limit: 10)
prepare build(load: [:friends])
```

Example 4 (unknown):
```unknown
change set_context(%{something_used_internally: true})
change set_context({MyApp.Context, :set_context, []})
```

---

## Ash.Resource.Aggregate.JoinFilter (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Ash.Resource.Aggregate.JoinFilter.html

**Contents:**
- Ash.Resource.Aggregate.JoinFilter (ash v3.7.6)

Represents a join filter on a resource aggregate

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## Ash.Resource.CalculationInterface (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Ash.Resource.CalculationInterface.html

**Contents:**
- Ash.Resource.CalculationInterface (ash v3.7.6)
- Summary
- Types
- Functions
- Types
- t()
- Functions
- schema()
- transform(interface)

Represents a function that evaluates a calculation in a resource's code interface

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## Ash.Resource.Relationships.ManyToMany (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Ash.Resource.Relationships.ManyToMany.html

**Contents:**
- Ash.Resource.Relationships.ManyToMany (ash v3.7.6)
- Summary
- Types
- Types
- t()

Represents a many_to_many relationship on a resource

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## mix ash.gen.resource (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Mix.Tasks.Ash.Gen.Resource.html

**Contents:**
- mix ash.gen.resource (ash v3.7.6)
- Example
- Options

Generate and configure an Ash.Resource.

If the domain does not exist, we create it. If it does, we add the resource to it if it is not already present.

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
mix ash.gen.resource Helpdesk.Support.Ticket \
  --default-actions read \
  --uuid-primary-key id \
  --attribute subject:string:required:public \
  --relationship belongs_to:representative:Helpdesk.Support.Representative \
  --timestamps \
  --extend postgres,graphql
```

---

## Ash.Resource.ManualDestroy behaviour (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Ash.Resource.ManualDestroy.html

**Contents:**
- Ash.Resource.ManualDestroy behaviour (ash v3.7.6)
- Summary
- Callbacks
- Callbacks
- bulk_destroy(changesets, opts, context)
- destroy(changeset, opts, context)

A module to implement manual destroy actions.

Note that in the returns of these functions you must return the destroyed record or records.

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## Ash.Resource.Validation behaviour (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Ash.Resource.Validation.html

**Contents:**
- Ash.Resource.Validation behaviour (ash v3.7.6)
- Summary
- Types
- Callbacks
- Functions
- Types
- path()
- ref()
- t()
- Callbacks

Represents a validation in Ash.

See Ash.Resource.Validation.Builtins for a list of builtin validations.

To write your own validation, define a module that implements the init/1 callback to validate options at compile time, and validate/3 callback to do the validation.

Then, in a resource, you can say:

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
validations do
  validate {MyValidation, [foo: :bar]}
end
```

---

## Ash.Resource.Preparation.Context (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Ash.Resource.Preparation.Context.html

**Contents:**
- Ash.Resource.Preparation.Context (ash v3.7.6)
- Summary
- Types
- Types
- t()

The context for a preparation.

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## Ash.Resource.Identity (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Ash.Resource.Identity.html

**Contents:**
- Ash.Resource.Identity (ash v3.7.6)
- Summary
- Types
- Functions
- Types
- t()
- Functions
- schema()

Represents a unique constraint on a resource

Data layers should (and all built in ones do), discount nil or null (in the case of postgres) values when determining if a unique constraint matches. This often means that you should prefer to use identities with non-nullable columns.

Eventually, features could be added to support including nil or null values, but they would need to include a corresponding feature for data layers.

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## Ash (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Ash.html

**Contents:**
- Ash (ash v3.7.6)
- Summary
- Types
- Functions
- Types
- actor()
- aggregate()
- data_layer_query()
- load_statement()
- page_request()

The primary interface to call actions and interact with resources.

The actor performing the action - can be any term.

Aggregate specification for queries.

A data layer query structure with execution and counting functions.

Load statement for relationships and calculations.

Page request options for paginated queries.

A single record or a list of records.

Runs an aggregate or aggregates over a resource query

Runs an aggregate or aggregates over a resource query, returning the result or raising an error.

Fetches the average of all values of a given field.

Fetches the average of all values of a given field or raises an error.

Creates many records.

Creates many records, raising any errors that are returned. See bulk_create/4 for more.

Destroys all items in the provided enumerable or query with the provided input.

Destroys all items in the provided enumerable or query with the provided input.

Updates all items in the provided enumerable or query with the provided input.

Updates all items in the provided enumerable or query with the provided input.

Evaluates the calculation on the resource.

Evaluates the calculation on the resource or raises an error. See calculate/3 for more.

Returns whether or not the user can perform the action, or :maybe, returning any errors.

Returns whether or not the user can perform the action, or raises on errors.

See Ash.Context.to_opts/2.

Fetches the count of results that would be returned from a given query.

Fetches the count of results that would be returned from a given query, or raises an error.

Create a record. See create/2 for more information.

Gets the full query and any runtime calculations that would be loaded

Gets the full query and any runtime calculations that would be loaded, raising any errors.

Destroy a record. See destroy/2 for more information.

Returns whether or not the query would return any results.

Returns whether or not the query would return any results, or raises an error.

Fetches the first value for a given field.

Fetches the first value for a given field, or raises an error.

Get a record by an identifier.

Get a record by an identifier, or raises an error. See get/3 for more.

Fetches a list of all values of a given field.

Fetches a list of all values of a given field or raises an error.

Load fields or relationships on already fetched records.

Load fields or relationships on already fetched records. See load/3 for more information.

Fetches the greatest of all values of a giv

*[Content truncated]*

**Examples:**

Example 1 (unknown):
```unknown
iex> MyApp.Post |> Ash.aggregate({:count, :count})
{:ok, %{count: 42}}

iex> query |> Ash.aggregate([{:avg_likes, :avg, field: :likes}, {:count, :count}])
{:ok, %{avg_likes: 10.5, count: 42}}

iex> MyApp.Post |> Ash.Query.filter(published: true) |> Ash.aggregate({:sum_views, :sum, field: :view_count})
{:ok, %{sum_views: 1542}}
```

Example 2 (unknown):
```unknown
iex> MyApp.Post |> Ash.aggregate!({:count, :count})
42

iex> query |> Ash.aggregate!([{:avg_likes, :avg, field: :likes}, {:count, :count}])
%{avg_likes: 10.5, count: 42}
```

Example 3 (unknown):
```unknown
iex> MyApp.Post |> Ash.avg(:view_count)
{:ok, 42.5}

iex> MyApp.Post |> Ash.Query.filter(published: true) |> Ash.avg(:likes)
{:ok, 15.8}
```

Example 4 (unknown):
```unknown
iex> MyApp.Post |> Ash.avg!(:view_count)
42.5

iex> MyApp.Post |> Ash.Query.filter(published: true) |> Ash.avg!(:likes)
15.8
```

---

## Ash.Resource.Dsl.Filter (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Ash.Resource.Dsl.Filter.html

**Contents:**
- Ash.Resource.Dsl.Filter (ash v3.7.6)

Introspection target for a filter for read actions and relationships

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## Ash.Error.Changes.InvalidChanges exception (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Ash.Error.Changes.InvalidChanges.html

**Contents:**
- Ash.Error.Changes.InvalidChanges exception (ash v3.7.6)
- Summary
- Functions
- Functions
- exception(msg)
- Keys

Used when a change is provided that covers multiple attributes/relationships

Create an Elixir.Ash.Error.Changes.InvalidChanges without raising it.

Create an Elixir.Ash.Error.Changes.InvalidChanges without raising it.

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## Ash.Resource.ManualCreate behaviour (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Ash.Resource.ManualCreate.html

**Contents:**
- Ash.Resource.ManualCreate behaviour (ash v3.7.6)
- Summary
- Callbacks
- Callbacks
- bulk_create(changesets, opts, context)
- create(changeset, opts, context)

A module to implement manual create actions.

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## Ash.Query.Calculation (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Ash.Query.Calculation.html

**Contents:**
- Ash.Query.Calculation (ash v3.7.6)
- Summary
- Types
- Functions
- Types
- t()
- Functions
- from_resource_calculation(resource, name, opts \\ [])
- Options
- from_resource_calculation!(resource, name, opts \\ [])

Represents a calculated attribute requested on a query

Creates a new query calculation from a resource calculation.

Creates a new query calculation from a resource calculation, raising any errors.

Creates a new query calculation.

Creates a new query calculation from a resource calculation.

:args (map/0) - Arguments to pass to the calculation The default value is %{}.

:source_context (map/0) - Context from the source query or changeset. The default value is %{}.

Creates a new query calculation from a resource calculation, raising any errors.

See from_resource_calculation/3 for more.

Creates a new query calculation.

:arguments (map/0) - Arguments to pass to the calculation The default value is %{}.

:async? (boolean/0) - Whether or not this calculation should be run asynchronously The default value is false.

:filterable? (boolean/0) - Whether or not this calculation can be filtered on The default value is true.

:sortable? (boolean/0) - Whether or not this calculation can be sorted on The default value is true.

:sensitive? (boolean/0) - Whether or not references to this calculation will be considered sensitive The default value is false.

:load (term/0) - Loads that are required for the calculation.

:actor (term/0) - The actor performing the calculation.

:tenant (term/0) - The tenant performing the calculation.

:authorize? (boolean/0) - Whether or not authorization is being performed

:tracer (term/0) - The tracer or tracers used in the calculation.

:source_context (map/0) - Context from the source query or changeset. The default value is %{}.

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## Encrypt Attributes

**URL:** https://hexdocs.pm/ash/encrypt-attributes.html

**Contents:**
- Encrypt Attributes
- Introduction
- Encrypting attributes
- Examples
- Data is encrypted when modified and is not displayed when inspecting.

When dealing with PII(Personally Identifiable Information) or other sensitive data, we often want to encrypt this data, and control access to the decrypted values.

To do this in Ash, we do that with AshCloak. See the getting started guide in AshCloak for installation instructions.

Hex Package Hex Preview (current file) Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
Mix.install([{:ash, "~> 3.0"}, {:ash_cloak, "~> 0.1.0"}, {:cloak, "~> 1.1"}],
  consolidate_protocols: false
)

Application.put_env(:my_app, MyApp.Vault,
  ciphers: [
    default: {
      Cloak.Ciphers.AES.GCM,
      tag: "AES.GCM.V1",
      key: Base.decode64!("ETpvtowVAL7JmcxfqJ+XVQWzKrt1ynAkC0vT7AxfyNU="),
      iv_length: 12
    }
  ]
)

defmodule MyApp.Vault do
  use Cloak.Vault, otp_app: :my_app
end

MyApp.Vault.start_link()
```

Example 2 (unknown):
```unknown
defmodule User do
  use Ash.Resource,
    domain: Domain,
    data_layer: Ash.DataLayer.Ets,
    extensions: [AshCloak]

  cloak do
    vault MyApp.Vault
    attributes [:ssn]
  end

  attributes do
    uuid_primary_key :id
    attribute :ssn, :string, allow_nil?: false
  end

  actions do
    defaults [:read, create: [:ssn], update: [:ssn]]
  end
end

defmodule Domain do
  use Ash.Domain,
    validate_config_inclusion?: false

  resources do
    resource User do
      define(:create_user, action: :create, args: [:ssn])
      define(:update_user, action: :update, args: [:ssn])
      define(:li
...
```

Example 3 (unknown):
```unknown
{:module, Domain, <<70, 79, 82, 49, 0, 1, 255, ...>>,
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
user = Domain.create_user!("111-11-1111")
```

---

## Ash.Domain behaviour (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Ash.Domain.html

**Contents:**
- Ash.Domain behaviour (ash v3.7.6)
  - Options
- Summary
- Types
- Types
- t()

A domain allows you to interact with your resources, and holds domain-wide configuration.

For example, the json domain extension adds a domain extension that lets you toggle authorization on/off for all resources in a given domain. You include resources in your domain like so:

:validate_config_inclusion? (boolean/0) - Whether or not to validate that this domain is included in the configuration. The default value is true.

:backwards_compatible_interface? (boolean/0) - Whether or not to include the 2.0 backwards compatible interface, which includes all of the interaction functions which are now defined on the Ash module The default value is true.

:extensions (list of module that adopts Spark.Dsl.Extension) - A list of DSL extensions to add to the Spark.Dsl

:authorizers (one or a list of module that adopts Ash.Authorizer) - authorizers extensions to add to the Spark.Dsl The default value is [].

:otp_app (atom/0) - The otp_app to use for any application configurable options

:fragments (list of module/0) - Fragments to include in the Spark.Dsl. See the fragments guide for more.

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
defmodule MyApp.MyDomain do
  use Ash.Domain

  resources do
    resource OneResource
    resource SecondResource
  end
end
```

---

## Sensitive Data

**URL:** https://hexdocs.pm/ash/sensitive-data.html

**Contents:**
- Sensitive Data
- Public & Private Attributes
- Public & Private Arguments
- Sensitive Attributes
  - Show Sensitive Attributes
- Field Policies

By default, attributes, calculations, aggregates and relationships are private (they are marked public?: false).If you are working with Ash in code, reading a resource, for example using Ash.read/2, the public/private status of an attribute is not relevant.However, when working with api extensions like AshGraphql and AshJsonApi, they will only include public fields in their interfaces. This helps avoid accidentally exposing data over "public" interfaces.

Public/private arguments work the same way as public/private fields, except that they default to public?: true.This is because arguments to an action being used in a public interface would naturally be expected to be public. If an argument is marked as public?: false, it can only be set using one of the following methods:

Using sensitive? true will cause an attribute, calculation or argument to show as "** Redacted **" when inspecting records.In filter statements, any value used in the same expression as a sensitive field will also be redacted. For example, you might see: email == "** Redacted **" in a filter statement if email is marked as sensitive.

IMPORTANT WARNING: The following configuration should only ever be used in development mode!

To display sensitive attributes in their original form during development, use the following config.

Field policies are a way to control the visibility of individual fields (except for relationships) as a part of authorization flow, for those using Ash.Policy.Authorizer.If a field is not visible, it will be populated with %Ash.ForbiddenField{}, or will be not shown (or may show an error) in public interfaces. See the Policies guide for more.

Hex Package Hex Preview (current file) Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
config :ash, show_sensitive?: true
```

---

## Ash.Resource.Calculation.Argument (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Ash.Resource.Calculation.Argument.html

**Contents:**
- Ash.Resource.Calculation.Argument (ash v3.7.6)
- Summary
- Types
- Functions
- Types
- t()
- Functions
- schema()

An argument to a calculation

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## Ash.Resource.ManualUpdate.Context (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Ash.Resource.ManualUpdate.Context.html

**Contents:**
- Ash.Resource.ManualUpdate.Context (ash v3.7.6)
- Summary
- Types
- Types
- t()

The context passed into manual update action functions

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## Ash.Changeset (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Ash.Changeset.html

**Contents:**
- Ash.Changeset (ash v3.7.6)
- Changeset lifecycle
- Action Lifecycle
- Summary
- Types
- Functions
- Types
- after_action_fun()
- after_transaction_fun()
- around_action_callback()

Changesets are used to create and update data in Ash.

Create a changeset with new/1 or new/2, and alter the attributes and relationships using the functions provided in this module. Nothing in this module actually incurs changes in a data layer. To commit a changeset, see Ash.create/2 and Ash.update/2.

The following example illustrates the hook lifecycle of a changeset.

Function type for after action hooks.

Function type for after transaction hooks.

Callback function type for around action hooks.

Function type for around action hooks.

Result type for around action callbacks.

Callback function type for around transaction hooks.

Function type for around transaction hooks.

Result type for around transaction callbacks.

Function type for before action hooks.

Function type for before transaction hooks.

The type of relationship management strategy to use.

The current phase of changeset processing.

The changeset struct containing all the information about a pending action.

Returns a list of attributes, aggregates, relationships, and calculations that are being loaded

Add an error to the errors list and mark the changeset as invalid.

Adds an after_action hook to the changeset.

Adds an after_transaction hook to the changeset. Cannot be called within other hooks.

Returns the original data with attribute changes merged, if the changeset is valid.

Adds an around_action hook to the changeset.

Adds an around_transaction hook to the changeset.

Gets a reference to a field, or the current atomic update expression of that field.

Adds multiple atomic changes to the changeset

Adds an atomic change to the changeset.

Checks if an attribute is not nil, either in the original data, or that it is not being changed to a nil value if it is changing.

Adds a before_action hook to the changeset.

Adds a before_transaction hook to the changeset.

Adds a change to the changeset, unless the value matches the existing value.

Calls change_attribute/3 for each key/value pair provided.

The same as change_attribute, but annotates that the attribute is currently holding a default value.

Change an attribute only if is not currently being changed

Change an attribute if is not currently being changed, by calling the provided function.

Returns true if an attribute exists in the changes.

Returns true if any attributes on the resource are being changed.

Returns true if a relationship exists in the changes

Clears an attribute or relationship change off of the changese

*[Content truncated]*

**Examples:**

Example 1 (python):
```python
defmodule AshChangesetLifeCycleExample do
  def change(changeset, _, _) do
    changeset
    # execute code both before and after the transaction
    |> Ash.Changeset.around_transaction(fn changeset, callback ->
      callback.(changeset)
    end)
    # execute code before the transaction is started. Use for things like external calls
    |> Ash.Changeset.before_transaction(fn changeset -> changeset end)
    # execute code in the transaction, before and after the data layer is called
    |> Ash.Changeset.around_action(fn changeset, callback ->
      callback.(changeset)
    end)
    # execute 
...
```

Example 2 (unknown):
```unknown
# Create related audit record with the final data
iex> changeset = Ash.Changeset.for_update(user, :update_profile, %{email: "new@example.com"})
iex> changeset = Ash.Changeset.after_action(changeset, fn changeset, updated_user ->
...>   {:ok, _audit} = MyApp.AuditLog.create(%{
...>     action: "profile_updated",
...>     user_id: updated_user.id,
...>     changes: changeset.attributes,
...>     actor_id: changeset.context.actor.id,
...>     timestamp: DateTime.utc_now()
...>   })
...>   {:ok, updated_user}
...> end)

# Send notification with the final record
iex> changeset = Ash.Changeset.for_c
...
```

Example 3 (unknown):
```unknown
# Send notification regardless of order creation success/failure
iex> changeset = Ash.Changeset.for_create(MyApp.Order, :create, %{total: 100.00})
iex> changeset = Ash.Changeset.after_transaction(changeset, fn changeset, result ->
...>   case result do
...>     {:ok, order} ->
...>       NotificationService.order_created_successfully(order.id, changeset.context.actor)
...>     {:error, _error} ->
...>       NotificationService.order_creation_failed(changeset.attributes, changeset.context.actor)
...>   end
...>   result  # Always return the original result
...> end)

# Release external resource
...
```

Example 4 (unknown):
```unknown
# Monitor action execution time for debugging
iex> changeset = Ash.Changeset.for_create(MyApp.Order, :create, %{total: 100.00})
iex> changeset = Ash.Changeset.around_action(changeset, fn changeset, callback ->
...>   start_time = System.monotonic_time(:microsecond)
...>   result = callback.(changeset)
...>   duration = System.monotonic_time(:microsecond) - start_time
...>
...>   Logger.debug("Action #{changeset.action.name} took #{duration}μs")
...>   result
...> end)
```

---

## Ash.Resource.Preparation behaviour (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Ash.Resource.Preparation.html

**Contents:**
- Ash.Resource.Preparation behaviour (ash v3.7.6)
- Summary
- Types
- Callbacks
- Functions
- Types
- ref()
- t()
- Callbacks
- init(opts)

The behaviour for an action-specific query preparation.

init/1 is defined automatically by use Ash.Resource.Preparation, but can be implemented if you want to validate/transform any options passed to the module.

The main function is prepare/3. It takes the query, any options that were provided when this preparation was configured on a resource, and the context, which currently only has the actor.

To access any query arguments from within a preparation, make sure you are using Ash.Query.get_argument/2 as the argument keys may be strings or atoms.

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## Ash.Resource.ManualRelationship.Context (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Ash.Resource.ManualRelationship.Context.html

**Contents:**
- Ash.Resource.ManualRelationship.Context (ash v3.7.6)
- Summary
- Types
- Types
- t()

The context passed into manual relationship functions

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## mix ash.extend (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Mix.Tasks.Ash.Extend.html

**Contents:**
- mix ash.extend (ash v3.7.6)
  - Ash.Domain
  - Ash.Resource
- Example

Adds an extension or extensions to the domain/resource

Extensions can either be a fully qualified module name, or one of the following list, based on the thing being extended

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
mix ash.extend My.Domain.Resource postgres,Ash.Policy.Authorizer
```

---

## Ash.Resource.Relationships.BelongsTo (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Ash.Resource.Relationships.BelongsTo.html

**Contents:**
- Ash.Resource.Relationships.BelongsTo (ash v3.7.6)
- Summary
- Types
- Types
- t()

Represents a belongs_to relationship on a resource

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## Multi-Step Actions

**URL:** https://hexdocs.pm/ash/multi-step-actions.html

**Contents:**
- Multi-Step Actions
- When to use hooks vs reactors vs generic actions
  - Durable Workflows
- Action Lifecycle Hooks
- Examples
  - Example 1: Simple Activity Logging
  - Example 2: Multi-Hook Ticket Assignment
  - Example 3: Complex Workflow with External Services
  - Shortcuts for hooks
    - Anonymous Function Changes

Actions in Ash allow you to create sophisticated workflows that coordinate multiple changes or processes. Often business logic crosses multiple resources, and we often want it to be transactional. By leveraging action lifecycle hooks, you can build powerful domain-specific operations. This guide will explore how to build and use multi-step actions using a helpdesk example.

For most use cases, hooks are the preferred approach due to their simplicity and tight integration with Ash's action lifecycle. Reactor is the comprehensive solution for truly complex orchestration scenarios. Additionally, you can write generic actions by hand, implementing an action with fully custom code. Reactors can be used as the run function for generic actions, giving them first class support in Ash extensions. See below for an example.

You should use hooks for most multi-step workflow scenarios as they provide simplicity and leverage Ash's transactional nature. The key decision point is whether you need compensation/rollback across external services:

Use generic actions when:

For durable workflows, we suggest to use Oban. We provide tools to integrate with Oban in AshOban. AshOban supports very specific types of common workflows, like "triggers" that run periodically for resources, and "scheduled actions" which run generic actions on a cron. You should not be afraid to write "standard" Oban jobs and code where possible. Don't bend over backwards trying to fit everything into AshOban.

At the core of Ash's multi-step action capability are action lifecycle hooks. These hooks allow you to run code at specific points during an action's execution:

before_transaction: Runs before the transaction is started. Useful for operations that should happen before the transaction, like external API calls.

before_action: Runs in the transaction, before the data layer is called. Perfect for side effects and expensive logic. This hook can be used with changesets and queries.

after_action: Runs in the transaction, after the data layer is called, only if the action is successful. Ideal for transactional side effects that should only happen on success. This hook can be used with changesets and queries.

after_transaction: Runs after the transaction completes, in both success and error cases. Ideal for operations that should happen regardless of the transaction outcome, and for operations that work with external services.

There are other hooks that we won't go into here, as they are rarely used

*[Content truncated]*

**Examples:**

Example 1 (python):
```python
defmodule HelpDesk.Changes.LogActivity do
  use Ash.Resource.Change

  @impl true
  def change(changeset, _opts, _context) do
    # Log activity after the ticket is successfully created
    Ash.Changeset.after_action(changeset, fn _changeset, ticket ->
      HelpDesk.ActivityLog.log("Ticket #{ticket.id} created: #{ticket.title}")
      {:ok, ticket}
    end)
  end
end
```

Example 2 (unknown):
```unknown
actions do
  create :create do
    accept [:title, :description]
    change HelpDesk.Changes.LogActivity
  end
end
```

Example 3 (python):
```python
defmodule HelpDesk.Changes.AssignTicket do
  use Ash.Resource.Change

  @impl true
  def change(changeset, _opts, _context) do
    changeset
    |> Ash.Changeset.before_action(&find_and_assign_agent/1)
    |> Ash.Changeset.after_action(&notify_assignment/2)
  end

  defp find_and_assign_agent(changeset) do
    case HelpDesk.AgentManager.find_available_agent() do
      {:ok, agent} ->
        changeset
        |> Ash.Changeset.force_change_attribute(:agent_id, agent.id)
        |> Ash.Changeset.force_change_attribute(:status, "assigned")
        |> Ash.Changeset.put_context(:assigned_agent, age
...
```

Example 4 (python):
```python
defmodule HelpDesk.Changes.ProcessUrgentTicket do
  use Ash.Resource.Change

  @impl true
  def change(changeset, _opts, _context) do
    changeset
    # uses before_transaction as it communicates with an external service
    # and we don't want to keep a transaction longer than necessary
    |> Ash.Changeset.before_transaction(&validate_external_services/1)
    # Prepare for processing transactionally
    |> Ash.Changeset.before_action(&prepare_urgent_processing/1)
    # Complete the workflow transactionally
    |> Ash.Changeset.after_action(&complete_urgent_workflow/2)
    # Perform success 
...
```

---

## Ash.DataLayer behaviour (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Ash.DataLayer.html

**Contents:**
- Ash.DataLayer behaviour (ash v3.7.6)
- Summary
- Types
- Callbacks
- Functions
- Types
- bulk_create_options()
- bulk_update_options()
- combination_type()
- data_layer_query()

The behaviour for backing resource actions with persistence layers.

The data layer of the resource, or nil if it does not have one

Whether or not the data layer supports a specific feature

Custom functions supported by the data layer of the resource

Whether or not lateral joins should be used for many to many relationships by default

Rolls back the current transaction

Wraps the execution of the function in a transaction with the resource's data_layer.

The data layer of the resource, or nil if it does not have one

Whether or not the data layer supports a specific feature

Custom functions supported by the data layer of the resource

Whether or not lateral joins should be used for many to many relationships by default

Rolls back the current transaction

Wraps the execution of the function in a transaction with the resource's data_layer.

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## Ash.Resource.ManualCreate.Context (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Ash.Resource.ManualCreate.Context.html

**Contents:**
- Ash.Resource.ManualCreate.Context (ash v3.7.6)
- Summary
- Types
- Types
- t()

The context passed into manual create action functions

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## Ash.Resource.Actions.Destroy (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Ash.Resource.Actions.Destroy.html

**Contents:**
- Ash.Resource.Actions.Destroy (ash v3.7.6)
- Summary
- Types
- Functions
- Types
- t()
- Functions
- transform(action)

Represents a destroy action on a resource.

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## Ash.Resource.ManualRelationship behaviour (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Ash.Resource.ManualRelationship.html

**Contents:**
- Ash.Resource.ManualRelationship behaviour (ash v3.7.6)
- Summary
- Callbacks
- Callbacks
- load(list, opts, context)
- select(opts)

A module to implement manual relationships.

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## Ash.Resource.Change.Builtins (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Ash.Resource.Change.Builtins.html

**Contents:**
- Ash.Resource.Change.Builtins (ash v3.7.6)
- Summary
- Functions
- Functions
- after_action(callback, opts \\ [])
- Example
- after_transaction(callback, opts \\ [])
- Example
- atomic_update(attribute, expr, opts \\ [])
- before_action(callback, opts \\ [])

Built in changes that are available to all resources

The functions in this module are imported by default in the actions section.

Directly attach an after_action function to the current change.

Directly attach an after_transaction function to the current change.

Updates an attribute using an expression. See Ash.Changeset.atomic_update/3 for more.

Directly attach a before_action function to the current change.

Directly attach a before_transaction function to the current change.

Cascade this resource's destroy action to a related resource's destroy action.

Cascade a resource's update action to a related resource's update action.

Passes the provided value into Ash.Changeset.ensure_selected/2

Applies a filter to the changeset. Has no effect for create actions.

Re-fetches the record being updated and locks it with the given type.

Re-fetches the record being updated and locks it for update.

Increments an attribute's value by the amount specified, which defaults to 1.

Passes the provided value into Ash.load after the action has completed.

Calls Ash.Changeset.manage_relationship/4 with the changeset and relationship provided, using the value provided for the named argument.

Apply an "optimistic lock" on a record being updated or destroyed.

Clears a change off of the changeset before the action runs.

Relates the actor to the data being changed, as the provided relationship.

Passes the provided value into Ash.Changeset.select/3

Sets the attribute to the value provided.

Merges the given query context.

Sets the attribute to the value provided if the attribute is not already being changed.

Updates an existing attribute change by applying a function to it.

Directly attach an after_action function to the current change.

See Ash.Changeset.after_action/3 for more information.

Provide the option prepend?: true to place the hook before all other hooks instead of after.

Directly attach an after_transaction function to the current change.

See Ash.Changeset.after_transaction/3 for more information.

Provide the option prepend?: true to place the hook before all other hooks instead of after.

Updates an attribute using an expression. See Ash.Changeset.atomic_update/3 for more.

Directly attach a before_action function to the current change.

See Ash.Changeset.before_action/3 for more information.

Provide the option prepend?: true to place the hook before all other hooks instead of after.

Directly attach a before_transaction function to the current c

*[Content truncated]*

**Examples:**

Example 1 (unknown):
```unknown
change after_action(fn changeset, record, _context ->
  Logger.debug("Successfully executed action #{changeset.action.name} on #{inspect(changeset.resource)}")
  {:ok, record}
end)
```

Example 2 (unknown):
```unknown
change after_transaction(fn
  changeset, {:ok, record}, _context ->
    Logger.debug("Successfully executed transaction for action #{changeset.action.name} on #{inspect(changeset.resource)}")
    {:ok, record}
  changeset, {:error, reason}, _context ->
    Logger.debug("Failed to execute transaction for action #{changeset.action.name} on #{inspect(changeset.resource)}, reason: #{inspect(reason)}")
    {:error, reason}
end)
```

Example 3 (unknown):
```unknown
change before_action(fn changeset, _context ->
  Logger.debug("About to execute #{changeset.action.name} on #{inspect(changeset.resource)}")

  changeset
end)
```

Example 4 (unknown):
```unknown
change before_transaction(fn changeset, _context ->
  Logger.debug("About to execute transaction for #{changeset.action.name} on #{inspect(changeset.resource)}")

  changeset
end)
```

---

## Ash.Resource.Relationships.HasMany (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Ash.Resource.Relationships.HasMany.html

**Contents:**
- Ash.Resource.Relationships.HasMany (ash v3.7.6)
- Summary
- Types
- Functions
- Types
- t()
- Functions
- manual(module)
- transform(relationship)

Represents a has_many relationship on a resource

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## Ash.Resource.Calculation.Context (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Ash.Resource.Calculation.Context.html

**Contents:**
- Ash.Resource.Calculation.Context (ash v3.7.6)
- Summary
- Types
- Types
- t()

The context and arguments of a calculation

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## Ash.Resource.Interface.CustomInput (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Ash.Resource.Interface.CustomInput.html

**Contents:**
- Ash.Resource.Interface.CustomInput (ash v3.7.6)
- Summary
- Types
- Functions
- Types
- t()
- Functions
- schema()

Represents a custom input to a code interface

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## Ash.Resource.Actions.Read.Pagination (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Ash.Resource.Actions.Read.Pagination.html

**Contents:**
- Ash.Resource.Actions.Read.Pagination (ash v3.7.6)
- Summary
- Types
- Functions
- Types
- t()
- Functions
- transform(pagination)

Represents the pagination configuration of a read action

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## Ash.Resource.Actions.Metadata (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Ash.Resource.Actions.Metadata.html

**Contents:**
- Ash.Resource.Actions.Metadata (ash v3.7.6)
- Summary
- Types
- Functions
- Types
- t()
- Functions
- schema()

Represents metadata from an action

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## Define Polymorphic Relationships

**URL:** https://hexdocs.pm/ash/polymorphic-relationships.html

**Contents:**
- Define Polymorphic Relationships
- Introduction
- Defining our Resources
- Defining our union type
- Defining the calculation
- Adding the calculation to our resource
- Taking it further

Something that comes up in more complex domains is the idea of "polymorphic relationships". For this example, we will use the concept of a BankAccount, which can be either a SavingsAccount or a CheckingAccount. All accounts have an account_number and transactions, but checkings & savings accounts might have their own specific information. For example, a SavingsAccount has an interest_rate, and a CheckingAccount has many debit_cards.

Ash does not support polymorphic relationships defined as relationships, but you can accomplish similar functionality via calculations with the type Ash.Type.Union.

For this tutorial, we will have a dedicated resource called BankAccount. I suggest taking that approach, as many things down the road will be simplified. With that said, you don't necessarily need to do that when there is no commonalities between the types. Instead of setting up the polymorphism on the BankAccount resource, you would define relationships to SavingsAccount and CheckingAccount directly.

This tutorial is not attempting to illustrate good design of accounting systems. We make many concessions for the sake of the simplicity of our example.

We haven't implemented the polymorphic part yet, but lets create a few of the above resources to show how they relate. Below we create a BankAccount for checkings, and a BankAccount for savings, and connect them to their "specific" types, i.e CheckingAccount and SavingsAccount.

We load the data, you can see that one BankAccount has a :checking_account but no :savings_account. For the other, the opposite is the case.

Below we define an Ash.Type.NewType. This allows defining a new type that is the combination of an existing type and custom constraints.

Next, we'll define a calculation resolves to the specific type of any given account.

Finally, we'll add the calculation to our BankAccount resource!

For those following along with the LiveBook, go back up and uncomment the commented out calculation.

Now we can load :implementation and see that, for one account, it resolves to a CheckingAccount and for the other it resolves to a SavingsAccount.

One of the best things about using Ash.Type.Union is how it is integrated. Every extension (provided by the Ash team) supports working with unions. For example:

You can also synthesize filterable fields with calculations. For example, if you wanted to allow filtering BankAccount by :interest_rate, and that field only existed on SavingsAccount, you might have a calculation

*[Content truncated]*

**Examples:**

Example 1 (unknown):
```unknown
Mix.install([{:ash, "~> 3.0"}], consolidate_protocols: false)
```

Example 2 (unknown):
```unknown
defmodule BankAccount do
  use Ash.Resource,
    domain: Finance,
    data_layer: Ash.DataLayer.Ets

  actions do
    defaults [:read, :destroy, create: [:account_number, :type]]
  end

  attributes do
    uuid_primary_key :id

    attribute :account_number, :integer, allow_nil?: false
    attribute :type, :atom, constraints: [one_of: [:checking, :savings]]
  end

  # calculations do
  #   calculate :implementation, AccountImplementation, GetAccountImplementation do
  #    allow_nil? false
  #  end
  # end

  relationships do
    has_one :checking_account, CheckingAccount
    has_one :savings_
...
```

Example 3 (unknown):
```unknown
{:module, Finance, <<70, 79, 82, 49, 0, 0, 44, ...>>,
 [
   Ash.Domain.Dsl.Resources.Resource,
   Ash.Domain.Dsl.Resources.Options,
   %{opts: [], entities: [%Ash.Domain.Dsl.ResourceReference{...}, ...]}
 ]}
```

Example 4 (unknown):
```unknown
bank_account1 = Ash.create!(BankAccount, %{account_number: 1, type: :checking})
bank_account2 = Ash.create!(BankAccount, %{account_number: 2, type: :savings})
checking_account = Ash.create!(CheckingAccount, %{bank_account_id: bank_account1.id})
savings_account = Ash.create!(SavingsAccount, %{bank_account_id: bank_account2.id})

[bank_account1, bank_account2] |> Ash.load!([:checking_account, :savings_account])
```

---

## Ash.Resource.Actions.Read (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Ash.Resource.Actions.Read.html

**Contents:**
- Ash.Resource.Actions.Read (ash v3.7.6)
- Summary
- Types
- Functions
- Types
- t()
- Functions
- pagination_schema()
- transform(read)

Represents a read action on a resource.

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## Domains

**URL:** https://hexdocs.pm/ash/domains.html

**Contents:**
- Domains
- Grouping Resources
- Centralized Code Interface
- Configuring Cross-cutting Concerns
  - Built in configuration
  - Extensions
  - Policies

Domains serve three primary purposes:

If you are familiar with a Phoenix Context, you can think of a domain as the Ash equivalent.

In an Ash.Domain, you will typically see something like this:

With this definition, you can do things like placing all of these resources into a GraphQL Api with AshGraphql. You'd see a line like this:

Working with our domain & resources in code can be done the long form way, by building changesets/queries/action inputs and calling the relevant function in Ash. However, we generally want to expose a well defined code API for working with our resources. This makes our code much clearer, and gives us nice things like auto complete and inline documentation.

With these definitions, we can now do things like this:

Ash.Domain comes with a number of built-in configuration options. See Ash.Domain for more.

Extensions will often come with "domain extensions" to allow you to configure the behavior of all resources within a domain, as it pertains to that extension. For example:

You can also use Ash.Policy.Authorizer on your domains. This allows you to add policies that apply to all actions using this domain. For example:

Hex Package Hex Preview (current file) Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
defmodule MyApp.Tweets do
  use Ash.Domain

  resources do
    resource MyApp.Tweets.Tweet
    resource MyApp.Tweets.Comment
  end
end
```

Example 2 (unknown):
```unknown
use AshGraphql, domains: [MyApp.Tweets]
```

Example 3 (unknown):
```unknown
defmodule MyApp.Tweets do
  use Ash.Domain

  resources do
    resource MyApp.Tweets.Tweet do
      # define a function called `tweet` that uses
      # the `:create` action on MyApp.Tweets.Tweet
      define :tweet, action: :create, args: [:text]
    end

    resource MyApp.Tweets.Comment do
      # define a function called `comment` that uses
      # the `:create` action on MyApp.Tweets.Comment
      define :comment, action: :create, args: [:tweet_id, :text]
    end
  end
end
```

Example 4 (unknown):
```unknown
tweet = MyApp.Tweets.tweet!("My first tweet!", actor: user1)
comment = MyApp.Tweets.comment!(tweet.id, "What a cool tweet!", actor: user2)
```

---

## Ash.Resource

**URL:** https://hexdocs.pm/ash/dsl-ash-resource.html

**Contents:**
- Ash.Resource
- attributes
  - Nested DSLs
  - Examples
  - attributes.attribute
  - Examples
  - Arguments
  - Options
  - Introspection
  - attributes.create_timestamp

A section for declaring attributes on the resource.

Declares an attribute on the resource.

Target: Ash.Resource.Attribute

Declares a non-writable attribute with a create default of &DateTime.utc_now/0

Accepts all the same options as Ash.Resource.Dsl.attributes.attribute, except it sets the following different defaults:

Target: Ash.Resource.Attribute

Declares a non-writable attribute with a create and update default of &DateTime.utc_now/0

Accepts all the same options as Ash.Resource.Dsl.attributes.attribute, except it sets the following different defaults:

Target: Ash.Resource.Attribute

Declares a generated, non writable, non-nil, primary key column of type integer.

Generated integer primary keys must be supported by the data layer.

Accepts all the same options as Ash.Resource.Dsl.attributes.attribute, except for allow_nil?, but it sets the following different defaults:

Target: Ash.Resource.Attribute

Declares a non writable, non-nil, primary key column of type uuid, which defaults to Ash.UUID.generate/0.

Accepts all the same options as Ash.Resource.Dsl.attributes.attribute, except for allow_nil?, but it sets the following different defaults:

Target: Ash.Resource.Attribute

Declares a non writable, non-nil, primary key column of type uuid_v7, which defaults to Ash.UUIDv7.generate/0.

Accepts all the same options as Ash.Resource.Dsl.attributes.attribute, except for allow_nil?, but it sets the following different defaults:

Target: Ash.Resource.Attribute

A section for declaring relationships on the resource.

Relationships are a core component of resource oriented design. Many components of Ash will use these relationships. A simple use case is loading relationships (done via the Ash.Query.load/2).

See the relationships guide for more.

Declares a has_one relationship. In a relational database, the foreign key would be on the other table.

Generally speaking, a has_one also implies that the destination table is unique on that foreign key.

See the relationships guide for more.

Applies a filter. Can use ^arg/1, ^context/1 and ^actor/1 templates. Multiple filters are combined with and.

Target: Ash.Resource.Dsl.Filter

Target: Ash.Resource.Relationships.HasOne

Declares a has_many relationship. There can be any number of related entities.

See the relationships guide for more.

Applies a filter. Can use ^arg/1, ^context/1 and ^actor/1 templates. Multiple filters are combined with and.

Target: Ash.Resource.Dsl.Filter

Target: Ash.Resource.Relat

*[Content truncated]*

**Examples:**

Example 1 (unknown):
```unknown
attributes do
  uuid_primary_key :id

  attribute :first_name, :string do
    allow_nil? false
  end

  attribute :last_name, :string do
    allow_nil? false
  end

  attribute :email, :string do
    allow_nil? false

    constraints [
      match: ~r/^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+.[a-zA-Z0-9-.]+$/
    ]
  end

  attribute :type, :atom do
    constraints [
      one_of: [:admin, :teacher, :student]
    ]
  end

  create_timestamp :inserted_at
  update_timestamp :updated_at
end
```

Example 2 (unknown):
```unknown
attribute name, type
```

Example 3 (unknown):
```unknown
attribute :name, :string do
  allow_nil? false
end
```

Example 4 (unknown):
```unknown
create_timestamp name
```

---

## Test Resources

**URL:** https://hexdocs.pm/ash/test-resources.html

**Contents:**
- Test Resources
- Introduction
- Testing Resources
- Examples
- Create a generator
- Write some tests

We recommend testing your resources thoroughly. Often, folks think that testing an Ash.Resource is "testing the framework", and in some very simple cases this may be true, like a simple create that just accepts a few attributes.

However, testing has two primary roles:

To this end, we highly recommend writing tests even for your simple actions. A single test that confirms that, with simple inputs, the action returns what you expect, can be very powerful.

Additionally, Ash offers unique ways of testing individual components of our resources, similar to a unit test.

While you don't necessarily need to follow all steps below, we show the various ways you may want to go about testing your resources.

See Ash.Generator documentation for more examples and docs.

Hex Package Hex Preview (current file) Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
Application.put_env(:stream_data, :max_runs, 10)
Mix.install([{:ash, "~> 3.0"}, {:simple_sat, "~> 0.1"}],
  consolidate_protocols: false
)

Logger.configure(level: :warning)
ExUnit.start()
```

Example 2 (unknown):
```unknown
defmodule User do
  use Ash.Resource,
    domain: Domain,
    data_layer: Ash.DataLayer.Ets

  actions do
    defaults [:read, create: [:admin?]]
  end

  attributes do
    uuid_primary_key :id
    attribute :admin?, :boolean do
      allow_nil? false
      default false
    end
  end
end

defmodule Tweet do
  use Ash.Resource,
    domain: Domain,
    data_layer: Ash.DataLayer.Ets,
    authorizers: [Ash.Policy.Authorizer]

  attributes do
    uuid_primary_key :id
    attribute :text, :string do
      allow_nil? false
      constraints max_length: 144
      public? true
    end

    attribute :
...
```

Example 3 (unknown):
```unknown
{:module, Domain, <<70, 79, 82, 49, 0, 1, 110, ...>>,
 [
   Ash.Domain.Dsl.Resources.Resource,
   Ash.Domain.Dsl.Resources.Options,
   %{opts: [], entities: [%Ash.Domain.Dsl.ResourceReference{...}, ...]}
 ]}
```

Example 4 (python):
```python
defmodule Generator do
  use Ash.Generator

  def user(opts \\ []) do
    changeset_generator(
      User,
      :create,
      overrides: opts,
      actor: opts[:actor]
    ) 
  end

  def tweet(opts \\ []) do
    changeset_generator(
      Tweet,
      :create,
      overrides: opts,
      actor: opts[:actor]
    ) 
  end
end
```

---

## Ash.Resource.Actions.Implementation behaviour (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Ash.Resource.Actions.Implementation.html

**Contents:**
- Ash.Resource.Actions.Implementation behaviour (ash v3.7.6)
  - Example
- Summary
- Callbacks
- Functions
- Callbacks
- run(t, opts, t)
- Functions
- run(module, action_input, opts, context)

An implementation of a generic action.

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

**Examples:**

Example 1 (python):
```python
defmodule YourModule do
  use Ash.Resource.Actions.Implementation

  def run(input, opts, context) do
    {:ok, "Hello"}
  end
end
```

---

## mix ash.gen.base_resource (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Mix.Tasks.Ash.Gen.BaseResource.html

**Contents:**
- mix ash.gen.base_resource (ash v3.7.6)
- Example

Generates a base resource

See the writing extensions guide for more.

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
mix ash.gen.base_resource MyApp.Resource
```

---

## Ash.Resource.Actions.Action (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Ash.Resource.Actions.Action.html

**Contents:**
- Ash.Resource.Actions.Action (ash v3.7.6)
- Summary
- Types
- Functions
- Types
- t()
- Functions
- transform(action)

Represents a custom action on a resource.

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## Ash.Resource (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Ash.Resource.html

**Contents:**
- Ash.Resource (ash v3.7.6)
  - Options
- Summary
- Types
- Functions
- Types
- record()
- t()
- Functions
- get_metadata(record, key_or_path)

A resource is a static definition of an entity in your system.

Resource DSL documentation

:simple_notifiers (list of module that adopts Ash.Notifier) - Notifiers with no DSL.

:validate_domain_inclusion? (boolean/0) - Whether or not to validate that this resource is included in a domain. The default value is true.

:primary_read_warning? (boolean/0) - Set to false to silence warnings about arguments, preparations and filters on the primary read action. The default value is true.

:domain (module that adopts Ash.Domain) - The domain to use when interacting with this resource. Also sets defaults for various options that ask for a domain.

:embed_nil_values? (boolean/0) - Whether or not to include keys with nil values in an embedded representation. Has no effect unless resource is an embedded resource. The default value is true.

:extensions (list of module that adopts Spark.Dsl.Extension) - A list of DSL extensions to add to the Spark.Dsl

:data_layer (module that adopts Ash.DataLayer) - data_layer extensions to add to the Spark.Dsl The default value is Ash.DataLayer.Simple.

:authorizers (one or a list of module that adopts Ash.Authorizer) - authorizers extensions to add to the Spark.Dsl The default value is [].

:notifiers (one or a list of module that adopts Ash.Notifier) - notifiers extensions to add to the Spark.Dsl The default value is [].

:otp_app (atom/0) - The otp_app to use for any application configurable options

:fragments (list of module/0) - Fragments to include in the Spark.Dsl. See the fragments guide for more.

Returns true if the load or path to load has been loaded

Returns true if the given field has been selected on a record

Defines create and update timestamp attributes.

Sets a loaded key or path to a key back to its original unloaded stated

Sets a list of loaded key or paths to a key back to their original unloaded stated

Returns true if the load or path to load has been loaded

Returns true if the given field has been selected on a record

Defines create and update timestamp attributes.

Shorthand for Ash.Resource.Dsl.attributes.create_timestamp and Ash.Resource.Dsl.attributes.update_timestamp with the attribute names :inserted_at and :updated_at respectively. Any options passed to this helper are passed to both timestamp macros.

Sets a loaded key or path to a key back to its original unloaded stated

Sets a list of loaded key or paths to a key back to their original unloaded stated

Hex Package Hex Preview Search HexDocs Dow

*[Content truncated]*

---

## Relationships

**URL:** https://hexdocs.pm/ash/relationships.html

**Contents:**
- Relationships
- Relationships Basics
- Kinds of relationships
  - Belongs To
    - Attribute Defaults
    - Customizing default belongs_to attribute type
  - Has One
    - Attribute Defaults
  - Has Many
    - Attribute Defaults

Relationships describe the connections between resources and are a core component of Ash. Defining relationships enables you to do things like

A relationship exists between a source resource and a destination resource. These are defined in the relationships block of the source resource. For example, if MyApp.Tweet is the source resource, and MyApp.User is the destination resource, we could define a relationship called :owner like this:

There are four kinds of relationships:

Each of these relationships has a source resource and a destination resource with a corresponding attribute on the source resource (source_attribute), and destination resource (destination_attribute). Relationships will validate that their configured attributes exist at compile time.

You don't need to have a corresponding "reverse" relationship for every relationship, i.e if you have a MyApp.Tweet resource with belongs_to :user, MyApp.User you aren't required to have a has_many :tweets, MyApp.Tweet on MyApp.User. All that is required is that the attributes used by the relationship exist.

A belongs_to relationship means that there is an attribute (source_attribute) on the source resource that uniquely identifies a record with a matching attribute (destination_attribute) in the destination. In the example above, the source attribute on MyApp.Tweet is :owner_id and the destination attribute on MyApp.User is :id.

By default, the source_attribute is defined as :<relationship_name>_id of the type :uuid on the source resource and the destination_attribute is assumed to be :id. You can override the attribute names by specifying the source_attribute and destination_attribute options like so:

You can further customize the source_attribute using options such as:

Or if you wanted to define the attribute yourself,

Destination attributes that are added by default are assumed to be :uuid. To change this, set the following configuration in config.exs:

See the docs for more: Ash.Resource.Dsl.relationships.belongs_to

A has_one relationship means that there is a unique attribute (destination_attribute) on the destination resource that identifies a record with a matching unique attribute (source_resource) in the source. In the example above, the source attribute on MyApp.User is :id and the destination attribute on MyApp.Profile is :user_id.

A has_one is similar to a belongs_to except the reference attribute is on the destination resource, instead of the source.

has_one is specially useful whe

*[Content truncated]*

**Examples:**

Example 1 (unknown):
```unknown
defmodule MyApp.Tweet do
  use Ash.Resource,
    data_layer: my_data_layer

  attributes do
    uuid_primary_key :id
    attribute :body, :string
  end

  relationships do
    belongs_to :owner, MyApp.User
  end
end
```

Example 2 (unknown):
```unknown
# on MyApp.Tweet
belongs_to :owner, MyApp.User
```

Example 3 (unknown):
```unknown
belongs_to :owner, MyApp.User do
  # defaults to :<relationship_name>_id (i.e. :owner_id)
  source_attribute :custom_attribute_name

  # defaults to :id
  destination_attribute :custom_attribute_name
end
```

Example 4 (unknown):
```unknown
belongs_to :owner, MyApp.User do
  attribute_type :integer
  attribute_writable? false
end
```

---

## Attributes

**URL:** https://hexdocs.pm/ash/attributes.html

**Contents:**
- Attributes
- Special attributes
  - create_timestamp
  - update_timestamp
  - uuid_primary_key
  - integer_primary_key

Attributes specify the name, type and additional configuration of a simple property of a record. When using SQL data layers, for example, an attribute would correspond to a column in a database table. For information on types, see Ash.Type.

To see all of the options available when building attributes, see Ash.Resource.Dsl.attributes.attribute

If you are looking to compute values on demand, see the Calculations guide and the aggregates guide.

In Ash there are 4 special attributes these are:

These are really just shorthand for an attribute with specific options set. They're outlined below.

You may recognise this if you have used Ecto before. This attribute will record the time at which each row is created, by default it uses DateTime.utc_now/1.

create_timestamp :inserted_at is equivalent to an attribute with these options:

This is also similar in Ecto. This attribute records the last time a row was updated, also using DateTime.utc_now/1 by default.

update_timestamp :updated_at is equivalent to:

This attribute is used in almost every resource. It generates a UUID every time a new record is made. uuid_primary_key :id is equivalent to:

Creates a generated integer primary key. Keep in mind that not all data layers support auto incrementing ids, but for SQL data layers this is a very common practice. For those that don't, it is your own job to provide values for the primary key. We generally suggest using UUIDs over integers, as there are a lot of good reasons to not use autoincrementing integer ids.

integer_primary_key :id is equivalent to:

Hex Package Hex Preview (current file) Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
attribute :inserted_at, :utc_datetime_usec do
  writable? false
  default &DateTime.utc_now/0
  match_other_defaults? true
  allow_nil? false
end
```

Example 2 (unknown):
```unknown
attribute :updated_at, :utc_datetime_usec do
  writable? false
  default &DateTime.utc_now/0
  update_default &DateTime.utc_now/0
  match_other_defaults? true
  allow_nil? false
end
```

Example 3 (unknown):
```unknown
attribute :id, :uuid do
  writable? false
  default &Ash.UUID.generate/0
  primary_key? true
  allow_nil? false
end
```

Example 4 (unknown):
```unknown
attribute :id, :integer do
  writable? false
  generated? true
  primary_key? true
  allow_nil? false
end
```

---

## Ash.Error.Changes.InvalidAttribute exception (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Ash.Error.Changes.InvalidAttribute.html

**Contents:**
- Ash.Error.Changes.InvalidAttribute exception (ash v3.7.6)
- Summary
- Functions
- Functions
- exception(msg)
- Keys

Used when an invalid value is provided for an attribute change

Create an Elixir.Ash.Error.Changes.InvalidAttribute without raising it.

Create an Elixir.Ash.Error.Changes.InvalidAttribute without raising it.

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## Ash.Resource.Change behaviour (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Ash.Resource.Change.html

**Contents:**
- Ash.Resource.Change behaviour (ash v3.7.6)
- Summary
- Types
- Callbacks
- Functions
- Types
- context()
- ref()
- t()
- Callbacks

The behaviour for an action-specific resource change.

init/1 is defined automatically by use Ash.Resource.Change, but can be implemented if you want to validate/transform any options passed to the module.

The main function is change/3. It takes the changeset, any options that were provided when this change was configured on a resource, and the context, which currently only has the actor.

Runs on each batch result after it is dispatched to the data layer.

Whether or not batch callbacks should be run (if they are defined). Defaults to true.

Replaces change/3 for batch actions, allowing to optimize changes for bulk actions.

Runs on each batch before it is dispatched to the data layer.

Runs on each batch result after it is dispatched to the data layer.

Whether or not batch callbacks should be run (if they are defined). Defaults to true.

Replaces change/3 for batch actions, allowing to optimize changes for bulk actions.

You can define only batch_change/3, and it will be used for both single and batch actions. It cannot, however, be used in place of the atomic/3 callback.

Runs on each batch before it is dispatched to the data layer.

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## Identities

**URL:** https://hexdocs.pm/ash/identities.html

**Contents:**
- Identities
- Defining an identity
- Using Ash.get
- Using upserts
- Creating unique constraints
- Eager Checking
- Pre Checking

Identities are a way to declare that a record (an instance of a resource) can be uniquely identified by a set of attributes. This information can be used in various ways throughout the framework. The primary key of the resource does not need to be listed as an identity.

Identities are defined at the top level of a resource module, eg.

See Ash.Resource.Dsl.identities for the full range of options available when defining identities.

This will allow these fields to be passed to Ash.get/3, e.g Ash.get(Resource, %{email: "foo"}).

Create actions support the upsert?: true option, if the data layer supports it. An upsert? involves checking for a conflict on some set of attributes, and translating the behavior to an update in the case one is found. By default, the primary key is used when looking for duplicates, but you can set [upsert?: true, upsert_identity: :identity_name] to tell it to look for conflicts on a specific identity.

Tools like AshPostgres will create unique constraints in the database automatically for each identity. These unique constraints will honor other configuration on your resource, like the base_filter and attribute multitenancy

Setting eager_check?: true on an identity will allow that identity to be checked when building a create changeset over the resource. This allows for showing quick up-front validations about whether some value is taken, for example. If the resource does not have the domain configured, you can specify the domain to use with eager_check_with: DomainName.

If you are using AshPhoenix.Form, for example, this looks for a conflicting record on each call to Form.validate/2. For updates, it is only checked if one of the involved fields is being changed.

For creates, The identity is checked unless your are performing an upsert, and the upsert_identity is this identity. Keep in mind that for this to work properly, you will need to pass the upsert?: true, upsert_identity: :identity_name when creating the changeset. The primary? read action is used to search for a record. This will error if you have not configured one.

pre_check? behaves the same as eager_check?, but it runs just prior to the action being committed. Useful for data layers that don't support transactions/unique constraints, or manual resources with identities. Ash.DataLayer.Ets will require you to set pre_check? since the ETS data layer has no built in support for unique constraints. The domain can be manually specified with pre_check_with: DomainName.

He

*[Content truncated]*

**Examples:**

Example 1 (unknown):
```unknown
defmodule MyApp.MyResource do
  use Ash.Resource #, ...
  # ...

  identities do
    # If the `email` attribute must be unique across all records
    identity :unique_email, [:email]

    # If the `username` attribute must be unique for every record with a given `site` value
    identity :special_usernames, [:username, :site]

    # If the `user_id` field should hold the errors for the uniqueness violation
    identity :unique_email, [:email], field_names: [:user_id]
  end
end
```

---

## Ash.Resource.Interface (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Ash.Resource.Interface.html

**Contents:**
- Ash.Resource.Interface (ash v3.7.6)
- Summary
- Types
- Functions
- Types
- t()
- Functions
- calculate_opts()
- Options
- create_opts()

Represents a function in a resource's code interface

See the functions defined in this module for specifications of the options that each type of code interface function supports in its options list.

Options supported by code interfaces for calculations

Options supported by code interfaces for create actions

Options supported by code interfaces for destroy actions

Options supported by code interfaces for generic actions

Options supported by code interfaces for read actions with get? or get_by set.

Options supported by code interfaces for read actions

Options supported by code interfaces for update actions

Options supported by code interfaces for calculations

:actor (term/0) - The actor for handling ^actor/1 templates, supplied to calculation context.

:scope (term/0) - A value that implements the Ash.Scope.ToOpts protocol. Will overwrite any actor, tenant or context provided. See Ash.Context for more.

:tenant (value that implements the Ash.ToTenant protocol) - The tenant, supplied to calculation context.

:context (map/0) - Context to set on the calculation input.

:authorize? (boolean/0) - Whether or not the request is being authorized, provided to calculation context. The default value is true.

:tracer (one or a list of module that adopts Ash.Tracer) - A tracer, provided to the calculation context.

:data_layer? (boolean/0) - Set to true to require that the value be computed within the data layer. Only works for calculations that define an expression.

:reuse_values? (boolean/0) - Set to true to reuse existing values on any provided record. Only necessary if providing a record as the basis for calculation. The default value is false.

Options supported by code interfaces for create actions

:upsert? (boolean/0) - If a conflict is found based on the primary key, the record is updated in the database (requires upsert support) The default value is false.

:return_skipped_upsert? (boolean/0) - If true, and a record was not upserted because its filter prevented the upsert, the original record (which was not upserted) will be returned. The default value is false.

:upsert_identity (atom/0) - The identity to use when detecting conflicts for upsert?, e.g. upsert_identity: :full_name. By default, the primary key is used. Has no effect if upsert?: true is not provided

:upsert_fields - The fields to upsert. If not set, the action's upsert_fields is used, and if that is not set, then any fields not being set to defaults are written.

:upsert_condition (

*[Content truncated]*

---

## Ash.Seed (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Ash.Seed.html

**Contents:**
- Ash.Seed (ash v3.7.6)
- Summary
- Functions
- Functions
- keep_nil()
- seed!(input)
- seed!(resource, input, opts \\ [])
- skip()
- update!(record, input, opts \\ [])
- upsert!(input, opts \\ [])

Helpers for seeding data, useful for quickly creating lots of data either for database seeding or testing.

Important: this bypasses resource actions, and goes straight to the data layer. No action changes or validations are run. The only thing that it does at the moment is ensure that default values for attributes are set, it does not validate that required attributes are set (although the data layer may do that for you, e.g with ash_postgres).

Returns :__keep_nil__, allowing to ensure a default value is not used when you want the value to be nil.

Seed using a record (instance of a resource) as input.

Performs a direct call to the data layer of a resource with the provided input.

Returns :__skip__, allowing to ensure no value is generated for a given field when used with generators.

Usage is the same as seed!/2, but it will update an existing record.

Performs an upsert operation on the data layer of a resource with the provided input and identities. The usage is the same as seed!/1, but it will update the record if it already exists.

Usage is the same as seed!/2, but it will update the record if it already exists based on the identities.

Returns :__keep_nil__, allowing to ensure a default value is not used when you want the value to be nil.

Seed using a record (instance of a resource) as input.

If the passed in struct was retrieved from the data layer already (i.e already seeded), then it is returned and nothing is done. Otherwise, the attributes and relationships are used as input to seed/2, after having any %Ash.NotLoaded{} values stripped out.

Any nil values will be overwritten with their default values. To avoid this, either use seed/2 in which providing the key will have it not set the default values. If you want to force nil to be accepted and prevent the default value from being set, use the keep_nil/0 function provided here, which returns :__keep_nil__. Alternatively, use seed!(Post, %{text: nil}).

See seed!/2 for more information.

Performs a direct call to the data layer of a resource with the provided input.

If a list is provided as input, then you will get back that many results.

To set a tenant, use the tenant option.

Returns :__skip__, allowing to ensure no value is generated for a given field when used with generators.

Usage is the same as seed!/2, but it will update an existing record.

For multitenant resources, tenant will be extracted from the record if not provided in opts.

Performs an upsert operation on the data laye

*[Content truncated]*

**Examples:**

Example 1 (unknown):
```unknown
Ash.Seed.upsert!(%User{email: 'test@gmail.com', name: 'Test'}, identity: :email)
```

---

## Ash.Resource.Aggregate (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Ash.Resource.Aggregate.html

**Contents:**
- Ash.Resource.Aggregate (ash v3.7.6)
- Summary
- Types
- Types
- t()

Represents a named aggregate on the resource that can be loaded

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## Ash.Resource.Relationships (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Ash.Resource.Relationships.html

**Contents:**
- Ash.Resource.Relationships (ash v3.7.6)
- Summary
- Types
- Types
- cardinality()
- relationship()
- type()

Types Ash relationships

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## Ash.Resource.Attribute (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Ash.Resource.Attribute.html

**Contents:**
- Ash.Resource.Attribute (ash v3.7.6)
- Summary
- Types
- Functions
- Types
- t()
- Functions
- create_timestamp_schema()
- integer_primary_key_schema()
- transform(attribute)

Represents an attribute on a resource

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## Ash.Resource.ManualDestroy.Context (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Ash.Resource.ManualDestroy.Context.html

**Contents:**
- Ash.Resource.ManualDestroy.Context (ash v3.7.6)
- Summary
- Types
- Types
- t()

The context passed into manual update action functions

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## Ash.Resource.Validation.Builtins (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Ash.Resource.Validation.Builtins.html

**Contents:**
- Ash.Resource.Validation.Builtins (ash v3.7.6)
- Summary
- Functions
- Functions
- absent(attributes, opts \\ [])
- Options
- Examples
- action_is(action)
- Examples
- any(validations)

Built in validations that are available to all resources

The functions in this module are imported by default in the validations section.

Validates that the given attribute or argument or list of attributes or arguments are nil.

Validates that the action name matches the provided action name or names. Primarily meant for use in where.

Validates that at least one of the provided validations passes

Validates that an argument is not being changed to a specific value, or does not equal the given value if it is not being changed.

Validates that an argument is being changed to a specific value, or equals the given value if it is not being changed.

Validates that an argument is being changed to one of a set of specific values, or is in the the given list if it is not being changed.

Validates that an attribute is not being changed to a specific value, or does not equal the given value if it is not being changed.

Validates that an attribute is being changed to a specific value, or equals the given value if it is not being changed.

Validates that an attribute is being changed to one of a set of specific values, or is in the the given list if it is not being changed.

Validates that the attribute or list of attributes are nil. See absent/2 for more information.

Validates that the attribute or list of attributes are not nil. See present/2 for more information.

Validates that an attribute or relationship is being changed

Validates that an attribute or argument meets the given comparison criteria.

Validates that a field or argument matches another field or argument

Validates that the original value is in a given list

Validates that an attribute's value matches a given regex.

Validates that other validation does not pass

Validates that an attribute or argument meets the given comparison criteria.

Validates that an attribute's value is in a given list

Validates that the given attribute or argument or list of attributes or arguments are not nil.

Validates that an attribute on the original record meets the given length criteria

Validates that the given attribute or argument or list of attributes or arguments are nil.

This is the inverse of present/2.

Use options to specify how many must be nil. If no options are provided, validates that they are all absent.

Keep in mind that some types cast certain values to nil, and validations are applied after all inputs have been cast. For example, a :string type attribute with the default constraints will cast 

*[Content truncated]*

**Examples:**

Example 1 (unknown):
```unknown
validate absent(:unsettable_option)

validate absent([:first_name, :last_name]), where: [present(:full_name)]

validate absent([:is_admin, :is_normal_user], at_least: 1)
```

Example 2 (unknown):
```unknown
validate present(:foo), where: [action_is(:bar)]

validate present(:foo), where: action_is([:bar, :baz])
```

Example 3 (unknown):
```unknown
validate any([
  one_of(:status, [:valid]),
  match(:title, "^[a-z]+$")
])
```

Example 4 (unknown):
```unknown
validate argument_does_not_equal(:admin, true)

# Or to only check for changing to a given value
validate argument_does_not_equal(:admin, true), where: [changing(:admin)]
```

---

## Ash.Resource.Actions (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Ash.Resource.Actions.html

**Contents:**
- Ash.Resource.Actions (ash v3.7.6)
- Summary
- Types
- Types
- action()
- action_type()

Types for Ash actions

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## Embedded Resources

**URL:** https://hexdocs.pm/ash/embedded-resources.html

**Contents:**
- Embedded Resources
- Consider Simpler Alternatives
  - Ash.TypedStruct
  - Ash.Type.Struct
- Example Embedded Resource
  - Embedded resources can't do everything
- Adding embedded resource attributes
- Handling nil values
- Editing embedded attributes
- Calculations

Embedded resources are stored as maps in attributes of other resources. They are great for storing structured data, and support a whole range of useful features that resources support. For example, you can have calculations, validations, policies and even relationships on embedded resources.

Before creating a full embedded resource, consider if one of these simpler options might meet your needs:

For simple structured data with type validation but without the need for calculations, validations, or policies:

For when you need a generic struct type with field specifications:

Use embedded resources when you need the full power of Ash resources, including actions, calculations, validations, and policies.

Here is an example of a simple embedded resource:

Embedded resources cannot have aggregates, or expression calculations that rely on data-layer-specific capabilities.

Embedded resources define an Ash.Type under the hood, meaning you can use them anywhere you would use an Ash type.

By default, all fields on an embedded resource will be included in the data layer, including keys with nil values. To prevent this, add the embed_nil_values? option to use Ash.Resource. For example:

If you manually supply instances of the embedded structs, the structs you provide are used with no validation. For example:

However, you can also treat embedded resources like regular resources that can be "created", "updated", and "destroyed". To do this, provide maps as the input, instead of structs. In the example above, if you just wanted to change the first_name, you'd provide:

This will call the primary update action on the resource. This allows you to define an action on the embed, and add validations to it. For example, you might have something like this:

Calculations can be added to embedded resources. When you use an embedded resource, you declare what calculations to load via a constraint. For example:

Remember: default actions are already implemented for a resource, with no need to add them. They are called :create, :update, :destroy, and :read. You can use those without defining them. You only need to define them if you wish to override their configuration.

All values in the original array are destroyed, and all maps in the new array are used to create new records.

Adding a primary key to your embedded resources is especially useful when managing lists of data. Specifically, it allows you to consider changes to elements with matching primary key values as update

*[Content truncated]*

**Examples:**

Example 1 (unknown):
```unknown
defmodule MyApp.Address do
  use Ash.TypedStruct

  typed_struct do
    field :street, :string, allow_nil?: false
    field :city, :string, allow_nil?: false
    field :state, :string, constraints: [max_length: 2]
    field :zip, :string, constraints: [match: ~r/^\d{5}$/]
  end
end
```

Example 2 (unknown):
```unknown
attribute :address, :struct do
  constraints fields: [
    street: [type: :string, allow_nil?: false],
    city: [type: :string, allow_nil?: false],
    state: [type: :string, constraints: [max_length: 2]],
    zip: [type: :string, constraints: [match: ~r/^\d{5}$/]]
  ]
end
```

Example 3 (unknown):
```unknown
defmodule MyApp.Profile do
  use Ash.Resource,
    data_layer: :embedded # Use the atom `:embedded` as the data layer.

  attributes do
    attribute :first_name, :string, public?: true
    attribute :last_name, :string, public?: true
  end
end
```

Example 4 (unknown):
```unknown
defmodule MyApp.User do
  use Ash.Resource, ...

  attributes do
    ...

    attribute :profile, MyApp.Profile, public?: true
    attribute :profiles, {:array, MyApp.Profile}, public?: true # You can also have an array of embeds
  end
end
```

---
