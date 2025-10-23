# Ash-Core - Queries

**Pages:** 10

---

## Ash.Filter (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Ash.Filter.html

**Contents:**
- Ash.Filter (ash v3.7.6)
- Security Concerns
- Writing a filter
  - Built In Predicates
  - BooleanExpression syntax
  - Expressions
  - Keyword list syntax
  - Other formats
- Summary
- Types

The representation of a filter in Ash.

Do not pass user input directly to Ash.Query.filter/2, it will not be sanitised. Instead use Ash.Filter.parse_input/2 or Ash.Query.filter_input/2.

Refer to those functions for more information on how to safely work with user input.

The expression syntax ultimately just builds the keyword list style filter, but with lots of conveniences that would be very annoying to do manually.

More complex filters can be built using Ash Expressions.

See the Expressions guide guide for more information.

A filter is a nested keyword list (with some exceptions, like true for everything and false for nothing).

The key is the "predicate" (or "condition") and the value is the parameter. You can use and and or to create nested filters. Data layers can expose custom predicates. Eventually, you will be able to define your own custom predicates, which will be a mechanism for you to attach complex filters supported by the data layer to your queries.

Important In a given keyword list, all predicates are considered to be "ands". So [or: [first_name: "Tom", last_name: "Bombadil"]] doesn't mean 'First name == "tom" or last_name == "bombadil"'. To say that, you want to provide a list of filters, like so: [or: [[first_name: "Tom"], [last_name: "Bombadil"]]]

Some example filters:

Maps are also accepted, as are maps with string keys. Technically, a list of [{"string_key", value}] would also work.

Can be used to find a simple equality predicate on an attribute

Find an expression inside of a filter that matches the provided predicate

Can be used to find a simple equality predicate on an attribute

Returns a filter statement that would find a single record based on the input.

Parses a filter statement

Parses a filter statement

Parses a filter statement, accepting only public attributes/relationships and honoring field policies & related resource policies, raising on errors.

Parses a filter statement, accepting only public attributes/relationships and honoring field policies & related resource policies, raising on errors.

Returns true if the candidate filter returns the same or less data than the filter

Returns true if the second argument is a strict subset (always returns the same or less data) of the first

Transform an expression based filter to a simple filter, which is just a list of predicates

Can be used to find a simple equality predicate on an attribute

Use this when your attribute is configured with filterable? :simple_equal

*[Content truncated]*

**Examples:**

Example 1 (unknown):
```unknown
Ash.Query.filter(resource, name == "Zardoz")
Ash.Query.filter(resource, first_name == "Zar" and last_name == "Doz")
Ash.Query.filter(resource, first_name == "Zar" and last_name in ["Doz", "Daz"] and high_score > 10)
Ash.Query.filter(resource, first_name == "Zar" or last_name == "Doz" or (high_score > 10 and high_score < -10))
```

Example 2 (unknown):
```unknown
# Filter based on the contents of a string attribute
Ash.Query.filter(Helpdesk.Support.Ticket, contains(subject, "2"))
# Filter based on the attribute of a joined relationship:
Ash.Query.filter(Helpdesk.Support.Ticket, representative.name == ^name)
```

Example 3 (unknown):
```unknown
Ash.Query.filter(resource, [name: "Zardoz"])
Ash.Query.filter(resource, [first_name: "Zar", last_name: "Doz"])
Ash.Query.filter(resource, [first_name: "Zar", last_name: [in: ["Doz", "Daz"]], high_score: [greater_than: 10]])
Ash.Query.filter(resource, [or: [
  [first_name: "Zar"],
  [last_name: "Doz"],
  [or: [
    [high_score: [greater_than: 10]]],
    [high_score: [less_than: -10]]
  ]
]])
```

Example 4 (unknown):
```unknown
iex> get_filter(MyApp.Post, 1)
{:ok, %{id: 1}} #using primary key
iex> get_filter(MyApp.Post, id: 1)
{:ok, %{id: 1}} #using primary key
iex> get_filter(MyApp.Post, author_id: 1, publication_id: 2, first_name: "fred")
{:ok, %{author_id: 1, publication_id: 1}} # using a unique identity
iex> get_filter(MyApp.Post, first_name: "fred")
:error # not enough information
```

---

## Ash.DataLayer.Simple (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Ash.DataLayer.Simple.html

