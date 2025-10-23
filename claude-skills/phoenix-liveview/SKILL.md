---
name: phoenix-liveview-ash
description: Real-time user interfaces and interactive web pages. Use for ANY LiveView development, real-time features, interactive forms, live navigation, dynamic UIs, websocket connections, and server-rendered interactivity.
---

# Phoenix LiveView + Ash Framework Skill

Comprehensive guidance for building production-ready, real-time user interfaces with Phoenix LiveView 1.1+ and Ash Framework integration. Includes strong opinions on file organization, component architecture, optimistic UI patterns, and testing strategies.

## 🎯 THE GOLDEN RULES

### ALWAYS Use These Patterns

**CRITICAL:** When building LiveView interfaces with Ash Framework:

1. **File Organization is MANDATORY** - Follow CRUD naming convention: `live/post_live/index.ex`, `live/post_live/show.ex`
2. **Custom actions allowed** - Non-CRUD actions like `live/post_live/import.ex` are perfectly fine
3. **Single form component** - Always `post_live/form.ex` with `:edit` or `:new` action, NEVER duplicate forms
4. **Avoid LiveComponents** - Use function components instead (Phoenix.Component)
5. **Ash domain methods ONLY** - Never access Ash resources directly, never use `Ash.Query` directly in LiveViews
6. **AshPhoenix for forms** - Always use `AshPhoenix.Form` and `<.inputs_for>`, never manual form handling
7. **handle_params over mount** - Load URL-dependent data in `handle_params/3`, not `mount/3`
8. **Streams for collections** - Always use `stream/3` for lists, never assign entire collections
9. **Optimistic updates everywhere** - Use `phx-click-loading` classes on all interactive elements
10. **Dual layouts required** - Always have `auth` layout and `marketing` layout

### Priority Hierarchy

**1. Ash Domain Methods (FIRST PRIORITY)**
```elixir
# ✅ CORRECT - Use domain methods
Posts.list_posts(actor: current_user)
Posts.get_post!(id, actor: current_user)
Posts.create_post(attrs, actor: current_user)

# ❌ WRONG - Never access resources directly
Post |> Ash.Query.filter(published: true) |> Ash.read!()
Ash.get!(Post, id)
```

**2. Function Components (ALWAYS)**
```elixir
# ✅ CORRECT - Function components
defmodule MyAppWeb.PostLive.Components do
  use Phoenix.Component

  def post_card(assigns) do
    ~H"""
    <div class="post-card">
      <%= @post.title %>
    </div>
    """
  end
end

# ❌ WRONG - LiveComponents (only for stateful needs)
defmodule MyAppWeb.PostLive.PostCard do
  use Phoenix.LiveComponent
  # Avoid unless you need handle_event
end
```

**3. Optimistic Updates (MANDATORY)**
```elixir
# ✅ CORRECT - Immediate visual feedback
~H"""
<button
  phx-click="delete"
  phx-value-id={@post.id}
  class="phx-click-loading:opacity-50 phx-click-loading:animate-pulse"
>
  Delete
</button>
"""

# ❌ WRONG - No visual feedback
~H"""
<button phx-click="delete" phx-value-id={@post.id}>
  Delete
</button>
"""
```

## When to Use This Skill

Trigger this skill when you encounter any of these specific scenarios:

### Building LiveView Interfaces

**File Organization & Structure:**
- Setting up new LiveView CRUD interfaces
- Creating LiveView directory structures (`live/resource_live/`)
- Organizing forms, components, and LiveView modules
- Implementing custom actions beyond CRUD

**Data Loading & State:**
- Loading data in `mount/3` or `handle_params/3`
- Working with socket assigns
- Using streams for large collections
- Implementing async operations with `AsyncResult`

**Real-time Interactions:**
- Building interactive dashboards
- Implementing live search
- Creating real-time forms with validation
- Handling user events (clicks, form changes, keyboard)

### Forms & User Input

- Using `AshPhoenix.Form` for Ash resources
- Implementing form validation
- Handling form submissions
- Working with nested forms using `<.inputs_for>`
- File uploads with progress tracking

### Testing LiveViews

