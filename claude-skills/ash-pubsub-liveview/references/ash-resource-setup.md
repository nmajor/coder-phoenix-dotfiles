# Ash Resource PubSub Setup

Complete guide to configuring Ash resources for PubSub notifications.

## Basic Configuration

```elixir
defmodule MyApp.Support.Ticket do
  use Ash.Resource,
    domain: MyApp.Support,
    data_layer: AshPostgres.DataLayer

  postgres do
    table "tickets"
    repo MyApp.Repo
  end

  # PubSub configuration
  pub_sub do
    module MyApp.PubSub          # Your Phoenix.PubSub module
    prefix "tickets"             # Topic prefix

    # Basic publications - defaults to action name
    publish :create, ["tickets"]
    publish :update, ["tickets"]
    publish :destroy, ["tickets"]
  end

  attributes do
    uuid_primary_key :id
    attribute :title, :string, allow_nil?: false
    attribute :status, :atom, constraints: [one_of: [:open, :in_progress, :closed]]
    timestamps()
  end

  actions do
    defaults [:read, :destroy]

    create :create do
      accept [:title, :status]
    end

    update :update do
      accept [:title, :status]
    end
  end
end
```

## Topic Patterns

### Static Topics

Broadcast to a fixed topic regardless of record data:

```elixir
pub_sub do
  module MyApp.PubSub
  prefix "support"

  # All ticket events go to "support:tickets"
  publish :create, ["tickets"]
  publish :update, ["tickets"]
  publish :destroy, ["tickets"]
end
```

### Dynamic Topics with Record Fields

Use atoms to inject record field values into topics:

```elixir
pub_sub do
  module MyApp.PubSub

  # Broadcast to "ticket:<id>" (e.g., "ticket:123")
  publish :create, ["ticket", :id]
  publish :update, ["ticket", :id]
  publish :destroy, ["ticket", :id]
end
```

### Multiple Topics

Broadcast to multiple topics simultaneously:

```elixir
pub_sub do
  module MyApp.PubSub

  # Broadcasts to BOTH topics:
  # - "tickets" (all tickets)
  # - "tickets:user:<assigned_to_id>" (user-specific)
  publish :create, [
    ["tickets"],
    ["tickets", "user", :assigned_to_id]
  ]

  publish :update, [
    ["tickets"],
    ["tickets", "user", :assigned_to_id]
  ]

  publish :destroy, [
    ["tickets"],
    ["tickets", "user", :assigned_to_id]
  ]
end
```

### Special Topic Atoms

**`:_pkey`** - Stringified primary key:
```elixir
publish :update, ["ticket", :_pkey]
# For composite keys: concatenates all PK fields
```

**`:_tenant`** - Tenant value from changeset context:
```elixir
publish :create, ["tenant", :_tenant, "tickets"]
# Broadcasts to "tenant:org_123:tickets"
```

### Update-Specific: Old and New Values

For updates, publishes to BOTH old and new values when field changes:

```elixir
pub_sub do
  module MyApp.PubSub

  # When assigned_to_id changes from 5 to 10:
  # - Broadcasts to "tickets:user:5" (old)
  # - Broadcasts to "tickets:user:10" (new)
  publish :update, ["tickets", "user", :assigned_to_id]
end
```

**Important limitations:**
- If previous value was `nil` → no broadcast to old value topic
- If new value is `nil` → no broadcast to new value topic
- If field was not selected in query → no broadcast

## Custom Event Names

Override the default event name:

```elixir
pub_sub do
  module MyApp.PubSub

  # Event will be "ticket_created" instead of "create"
  publish :create, ["tickets"], event: "ticket_created"

  # For update action named "assign", event will be "assigned"
  publish :assign, ["tickets"], event: "assigned"
end
```

## Broadcast Types

Control the message format:

```elixir
pub_sub do
  module MyApp.PubSub
  broadcast_type :phoenix_broadcast  # or :notification (default) or :broadcast

  publish :create, ["tickets"]
end
```

**Options:**
- `:notification` (default) - Just sends the `%Ash.Notifier.Notification{}` struct
- `:phoenix_broadcast` - Wraps in `%Phoenix.Socket.Broadcast{topic, event, payload}`
- `:broadcast` - Custom map: `%{topic: topic, event: event, payload: notification}`

## Prefix and Delimiter

```elixir
pub_sub do
  module MyApp.PubSub
  prefix "app"           # All topics prefixed with "app"
  delimiter "."          # Use "." instead of ":" (default)

  # Produces: "app.tickets.123" instead of "app:tickets:123"
  publish :create, ["tickets", :id]
end
```

## Per-Action Configuration

Different configuration for each action:

