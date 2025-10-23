# Edge Cases and Common Pitfalls

Comprehensive guide to avoiding common mistakes and handling edge cases with Ash PubSub + LiveView.

## Edge Cases Automatically Handled

When using `keep_live` and `handle_live`, these are handled for you:

### ✅ Automatic Protections

**1. Network Reconnections**
- Subscriptions are re-established automatically
- Initial data is refetched on reconnect
- Duplicate events during reconnection are deduped

**2. Race Conditions**
- Event arriving before initial load completes
- Concurrent updates from multiple users
- Out-of-order event delivery

**3. Authorization Changes**
- User's permissions change mid-session
- Refetch ensures policies are re-evaluated
- Unauthorized data never shown (refetch goes through Ash policies)

**4. Partial Failures**
- Database read fails during refetch
- Network errors during broadcast
- Invalid data in notification

**5. Subscription Lifecycle**
- Process crashes and restarts
- LiveView unmounts and remounts
- Socket disconnects mid-operation

## Common Pitfalls

### 1. Manual PubSub Subscription

❌ **DON'T** manually subscribe:
```elixir
def mount(_params, _session, socket) do
  if connected?(socket) do
    Phoenix.PubSub.subscribe(MyApp.PubSub, "tickets")
  end

  tickets = Ash.read!(Ticket, actor: socket.assigns.current_user)
  {:ok, assign(socket, tickets: tickets)}
end
```

**Problems:**
- Race condition: event can arrive between initial fetch and subscription
- No automatic reconnection handling
- Manual cleanup required
- Duplicate subscriptions if component remounts

✅ **DO** use `keep_live`:
```elixir
def mount(_params, _session, socket) do
  {:ok,
   socket
   |> keep_live(:tickets, fn socket ->
     Ash.read!(Ticket, actor: socket.assigns.current_user)
   end, subscribe: "tickets")}
end
```

### 2. Querying Database Directly

❌ **DON'T** bypass Ash:
```elixir
def handle_info(%{payload: %Ash.Notifier.Notification{}}, socket) do
  # BAD: Direct Ecto query
  tickets = Repo.all(Ticket)
  {:noreply, assign(socket, tickets: tickets)}
end
```

**Problems:**
- Policies not applied (security vulnerability!)
- Calculations not loaded
- Relationships not handled correctly
- Multi-tenancy bypassed

✅ **DO** always use Ash domain functions:
```elixir
def handle_info(%{topic: topic, payload: %Ash.Notifier.Notification{}}, socket) do
  {:noreply, handle_live(socket, topic, [:tickets])}
end
```

### 3. Topic Mismatch

❌ **DON'T** subscribe to wrong topic:
```elixir
# Resource broadcasts to: "tickets"
publish :create, ["tickets"]

# LiveView subscribes to: "ticket" (missing 's')
keep_live(:tickets, fn -> ... end, subscribe: "ticket")
```

**Symptoms:**
- No updates received
- Silent failure (no errors)

✅ **DO** match topic exactly:
```elixir
# Use debug mode to verify:
# config :ash, :pub_sub, debug?: true

keep_live(:tickets, fn -> ... end, subscribe: "tickets")
```

### 4. Missing `actor:` Option

❌ **DON'T** query without actor:
```elixir
def mount(_params, _session, socket) do
  {:ok,
   socket
   |> keep_live(:tickets, fn socket ->
     Ash.read!(Ticket)  # BAD: No actor!
   end, subscribe: "tickets")}
end
```

**Problems:**
- Policies not evaluated
- May show unauthorized data
- Calculations that depend on actor fail

✅ **DO** always pass actor:
```elixir
keep_live(:tickets, fn socket ->
  Ash.read!(Ticket, actor: socket.assigns.current_user)
end, subscribe: "tickets")
```

### 5. Assuming Notification Data is Authorized

❌ **DON'T** directly use notification data:
```elixir
def handle_info(%{payload: %Ash.Notifier.Notification{data: ticket}}, socket) do
  # BAD: Using data from notification without auth check
  {:noreply, stream_insert(socket, :tickets, ticket)}
end
```

**Problems:**
- Notification bypasses policies
- User might see unauthorized data
- Data might be stale or incomplete

✅ **DO** refetch through Ash:
```elixir
def handle_info(%{payload: %Ash.Notifier.Notification{data: ticket}}, socket) do
  # Refetch with authorization
  case Ash.get(Ticket, ticket.id, actor: socket.assigns.current_user) do
    {:ok, authorized_ticket} ->
      {:noreply, stream_insert(socket, :tickets, authorized_ticket)}
    {:error, %Ash.Error.Forbidden{}} ->
      # User not authorized - remove from view
      {:noreply, stream_delete(socket, :tickets, ticket)}
    {:error, _} ->
      # Other error - just ignore this update
      {:noreply, socket}
  end
end
```