- Setting up LiveView tests with Ash Authentication
- Testing authenticated LiveViews
- Testing form submissions and validations
- Testing interactive behaviors (clicks, changes)
- Using `Phoenix.LiveViewTest`

### Navigation & Routing

- Implementing `<.link patch={...}>` for same LiveView navigation
- Using `<.link navigate={...}>` for cross-LiveView navigation
- Working with `handle_params/3` for URL changes
- Implementing breadcrumbs or multi-step workflows

### Optimizing UX

- Adding loading states with `phx-click-loading`
- Implementing optimistic UI updates
- Using debounce/throttle for performance
- Adding transitions and animations with `Phoenix.LiveView.JS`

### JavaScript Interop

- Using `Phoenix.LiveView.JS` commands
- Implementing client hooks with `phx-hook`
- Using colocated hooks for component-specific JS
- Dispatching custom JavaScript events

## Key Concepts

### LiveView Lifecycle

A LiveView has two phases:

1. **Static/Disconnected Mount** - Initial HTTP request renders HTML
2. **Connected Mount** - WebSocket connection establishes stateful process

```elixir
def mount(params, session, socket) do
  # Runs TWICE - once for HTTP, once for WebSocket
  # Only do initial setup here
  {:ok, socket}
end

def handle_params(params, _uri, socket) do
  # Runs AFTER mount, and on every patch/navigation
  # Load data that depends on URL params here
  {:noreply, socket}
end
```

### Streams vs. Assigns

**Use Streams for Collections:**
```elixir
# ✅ CORRECT - Stream large lists
def mount(_params, _session, socket) do
  {:ok, stream(socket, :posts, Posts.list_posts())}
end

# In template
~H"""
<div id="posts" phx-update="stream">
  <div :for={{id, post} <- @streams.posts} id={id}>
    <%= post.title %>
  </div>
</div>
"""

# ❌ WRONG - Assign entire collection
def mount(_params, _session, socket) do
  {:ok, assign(socket, :posts, Posts.list_posts())}
end
```

### Function Components vs. LiveComponents

**Use Function Components (default):**
- Stateless UI rendering
- No event handling needed
- Reusable UI elements

**Use LiveComponents (rare):**
- Need internal state
- Need to handle events
- Complex stateful widgets

### Event Bindings

Common `phx-*` bindings:
- `phx-click` - Handle clicks
- `phx-change` - Form field changes
- `phx-submit` - Form submissions
- `phx-blur` / `phx-focus` - Focus events
- `phx-keydown` / `phx-keyup` - Keyboard events
- `phx-window-*` - Window-level events
- `phx-mounted` - Element mounted to DOM
- `phx-viewport-top` / `phx-viewport-bottom` - Infinite scroll

## Quick Reference

### 1. Basic LiveView Setup

```elixir
defmodule MyAppWeb.ThermostatLive do
  use MyAppWeb, :live_view

  def render(assigns) do
    ~H"""
    Current temperature: {@temperature}°F
    <button phx-click="inc_temperature">+</button>
    """
  end

  def mount(_params, _session, socket) do
    temperature = 70 # Let's assume a fixed temperature for now
    {:ok, assign(socket, :temperature, temperature)}
  end

  def handle_event("inc_temperature", _params, socket) do
    {:noreply, update(socket, :temperature, &(&1 + 1))}
  end
end
```

**Key Points:**
- Use `render/1` with `~H` sigil for templates
- `mount/3` initializes state (runs twice: HTTP + WebSocket)
- `handle_event/3` responds to user interactions
- Return `{:noreply, socket}` after state updates

### 2. Function Components

```elixir
defmodule MyComponent do
  use Phoenix.Component

  def greet(assigns) do
    ~H"""
    <p>Hello, {@name}!</p>
    """
  end
end

# Usage in template
~H"""
<MyComponent.greet name="Jane" />
"""
```

**Key Points:**
- Function components receive `assigns` map
- Access assigns with `@name` syntax
- Import with `use Phoenix.Component`

### 3. Handling Events with Values

```elixir
# Template
~H"""
<button phx-click="delete" phx-value-id={@post.id}>
  Delete
</button>
"""

# LiveView
def handle_event("delete", %{"id" => id}, socket) do
  # id is automatically extracted from phx-value-id
  Posts.delete_post(id)
  {:noreply, socket}
end
```

