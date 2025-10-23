---
name: ash-pubsub-liveview
description: Real-time updates with PubSub. Use for ANY real-time features, live updates, reactive UIs, PubSub integration, WebSocket synchronization, and building responsive applications with Ash Framework and Phoenix LiveView.
---

# Ash PubSub + LiveView Real-Time Patterns

**Gold-standard patterns for real-time updates using Ash Framework PubSub with Phoenix LiveView.**

## When to Use This Skill

**Trigger this skill for ANY real-time work:**

- **Live dashboards** - Real-time status displays, analytics, monitoring
- **Collaborative features** - Multiple users editing simultaneously, shared workspaces
- **Notifications and alerts** - User notifications, system alerts, warnings
- **Real-time lists** - Live tickets, messages, orders, inventory
- **Progress tracking** - Background job progress, long-running operations (Oban integration)
- **Chat interfaces** - Messaging, comments, conversations
- **Live data visualization** - Charts, graphs, metrics updating in real-time
- **Multi-user synchronization** - Keeping views in sync across users

**When NOT to use:** Static pages without real-time requirements.

## Core Philosophy

This skill defines the canonical approach for building real-time, reactive interfaces with Ash Framework:

- **Ash handles ALL data operations** - Use domain functions exclusively (`Ash.read!`, `Ash.create!`, etc.)
- **Single source of truth** - LiveView assigns structure with proper scoping
- **Subscribe-refetch pattern** - Events signal changes, refetch ensures consistency and authorization
- **Progressive enhancement** - Start simple (Tier 1), optimize when needed (Tier 2)
- **Reliability over optimization** - Edge case handling, reconnections, and auth changes handled automatically

## Quick Reference

### 1. Basic Ash Resource PubSub Setup

Configure your Ash resource to broadcast events:

```elixir
defmodule MyApp.Support.Ticket do
  use Ash.Resource,
    domain: MyApp.Support,
    data_layer: AshPostgres.DataLayer

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

### 2. Tier 1 LiveView Pattern (Simple & Reliable)

Start here for all new features - simple, reliable, handles all edge cases:

```elixir
defmodule MyAppWeb.TicketLive do
  use MyAppWeb, :live_view
  import AshPhoenix.LiveView

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> keep_live(:tickets, fn socket ->
       Ash.read!(Ticket, actor: socket.assigns.current_user)
     end, subscribe: "tickets")}
  end

  def handle_info(%{topic: topic, payload: %Ash.Notifier.Notification{}}, socket) do
    {:noreply, handle_live(socket, topic, [:tickets])}
  end
end
```

**Use when:** List has <100 items, updates are infrequent (<1/min), reliability > performance

### 3. Tier 2 LiveView Pattern (Optimized for Scale)

Evolve to this when you need better performance:

```elixir
defmodule MyAppWeb.TicketLive do
  use MyAppWeb, :live_view
  import AshPhoenix.LiveView

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> keep_live(:tickets, fn socket ->
       tickets = Ash.read!(Ticket, actor: socket.assigns.current_user)
       stream(socket, :tickets, tickets)
     end, subscribe: "tickets")}
  end

  # Handle create events
  def handle_info(%{payload: %Ash.Notifier.Notification{
    action: %{name: :create},
    data: ticket
  }}, socket) do
    {:noreply, stream_insert(socket, :tickets, ticket, at: 0)}
  end

  # Handle update events
  def handle_info(%{payload: %Ash.Notifier.Notification{
    action: %{name: :update},
    data: ticket
  }}, socket) do
    {:noreply, stream_insert(socket, :tickets, ticket)}
  end

  # Handle destroy events
  def handle_info(%{payload: %Ash.Notifier.Notification{
    action: %{name: :destroy},
    data: ticket
  }}, socket) do
    {:noreply, stream_delete(socket, :tickets, ticket)}
  end

  # Fallback for bulk updates
  def handle_info(%{topic: topic, payload: %Ash.Notifier.Notification{}}, socket) do
    {:noreply, handle_live(socket, topic, [:tickets])}
  end
end
```

**Use when:** List has 100+ items, updates are frequent (>1/min), performance is critical

### 4. User-Scoped Topics (Filtered Views)

Broadcast to multiple topics for different views:

```elixir
# In Ash Resource
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
end

# In LiveView - subscribe to user-specific topic
def mount(_params, _session, socket) do
  user_id = socket.assigns.current_user.id

  {:ok,
   socket
   |> assign(:user_id, user_id)
   |> keep_live(:my_tickets, fn socket ->
     Ticket
     |> Ash.Query.filter(assigned_to_id == ^socket.assigns.user_id)
     |> Ash.read!(actor: socket.assigns.current_user)
   end, subscribe: "tickets:user:#{user_id}")}