```elixir
pub_sub do
  module MyApp.PubSub

  # Create: broadcast to general topic
  publish :create, ["tickets"]

  # Update: broadcast to both general and specific
  publish :update, [
    ["tickets"],
    ["ticket", :id]
  ]

  # Assign: only to user-specific topics
  publish :assign, [
    ["tickets", "user", :assigned_to_id]
  ], event: "assigned"

  # Don't broadcast destroy at all (omit it)
end
```

## Multi-Tenancy

```elixir
multitenancy do
  strategy :attribute
  attribute :organization_id
end

pub_sub do
  module MyApp.PubSub

  # Scoped to tenant
  publish :create, ["org", :_tenant, "tickets"]
  publish :update, ["org", :_tenant, "tickets"]

  # Results in topics like: "org:abc123:tickets"
end
```

## Complete Real-World Example

```elixir
defmodule MyApp.Support.Ticket do
  use Ash.Resource,
    domain: MyApp.Support,
    data_layer: AshPostgres.DataLayer

  postgres do
    table "tickets"
    repo MyApp.Repo
  end

  pub_sub do
    module MyApp.PubSub
    prefix "support"

    # General ticket topic for list views
    publish :create, [["tickets"]]

    # Multiple topics for updates:
    # 1. General list
    # 2. Specific ticket (for show pages)
    # 3. User-specific (when assignment changes)
    publish :update, [
      ["tickets"],
      ["ticket", :id],
      ["tickets", "user", :assigned_to_id]
    ]

    # Only to general list and specific ticket
    publish :destroy, [
      ["tickets"],
      ["ticket", :id]
    ]

    # Custom action with custom event name
    publish :escalate, [
      ["tickets"],
      ["ticket", :id]
    ], event: "ticket_escalated"
  end

  attributes do
    uuid_primary_key :id

    attribute :title, :string, allow_nil?: false
    attribute :description, :string
    attribute :status, :atom,
      constraints: [one_of: [:open, :in_progress, :closed]],
      default: :open

    attribute :priority, :atom,
      constraints: [one_of: [:low, :medium, :high, :urgent]],
      default: :medium

    create_timestamp :inserted_at
    update_timestamp :updated_at
  end

  relationships do
    belongs_to :assigned_to, MyApp.Accounts.User
    belongs_to :created_by, MyApp.Accounts.User
  end

  actions do
    defaults [:read]

    read :mine do
      # Shows only tickets assigned to current user
      filter expr(assigned_to_id == ^actor(:id))
    end

    create :create do
      accept [:title, :description, :priority]
      change relate_actor(:created_by)
    end

    update :update do
      accept [:title, :description, :status, :priority]
    end

    update :assign do
      accept [:assigned_to_id]
      # Will broadcast to old and new assigned_to_id topics
    end

    update :escalate do
      accept []
      change set_attribute(:priority, :urgent)
      change set_attribute(:status, :open)
    end

    destroy :destroy
  end

  policies do
    policy action_type(:read) do
      authorize_if relates_to_actor_via([:assigned_to, :created_by])
    end

    policy action_type([:create, :update, :destroy]) do
      authorize_if actor_attribute_equals(:role, :admin)
      authorize_if relates_to_actor_via(:created_by)
    end
  end
end
```

## Testing Your Configuration

```elixir
# In IEx
iex> {:ok, ticket} = MyApp.Support.create_ticket(%{title: "Test"}, actor: user)

# Check that notification was broadcast
# Subscribe first:
iex> Phoenix.PubSub.subscribe(MyApp.PubSub, "support:tickets")

# Then create/update and see the message:
iex> flush()
# Should show: %{topic: "support:tickets", payload: %Ash.Notifier.Notification{...}}
```

## Debugging

Enable debug mode to see all broadcasts:

```elixir
# config/dev.exs
config :ash, :pub_sub, debug?: true
```

This will log every PubSub event:
```
[debug] Broadcasting to topic: support:tickets
[debug] Event: create
[debug] Payload: %Ash.Notifier.Notification{action: %{name: :create}, ...}
```

## Common Patterns

### Pattern: Global + Scoped Topics

```elixir
# Broadcast to both global list and user-specific
publish :create, [
  ["tickets"],                          # Global
  ["tickets", "user", :assigned_to_id]  # Scoped
]
```

### Pattern: Room/Channel Based

```elixir
# For chat messages scoped to conversation
publish :create, ["conversation", :conversation_id, "messages"]
# Results in: "conversation:abc123:messages"
```

### Pattern: Hierarchical Topics

```elixir
# Project → Board → Column → Card
publish :update, ["project", :project_id, "board", :board_id, "cards"]
```

## Next Steps

- **Read** `event-names-topics.md` for topic subscription patterns in LiveView
- **Review** `liveview-patterns.md` for implementation details