**Key Points:**
- Use `phx-value-*` to pass data with events
- Values automatically added to params map
- Multiple values supported: `phx-value-id`, `phx-value-name`, etc.

### 4. Form Handling with Validation

```elixir
def mount(_params, _session, socket) do
  changeset = User.changeset(%User{}, %{})
  {:ok, assign(socket, :changeset, changeset)}
end

def handle_event("validate", %{"user" => params}, socket) do
  changeset =
    %User{}
    |> User.changeset(params)
    |> Map.put(:action, :validate)

  {:noreply, assign(socket, :changeset, changeset)}
end

def handle_event("save", %{"user" => params}, socket) do
  case Users.create_user(params) do
    {:ok, user} ->
      {:noreply,
       socket
       |> put_flash(:info, "User created!")
       |> push_navigate(to: ~p"/users/#{user.id}")}

    {:error, %Ecto.Changeset{} = changeset} ->
      {:noreply, assign(socket, :changeset, changeset)}
  end
end

# Template
~H"""
<.form for={@changeset} phx-change="validate" phx-submit="save">
  <.input field={@changeset[:email]} type="email" label="Email" />
  <.input field={@changeset[:password]} type="password" label="Password" />
  <button type="submit">Create Account</button>
</.form>
"""
```

**Key Points:**
- `phx-change="validate"` for live validation
- `phx-submit="save"` for form submission
- Set `action: :validate` to show errors
- Use `push_navigate/2` after successful save

### 5. File Uploads

```elixir
def mount(_params, _session, socket) do
  {:ok,
   socket
   |> assign(:uploaded_files, [])
   |> allow_upload(:avatar, accept: ~w(.jpg .jpeg), max_entries: 2)}
end

def handle_event("validate", _params, socket) do
  {:noreply, socket}
end

def handle_event("save", _params, socket) do
  uploaded_files =
    consume_uploaded_entries(socket, :avatar, fn %{path: path}, _entry ->
      dest = Path.join("priv/static/uploads", Path.basename(path))
      File.cp!(path, dest)
      {:ok, ~p"/uploads/#{Path.basename(dest)}"}
    end)

  {:noreply, update(socket, :uploaded_files, &(&1 ++ uploaded_files))}
end

# Template
~H"""
<form id="upload-form" phx-change="validate" phx-submit="save">
  <.live_file_input upload={@uploads.avatar} />
  <button type="submit">Upload</button>
</form>
"""
```

**Key Points:**
- Use `allow_upload/3` in mount
- Must bind `phx-change` and `phx-submit`
- Use `consume_uploaded_entries/3` to process files
- Use `<.live_file_input>` component

### 6. Live Navigation

```elixir
# Same LiveView navigation (no remount)
~H"""
<.link patch={~p"/users?sort=name"}>Sort by Name</.link>
"""

def handle_params(%{"sort" => sort}, _uri, socket) do
  {:noreply, assign(socket, :sort_by, sort)}
end

# Different LiveView navigation (remount)
~H"""
<.link navigate={~p"/posts"}>View Posts</.link>
"""

# Programmatic navigation
def handle_event("go_to_post", %{"id" => id}, socket) do
  {:noreply, push_navigate(socket, to: ~p"/posts/#{id}")}
end
```

**Key Points:**
- `patch={...}` - Same LiveView, minimal update
- `navigate={...}` - Different LiveView, full remount
- `handle_params/3` called on patch
- `push_patch/2` and `push_navigate/2` for programmatic navigation

### 7. Streams for Large Collections

```elixir
def mount(_params, _session, socket) do
  posts = Posts.list_posts()
  {:ok, stream(socket, :posts, posts)}
end

def handle_event("add_post", %{"title" => title}, socket) do
  {:ok, post} = Posts.create_post(%{title: title})
  {:noreply, stream_insert(socket, :posts, post, at: 0)}
end

def handle_event("delete_post", %{"id" => id}, socket) do
  post = Posts.get_post!(id)
  Posts.delete_post(post)
  {:noreply, stream_delete(socket, :posts, post)}
end

# Template
~H"""
<div id="posts" phx-update="stream">
  <div :for={{id, post} <- @streams.posts} id={id}>
    <h2><%= post.title %></h2>
    <button phx-click="delete_post" phx-value-id={post.id}>Delete</button>
  </div>
</div>
"""
```