**Contents:**
- Ash.DataLayer.Simple (ash v3.7.6)
- Summary
- Functions
- Functions
- bulk_create(resource, stream, options)
- set_data(query, data)

A data layer that returns structs.

This is the data layer that is used under the hood by embedded resources, and resources without data layers.

Callback implementation for Ash.DataLayer.bulk_create/3.

Sets the data for a query against a data-layer-less resource

Callback implementation for Ash.DataLayer.bulk_create/3.

Sets the data for a query against a data-layer-less resource

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## Ash.Query.Aggregate (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Ash.Query.Aggregate.html

**Contents:**
- Ash.Query.Aggregate (ash v3.7.6)
- Summary
- Types
- Functions
- Types
- kind()
- t()
- Functions
- default_value(atom)
- new(resource, name, kind, opts \\ [])

Represents an aggregated association value

Create a new aggregate, used with Query.aggregate or Ash.aggregate

Create a new aggregate, used with Query.aggregate or Ash.aggregate, raising on errors.

Create a new aggregate, used with Query.aggregate or Ash.aggregate

:path (list of atom/0) - The relationship path to aggregate over. Only used when adding aggregates to a query. The default value is [].

:query (term/0) - A base query to use for the aggregate, or a keyword list to be passed to Ash.Query.build/2

:field - The field to use for the aggregate. Not necessary for all aggregate types.

:expr (term/0) - An expression to aggregate, cannot be used with field.

:expr_type - The type of the expression, required if expr is used.

:arguments (map/0) - Arguments to pass to the field, if field is a calculation.

:default (term/0) - A default value to use for the aggregate if it returns nil.

:filterable? (boolean/0) - Whether or not this aggregate may be used in filters. The default value is true.

:sortable? (boolean/0) - Whether or not this aggregate may be used in sorts. The default value is true.

:type (term/0) - A type to use for the aggregate.

:constraints (term/0) - Type constraints to use for the aggregate. The default value is [].

:implementation (term/0) - The implementation for any custom aggregates.

:read_action (atom/0) - The read action to use for the aggregate, defaults to the primary read action.

:uniq? (boolean/0) - Whether or not to only consider unique values. Only relevant for count and list aggregates. The default value is false.

:include_nil? (boolean/0) - Whether or not to include nil values in the aggregate. Only relevant for list and first aggregates. The default value is false.

:join_filters (map of one or a list of atom/0 keys and term/0 values) - A map of relationship paths (an atom or list of atoms), to an expression to apply when fetching the aggregate data. See the aggregates guide for more. The default value is %{}.

:sensitive? (boolean/0) - Whether or not references to this aggregate will be considered sensitive The default value is false.

:tenant (term/0) - The tenant to use for the aggregate, if applicable. The default value is nil.

:authorize? (boolean/0) - Whether or not the aggregate query should authorize based on the target action.See Ash.Resource.Dsl.aggregates.count for more information. The default value is true.

:resource (atom/0) - For unrelated aggregates, the target resource to aggregate over

:relate

*[Content truncated]*

---

## Ash.Error.Query.NotFound exception (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Ash.Error.Query.NotFound.html

**Contents:**
- Ash.Error.Query.NotFound exception (ash v3.7.6)
- Summary
- Functions
- Functions
- exception(args)
- Keys

Used when an entity that not exist is referenced

Create an Elixir.Ash.Error.Query.NotFound without raising it.

Create an Elixir.Ash.Error.Query.NotFound without raising it.

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## Ash.Reactor.Dsl.Load (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Ash.Reactor.Dsl.Load.html

**Contents:**
- Ash.Reactor.Dsl.Load (ash v3.7.6)
- Summary
- Types
- Types
- t()

The load step entity for the Ash.Reactor reactor extension.

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## Aggregates

**URL:** https://hexdocs.pm/ash/aggregates.html

**Contents:**
- Aggregates
- Declaring aggregates on a resource
  - Relationship-based Aggregates
  - Resource-based Aggregates
- Using an aggregate
  - Loading aggregates in a query or on records
  - Filtering on aggregates
  - Sorting aggregates
- Aggregate types
- Custom aggregates in the query

Aggregates in Ash allow for retrieving summary information over groups of related data. A simple example might be to show the "count of published posts for a user". Aggregates allow us quick and performant access to this data, in a way that supports being filtered/sorted on automatically. More aggregate types can be added, but you will be restricted to only the supported types. In cases where aggregates don't suffice, use Calculations, which are intended to be much more flexible.

