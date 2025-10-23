# Ash-Rate-Limiter - Configuration

**Pages:** 7

---

## AshRateLimiter.BuiltinChanges (ash_rate_limiter v0.2.0)

**URL:** https://hexdocs.pm/ash_rate_limiter/AshRateLimiter.BuiltinChanges.html

**Contents:**
- AshRateLimiter.BuiltinChanges (ash_rate_limiter v0.2.0)
- Summary
- Types
- Functions
- Types
- rate_limit_options()
- Functions
- rate_limit(options)
- Options

Change helpers to allow direct usage in mutation actions.

Add a rate-limit change directly to an action.

Add a rate-limit change directly to an action.

:limit (pos_integer/0) - Required. The maximum number of events allowed within the given scale

:per (pos_integer/0) - Required. The time period (in milliseconds) for in which events are counted

:key - The key used to identify the event. See the docs for AshRateLimiter.key_for_action/2 for more. The default value is &AshRateLimiter.key_for_action/2.

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## AshRateLimiter (ash_rate_limiter v0.2.0)

**URL:** https://hexdocs.pm/ash_rate_limiter/AshRateLimiter.html

**Contents:**
- AshRateLimiter (ash_rate_limiter v0.2.0)
- Summary
- Types
- Functions
- Types
- keyfun()
- t()
- Functions
- key_for_action(query_or_changeset, context, opts \\ [])
- Options

An extension for Ash.Resource which adds the ability to rate limit access to actions.

The default bucket key generation function for AshRateLimiter.

The default bucket key generation function for AshRateLimiter.

Generates a key based on the domain, resource and action names. For update and destroy actions it will also include the primary key(s) in the key.

:include_pk? (boolean/0) - Whether or not to include the primary keys in the generated key in update/destroy actions. The default value is true.

:include_actor_attributes (one or a list of atom/0) - A list of attributes to include from the current actor The default value is [].

:include_tenant? (boolean/0) - Whether or not to include the tenant in the bucket key. The default value is false.

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
iex> Example.Post
...> |> Ash.Changeset.for_create(:create, post_attrs())
...> |> key_for_action(%{})
"example/post/create"

iex> Example.Post
...> |> Ash.Query.for_read(:read)
...> |> key_for_action(%{})
"example/post/read"

iex> generate_post(id: "0196ebc0-83b4-7938-bc9d-22ae65dbec0b")
...> |> Ash.Changeset.for_update(:update, %{title: "Local Farmer Claims 'Space Zombie' Wrecked His Barn"})
...> |> key_for_action(%{})
"example/post/update?id=0196ebc0-83b4-7938-bc9d-22ae65dbec0b"

iex> generate_post(id: "0196ebc6-4839-7a9e-b2a6-feb0eabc8772")
...> |> Ash.Changeset.for_destroy(:destroy)
...> |
...
```

---

## AshRateLimiter.LimitExceeded exception (ash_rate_limiter v0.2.0)

**URL:** https://hexdocs.pm/ash_rate_limiter/AshRateLimiter.LimitExceeded.html

**Contents:**
- AshRateLimiter.LimitExceeded exception (ash_rate_limiter v0.2.0)
- Summary
- Functions
- Functions
- exception(args)
- Keys

An exception which is raised or returned when an action invocation exceeds the defined limits.

Create an Elixir.AshRateLimiter.LimitExceeded without raising it.

Create an Elixir.AshRateLimiter.LimitExceeded without raising it.

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## AshRateLimiter

**URL:** https://hexdocs.pm/ash_rate_limiter/dsl-ashratelimiter.html

**Contents:**
- AshRateLimiter
- rate_limit
    - Hammer
    - Keys
  - Nested DSLs
  - Examples
  - Options
  - rate_limit.action
  - Arguments
  - Options

An extension for Ash.Resource which adds the ability to rate limit access to actions.

Configure rate limiting for actions.

This library uses the hammer package to provide rate limiting features. See hammer's documentation for more information.

Hammer uses a "key" to identify which bucket to allocate an event against. You can use this to tune the rate limit for specific users or events.

You can provide either a statically configured string key, or a function of arity one or two, which when given a query/changeset and optional context object can generate a key.

The default is AshRateLimiter.key_for_action/2. See it's docs for more information.

Configure rate limiting for a single action.

It does this by adding a global change or preparation to the resource with the provided configuration. For more advanced configuration you can add the change/preparation directly to your action using AshRateLimiter.BuiltinChanges.rate_limit/1 or AshRateLimiter.BuiltinPreparations.rate_limit/1.

Target: AshRateLimiter

Hex Package Hex Preview (current file) Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
rate_limit do
  action :create, limit: 10, per: :timer.minutes(5)
end
```

Example 2 (unknown):
```unknown
action action
```

---

## README

**URL:** https://hexdocs.pm/ash_rate_limiter/readme.html

**Contents:**
- README
- AshRateLimiter
- Installation
  - Using Igniter (Recommended)
  - Manual Installation
- Quick Start
- Basic Usage
  - Simple Rate Limiting
  - Per-User Rate Limiting
  - Multiple Actions

Welcome! This is an extension for the Ash framework which protects actions from abuse by enforcing rate limits.

Uses the excellent hammer to provide rate limiting functionality.

The easiest way to install ash_rate_limiter is using Igniter:

Add ash_rate_limiter to your list of dependencies in mix.exs:

And add :ash_rate_limiter to your .formatter.exs:

For more control, you can add rate limiting directly to specific actions:

Or use the built-in helpers:

The key function determines how requests are grouped for rate limiting:

When rate limits are exceeded, an AshRateLimiter.LimitExceeded exception is raised:

In web applications, the exception includes Plug.Exception behaviour for automatic HTTP 429 responses.

Hex Package Hex Preview (current file) Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
mix igniter.install ash_rate_limiter
```

Example 2 (python):
```python
def deps do
  [
    {:ash_rate_limiter, "~> 0.2.0"}
  ]
end
```

Example 3 (unknown):
```unknown
[
  import_deps: [:ash, :ash_rate_limiter],
  # ... other formatter config
]
```

Example 4 (unknown):
```unknown
# lib/my_app/hammer.ex
defmodule MyApp.Hammer do
  use Hammer, backend: :ets
end
```

---

## 

**URL:** https://hexdocs.pm/ash_rate_limiter/ash_rate_limiter.epub

---

## AshRateLimiter.BuiltinPreparations (ash_rate_limiter v0.2.0)

**URL:** https://hexdocs.pm/ash_rate_limiter/AshRateLimiter.BuiltinPreparations.html

**Contents:**
- AshRateLimiter.BuiltinPreparations (ash_rate_limiter v0.2.0)
- Summary
- Types
- Functions
- Types
- rate_limit_options()
- Functions
- rate_limit(options)
- Options

Preparation helpers to allow direct usage in read actions.

Add a rate-limit change directly to an action.

Add a rate-limit change directly to an action.

:limit (pos_integer/0) - Required. The maximum number of events allowed within the given scale

:per (pos_integer/0) - Required. The time period (in milliseconds) for in which events are counted

:key - The key used to identify the event. See the docs for AshRateLimiter.key_for_action/2 for more. The default value is &AshRateLimiter.key_for_action/2.

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

---