### 6. Over-Broad Topics

❌ **DON'T** subscribe to everything:
```elixir
# All resources broadcast to "updates"
pub_sub do
  publish :create, ["updates"]
  publish :update, ["updates"]
end

# Every LiveView subscribes
subscribe: "updates"
```

**Problems:**
- Unnecessary refetches for unrelated data
- Performance degradation
- Network traffic

✅ **DO** use scoped topics:
```elixir
# Resource-specific topics
publish :create, ["tickets"]

# User-scoped subscriptions
subscribe: "tickets:user:#{user_id}"
```

### 7. Forgetting to Handle All Action Types

❌ **DON'T** only handle one action:
```elixir
# Only handles creates
def handle_info(%{payload: %Ash.Notifier.Notification{
  action: %{name: :create}
}}, socket) do
  {:noreply, handle_live(socket, :tickets)}
end

# Updates and destroys are ignored!
```

✅ **DO** handle all actions or use fallback:
```elixir
# Handle each specifically (Tier 2)
def handle_info(%{payload: %Ash.Notifier.Notification{
  action: %{name: :create},
  data: ticket
}}, socket) do
  {:noreply, stream_insert(socket, :tickets, ticket, at: 0)}
end

def handle_info(%{payload: %Ash.Notifier.Notification{
  action: %{name: :update},
  data: ticket
}}, socket) do
  {:noreply, stream_insert(socket, :tickets, ticket)}
end

def handle_info(%{payload: %Ash.Notifier.Notification{
  action: %{name: :destroy},
  data: ticket
}}, socket) do
  {:noreply, stream_delete(socket, :tickets, ticket)}
end

# Catch-all for unknown actions (Tier 1)
def handle_info(%{topic: topic, payload: %Ash.Notifier.Notification{}}, socket) do
  {:noreply, handle_live(socket, topic, [:tickets])}
end
```

### 8. Not Using Streams for Large Lists

❌ **DON'T** use regular assigns for large lists:
```elixir
# 1000+ items in assigns
keep_live(:tickets, fn socket ->
  Ash.read!(Ticket, actor: socket.assigns.current_user)  # Returns 1000 records
end, subscribe: "tickets")

# Full list sent over websocket on every update!
```

**Problems:**
- High bandwidth usage
- Slow updates
- UI flicker

✅ **DO** use streams for large lists:
```elixir
keep_live(:tickets, fn socket ->
  tickets = Ash.read!(Ticket, actor: socket.assigns.current_user)
  stream(socket, :tickets, tickets)
end, subscribe: "tickets")
```

## Specific Edge Cases

### Edge Case 1: Event Arrives During Mount

**Scenario:** PubSub event arrives while `mount` is still executing initial query.

**Handled by `keep_live`:**
- Subscription happens AFTER initial fetch completes
- Events are queued until subscription is active
- No race condition

**If doing manual subscription:**
```elixir
# ❌ WRONG - race condition
def mount(_params, _session, socket) do
  Phoenix.PubSub.subscribe(MyApp.PubSub, "tickets")  # Subscribed too early
  tickets = Ash.read!(Ticket)  # Event could arrive during this query
  {:ok, assign(socket, tickets: tickets)}
end

# ✅ RIGHT - use keep_live
def mount(_params, _session, socket) do
  {:ok, keep_live(:tickets, fn -> Ash.read!(Ticket) end, subscribe: "tickets")}
end
```

### Edge Case 2: User's Assignment Changes

**Scenario:** User is viewing their assigned tickets. Ticket is reassigned to someone else.

**Solution:** Refetch ensures proper filtering:

```elixir
# Resource broadcasts to both old and new assignee
publish :update, ["tickets", "user", :assigned_to_id]

# User's LiveView refetches with filter
keep_live(:my_tickets, fn socket ->
  Ticket
  |> Ash.Query.filter(assigned_to_id == ^socket.assigns.current_user.id)
  |> Ash.read!(actor: socket.assigns.current_user)
end, subscribe: "tickets:user:#{socket.assigns.current_user.id}")

# When ticket is reassigned away:
# - User receives notification on their topic
# - Refetch with filter excludes the ticket
# - It disappears from their view
```

### Edge Case 3: Rapid Successive Updates

**Scenario:** Same record updated multiple times quickly (e.g., progress updates from Oban job).

**Tier 1 Behavior:** Multiple refetches (inefficient but correct)

**Tier 2 Solution:** Debounce with `Process.send_after`:

