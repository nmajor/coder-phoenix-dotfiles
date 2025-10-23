---
name: ash-oban
description: Background jobs and async task processing. Use for ANY async work, scheduled tasks, background processing, job queues, delayed execution, cron jobs, and non-blocking operations.
---

# Ash-Oban Skill

Comprehensive assistance with AshOban - the Oban background job integration for Ash Framework. This skill provides expertise in triggers, scheduled actions, error handling, and actor persistence.

## When to Use This Skill

Trigger this skill when working with:

**Background Processing:**
- Setting up background jobs for Ash resources
- Creating periodic tasks that run on schedules (daily, hourly, etc.)
- Processing records asynchronously based on conditions
- Building job queues for resource actions

**Triggers:**
- Defining triggers that run actions for records matching conditions
- Setting up cron-based triggers (e.g., "send email when subscription expires soon")
- Implementing error handling for failed triggers
- Managing trigger lifecycle and error recovery

**Scheduled Actions:**
- Scheduling generic actions to run on a timetable
- Setting up data imports or batch processing
- Creating maintenance jobs

**Integration:**
- Integrating AshOban with existing Oban configuration
- Configuring queues for AshOban triggers
- Persisting actors (users) across background jobs
- Authorizing trigger actions with policies

**Troubleshooting:**
- Debugging AshOban triggers that aren't firing
- Fixing authorization issues with triggers
- Handling errors in background jobs
- Managing dangling jobs from renamed triggers

## 🎯 THE GOLDEN RULES

### ALWAYS Use Ash.Oban First

**CRITICAL:** When working with background jobs in Ash Framework projects:

1. **ALWAYS use Ash.Oban primitives** - triggers, scheduled actions, and the AshOban DSL
2. **NEVER write custom Oban workers** unless Ash.Oban cannot solve your use case
3. **Oban core documentation is for REFERENCE ONLY** - fallback when Ash.Oban docs don't cover something

### Priority Hierarchy

**1. Ash.Oban Primitives (FIRST PRIORITY)**
- Use `trigger` for record-based background jobs
- Use `scheduled_actions` for periodic tasks
- Use Ash.Oban's built-in error handling (`on_error`)
- Use Ash.Oban's actor persistence for user context
- Model your business logic in domain, not in workers

**2. Oban Core Features (FALLBACK REFERENCE ONLY)**
- Only consult when Ash.Oban docs don't cover something
- Understand Oban concepts to troubleshoot Ash.Oban
- Reference for queue configuration and monitoring

**3. NEVER Use Oban Premium/Pro Features**
- **ONLY use FREE Oban features**
- Do NOT use Oban Pro plugins (Web, Notifier, Pro workers)
- Do NOT use Oban Pro dynamic cron management
- Ash.Oban provides what you need with free Oban

### Why Ash.Oban First?

**Domain Modeling:**
- Query your domain to see what will happen ("who gets an email today?")
- Jobs automatically retry if external services fail
- Each record gets its own job (isolated failures)
- Easy to debug using your domain model

**Ash Integration:**
- Automatic authorization with policies
- Actor persistence for user context
- Integration with Ash actions and changes
- Type-safe with Ash attributes and calculations

**Simplicity:**
- No need to write custom worker modules
- Error handling through Ash actions
- Cron scheduling built-in
- Queue management automated

## Key Concepts

### Triggers vs Scheduled Actions

**Triggers:**
- Run actions on records that match a condition
- Check periodically (e.g., every minute, daily)
- Each matching record gets its own Oban job
- Example: Send email to users with subscriptions expiring in 30 days

**Scheduled Actions:**
- Run a single generic/create action on a schedule
- One job per schedule, not per record
- Example: Import data from external API every 6 hours

### Domain Modeling Advantage

AshOban encourages modeling business logic in your domain instead of relying on background jobs as the source of truth. Benefits:
- Query the domain to see what will happen (e.g., "who will get an email today?")
- Jobs automatically retry if external services fail
- Each record gets its own job (isolated failures)
- Easy to debug and re-trigger failed jobs