end
```

### 5. Single Record Updates (Show Page)

Subscribe to specific record changes:

```elixir
# In Ash Resource - dynamic topic with record ID
pub_sub do
  publish :update, ["ticket", :id]
end

# In LiveView
def mount(%{"id" => id}, _session, socket) do
  {:ok,
   socket
   |> assign(:ticket_id, id)
   |> keep_live(:ticket, fn socket ->
     Ash.get!(Ticket, socket.assigns.ticket_id, actor: socket.assigns.current_user)
   end, subscribe: "ticket:#{id}")}
end

def handle_info(%{topic: topic, payload: %Ash.Notifier.Notification{}}, socket) do
  {:noreply, handle_live(socket, topic, [:ticket])}
end
```

### 6. Multiple Queries in One View

Track multiple live queries simultaneously:

```elixir
def mount(_params, _session, socket) do
  {:ok,
   socket
   |> keep_live(:open_tickets, fn socket ->
     Ticket
     |> Ash.Query.filter(status == :open)
     |> Ash.read!(actor: socket.assigns.current_user)
   end, subscribe: "tickets")
   |> keep_live(:closed_tickets, fn socket ->
     Ticket
     |> Ash.Query.filter(status == :closed)
     |> Ash.read!(actor: socket.assigns.current_user)
   end, subscribe: "tickets")}
end

def handle_info(%{topic: topic, payload: %Ash.Notifier.Notification{}}, socket) do
  {:noreply, handle_live(socket, topic, [:open_tickets, :closed_tickets])}
end
```

### 7. LiveComponents with PubSub

Use PubSub in reusable components:

```elixir
# Parent LiveView
def render(assigns) do
  ~H"""
  <.live_component
    module={TicketListComponent}
    id="ticket-list"
    current_user={@current_user}
  />
  """
end

# lib/my_app_web/live/ticket_list_component.ex
defmodule MyAppWeb.TicketListComponent do
  use MyAppWeb, :live_component
  import AshPhoenix.LiveView

  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> keep_live(:tickets, fn socket ->
       Ash.read!(Ticket, actor: socket.assigns.current_user)
     end, subscribe: "tickets")}
  end

  def handle_info(%{topic: topic, payload: %Ash.Notifier.Notification{}}, socket) do
    {:noreply, handle_live(socket, topic, [:tickets])}
  end
end
```

### 8. Debugging PubSub

Enable debug mode and verify broadcasts:

```elixir
# config/dev.exs
config :ash, :pub_sub, debug?: true

# In IEx - check subscriptions
Phoenix.PubSub.subscribers(MyApp.PubSub, "tickets")

# Manually trigger a broadcast for testing
Phoenix.PubSub.broadcast(
  MyApp.PubSub,
  "tickets",
  %{
    topic: "tickets",
    payload: %Ash.Notifier.Notification{
      action: %{name: :create},
      data: ticket
    }
  }
)
```

### 9. Multi-Tenancy with PubSub

Scope topics by tenant/organization:

```elixir
# In Ash Resource
multitenancy do
  strategy :attribute
  attribute :organization_id
end

pub_sub do
  module MyApp.PubSub

  # Scoped to tenant using :_tenant
  publish :create, ["org", :_tenant, "tickets"]
  publish :update, ["org", :_tenant, "tickets"]
end

# In LiveView - subscribe to tenant-specific topic
subscribe: "org:#{socket.assigns.current_user.organization_id}:tickets"
```

### 10. Chat/Messaging Pattern

Real-time messages scoped to conversation:

```elixir
# Resource: Message
pub_sub do
  module MyApp.PubSub

  publish :create, ["conversation", :conversation_id, "messages"]
  publish :update, ["conversation", :conversation_id, "messages"]
  publish :destroy, ["conversation", :conversation_id, "messages"]
end

# LiveView subscription
def mount(%{"conversation_id" => conv_id}, _session, socket) do
  {:ok,
   socket
   |> keep_live(:messages, fn socket ->
     Message
     |> Ash.Query.filter(conversation_id == ^conv_id)
     |> Ash.read!(actor: socket.assigns.current_user)
   end, subscribe: "conversation:#{conv_id}:messages")}