**Key Points:**
- Use `stream/3` to initialize
- `stream_insert/4` to add items
- `stream_delete/3` to remove items
- Requires `phx-update="stream"` and unique `id` attributes
- Efficient for large lists (DOM updates only changed items)

### 8. JavaScript Commands (No Server Round-trip)

```elixir
alias Phoenix.LiveView.JS

# Simple show/hide
~H"""
<div id="modal" class="modal">My Modal</div>
<button phx-click={JS.show(to: "#modal", transition: "fade-in")}>
  Show Modal
</button>
<button phx-click={JS.hide(to: "#modal", transition: "fade-out")}>
  Hide Modal
</button>
"""

# Composing commands
def hide_modal(js \\ %JS{}) do
  js
  |> JS.hide(transition: "fade-out", to: "#modal")
  |> JS.push("modal-closed")
end

~H"""
<button phx-click={hide_modal()}>Hide Modal</button>
"""
```

**Key Points:**
- Use `Phoenix.LiveView.JS` for client-side-only operations
- No server round-trip needed
- Commands compose with `|>`
- Can combine with `JS.push/3` to also notify server

### 9. Client Hooks for Custom JavaScript

```elixir
# In LiveView template
~H"""
<div id="map" phx-hook="MapWidget" data-lat={@lat} data-lng={@lng}>
</div>
"""
```

```javascript
// In app.js
let Hooks = {}

Hooks.MapWidget = {
  mounted() {
    const lat = this.el.dataset.lat
    const lng = this.el.dataset.lng
    this.map = initMap(this.el, lat, lng)
  },

  updated() {
    const lat = this.el.dataset.lat
    const lng = this.el.dataset.lng
    this.map.setCenter(lat, lng)
  },

  destroyed() {
    this.map.destroy()
  }
}

let liveSocket = new LiveSocket("/live", Socket, {
  params: {_csrf_token: csrfToken},
  hooks: Hooks
})
```

**Key Points:**
- Use `phx-hook` attribute to attach hooks
- Hooks have lifecycle: `mounted`, `updated`, `destroyed`
- Pass data via `data-*` attributes
- Register hooks in LiveSocket constructor

### 10. Optimistic UI with Loading States

```elixir
~H"""
<button
  phx-click="save"
  class="phx-submit-loading:opacity-50 phx-click-loading:animate-pulse"
  disabled={@saving}
>
  <span class="phx-submit-loading:hidden">Save</span>
  <span class="hidden phx-submit-loading:block">Saving...</span>
</button>

<form phx-change="validate" phx-submit="save">
  <input
    type="text"
    name="title"
    class="phx-change-loading:bg-gray-100"
  />
  <button type="submit">Submit</button>
</form>
"""
```

**Key Points:**
- `phx-click-loading` class added during click event
- `phx-submit-loading` class added during form submission
- `phx-change-loading` class added during form change
- Use for visual feedback while waiting for server

## Reference Files

This skill includes comprehensive documentation in `references/`:

### Core Documentation

- **api.md** - Phoenix.LiveView API documentation
  - `AsyncResult` - Tracking async operation state
  - `Socket` - LiveView socket structure
  - `Comprehension` - For-comprehension structs
  - `Rendered` - Template rendering internals
  - `Engine` - Template engine details
  - `ColocatedHook` - Component-scoped JavaScript hooks
  - `HTMLEngine` - HEEx template engine

- **components.md** - Components and navigation
  - Live navigation with `patch` and `navigate`
  - `Phoenix.Component` - Function component system
  - Component attributes with `attr/3`
  - Global attributes
  - Slots and named slots
  - `Phoenix.LiveComponent` - Stateful components
  - `Phoenix.LiveView.TagEngine` - Tag engine behavior

- **getting_started.md** - Getting started guide
  - What is a LiveView?
  - Basic example walkthrough
  - Parameters and session
  - Bindings overview
  - Navigation patterns
  - Compartmentalizing with components

