---
name: ash-rate-limiter
description: API rate limiting and request throttling. Use for rate limits, request throttling, API quotas, controlling request frequency, preventing abuse, and managing API usage limits.
---

# Ash-Rate-Limiter Skill

Comprehensive assistance with ash-rate-limiter development, generated from official documentation.

## When to Use This Skill

This skill should be triggered when:
- **Implementing rate limiting** on Ash Framework resources and actions
- **Protecting API endpoints** from abuse and excessive requests
- **Throttling user actions** (e.g., limiting post creation, API calls, form submissions)
- **Adding per-user or per-tenant rate limits** to prevent resource exhaustion
- **Debugging rate limit errors** or `AshRateLimiter.LimitExceeded` exceptions
- **Configuring different rate limits** for read, create, update, or destroy actions
- **Using Hammer** for rate limiting with custom bucket keys
- **Working with multi-tenant applications** that need tenant-specific rate limits
- **Handling HTTP 429 responses** in web applications

## Key Concepts

### Core Components

**AshRateLimiter Extension**
- An Ash Framework extension that adds rate limiting to resource actions
- Uses the [Hammer](https://hex.pm/packages/hammer) library for bucketing and counting
- Supports both resource-level DSL configuration and direct change/preparation usage

**Bucket Keys**
- Hammer uses a "key" to identify which bucket to track events against
- Keys determine how rate limits are grouped (e.g., per-user, per-IP, global)
- Default key format: `"domain/resource/action"` (with optional primary key for updates/destroys)

**Rate Limit Configuration**
- `limit`: Maximum number of events allowed (e.g., 10 requests)
- `per`: Time window in milliseconds (e.g., `:timer.minutes(5)` = 5 minutes)
- `key`: Function to generate bucket keys (defaults to `AshRateLimiter.key_for_action/2`)

**Exception Handling**
- Raises `AshRateLimiter.LimitExceeded` when limits are exceeded
- Implements `Plug.Exception` behavior for automatic HTTP 429 responses in web apps

## Quick Reference

### Example 1: Basic DSL Configuration (Resource-Level)

Simple rate limiting for a create action using the DSL:

```elixir
defmodule Example.Post do
  use Ash.Resource,
    extensions: [AshRateLimiter]

  rate_limit do
    # Limit create action: 10 posts per 5 minutes
    action :create, limit: 10, per: :timer.minutes(5)
  end

  actions do
    defaults [:read, :destroy]
    create :create
  end
end
```

**What this does:**
- Adds rate limiting to the `:create` action
- Allows maximum 10 create operations per 5-minute window
- Uses default key (global across all users)

---

### Example 2: Per-User Rate Limiting

Rate limit based on the current actor (user):

```elixir
defmodule Example.Comment do
  use Ash.Resource,
    extensions: [AshRateLimiter]

  rate_limit do
    action :create,
      limit: 5,
      per: :timer.minutes(1),
      key: fn changeset, _context ->
        # Generate unique key per user
        case changeset.context[:actor] do
          nil -> "anonymous/comment/create"
          actor -> "user:#{actor.id}/comment/create"
        end
      end
  end
end
```

**What this does:**
- Each user can create 5 comments per minute
- Anonymous users share a separate rate limit bucket
- Different users have independent rate limits

---

### Example 3: Direct Change Usage (Inline)

Apply rate limiting directly in an action definition:

```elixir
defmodule Example.Article do
  use Ash.Resource,
    extensions: [AshRateLimiter]

  actions do
    create :publish do
      # Add rate limit as a change
      change AshRateLimiter.BuiltinChanges.rate_limit(
        limit: 3,
        per: :timer.hours(1)
      )
    end

    update :edit do
      # Rate limit updates per-record using default key
      change AshRateLimiter.BuiltinChanges.rate_limit(
        limit: 10,
        per: :timer.minutes(10)
      )
    end
  end
end
```

**What this does:**
- Publish action: 3 publishes per hour (global)
- Edit action: 10 edits per 10 minutes per article (includes primary key in key)

---

### Example 4: Read Action Rate Limiting

Use preparations for read actions:

```elixir
defmodule Example.Report do
  use Ash.Resource,
    extensions: [AshRateLimiter]

  actions do
    read :expensive_query do
      # Rate limit read queries
      prepare AshRateLimiter.BuiltinPreparations.rate_limit(
        limit: 5,
        per: :timer.minutes(1)
      )
    end
  end
end
```

**What this does:**
- Limits expensive query reads to 5 per minute
- Prevents abuse of resource-intensive queries

---

### Example 5: Understanding Default Bucket Keys

The default key function generates keys based on action type:

```elixir
# Create action - global key
iex> Example.Post
...> |> Ash.Changeset.for_create(:create, %{title: "Hello"})
...> |> AshRateLimiter.key_for_action(%{})
"example/post/create"

# Read action - global key
iex> Example.Post
...> |> Ash.Query.for_read(:read)
...> |> AshRateLimiter.key_for_action(%{})
"example/post/read"

# Update action - includes primary key
iex> post = %{id: "0196ebc0-83b4-7938-bc9d-22ae65dbec0b"}
...> post
...> |> Ash.Changeset.for_update(:update, %{title: "Updated"})
...> |> AshRateLimiter.key_for_action(%{})
"example/post/update?id=0196ebc0-83b4-7938-bc9d-22ae65dbec0b"

# Destroy action - includes primary key
iex> post = %{id: "0196ebc6-4839-7a9e-b2a6-feb0eabc8772"}
...> post
...> |> Ash.Changeset.for_destroy(:destroy)
...> |> AshRateLimiter.key_for_action(%{})
"example/post/destroy?id=0196ebc6-4839-7a9e-b2a6-feb0eabc8772"
```

---

### Example 6: Customizing Key Generation with Options

Use built-in options to customize key behavior:

```elixir
# Include actor attributes in the key
AshRateLimiter.key_for_action(
  changeset,
  %{},
  include_actor_attributes: [:email, :role]
)
# Result: "example/post/create?actor.email=user@example.com&actor.role=admin"

# Disable primary key inclusion for updates
AshRateLimiter.key_for_action(
  changeset,
  %{},
  include_pk?: false
)
# Result: "example/post/update" (no ID in key)

# Include tenant in multi-tenant apps
AshRateLimiter.key_for_action(
  changeset,
  %{},
  include_tenant?: true
)
# Result: "tenant:acme/example/post/create"
```

---

### Example 7: Handling Rate Limit Exceptions

Handle `LimitExceeded` errors in your application:

```elixir
case MyApp.Post.create(attrs, actor: current_user) do
  {:ok, post} ->
    {:ok, post}

  {:error, %AshRateLimiter.LimitExceeded{} = error} ->
    # Rate limit exceeded
    Logger.warn("Rate limit hit: #{inspect(error)}")
    {:error, "Too many requests. Please try again later."}

  {:error, error} ->
    # Other errors
    {:error, error}
end
```

**In Phoenix/Plug apps:**
- `LimitExceeded` automatically returns HTTP 429 (Too Many Requests)
- No manual exception handling needed for web responses

---

### Example 8: Setting Up Hammer Backend

Configure Hammer with ETS backend (in your application):

```elixir
# lib/my_app/hammer.ex
defmodule MyApp.Hammer do
  use Hammer, backend: :ets
end

# config/config.exs
config :ash_rate_limiter,
  hammer_module: MyApp.Hammer
```

**What this does:**
- Creates a Hammer module with ETS (in-memory) storage
- AshRateLimiter uses this module for tracking rate limits
- For production, consider persistent backends (Redis, etc.)

---

### Example 9: Multiple Actions with Different Limits

Configure different limits for multiple actions:

```elixir
defmodule Example.User do
  use Ash.Resource,
    extensions: [AshRateLimiter]

  rate_limit do
    # Login attempts: very strict
    action :login, limit: 5, per: :timer.minutes(15)

    # Password reset: moderately strict
    action :request_password_reset, limit: 3, per: :timer.hours(1)

    # Profile updates: lenient
    action :update_profile, limit: 20, per: :timer.minutes(10)
  end
end
```

---

### Example 10: Advanced Custom Key Function

Create complex bucket keys for multi-tenant scenarios:

```elixir
defmodule Example.Invoice do
  use Ash.Resource,
    extensions: [AshRateLimiter]

  rate_limit do
    action :create,
      limit: 100,
      per: :timer.hours(1),
      key: fn changeset, context ->
        # Combine tenant, user, and action
        tenant = changeset.tenant || "default"
        user_id = changeset.context[:actor][:id] || "anonymous"

        "tenant:#{tenant}/user:#{user_id}/invoice/create"
      end
  end
end
```

**What this does:**
- Each tenant has independent rate limits
- Within each tenant, each user has independent limits
- Allows 100 invoices per hour per user per tenant

## Reference Files

This skill includes comprehensive documentation in `references/`:

- **configuration.md** - Complete configuration reference with DSL options, built-in changes/preparations, key generation functions, and exception handling

### What's in configuration.md:

**AshRateLimiter Module** (`AshRateLimiter`)
- Default key generation function with customization options
- Understanding bucket key structure and behavior

**DSL Configuration** (`rate_limit` block)
- Resource-level rate limit configuration
- Action-specific rate limiting with the `rate_limit.action` directive

**Built-in Changes** (`AshRateLimiter.BuiltinChanges`)
- `rate_limit/1` - Apply rate limiting to mutation actions (create, update, destroy)
- Options: `limit`, `per`, `key`

**Built-in Preparations** (`AshRateLimiter.BuiltinPreparations`)
- `rate_limit/1` - Apply rate limiting to read actions
- Options: `limit`, `per`, `key`

**Exception Handling** (`AshRateLimiter.LimitExceeded`)
- Exception raised when limits are exceeded
- Automatic HTTP 429 response in web applications
- Using `exception/1` to create exceptions programmatically

**Installation and Setup** (README)
- Installing via Igniter (recommended) or manual installation
- Setting up Hammer backend
- Basic usage examples
- Key function examples

## Working with This Skill

### For Beginners

**Start here:**
1. Read the **Quick Reference Examples 1-4** above for basic usage patterns
2. Review **Example 8** to set up Hammer backend in your application
3. Install ash_rate_limiter using Igniter: `mix igniter.install ash_rate_limiter`
4. Add a simple rate limit to one action using the DSL (Example 1)
5. Test by triggering the action multiple times to see `LimitExceeded` exception

**Key concepts to understand:**
- Rate limits are enforced per "bucket key"
- Default keys are global (all users share the same limit)
- Use custom key functions for per-user or per-tenant limits
- Hammer handles the actual counting and time windows

### For Intermediate Users

**Common tasks:**
- **Per-user rate limiting**: See Example 2 for actor-based keys
- **Different limits per action**: Use multiple `action` directives in the DSL (Example 9)
- **Inline rate limiting**: Apply `rate_limit` changes directly in action definitions (Example 3)
- **Multi-tenant rate limiting**: See Example 10 for tenant-aware key generation
- **Read action protection**: Use `BuiltinPreparations.rate_limit/1` (Example 4)

**Best practices:**
- Use strict limits for sensitive actions (login, password reset)
- Use lenient limits for common operations (profile updates)
- Always include actor information in keys for per-user limits
- Consider tenant isolation in multi-tenant applications

### For Advanced Users

**Advanced scenarios:**
- **Custom key generation**: Write complex key functions using changeset context and metadata
- **Conditional rate limiting**: Use key functions that return different keys based on user roles
- **Multiple bucket strategies**: Combine global and per-user limits using different actions
- **Performance tuning**: Optimize Hammer backend (consider Redis for distributed systems)
- **Monitoring**: Track `LimitExceeded` exceptions to identify abuse patterns

**Extending the functionality:**
- Implement custom Hammer backends for specialized storage
- Create reusable key generation functions for common patterns
- Build middleware to log rate limit violations
- Integrate with observability tools (Telemetry, etc.)

### Navigation Tips

**Finding information:**
- For **configuration syntax**: View `references/configuration.md` → DSL section
- For **key generation options**: View `references/configuration.md` → AshRateLimiter module
- For **installation steps**: View `references/configuration.md` → README section
- For **exception handling**: View `references/configuration.md` → LimitExceeded section

**Quick lookups:**
- "How do I rate limit create actions?" → Example 1 or 3
- "How do I rate limit per user?" → Example 2
- "How do I rate limit reads?" → Example 4
- "How do I handle rate limit errors?" → Example 7
- "How do I set up Hammer?" → Example 8

## Common Patterns

### Pattern: Global Rate Limiting
```elixir
rate_limit do
  action :create, limit: 100, per: :timer.hours(1)
end
```
**Use when:** You want to limit total requests across all users

---

### Pattern: Per-User Rate Limiting
```elixir
rate_limit do
  action :create,
    limit: 10,
    per: :timer.minutes(5),
    key: fn changeset, _context ->
      actor_id = changeset.context[:actor][:id]
      "user:#{actor_id}/#{changeset.domain}/#{changeset.resource}/#{changeset.action.name}"
    end
end
```
**Use when:** Each user should have independent rate limits

---

### Pattern: Inline Action Rate Limiting
```elixir
create :sensitive_action do
  change AshRateLimiter.BuiltinChanges.rate_limit(
    limit: 3,
    per: :timer.minutes(60)
  )
end
```
**Use when:** You want fine-grained control over specific action configuration

---

### Pattern: Read Query Protection
```elixir
read :expensive_report do
  prepare AshRateLimiter.BuiltinPreparations.rate_limit(
    limit: 5,
    per: :timer.minutes(1)
  )
end
```
**Use when:** Protecting resource-intensive read operations

## Resources

### references/
Organized documentation extracted from official sources. These files contain:
- Detailed API documentation for all modules and functions
- Complete DSL reference with all available options
- Real code examples from the official documentation
- Links to original HexDocs pages
- Installation and setup instructions

### Official Links
- **Hex Package**: https://hex.pm/packages/ash_rate_limiter
- **HexDocs**: https://hexdocs.pm/ash_rate_limiter
- **Hammer Library**: https://hex.pm/packages/hammer

## Notes

- This skill was automatically generated from official documentation
- Reference files preserve the structure and examples from source docs
- Code examples include language detection for better syntax highlighting
- Quick reference patterns are extracted from common usage examples in the docs
- Default bucket keys include primary keys for update/destroy actions to enable per-record rate limiting
- For production use, consider persistent Hammer backends (Redis, Mnesia) instead of ETS
- Rate limits are enforced synchronously and will block the action if exceeded

## Updating

To refresh this skill with updated documentation:
1. Re-run the scraper with the same configuration
2. The skill will be rebuilt with the latest information