```elixir
@debounce_ms 100

def handle_info(%{payload: %Ash.Notifier.Notification{data: %{id: id}}}, socket) do
  # Cancel previous timer for this ID
  if timer = socket.assigns[:update_timers][id] do
    Process.cancel_timer(timer)
  end

  # Schedule new update
  timer = Process.send_after(self(), {:apply_update, id}, @debounce_ms)

  {:noreply,
   update(socket, :update_timers, &Map.put(&1 || %{}, id, timer))}
end

def handle_info({:apply_update, id}, socket) do
  case Ash.get(Ticket, id, actor: socket.assigns.current_user) do
    {:ok, ticket} ->
      {:noreply, stream_insert(socket, :tickets, ticket)}
    _ ->
      {:noreply, socket}
  end
end
```

### Edge Case 4: Multi-Tenant Data Leakage

**Scenario:** User switches organizations mid-session.

**Problem:**
```elixir
# User was in org A, switched to org B
# Old subscriptions still active for org A data
```

**Solution:** Re-subscribe on org change:

```elixir
def handle_event("switch_org", %{"org_id" => new_org_id}, socket) do
  # Update user's current org
  socket = assign(socket, current_org_id: new_org_id)

  # Re-initialize keep_live subscriptions (they'll unsubscribe from old topics)
  {:noreply, redirect(socket, to: ~p"/dashboard")}  # Triggers remount
end
```

### Edge Case 5: Partial Data in Stream

**Scenario:** Using Tier 2 with granular updates, but notification doesn't include all needed data.

**Problem:**
```elixir
# Resource only publishes ID
publish :update, ["ticket", :id]

# Notification only has ID, not full record
def handle_info(%{payload: %Ash.Notifier.Notification{data: ticket}}, socket) do
  # ticket.title might be nil if not selected in changeset!
  {:noreply, stream_insert(socket, :tickets, ticket)}
end
```

**Solution:** Always refetch for Tier 2:

```elixir
def handle_info(%{payload: %Ash.Notifier.Notification{data: %{id: id}}}, socket) do
  case Ash.get(Ticket, id, actor: socket.assigns.current_user) do
    {:ok, full_ticket} ->
      {:noreply, stream_insert(socket, :tickets, full_ticket)}
    _ ->
      {:noreply, socket}
  end
end
```

## Testing for Edge Cases

### Test 1: Concurrent Updates

```elixir
test "handles concurrent updates from multiple users", %{conn: conn} do
  {:ok, lv, _html} = live(conn, ~p"/tickets")

  # User A creates ticket
  {:ok, ticket} = Support.create_ticket(%{title: "Test"}, actor: user_a)

  # Verify it appears
  assert has_element?(lv, "#ticket-#{ticket.id}")

  # User B updates it concurrently
  :ok = Support.update_ticket(ticket.id, %{status: :closed}, actor: user_b)

  # Should show updated status
  assert has_element?(lv, "#ticket-#{ticket.id} .status", "closed")
end
```

### Test 2: Authorization Changes

```elixir
test "removes ticket when user loses access", %{conn: conn} do
  {:ok, lv, _html} = live(conn, ~p"/my-tickets")

  # Initially assigned to current user
  {:ok, ticket} = Support.create_ticket(%{assigned_to_id: user.id}, actor: admin)
  assert has_element?(lv, "#ticket-#{ticket.id}")

  # Reassign to someone else
  :ok = Support.update_ticket(ticket.id, %{assigned_to_id: other_user.id}, actor: admin)

  # Should disappear from view
  refute has_element?(lv, "#ticket-#{ticket.id}")
end
```

### Test 3: Network Disconnect/Reconnect

```elixir
test "recovers from network disconnect", %{conn: conn} do
  {:ok, lv, _html} = live(conn, ~p"/tickets")

  # Simulate disconnect
  Process.unlink(lv.pid)
  Process.exit(lv.pid, :kill)

  # Reconnect
  {:ok, lv, _html} = live(conn, ~p"/tickets")

  # Should still see current data
  {:ok, ticket} = Support.create_ticket(%{title: "After Reconnect"}, actor: user)
  assert has_element?(lv, "#ticket-#{ticket.id}")
end
```

## Debugging Checklist

When PubSub isn't working:

1. ✅ Enable debug mode: `config :ash, :pub_sub, debug?: true`
2. ✅ Verify topic names match exactly (resource vs LiveView)
3. ✅ Check subscriptions: `Phoenix.PubSub.subscribers(MyApp.PubSub, "topic")`
4. ✅ Manually broadcast test event
5. ✅ Verify `handle_info` pattern matches notification structure
6. ✅ Confirm resource action actually completes (isn't failing before broadcast)
7. ✅ Check policies allow reading the updated data
8. ✅ Verify PubSub module name matches in resource and application
9. ✅ Test with multiple browser windows/users

## Next Steps

- **Review** `testing-strategies.md` for comprehensive test examples
- **See** `optimization-guide.md` for performance tuning