### Module Names (Important!)

Every trigger and scheduled action **must** have a defined `module_name`. Otherwise, renaming the trigger creates "dangling" jobs that fail. Use `mix ash_oban.set_default_module_names` to set default values.

## Quick Reference

### 1. Basic Trigger Setup

```elixir
# In your Ash resource
defmodule MyApp.Subscription do
  use Ash.Resource,
    domain: MyApp.Domain,
    extensions: [AshOban]

  oban do
    triggers do
      trigger :send_expiration_notice do
        # Action to run
        action :send_expiration_notification

        # Condition - which records to process
        where expr(
          subscription_expires_soon and
          (is_nil(last_notification_sent_at) or
            last_notification_sent_at < ago(30, :day))
        )

        # Schedule - check every day at midnight
        scheduler_cron "0 0 * * *"

        # Error handling
        on_error :handle_notification_error

        # Worker configuration
        module_name MyApp.Workers.SendExpirationNotice
        worker_read_action :read
      end
    end
  end
end
```

### 2. Scheduled Action

```elixir
# Run generic action on a schedule
oban do
  scheduled_actions do
    schedule :import_external_data do
      action :import_from_api

      # Every 6 hours
      scheduler_cron "0 */6 * * *"

      module_name MyApp.Workers.ImportExternalData
    end
  end
end
```

### 3. Installation and Configuration

```elixir
# mix.exs dependencies
{:ash_oban, "~> 0.4.12"}

# Application supervision tree
# lib/my_app/application.ex
children = [
  # Replace this:
  # {Oban, oban_config}

  # With this:
  {Oban, AshOban.config(
    Application.fetch_env!(:my_app, :ash_domains),
    oban_config
  )}

  # Or for specific domains only:
  # {Oban, AshOban.config([MyApp.Domain1, MyApp.Domain2], oban_config)}
]
```

### 4. Error Handling Action

```elixir
# Define error handler action
actions do
  update :handle_notification_error do
    accept []

    # Receive the error
    argument :error, :map do
      allow_nil? false
    end

    # Mark as errored (simple - prevents retrigger)
    change set_attribute(:notification_status, :errored)
  end
end
```

### 5. Actor Persistence (Preserving Current User)

```elixir
# 1. Create persister module
defmodule MyApp.AshObanActorPersister do
  use AshOban.ActorPersister

  # Encode actor for JSON storage
  def store(%MyApp.User{id: id}) do
    %{"type" => "user", "id" => id}
  end

  # Decode actor from JSON
  def lookup(%{"type" => "user", "id" => id}) do
    MyApp.Accounts.get_user_by_id(id)
  end

  # Default actor when none was present
  def lookup(nil), do: {:ok, nil}
end

# 2. Configure globally
# config/config.exs
config :ash_oban, :actor_persister, MyApp.AshObanActorPersister

# 3. Or per-trigger
trigger :process do
  actor_persister MyApp.AshObanActorPersister
  # ...
end

# 4. Or override to disable
trigger :system_task do
  actor_persister :none
  # ...
end
```

### 6. Authorization Bypass for Triggers

```elixir
# AshOban passes authorize?: true to all actions (as of v0.2)
# Option 1: Bypass in policies (recommended)
policies do
  bypass AshOban.Checks.AshObanInteraction do
    authorize_if always()
  end

  # ... rest of your policies
end

# Option 2: Disable globally (not recommended)
# config/config.exs
config :ash_oban, authorize?: false
```

### 7. Queue Configuration

```elixir
# Default queue name: {resource_short_name}_{trigger_name}
# Example trigger in MyApp.Resource named :process
# -> queue: :resource_process

# Add to Oban config:
config :my_app, Oban,
  queues: [
    resource_process: 10,  # 10 concurrent jobs
    default: 5
  ]

# Or customize queue in trigger:
trigger :process do
  queue :custom_queue_name
  # ...
end
```

### 8. Running Triggers Manually