Aggregates can work in two ways:

Aggregates are defined in an aggregates section. For all possible types, see below. For a full reference, see Ash.Resource.Dsl.aggregates.

Resource-based aggregates allow you to aggregate over any resource without needing a relationship. Instead of providing a relationship path, you provide the target resource module directly:

The parent/1 function allows you to reference fields from the source resource within the aggregate's filter expression.

Aggregates are loaded and filtered on in the same way that calculations are. Lets look at some examples:

The declared set of named aggregates can be used by extensions and referred to throughout your application As an escape hatch, they can also be loaded in the query using Ash.Query.load/2, or after the fact using Ash.load/3. Aggregates declared on the resource will be keys in the resource's struct.

See the docs on Ash.Resource.Dsl.aggregates for more information.

Custom aggregates can be added to the query and will be placed in the aggregates key of the results. This is an escape hatch, and is not the primary way that you should be using aggregates. It does, however, allow for dynamism, i.e if you are accepting user input that determines what the filter and/or field should be, that kind of thing.

Here's an example of creating a custom aggregate that uses PostgreSQL's PERCENTILE_CONT function to calculate percentiles:

This aggregate calculates the median (50th percentile) distance walked by cats each day, filtering out any days where no walking occurred.

See the documentation for Ash.Query.aggregate/4 for more information.

Join filters allows for more complex aggregate queries, including joining with predicates based on multiple related values.

Aggregates can be created in-line in expressions, with their relationship path specified and any options provided that match the options given to Ash.Query.Aggregate.new/4. For example:

See the Expressions guide for more.

