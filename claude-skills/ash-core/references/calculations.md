# Ash-Core - Calculations

**Pages:** 4

---

## Calculations

**URL:** https://hexdocs.pm/ash/calculations.html

**Contents:**
- Calculations
- Primer
- Declaring calculations on a resource
  - Expression Calculations
  - Module Calculations
- Custom calculations in the query
- Arguments in calculations
- Loading Calculations
  - Loading with a custom name
  - Loading "through" calculations

Calculations in Ash allow for displaying complex values as a top level value of a resource.

The simplest kind of calculation refers to an Ash expression. For example:

See the Expressions guide for more.

When calculations require more complex code or can't be pushed down into the data layer, a module that uses Ash.Resource.Calculation can be used.

See the documentation for the calculations section in Resource DSL docs and the Ash.Resource.Calculation docs for more information.

The calculations declared on a resource allow for declaring a set of named calculations that can be used by extensions. They can also be loaded in the query using Ash.Query.load/2, or after the fact using Ash.load/3. Calculations declared on the resource will be keys in the resource's struct.

See the documentation for Ash.Query.calculate/4 for more information.

Using the above example with arguments, you can load a calculation with arguments like so:

If the calculation uses an expression, you can also filter and sort on it like so:

When loading calculations, you specify them in the load statement just like relationships and aggregates.

Every record in Ash also has a calculations field, where arbitrarily named calculations can live. See Ash.Query.calculate/4 for more. To do this with load statements, you use the reserved as key in the calculation arguments.

If you have calculations that produce records, or loadable types like Ash.Type.Map and Ash.Type.Struct you can load further things on those records by providing a tuple of calculation input and further load statements.

You could then load this calculation like so:

But what if you wanted additional fields from the calculated user? To do this, we provide a tuple of additional loads alongside their arguments. Maps support loading "through" fields by using the configured fields in the map and providing further loads.

Hex Package Hex Preview (current file) Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
calculations do
  calculate :full_name, :string, expr(first_name <> " " <> last_name)
end
```

Example 2 (python):
```python
defmodule Concat do
  # An example concatenation calculation, that accepts the delimiter as an argument,
  #and the fields to concatenate as options
  use Ash.Resource.Calculation

  # Optional callback that verifies the passed in options (and optionally transforms them)
  @impl true
  def init(opts) do
    if opts[:keys] && is_list(opts[:keys]) && Enum.all?(opts[:keys], &is_atom/1) do
      {:ok, opts}
    else
      {:error, "Expected a `keys` option for which keys to concat"}
    end
  end

  @impl true
  # A callback to tell Ash what keys must be loaded/selected when running this calculati
...
```

Example 3 (unknown):
```unknown
User
|> Ash.Query.calculate(:full_name, {Concat, keys: [:first_name, :last_name]}, :string, %{separator: ","})
```

Example 4 (unknown):
```unknown
load(full_name: [separator: ","])
```

---

## mix ash.gen.custom_expression (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Mix.Tasks.Ash.Gen.CustomExpression.html

**Contents:**
- mix ash.gen.custom_expression (ash v3.7.6)
- Example
- Options

Generates a custom expression

See Ash.CustomExpression for more.

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
mix ash.gen.custom_expression MyApp.Expressions.LevenshteinDistance --args string,string
```

---

## Ash.CustomExpression behaviour (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Ash.CustomExpression.html

**Contents:**
- Ash.CustomExpression behaviour (ash v3.7.6)
  - Options
  - Registering Your Expression
- Summary
- Callbacks
- Callbacks
- arguments()
- expression(data_layer, arguments)
- name()

A module for defining custom functions that can be called in Ash expressions.

Use compile-time configuration to register your custom expressions

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

**Examples:**

