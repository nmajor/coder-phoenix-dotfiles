## Phoenix LiveView Standards

### Component Choice: Function Components First

**Default to function components. Use LiveComponent only when you need isolated state.**

```elixir
# ✅ Function component (preferred) - stateless UI
def card(assigns) do
  ~H"""
  <div class="card"><%= @title %></div>
  """
end

# ❌ LiveComponent for simple UI - unnecessary complexity
defmodule CardComponent do
  use Phoenix.LiveComponent
  # Don't do this for stateless presentation!
end

# ✅ LiveComponent - when you need component-specific state
defmodule ProductSelectorComponent do
  use Phoenix.LiveComponent
  # Multiple interactive elements with shared state
  def handle_event("select_variant", %{"id" => id}, socket) do
    # Component manages its own selection state
  end
end
```

**Rule: Function components for markup, LiveComponents for encapsulated application concerns (not just DOM).**

### Critical Gotchas (Learn These First)

**1. Always check `connected?(socket)` before expensive work:**
```elixir
def mount(_params, _session, socket) do
  if connected?(socket) do
    Phoenix.PubSub.subscribe(MyApp.PubSub, "topic")
  end

  {:ok, assign(socket, items: [])}
end
```

**2. Never pass socket to context functions:**
```elixir
# ❌ Wrong - tight coupling, breaks separation of concerns
Blog.create_post(socket, params)

# ✅ Correct - pass only needed data
Blog.create_post(params, actor: socket.assigns.current_user)
```

**3. Use streams for large lists (>100 items):**
```elixir
# ❌ Wrong - stores entire list in memory per user
assign(socket, items: list_of_1000_items)

# ✅ Correct - memory efficient, surgical updates
stream(socket, :items, list_of_1000_items)
```

**4. Pattern match only control flow values in function heads:**
```elixir
# ❌ Wrong - unreadable, obscures intent
def handle_event("save", %{"name" => name, "email" => email, "age" => age}, %{assigns: %{user: user, org: org}} = socket)

# ✅ Correct - extract in function body
def handle_event("save", params, socket) do
  %{"name" => name, "email" => email} = params
  %{user: user} = socket.assigns
end
```

**5. Use `assign_async/3` for slow mount operations:**
```elixir
def mount(_params, _session, socket) do
  {:ok,
    assign(socket, loading: true)
    |> assign_async(:data, fn ->
      {:ok, %{data: expensive_query()}}
    end)}
end
```

### Memory & Performance Rules

**Keep assigns minimal - everything is stored in memory per user:**
```elixir
# ❌ Wrong - stores large dataset per connection
assign(socket, all_products: Products.list_all())

# ✅ Correct - query on demand, use streams
stream(socket, :products, Products.list_paginated(page: 1))
```

**Use temporary assigns for append-only data:**
```elixir
# In mount
socket = assign(socket, messages: [])
{:ok, socket, temporary_assigns: [messages: []]}

# New messages don't accumulate in memory
socket = assign(socket, messages: new_messages)
```

### Form Patterns

```elixir
# Handle validation
def handle_event("validate", %{"user" => params}, socket) do
  changeset = Accounts.change_user(%User{}, params)
  {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
end

# Handle submission
def handle_event("save", %{"user" => params}, socket) do
  case Accounts.create_user(params, actor: socket.assigns.current_user) do
    {:ok, user} ->
      {:noreply, push_navigate(socket, to: ~p"/users/#{user}")}

    {:error, changeset} ->
      {:noreply, assign(socket, form: to_form(changeset, action: :insert))}
  end
end
```

### PubSub Pattern

```elixir
# In mount (only when connected)
if connected?(socket) do
  Phoenix.PubSub.subscribe(MyApp.PubSub, "room:#{room_id}")
end

# In context (broadcast from business logic, not LiveView)
def create_message(attrs) do
  # ... create message
  Phoenix.PubSub.broadcast(MyApp.PubSub, "room:#{message.room_id}",
    {:new_message, message})
end

# Handle in LiveView
def handle_info({:new_message, message}, socket) do
  {:noreply, stream_insert(socket, :messages, message)}
end
```

### What NOT to Do

- **Never mutate socket** - Use `assign/2`, never `socket.assigns.foo = bar`
- **Never query in templates** - Load data in callbacks only
- **Never skip `connected?` check** - Causes duplicate subscriptions/work
- **Never use LiveComponent for simple UI** - Function components are faster/simpler
- **Never bypass contexts** - LiveViews call contexts, not Ecto/Repo directly
- **Never store everything in assigns** - Only store what's needed for current render

### Navigation

```elixir
# Same LiveView, update URL params
push_patch(socket, to: ~p"/posts?#{[filter: "new"]}")

# Different LiveView
push_navigate(socket, to: ~p"/settings")

# After mutations (causes full reload)
redirect(socket, to: ~p"/posts/#{post}")
```

### JS Interop (Use Sparingly)

```elixir
# ✅ Prefer Phoenix.LiveView.JS
<button phx-click={JS.toggle(to: "#dropdown")}>Toggle</button>

# ⚠️ Only use hooks when JS commands insufficient
<div id="chart" phx-hook="Chart" phx-update="ignore"></div>
```
