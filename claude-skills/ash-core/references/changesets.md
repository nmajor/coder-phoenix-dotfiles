# Ash-Core - Changesets

**Pages:** 6

---

## Ash.Notifier.Notification (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Ash.Notifier.Notification.html

**Contents:**
- Ash.Notifier.Notification (ash v3.7.6)
- Summary
- Types
- Functions
- Types
- t()
- Functions
- new(resource, opts)

Represents a notification that will be handled by a resource's notifiers

Set the for key to a notifier or a list of notifiers to route the notification to them. This allows you to produce notifications inside of a change module and target specific notifiers with them.

metadata is freeform data to be set however you want. resource, action, data, changeset and actor are all set by default based on the details of the action, so they can be omitted.

When creating a notification, a resource is required to ensure that the notification isn't sent until the current transaction for that resource is closed. If you don't need this behavior you can explicitly supply nil for the resource. If you supply nil for the resource, however, you must manually set the for option, e.g: for: Notifier or for: [Notifier1, Notifier2]

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## mix ash.gen.change (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Mix.Tasks.Ash.Gen.Change.html

**Contents:**
- mix ash.gen.change (ash v3.7.6)
- Example

Generates a custom change

See Custom Changes for more.

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
mix ash.gen.change MyApp.Changes.Slugify
```

---

## mix ash.gen.validation (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Mix.Tasks.Ash.Gen.Validation.html

**Contents:**
- mix ash.gen.validation (ash v3.7.6)
- Example

Generates a custom validation

See Custom Validations for more.

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
mix ash.gen.validation MyApp.Validations.IsPrime
```

---

## Ash.Can (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Ash.Can.html

**Contents:**
- Ash.Can (ash v3.7.6)
- Summary
- Types
- Functions
- Types
- subject()
- Functions
- can(action_or_query_or_changeset, domain, actor_or_scope, opts \\ [])
- can?(action_or_query_or_changeset, domain, actor, opts \\ [])

Contains the Ash.can function logic.

Returns a an ok tuple if the actor can perform the action, query, or changeset, an error tuple if an error happens, and a ok tuple with maybe if maybe is set to true or not set.

Returns whether an actor can perform an action, query, or changeset.

Returns a an ok tuple if the actor can perform the action, query, or changeset, an error tuple if an error happens, and a ok tuple with maybe if maybe is set to true or not set.

You should prefer to use Ash.can/3 over this module, directly.

Note: is_maybe is set to true, if not set.

Returns whether an actor can perform an action, query, or changeset.

You should prefer to use Ash.can?/3 over this module, directly.

Can raise an exception if return_forbidden_error is truthy in opts or there's an error.

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## Ash.Reactor.Dsl.Change (ash v3.7.6)

**URL:** https://hexdocs.pm/ash/Ash.Reactor.Dsl.Change.html

**Contents:**
- Ash.Reactor.Dsl.Change (ash v3.7.6)
- Summary
- Types
- Types
- t()

The change entity for the Ash.Reactor reactor extension.

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## Timeouts

**URL:** https://hexdocs.pm/ash/timeouts.html

**Contents:**
- Timeouts
- Ways to Specify Timeouts
  - timeouts use processes
- How are timeouts handled?

You have a few options.

You can specify a timeout when you call an action. This takes the highest precedence.

You can specify one using Ash.Changeset.timeout/2 or Ash.Query.timeout/2. This can be useful if you want to conditionally set a timeout based on the details of the request. For example, you might do something like this:

You can also specify a default timeout on your domain modules.

Keep in mind, you can't specify timeouts in a before_action or after_action hook, because at that point you are already "within" the code that should have a timeout applied.

Timeouts are implemented using processes. This means that potentially large query results will be copied across processes. Because of this, specifying timeouts globally or for things that you don't suspect would ever exceed that timeout is not recommended.

Timeouts in Ash work a bit differently than other tools. The following considerations must be taken into account:

Hex Package Hex Preview (current file) Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
Ash.read!(query, timeout: :timer.seconds(30))
```

Example 2 (python):
```python
# in your resource
defmodule MyApp.SetReportTimeout do
  use Ash.Resource.Preparation

  def prepare(query, _, _) do
    if Ash.Query.get_argument(query, :full_report) do
      Ash.Query.timeout(query, :timer.minutes(3))
    else
      Ash.Query.timeout(query, :timer.minutes(1))
    end
  end
end

actions do
  read :report_items do
    argument :full_report, :boolean, default: false

    prepare MyApp.SetReportTimeout
  end
end
```

Example 3 (unknown):
```unknown
execution do
  timeout :timer.seconds(30) # the default is `:infinity`
end
```

---