Example 1 (python):
```python
defmodule MyApp.Expressions.LevenshteinDistance do
  use Ash.CustomExpression,
    name: :levenshtein,
    arguments: [
      [:string, :string]
    ]

  def expression(AshPostgres.DataLayer, [left, right]) do
    {:ok, expr(fragment("levenshtein(?, ?)", ^left, ^right))}
  end

  # It is good practice to always define an expression for `Ash.DataLayer.Simple`,
  # as that is what Ash will use to run your custom expression in Elixir.
  # This allows us to completely avoid communicating with the database in some cases.

  # Always use a fragment like this to evaluate code in simple data layers. T
...
```

Example 2 (unknown):
```unknown
config :ash, :custom_expressions, [MyApp.Expressions.LevenshteinDistance]
```

---

## Expressions

**URL:** https://hexdocs.pm/ash/expressions.html

**Contents:**
- Expressions
  - Ash Expressions are SQL-ish
- Operators
  - Elixir-ish operators
- Functions
- Fragments
- String Fragments
- Function Fragments
- Sub-expressions
- DateTime Functions

Ash expressions are used in various places like calculations, filters, and policies, and are meant to be portable representations of elixir expressions. You can create an expression using the Ash.Expr.expr/1 macro, like so:

Ash expressions have some interesting properties in their evaluation, primarily because they are made to be portable, i.e executable in some data layer (like SQL) or executable in Elixir. In general, these expressions will behave the same way they do in Elixir. The primary difference is how nil values work. They behave the way that NULL values behave in SQL. This is primarily because this pattern is easier to replicate to various popular data layers, and is generally safer when using expressions for things like authentication. The practical implications of this are that nil values will "poison" many expressions, and cause them to return nil. For example, x + nil would always evaluate to nil. Additionally, true and nil will always result in nil, this is also true with or and not, i.e true or nil will return nil, and not nil will return nil.

Additionally, atoms and strings compare as if the atom was a string. This is because most external data layers do not know about atoms, and so they are converted to strings before comparison.

The following operators are available and they behave the same as they do in Elixir, except for the nil addendum above.

is_nil | Only works as an operator in maps/keyword list syntax. i.e [x: [is_nil: true]]

Prefer to use and and or if you are dealing with booleans, as they will typically perform much better in SQL data layers. && and || should only be used when you want to deal with more than boolaens.

The following functions are built in. Data Layers can add their own functions to expressions. For example, AshPostgres adds trigram_similarity function.

The following functions are built in:

if | Works like elixir's if.

is_nil/1 | Works like elixir's is_nil

get_path/2 | i.e get_path(value, ["foo", "bar"]). This is what expressions like value[:foo]["bar"] are turned into under the hood.

contains/2 | if one string contains another string, i.e contains("fred", "red")

length/1 | the length of a list, i.e. length([:foo, :bar])

type/2 | Cast a given value to a specific type, i.e type(^arg(:id), :uuid) or type(integer_field, :string)

string_downcase/1 | Downcases a string

string_join/1 | Concatenates a list of strings, and ignores any nil values

string_join/2 | As above, but with a joiner

string_position

*[Content truncated]*

**Examples:**

Example 1 (unknown):
```unknown
Ash.Expr.expr(1 + 2)
Ash.Expr.expr(x + y)
Ash.Expr.expr(post.title <> " | " <> post.subtitle)
```

Example 2 (unknown):
```unknown
calculate :identifier, expr(manual_identifier || employee_id <> " " <> location_code)
```

Example 3 (unknown):
```unknown
calculate :grade, :decimal, expr(
  count(answers, query: [filter: expr(correct == true)]) /
  count(answers, query: [filter: expr(correct == false)])
)
```

Example 4 (unknown):
```unknown
# Count profiles matching the user's name
calculate :matching_profiles, :integer, 
  expr(count(Profile, filter: expr(name == parent(name))))

# Get the latest report title by the user
calculate :latest_report, :string,
  expr(first(Report, 
    field: :title,
    query: [
      filter: expr(author_name == parent(name)),
      sort: [inserted_at: :desc]
    ]
  ))

# Complex calculation with multiple resource-based aggregates and exists
calculate :stats, :map, expr(%{
  profile_count: count(Profile, filter: expr(name == parent(name))),
  total_score: sum(Report, field: :score, query: [filter: 
...
```

---
