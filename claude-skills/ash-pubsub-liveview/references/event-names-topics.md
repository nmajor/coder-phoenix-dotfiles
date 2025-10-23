# Event Names and Topics

Understanding Ash's automatic event generation and topic patterns for LiveView subscriptions.

## Event Name Generation

Ash automatically generates event names based on the action name unless explicitly overridden.

### Default Event Names

```elixir
# In resource
pub_sub do
  publish :create, ["tickets"]   # event name: "create"
  publish :update, ["tickets"]   # event name: "update"
  publish :destroy, ["tickets"]  # event name: "destroy"
end
```

**Notification payload:**
```elixir
%Ash.Notifier.Notification{
  action: %{name: :create},  # This is the action name
  # ...
}
```

### Custom Event Names

Override with the `event` option:

```elixir
pub_sub do
  # Action name: :create
  # Event name: "ticket_created"
  publish :create, ["tickets"], event: "ticket_created"

  # Action name: :assign
  # Event name: "assigned"
  publish :assign, ["tickets"], event: "assigned"
end
```

**When to use custom event names:**
- External integrations expecting specific event names
- Clearer semantic meaning (e.g., "assigned" vs "assign")
- Avoiding conflicts with Phoenix.LiveView internal events

### Pattern Matching Events in LiveView

**Default events (recommended):**
```elixir
def handle_info(%{payload: %Ash.Notifier.Notification{
  action: %{name: :create}
}}, socket) do
  # Handle create
end

def handle_info(%{payload: %Ash.Notifier.Notification{
  action: %{name: :update}
}}, socket) do
  # Handle update
end

def handle_info(%{payload: %Ash.Notifier.Notification{
  action: %{name: :destroy}
}}, socket) do
  # Handle destroy
end
```

**Custom events:**
```elixir
# If you used: event: "ticket_created"
def handle_info(%{event: "ticket_created", payload: %Ash.Notifier.Notification{}}, socket) do
  # Handle creation
end
```

## Topic Patterns

### Static Topics

**Resource configuration:**
```elixir
publish :create, ["tickets"]
```

**LiveView subscription:**
```elixir
keep_live(:tickets, fn socket ->
  Ash.read!(Ticket, actor: socket.assigns.current_user)
end, subscribe: "tickets")
```

**Resulting topic:** `"tickets"`

### Dynamic Topics with IDs

**Resource configuration:**
```elixir
publish :update, ["ticket", :id]
```

**LiveView subscription:**
```elixir
# For ticket with id = "abc123"
keep_live(:ticket, fn socket ->
  Ash.get!(Ticket, socket.assigns.ticket_id, actor: socket.assigns.current_user)
end, subscribe: "ticket:#{socket.assigns.ticket_id}")
```

**Resulting topic:** `"ticket:abc123"`

### User-Scoped Topics

**Resource configuration:**
```elixir
publish :create, ["tickets", "user", :assigned_to_id]
```

**LiveView subscription:**
```elixir
user_id = socket.assigns.current_user.id

keep_live(:my_tickets, fn socket ->
  Ticket
  |> Ash.Query.filter(assigned_to_id == ^socket.assigns.current_user.id)
  |> Ash.read!(actor: socket.assigns.current_user)
end, subscribe: "tickets:user:#{user_id}")
```

**Resulting topic:** `"tickets:user:5"`

### Multiple Topics

**Resource broadcasts to multiple topics:**
```elixir
publish :update, [
  ["tickets"],
  ["ticket", :id],
  ["tickets", "user", :assigned_to_id]
]
```

**LiveView subscribes to ONE topic:**
```elixir
# For list view - subscribe to global
keep_live(:tickets, fn -> ... end, subscribe: "tickets")

# For show page - subscribe to specific
keep_live(:ticket, fn -> ... end, subscribe: "ticket:#{id}")

# For user view - subscribe to user-scoped
keep_live(:my_tickets, fn -> ... end, subscribe: "tickets:user:#{user_id}")
```

### Wildcard Patterns (Not Recommended)

Phoenix.PubSub doesn't support wildcards, but you can subscribe to multiple topics:

```elixir
# DON'T DO THIS (won't work)
subscribe: "tickets:*"

# Instead, subscribe to multiple topics explicitly:
Phoenix.PubSub.subscribe(MyApp.PubSub, "tickets")
Phoenix.PubSub.subscribe(MyApp.PubSub, "tickets:user:#{user_id}")

# Or better: use keep_live multiple times
keep_live(:all_tickets, fn -> ... end, subscribe: "tickets")
keep_live(:my_tickets, fn -> ... end, subscribe: "tickets:user:#{user_id}")
```

## Topic Naming Best Practices

### ✅ Good Patterns

**Hierarchical structure:**
```
"resource:scope:id"
"tickets:user:5"
"project:123:boards"
"conversation:abc:messages"
```

**Clear separation:**
```
"tickets"           # All tickets
"ticket:123"        # Specific ticket
"tickets:user:5"    # User's tickets
"tickets:status:open" # Filtered view
```

**Scoped by actor:**
```
"tickets:org:#{org_id}"
"notifications:user:#{user_id}"
"events:team:#{team_id}"
```