- **js_interop.md** - JavaScript interoperability
  - `Phoenix.LiveView.ColocatedJS` - Colocated JavaScript
  - JavaScript interoperability guide
  - Debugging client events
  - Simulating latency
  - Server-pushed events
  - Client hooks via `phx-hook`
  - `Phoenix.LiveView.JS` - JavaScript commands

### Testing & Tools

- **forms.md** - Forms and formatting
  - `Phoenix.LiveView.HTMLFormatter` - HEEx formatter
  - Setup and configuration
  - Formatting rules
  - Line length options

### Specialized Topics

- **uploads.md** - File uploads (if present)
  - File upload patterns
  - Progress tracking
  - Drag and drop

- **other.md** - Additional documentation
  - Advanced patterns
  - Edge cases
  - Migration guides

Use the Read tool to access specific reference files when detailed information is needed.

## Working with This Skill

### For Beginners

**Start here:**
1. Read `references/getting_started.md` for foundational concepts
2. Review the "Basic LiveView Setup" example in Quick Reference
3. Try the simple examples above (especially #1, #2, #3)
4. Focus on understanding the lifecycle: `mount/3` → `handle_params/3` → `render/1`

**Key concepts to master first:**
- Socket assigns and how to update them
- The `~H` sigil for templates
- Event handling with `phx-click`
- The difference between `assign/3` and `update/3`

### For Intermediate Users

**Building features:**
1. Use `references/components.md` for component patterns
2. Implement forms with validation (Quick Reference #4)
3. Add navigation with `patch` and `navigate` (Quick Reference #6)
4. Use streams for performance (Quick Reference #7)

**Best practices:**
- Always use optimistic UI (Quick Reference #10)
- Prefer function components over LiveComponents
- Use `handle_params/3` for URL-dependent data
- Use streams for any list with >50 items

### For Advanced Users

**Optimization & Polish:**
1. Study `references/js_interop.md` for JavaScript integration
2. Implement custom hooks (Quick Reference #9)
3. Use `Phoenix.LiveView.JS` commands for smooth UX (#8)
4. Add file uploads (Quick Reference #5)
5. Implement infinite scrolling with viewport events

**Performance tips:**
- Use `stream/3` for all collections
- Debounce search inputs with `phx-debounce`
- Use `JS` commands to avoid server round-trips
- Lazy load data in `handle_params/3` instead of `mount/3`

### Navigation Tips

**Find information by topic:**
- **Lifecycle callbacks** → `references/api.md` (Phoenix.LiveView)
- **Form handling** → Quick Reference #4, `references/forms.md`
- **Navigation** → Quick Reference #6, `references/components.md`
- **JavaScript** → Quick Reference #8, #9, `references/js_interop.md`
- **Testing** → `references/api.md` (Phoenix.LiveViewTest)
- **Components** → Quick Reference #2, `references/components.md`
- **Uploads** → Quick Reference #5, `references/uploads.md` (if present)

**Common questions:**
- "How do I validate forms?" → Quick Reference #4
- "How do I handle large lists?" → Quick Reference #7
- "How do I add custom JavaScript?" → Quick Reference #9
- "How do I navigate between pages?" → Quick Reference #6
- "How do I upload files?" → Quick Reference #5

## Notes

- This skill is built from official Phoenix LiveView 1.1.16 documentation
- Examples are production-tested patterns
- Prioritizes Ash Framework integration patterns
- Emphasizes performance and user experience
- All code examples use Elixir syntax

## Resources

### Official Documentation

- [Phoenix LiveView Hex Docs](https://hexdocs.pm/phoenix_live_view/)
- [Phoenix Framework](https://www.phoenixframework.org/)
- [Ash Framework](https://ash-hq.org/)

### Reference Files Structure

```
references/
├── index.md              # Overview and table of contents
├── api.md                # Core API documentation (9 pages)
├── components.md         # Components and navigation (7 pages)
├── getting_started.md    # Getting started guide (1 page)
├── js_interop.md         # JavaScript interoperability (3 pages)
├── forms.md              # Forms and formatting (1 page)
└── other.md              # Additional topics (if present)
```

Each reference file includes:
- Detailed explanations from official docs
- Complete code examples with syntax highlighting
- Links to original documentation
- Table of contents for quick navigation