Hex Package Hex Preview (curre

*[Content truncated]*

**Examples:**

Example 1 (unknown):
```unknown
aggregates do
  count :count_of_posts, :posts do
    filter expr(published == true)
  end
end
```

Example 2 (unknown):
```unknown
aggregates do
  # Count profiles with matching name
  count :matching_profiles_count, Profile do
    filter expr(name == parent(name))
  end
  
  # Sum scores from reports where author matches user's name
  sum :total_report_score, Report, :score do
    filter expr(author_name == parent(name))
  end
  
  # Check if any active profile exists (no parent filter needed)
  exists :has_active_profile, Profile do
    filter expr(active == true)
  end
end
```

Example 3 (javascript):
```javascript
User
|> Ash.Query.load(:count_of_posts)
|> Map.get(:count_of_posts)
# => 10

users
|> Ash.load!(:count_of_posts)
|> Enum.map(&(&1.count_of_posts))
# => [3, 5, 2]
```

Example 4 (unknown):
```unknown
require Ash.Query

User
|> Ash.Query.filter(count_of_posts > 10)
|> Ash.read!()
```

---

## Ash.Policy.FilterCheck behaviour (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Ash.Policy.FilterCheck.html

**Contents:**
- Ash.Policy.FilterCheck behaviour (ash v3.7.6)
- Summary
- Types
- Callbacks
- Functions
- Types
- context()
- options()
- Callbacks
- filter(actor, context, options)

A type of check that is represented by a filter statement

You can customize what the "negative" filter looks like by defining reject/3. This is important for filters over related data. For example, given an owner relationship and a data layer like ash_postgres where column != NULL does not evaluate to true (see postgres docs on NULL for more):

By being able to customize the reject filter, you can use related filters in your policies. Without it, they will likely have undesired effects.

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
# The opposite of
`owner.id == 1`
# in most cases is not
`not(owner.id == 1)`
# because in postgres that would be `NOT (owner.id = NULL)` in cases where there was no owner
# A better opposite would be
`owner.id != 1 or is_nil(owner.id)`
# alternatively
`not(owner.id == 1) or is_nil(owner.id)`
```

---

## Ash.Sort (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Ash.Sort.html

**Contents:**
- Ash.Sort (ash v3.7.6)
- Summary
- Types
- Functions
- Types
- sort_item()
- sort_order()
- t()
- Functions
- expr_sort(expression, type \\ nil)

Utilities and types for sorting.

Builds an expression to be used in a sort statement. Prefer to use Ash.Expr.calc/2 instead.

A utility for parsing sorts provided from external input. Only allows sorting on public fields.

Same as parse_input/2 except raises any errors

Reverses an Ash sort statement.

A utility for sorting a list of records at runtime.

Builds an expression to be used in a sort statement. Prefer to use Ash.Expr.calc/2 instead.

A utility for parsing sorts provided from external input. Only allows sorting on public fields.

See Ash.Query.sort/3 for supported formats.

A handler function may be provided that takes a string, and returns the relevant sort It won't be given any prefixes, only the field. This allows for things like parsing the calculation values out of the sort, or setting calculation values if they are not included in the sort string.

To return calculation parameters, return {:field, %{param: :value}}. This will end up as something like {:field, {%{param: :value}, :desc}}, with the corresponding sort order.

This handler function will only be called if you pass in a string or list of strings for the sort. Atoms will be assumed to have already been handled. The handler should return nil if it is not handling the given field.

Same as parse_input/2 except raises any errors

See parse_input/2 for more.

Reverses an Ash sort statement.

A utility for sorting a list of records at runtime.

Keep in mind that it is unrealistic to expect this runtime sort to always be exactly the same as a sort that may have been applied by your data layer. This is especially true for strings. For example, Postgres strings have a collation that affects their sorting, making it unpredictable from the perspective of a tool using the database: https://www.postgresql.org/docs/current/collation.html

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
Ash.Query.sort(query, Ash.Sort.expr_sort(author.full_name, :string))

Ash.Query.sort(query, [{Ash.Sort.expr_sort(author.full_name, :string), :desc_nils_first}])
```

Example 2 (unknown):
```unknown
Ash.Sort.runtime_sort([record1, record2, record3], name: :asc, type: :desc_nils_last)
```

---

## Ash.Query.Combination (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Ash.Query.Combination.html

**Contents:**
- Ash.Query.Combination (ash v3.7.6)
- Summary
- Types
- Functions
- Types
- t()
- Functions
- base(opts)
- except(opts)
- intersect(opts)

Represents one combination in a combination of queries.

The initial combination of a combined query.

Removes all rows that are present in the previous combinations and this one.

Intersects the query with the previous combinations, keeping only rows that are present in the previous combinations and this one.

Unions the query with the previous combinations, discarding duplicates when all fields are equal.

Unions the query with the previous combinations, keeping all rows.

The initial combination of a combined query.

Removes all rows that are present in the previous combinations and this one.

Intersects the query with the previous combinations, keeping only rows that are present in the previous combinations and this one.

Unions the query with the previous combinations, discarding duplicates when all fields are equal.

Unions the query with the previous combinations, keeping all rows.

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## Ash.Page.Keyset (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Ash.Page.Keyset.html

**Contents:**
- Ash.Page.Keyset (ash v3.7.6)
- Summary
- Types
- Functions
- Types
- page_opts()
- page_opts_opts()
- page_opts_type()
- t()
- Functions

A page of results from keyset based pagination.

The results are generated with a keyset metadata, which can be used to fetch the next/previous pages.

Appends keyset info to results.

Creates filters on the query using the query for the Keyset.

Creates a new Ash.Page.Keyset.t.

A restricted version of :erlang.binary_to_term/2 that forbids executable terms, such as anonymous functions. The opts are given to the underlying :erlang.binary_to_term/2 call, with an empty list as a default. By default this function does not restrict atoms, as an atom interned in one node may not yet have been interned on another (except for releases, which preload all code). If you want to avoid atoms from being created, then you can pass [:safe] as options, as that will also enable the safety mechanisms from :erlang.binary_to_term/2 itself. Ripped from https://github.com/elixir-plug/plug_crypto/blob/v1.2.0/lib/plug/crypto.ex

Appends keyset info to results.

Creates filters on the query using the query for the Keyset.

Creates a new Ash.Page.Keyset.t.

A restricted version of :erlang.binary_to_term/2 that forbids executable terms, such as anonymous functions. The opts are given to the underlying :erlang.binary_to_term/2 call, with an empty list as a default. By default this function does not restrict atoms, as an atom interned in one node may not yet have been interned on another (except for releases, which preload all code). If you want to avoid atoms from being created, then you can pass [:safe] as options, as that will also enable the safety mechanisms from :erlang.binary_to_term/2 itself. Ripped from https://github.com/elixir-plug/plug_crypto/blob/v1.2.0/lib/plug/crypto.ex

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

---