### ❌ Anti-Patterns

**Too broad:**
```
"app"  # Everything - causes unnecessary refetches
"updates"  # What updates?
```

**Too narrow:**
```
"ticket:123:status"  # Too granular, harder to maintain
"ticket:123:title:updated"  # Just use "ticket:123"
```

**Inconsistent delimiters:**
```
"tickets-user-5"   # Use : (colon) consistently
"tickets.user.5"   # Unless you override delimiter
"tickets/user/5"   # Confusing with URLs
```

## Prefix Configuration

The `prefix` option prepends all topics:

```elixir
pub_sub do
  prefix "app"
  publish :create, ["tickets"]
end
```

**Resulting topic:** `"app:tickets"`

**LiveView subscription:**
```elixir
subscribe: "app:tickets"  # Must include prefix
```

### When to Use Prefix

**Multi-app deployments:**
```elixir
# App A
prefix "crm"  # Topics: "crm:leads", "crm:contacts"

# App B
prefix "support"  # Topics: "support:tickets", "support:chats"
```

**Environment separation:**
```elixir
# Usually NOT recommended - use separate PubSub modules instead
prefix "#{Mix.env()}"  # DON'T DO THIS
```

**Versioning:**
```elixir
prefix "v1"  # For API versioning
```

## Complete Topic Examples

### Example 1: Ticket System

```elixir
# Resource
pub_sub do
  module MyApp.PubSub
  prefix "support"

  publish :create, [["tickets"]]
  publish :update, [
    ["tickets"],
    ["ticket", :id],
    ["tickets", "user", :assigned_to_id]
  ]
  publish :destroy, [["tickets"], ["ticket", :id]]
end

# LiveView subscriptions:

# 1. Admin viewing all tickets
subscribe: "support:tickets"

# 2. User viewing their assigned tickets
subscribe: "support:tickets:user:#{user_id}"

# 3. Show page for specific ticket
subscribe: "support:ticket:#{ticket_id}"
```

### Example 2: Real-Time Chat

```elixir
# Resource: Message
pub_sub do
  module MyApp.PubSub

  publish :create, ["conversation", :conversation_id, "messages"]
  publish :update, ["conversation", :conversation_id, "messages"]
  publish :destroy, ["conversation", :conversation_id, "messages"]
end

# LiveView subscription:
subscribe: "conversation:#{conversation_id}:messages"
```

### Example 3: Multi-Tenant SaaS

```elixir
# Resource
multitenancy do
  strategy :attribute
  attribute :organization_id
end

pub_sub do
  module MyApp.PubSub

  publish :create, ["org", :_tenant, "projects"]
  publish :update, ["org", :_tenant, "projects"]
end

# LiveView subscription (tenant comes from socket assigns):
subscribe: "org:#{socket.assigns.current_user.organization_id}:projects"
```

## Debugging Topics

### Check Active Subscriptions

```elixir
# In IEx or LiveView handle_info
Phoenix.PubSub.subscribers(MyApp.PubSub, "tickets")
# Returns list of PIDs subscribed to this topic
```

### Manual Broadcast for Testing

```elixir
# Create a test notification
notification = %Ash.Notifier.Notification{
  resource: MyApp.Support.Ticket,
  action: %{name: :create, type: :create},
  data: ticket,
  actor: user
}

# Broadcast it
Phoenix.PubSub.broadcast(
  MyApp.PubSub,
  "tickets",
  %{topic: "tickets", payload: notification}
)
```

### Enable Debug Logging

```elixir
# config/dev.exs
config :ash, :pub_sub, debug?: true

# Logs will show:
# [debug] Broadcasting to topic: tickets
# [debug] Event: create
# [debug] Broadcast type: notification
```

## Topic Mismatch Troubleshooting

**Problem:** LiveView not receiving updates

**Checklist:**
1. ✅ Topic names match exactly (including prefix)
2. ✅ Dynamic values interpolated correctly (`:id` → actual ID)
3. ✅ Delimiters match (`:` is default)
4. ✅ Subscribed to the right topic for your view
5. ✅ Resource is actually broadcasting (check with debug mode)

**Example mismatch:**
```elixir
# Resource broadcasts to:
publish :create, ["tickets"]  # Topic: "tickets"

# LiveView subscribes to:
subscribe: "ticket"  # ❌ WRONG - missing 's'
subscribe: "tickets"  # ✅ CORRECT
```

## Topic Selection Decision Tree

```
┌─ Single record (show page)?
│   └─ subscribe: "#{resource}:#{id}"
│
├─ All records (admin view)?
│   └─ subscribe: "#{resource}s"
│
├─ Filtered by user/org/team?
│   └─ subscribe: "#{resource}s:#{scope}:#{scope_id}"
│
├─ Nested resource (e.g., comments on post)?
│   └─ subscribe: "#{parent}:#{parent_id}:#{resource}s"
│
└─ Multiple related resources?
    └─ Use multiple keep_live with different topics
```

## Next Steps

- **Review** `liveview-patterns.md` for subscription implementation
- **See** `ash-resource-setup.md` for topic configuration examples