end
```

## Key Concepts

### The Subscribe-Refetch Pattern

**Core principle:** PubSub events are **notifications** that changes occurred, not the data itself.

**How it works:**
1. **Initial load**: Query Ash for full, authorized data
2. **Subscribe**: Listen to relevant topics
3. **On notification**: Refetch data through Ash domain functions
4. **Benefits**:
   - Authorization respected (policies applied on refetch)
   - No stale data (always fetch latest)
   - Race conditions handled automatically
   - Network reconnections handled automatically
   - Simpler than optimistic updates

**Why refetch vs using notification data?**
- Notification data bypasses policies (security risk!)
- Refetch ensures current user is still authorized to see the data
- Handles edge cases like concurrent updates, authorization changes mid-session
- Notification might not include all fields needed for display

### AshPhoenix.LiveView Helpers

**`keep_live/4`** - Manages live queries with automatic subscriptions:
- Handles subscription lifecycle (subscribe, unsubscribe on unmount)
- Automatic reconnection logic
- Authorization refreshes on refetch
- Initial data loading
- Pagination support

**`handle_live/3`** - Processes notifications and refetches:
- Receives `Ash.Notifier.Notification` events
- Triggers callbacks defined in `keep_live`
- Handles multiple queries simultaneously
- Applies authorization policies on refetch

**Why use these instead of manual Phoenix.PubSub?**
- Eliminates race conditions between mount and subscription
- Automatic cleanup on unmount
- Handles edge cases (reconnections, auth changes, duplicate events)
- Less code, fewer bugs

### Ash PubSub Notifications

Ash automatically broadcasts events when actions complete:

**Automatic event names:**
- `:create` - For create actions
- `:update` - For update actions
- `:destroy` - For destroy actions
- Custom actions use their action name (e.g., `:assign`, `:escalate`)

**Notification payload structure:**
```elixir
%Ash.Notifier.Notification{
  action: %{name: :create, type: :create},
  data: %Ticket{id: 1, status: "open"},  # The created/updated/destroyed record
  resource: MyApp.Support.Ticket,
  actor: %User{id: 5},
  changeset: %Ash.Changeset{},
  # ... other fields
}
```

**Important:** The `data` field contains the record but is NOT authorized. Always refetch through Ash to apply policies.

### Topic Naming Patterns

**Good patterns:**
```
"tickets"                    # All tickets (global)
"ticket:123"                 # Specific ticket (show page)
"tickets:user:5"             # User's tickets (filtered view)
"tickets:status:open"        # Status filter
"conversation:abc:messages"  # Nested resources
"org:123:projects"           # Multi-tenant scoped
```

**Anti-patterns:**
```
"app"                        # Too broad - unnecessary refetches
"updates"                    # Vague - what updates?
"ticket:123:status"          # Too granular - just use "ticket:123"
```

**Hierarchical structure:**
```
"resource:scope:id"
```

### When to Optimize (Tier 1 → Tier 2)

**Start with Tier 1 (full refetch) unless:**
1. List has 100+ items AND
2. Updates are frequent (>1/min) AND
3. Users report lag or flicker

**How to decide:**
1. **Measure first** - Use Phoenix LiveDashboard to profile
2. **Check list size** - How many items are displayed?
3. **Check update frequency** - How often do updates happen?
4. **User feedback** - Are users experiencing issues?

**Tier 1 characteristics:**
- ✅ Simple - one handler
- ✅ Reliable - handles all edge cases automatically
- ✅ Good for <100 items
- ⚠️ Refetches entire list on every event
- ⚠️ May cause UI flicker on large lists

**Tier 2 characteristics:**
- ✅ Efficient - only updates changed items
- ✅ No flicker - smooth UI updates
- ✅ Scales to 1000+ items
- ⚠️ More complex - need handlers for each action type
- ⚠️ Must refetch notification data to apply authorization

## Reference Files

This skill includes comprehensive guides in `references/`:

- **ash-resource-setup.md** - Complete Ash resource PubSub configuration
  - Basic configuration examples
  - Topic patterns (static, dynamic, multiple)
  - Special topic atoms (`:_pkey`, `:_tenant`)
  - Update-specific old/new value handling
  - Custom event names
  - Broadcast types
  - Multi-tenancy setup
  - Complete real-world example with policies

- **event-names-topics.md** - Event naming, topic patterns, payload structure
  - Default vs custom event names
  - Pattern matching events in LiveView
  - Topic patterns (static, dynamic, user-scoped, multiple)
  - Topic naming best practices
  - Prefix configuration
  - Complete examples (ticket system, chat, multi-tenant)
  - Debugging topics
  - Topic selection decision tree

- **edge-cases-pitfalls.md** - Common mistakes and how to avoid them
  - Automatic protections (reconnections, race conditions, auth changes)
  - Common pitfalls (manual subscription, direct DB queries, topic mismatch)
  - Specific edge cases (events during mount, assignment changes, rapid updates)
  - Testing for edge cases
  - Debugging checklist

## Working with This Skill

### For Beginners

**Start here:**
1. Read the **Quick Reference** section above - try examples 1-3
2. Copy the **Tier 1 pattern** for your first feature
3. Configure your Ash resource with basic PubSub (example 1)
4. Test with multiple browser windows
5. Enable debug mode if things don't work (example 8)

**Common beginner mistakes:**
- Forgetting `actor:` in Ash queries (security issue!)
- Topic names not matching between resource and LiveView
- Using notification data directly instead of refetching

### For Intermediate Users

**When you're comfortable with basics:**
1. Review `references/ash-resource-setup.md` for advanced topic patterns
2. Implement user-scoped topics (example 4)
3. Try multiple queries in one view (example 6)
4. Explore `references/event-names-topics.md` for topic strategies
5. Read `references/edge-cases-pitfalls.md` to understand what can go wrong

**When to level up:**
- Use **Tier 2 pattern** when lists get large (>100 items)
- Implement **multi-tenancy** for SaaS applications (example 9)
- Add **LiveComponents** for reusable real-time widgets (example 7)

### For Advanced Users

**Deep dives:**
1. `references/ash-resource-setup.md` - Master all topic patterns and broadcast types
2. `references/edge-cases-pitfalls.md` - Handle race conditions, rapid updates, multi-tenant edge cases
3. Implement custom debouncing for high-frequency updates
4. Optimize with selective field loading
5. Build complex multi-resource real-time dashboards

**Advanced patterns:**
- Debounced updates for rapid changes
- Hierarchical topic structures (project → board → cards)
- Cross-resource real-time synchronization
- Real-time audit trails with ash-paper-trail

## Critical Rules

### ✅ DO:
- Use `keep_live` and `handle_live` for all PubSub integration
- Always fetch data through Ash domain functions (`Ash.read!`, `Ash.get!`)
- Pattern match on `%Ash.Notifier.Notification{}` in `handle_info/2`
- Subscribe to scoped topics (e.g., `"tickets:user:#{id}"`)
- Start with Tier 1 pattern, optimize to Tier 2 when needed
- Let Ash handle event generation (use default action names)
- Test with multiple users to verify authorization
- Use `actor:` option in all Ash queries for proper policies

### ❌ DON'T:
- Manually subscribe with `Phoenix.PubSub.subscribe` (use `keep_live` instead)
- Query database directly (always use Ash functions)
- Broadcast custom structs (let Ash.Notifier.PubSub handle it)
- Assume notification data is authorized (always refetch)
- Put business logic in LiveView (keep it in Ash actions/resources)
- Use optimistic updates without version tracking
- Subscribe to overly broad topics (causes unnecessary refetches)
- Mix manual PubSub with AshPhoenix helpers

## Common Issues and Solutions

**No updates received:**
- ✅ Check topic names match exactly between resource and LiveView
- ✅ Enable debug mode: `config :ash, :pub_sub, debug?: true`
- ✅ Verify resource action completes successfully

**Unauthorized data shown:**
- ✅ Always use `actor:` option in Ash queries
- ✅ Refetch data instead of using notification payload directly

**Performance lag:**
- ✅ Check list size - need Tier 2 pattern for 100+ items
- ✅ Use streams instead of assigns for large lists
- ✅ Consider debouncing for high-frequency updates

**Flicker on updates:**
- ✅ Use streams (Tier 2) instead of regular assigns
- ✅ Ensure proper DOM key tracking with `stream(:tickets, tickets)`

**Multi-user conflicts:**
- ✅ Subscribe-refetch pattern handles this automatically
- ✅ Last write wins (Ash handles concurrency)
- ✅ Consider optimistic locking for critical updates

## Resources

- **Ash.Notifier.PubSub**: https://hexdocs.pm/ash/Ash.Notifier.PubSub.html
- **AshPhoenix.LiveView**: https://hexdocs.pm/ash_phoenix/AshPhoenix.LiveView.html
- **Phoenix.LiveView Streams**: https://hexdocs.pm/phoenix_live_view/Phoenix.LiveView.html#stream/3
- **Phoenix.PubSub**: https://hexdocs.pm/phoenix_pubsub/Phoenix.PubSub.html