```elixir
# Build trigger job for a single record
AshOban.build_trigger(subscription, :send_expiration_notice)

# Run trigger immediately for a record
AshOban.run_trigger(subscription, :send_expiration_notice)

# Run trigger for multiple records
AshOban.run_triggers([sub1, sub2], :send_expiration_notice)

# Schedule all jobs for a trigger
AshOban.schedule(MyApp.Subscription, :send_expiration_notice)
```

### 9. Igniter Installation (Recommended)

```bash
# Installs ash_oban + oban automatically
mix igniter.install ash_oban

# Sets up configuration in application.ex
# Creates necessary files
```

## Reference Files

This skill includes comprehensive documentation in `references/`:

### Ash.Oban Documentation (PRIMARY)

**triggers.md (8 pages)** - Core AshOban documentation:
- **Triggers and Scheduled Actions** - Conceptual overview, comparing triggers to traditional background jobs
- **Cron Syntax** - Understanding scheduler_cron expressions
- **AshOban.Trigger** - Trigger struct and functions
- **Getting Started** - Installation, setup, and usage guide
- **Error Handling** - on_error configuration and best practices
- **Actor Persistence** - Persisting current user across jobs
- **Authorization** - Handling authorize?: true in policies
- **Trigger Management** - Lifecycle and configuration

**other.md (1 page)** - Additional reference material and miscellaneous documentation

### Oban Core Documentation (FALLBACK REFERENCE ONLY)

Located in `references/oban-fallback/` - **consult only when Ash.Oban docs don't cover something**:

- **getting_started.md** - Oban installation and setup (use Ash.Oban installation instead)
- **configuration.md** - Oban config options (queues, plugins, cron)
- **workers.md** - Custom Oban workers (DON'T use - use Ash.Oban triggers instead)
- **queues.md** - Queue management and configuration
- **plugins.md** - Oban plugins (FREE features only - no Pro plugins)
- **testing.md** - Testing Oban jobs
- **troubleshooting.md** - Debugging Oban issues
- **other.md** - Additional Oban concepts

**⚠️ Remember:** Only reference Oban core docs for understanding underlying concepts. Always implement using Ash.Oban primitives.

Use the `Read` tool to access specific reference files when you need detailed information about:
- Advanced trigger configurations
- Detailed API documentation
- Edge cases and troubleshooting
- Module names and transaction contexts
- Oban queue/plugin configuration (fallback only)

## Working with This Skill

### For Beginners

**Start here:**
1. Read "Getting Started With Ash Oban" in `references/triggers.md`
2. Understand the difference between triggers and scheduled actions
3. Set up a simple trigger (see Quick Reference #1)
4. Configure error handling (see Quick Reference #4)

**Key learning path:**
- Triggers run actions for records matching a condition
- Each matching record gets its own Oban job
- Scheduled actions run once per schedule (for generic/create actions)
- Always define `module_name` to prevent dangling jobs

### For Intermediate Users

**Common tasks:**
- Setting up actor persistence for user context (Quick Reference #5)
- Configuring authorization bypass in policies (Quick Reference #6)
- Customizing queues and worker options (Quick Reference #7)
- Running triggers manually (Quick Reference #8)

**Best practices:**
- Model state in your domain, not just in jobs
- Keep `on_error` actions simple (just set a flag)
- Use separate triggers for complex error handling
- Always test what records match your `where` condition

### For Advanced Users

**Advanced patterns:**
- Manual trigger execution with `AshOban.run_trigger/3`
- Building custom actor persisters with error handling
- Transaction handling and metadata
- Integration with existing Oban workers
- Multi-tenancy with triggers

**Architecture considerations:**
- When to use triggers vs scheduled actions vs manual Oban workers
- Queue design and concurrency limits
- Error recovery strategies
- Monitoring and observability

## Common Patterns

### Pattern: Send Email When Subscription Expires Soon

Instead of a background job that queries for expiring subscriptions:

```elixir
# ❌ Traditional approach (background job as source of truth)
def send_expiration_emails do
  Subscription
  |> query_expiring_subscriptions()
  |> Enum.each(&send_email/1)
end

# ✅ AshOban approach (domain model as source of truth)
# 1. Model the state
attributes do
  attribute :last_expiration_notification_sent_at, :utc_datetime_usec
end

calculations do
  calculate :subscription_expires_soon, :boolean do
    calculation expr(expires_at < from_now(30, :day))
  end

  calculate :should_send_expiring_notification, :boolean do
    calculation expr(
      subscription_expires_soon and
      (is_nil(last_expiration_notification_sent_at) or
        last_expiration_notification_sent_at < ago(30, :day))
    )
  end
end

# 2. Add action with change
actions do
  update :send_expiration_notification do
    change SendExpiringSubscriptionEmail
    change set_attribute(:last_expiration_notification_sent_at, &DateTime.utc_now/0)
  end
end

# 3. Add trigger
oban do
  triggers do
    trigger :send_expiration_notice do
      action :send_expiration_notification
      where expr(should_send_expiring_notification)
      scheduler_cron "@daily"  # Runs at midnight
      on_error :handle_notification_error
      module_name MyApp.Workers.SendExpirationNotice
    end
  end
end
```

**Benefits:**
- Can query "who will get an email today?" before sending
- If email provider is down, retries next day automatically
- Each user gets their own job (isolated failures)
- Easy to debug: check user's state to see why they didn't get email

### Pattern: Periodic Data Import

```elixir
# For importing data from external API
oban do
  scheduled_actions do
    schedule :import_products do
      action :import_from_shopify
      scheduler_cron "0 */6 * * *"  # Every 6 hours
      module_name MyApp.Workers.ImportProducts
    end
  end
end

actions do
  create :import_from_shopify do
    change ImportProductsFromShopifyChange
  end
end
```

## Cron Expression Examples

```elixir
"@hourly"          # Every hour
"@daily"           # Midnight every day (0 0 * * *)
"@weekly"          # Sundays at midnight (0 0 * * 0)
"@monthly"         # First of month at midnight (0 0 1 * *)

"*/5 * * * *"      # Every 5 minutes
"0 */2 * * *"      # Every 2 hours
"0 9 * * *"        # 9 AM daily
"0 9 * * 1-5"      # 9 AM weekdays
"0 0,12 * * *"     # Midnight and noon
"30 2 1 * *"       # 2:30 AM on first of month
```

## Troubleshooting

### Trigger Not Firing

**Check:**
1. Is queue configured in Oban config?
2. Does `where` condition match any records?
3. Is `worker_read_action` accessible?
4. Check Oban dashboard for job status

**Debug:**
```elixir
# See which records match
MyApp.Subscription
|> Ash.Query.filter(should_send_expiring_notification)
|> MyApp.Domain.read!()
```

### Authorization Errors

Add bypass to policies (see Quick Reference #6) or check actor is available.

### Dangling Jobs After Rename

Always set `module_name` explicitly. Use `mix ash_oban.set_default_module_names` to fix existing triggers.

## Resources

### Official Documentation
- [AshOban HexDocs](https://hexdocs.pm/ash_oban/) - PRIMARY reference
- [Oban Documentation](https://hexdocs.pm/oban/) - Fallback reference only (FREE features)

### Related Ash Extensions
- `Ash.Notifier.PubSub` - Real-time notifications (alternative to some trigger use cases)
- `Ash.Policy.Authorizer` - Authorization for trigger actions

## Notes

- **Version:** This skill covers ash_oban v0.4.12
- **⚠️ FREE Oban Only:** This skill uses ONLY FREE Oban features - NEVER use Oban Pro/Premium features
- **Module Names:** Critical for production - prevents dangling jobs when renaming triggers
- **Authorization:** As of v0.2, `authorize?: true` is passed to all actions
- **Transactions:** AshOban uses explicit transactions for serial execution and locking
- **Ash.Oban First:** ALWAYS use Ash.Oban primitives - Oban docs are for fallback reference only

## Migration Guide

### If you have triggers without module_names:

```bash
# 1. Run this command to set defaults
mix ash_oban.set_default_module_names

# 2. Deploy the changes

# 3. Now safe to rename triggers
```
