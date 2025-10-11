## Phoenix LiveView standards

**CRITICAL REQUIREMENT**: This application MUST follow Phoenix LiveView declarative patterns and best practices. Imperative DOM manipulation is forbidden except through sanctioned escape hatches (hooks, Phoenix.LiveView.JS commands).

### Core Philosophy

- **Server-Rendered**: LiveView renders HTML on the server and sends minimal diffs over WebSocket - embrace this paradigm
- **Declarative Updates**: Describe state changes through assigns - LiveView handles DOM updates automatically
- **Real-Time by Default**: WebSocket connection enables push-based updates without polling or complex client-side state
- **Progressive Enhancement**: Initial render is standard HTTP request - JavaScript enhances with live updates
- **Elixir Everywhere**: Write interactive UIs in pure Elixir - JavaScript only for client-specific concerns

### LiveView vs LiveComponent vs Function Component

- **LiveView**: Full page component with own route, WebSocket process, and lifecycle - use for pages/routes
- **LiveComponent**: Stateful component with own lifecycle inside parent LiveView - use for complex, reusable widgets with internal state
- **Function Component**: Stateless template function that returns HEEx - use for simple, reusable UI elements (buttons, inputs, cards)

### When to Use Each Component Type

- **Use LiveView**: When you need a routable page, handle real-time events, manage page-level state
- **Use LiveComponent**: When you need encapsulated state separate from parent, complex interaction logic, or send_update from external processes
- **Use Function Component**: For presentational markup, simple reusable elements, layout components, form fields

### Function Component Best Practices

- **Pure Functions**: Accept assigns, return HEEx template - no side effects or external dependencies
- **Define in MyAppWeb.CoreComponents**: Central location for shared components following Phoenix 1.7+ conventions
- **Use attr and slot**: Document component interface with `attr :name, :type, required: true` and `slot :inner_block`
- **Prefix Custom Attributes**: Use data- prefix for custom HTML attributes to avoid conflicts
- **No Business Logic**: Keep components focused on presentation - business logic belongs in contexts
- **Compose Small Components**: Build complex UIs from simple, focused components

### LiveComponent Patterns

- **Assign Unique :id**: ALWAYS set unique `:id` attribute - required for stateful components
- **Implement @behaviour**: Add `use Phoenix.LiveComponent` directive
- **Define update/2**: Implement `update(assigns, socket)` for initialization and assign updates
- **Use send_update**: Update component from parent or external process with `send_update(Component, id: "foo", ...)`
- **Handle Events Locally**: Use `handle_event/3` in component for component-specific interactions
- **Avoid State Duplication**: Parent OR component should own state, never both - decide single source of truth
- **Application Concerns Not DOM**: LiveComponents encapsulate business logic/workflows, not just DOM presentation

### State Management (Socket Assigns)

- **Single Source of Truth**: Each piece of state should have exactly one owner - parent LiveView OR child component
- **Immutable Updates**: Use `assign/2` and `assign/3` to create new socket - never mutate socket directly
- **Minimize Assigns**: Only store data needed for rendering - everything in assigns is kept in memory per client
- **Query on Demand**: Load data when needed instead of storing it in assigns
- **Temporary Assigns**: Use `assign/3` with `temporary: true` for data that resets after render (chat messages, feeds)
- **Struct Access Only**: Use `socket.assigns.field` not `socket.assigns[:field]` for compile-time guarantees

### Lifecycle Callbacks

- **mount/3**: Initialize socket, subscribe to PubSub, set defaults - called once per connection
- **handle_params/3**: React to URL changes, load data based on params - called after mount and on navigation
- **handle_event/3**: Respond to client events (clicks, form changes) - return `{:noreply, socket}`
- **handle_info/2**: Receive messages from PubSub, async tasks, timers - return `{:noreply, socket}`
- **render/1**: Return HEEx template - called automatically after assign changes

### Mount Patterns

- **Check connected?/1**: Use `if connected?(socket)` to skip expensive work during initial static render
- **Subscribe in connected**: Only subscribe to PubSub topics when `connected?(socket)` returns true
- **Set Loading States**: Assign loading placeholders during mount, update asynchronously
- **Validate Params**: Validate route params in mount, redirect if invalid
- **Return Tuple**: Always return `{:ok, socket}` or `{:ok, socket, temporary_assigns: [...]}`

### Performance Optimization

- **Use Streams for Lists**: For lists > 100 items, use `stream/3` instead of storing list in assigns
- **Static vs Dynamic Separation**: LiveView auto-splits static/dynamic content - only dynamics sent on updates
- **Temporary Assigns**: Mark frequently-changing large data as temporary to prevent memory buildup
- **Lazy Load Components**: Don't render modals/overlays until needed - conditionally render based on state
- **Throttle Updates**: Use `phx-throttle` attribute to limit event frequency (input validation, scrolling)
- **Async Operations**: Use `assign_async/3` for expensive operations to avoid blocking render
- **Minimize Payload**: Keep assigns lean - large nested structures slow down diffs
- **Debounce Form Validation**: Use `phx-debounce` on inputs to reduce validation event frequency

### Real-Time Features (PubSub)

- **Subscribe in mount**: Use `Phoenix.PubSub.subscribe(MyApp.PubSub, "topic")` when connected
- **Broadcast from Context**: Context modules should broadcast domain events, not LiveViews
- **Handle with handle_info**: Pattern match broadcast messages in `handle_info/2` and update assigns
- **Topic Naming**: Use clear hierarchical topics like `"users:#{user_id}"` or `"rooms:#{room_id}"`
- **Broadcast Helpers**: Define `subscribe/1` and `broadcast/2` helpers in context modules
- **Exclude Self**: Use `broadcast_from/4` when sender shouldn't receive its own message

### Form Handling

- **Use Phoenix.Component.to_form/1**: Convert changesets to form assigns with `to_form(changeset)`
- **Validate on Change**: Handle "validate" event with `phx-change` for real-time validation feedback
- **Submit with phx-submit**: Use `phx-submit` attribute on form to handle submission
- **Show Errors**: Display changeset errors with `Phoenix.HTML.FormHelpers` or custom error components
- **Disable During Submit**: Add `phx-disable-with` to show loading state during submission
- **Handle Success**: After successful save, redirect or update assigns with success message
- **Handle Failure**: On error, assign error changeset to show validation messages

### Event Handling

- **phx-click**: Handle button clicks and element interactions
- **phx-change**: Validate forms on input change
- **phx-submit**: Handle form submission
- **phx-blur/phx-focus**: Respond to focus events
- **phx-window-keydown**: Handle keyboard shortcuts
- **phx-value-***: Send custom values with events (`phx-value-id={@user.id}`)
- **Return {:noreply, socket}**: All event handlers must return socket tuple

### JavaScript Interop

- **Prefer Phoenix.LiveView.JS**: Use JS commands (`JS.show`, `JS.hide`, `JS.toggle`) over custom JavaScript
- **Hooks as Escape Hatch**: Only use hooks when Phoenix.LiveView.JS insufficient (third-party libraries, complex DOM)
- **Set Unique ID**: Always set unique DOM ID when using `phx-hook` attribute
- **Lifecycle Callbacks**: Use `mounted`, `updated`, `destroyed` callbacks in hook object
- **pushEvent for Communication**: Send messages to server with `this.pushEvent("event", payload)`
- **handleEvent for Responses**: Receive server messages with `this.handleEvent("event", callback)`
- **Minimize Hook Logic**: Keep hooks focused and small - complex logic belongs on server
- **phx-update="ignore"**: Prevent LiveView from updating hook-managed DOM elements

### Navigation and URLs

- **Use patch for Same LiveView**: Use `push_patch/2` for navigation within same LiveView (updates URL, calls handle_params)
- **Use navigate for Different LiveView**: Use `push_navigate/2` for navigation to different LiveView (full remount)
- **Use redirect for External**: Use `redirect/2` for external URLs or after mutations
- **Handle Params in handle_params/3**: React to URL changes, load filtered data based on query params
- **Update URL State**: Reflect UI state in URL with push_patch for bookmarkable/shareable state

### Error Handling

- **Handle Errors in Callbacks**: Wrap risky operations in try/rescue or use case statements
- **Show User-Friendly Messages**: Use `put_flash/3` to show error messages to users
- **Log Unexpected Errors**: Use Logger to record unexpected errors for debugging
- **Validate Input**: Always validate user input in event handlers before processing
- **Handle Async Failures**: Handle {:exit, reason} in handle_info for async task failures

### Testing LiveView

- **Use Phoenix.LiveViewTest**: Import helpers like `live/2`, `render/1`, `render_click/2`
- **Test Disconnected and Connected**: Test both initial HTTP render and connected live mount
- **Assert HTML Content**: Use `assert html =~ "expected text"` to verify rendered output
- **Simulate Events**: Use `render_click`, `render_submit`, `render_change` to trigger events
- **Test Async Assigns**: Use `render_async/2` to wait for async operations before assertions
- **Test PubSub**: Broadcast messages in tests and assert socket assigns update correctly
- **Test Navigation**: Use `follow_redirect/2` after push_patch/push_navigate
- **Keep Tests Readable**: LiveView tests should describe user interaction flow clearly

### Security Considerations

- **Validate All Inputs**: Never trust client data - validate in event handlers
- **Authorize Actions**: Check permissions before processing events or loading data
- **CSRF Protection**: LiveView provides automatic CSRF protection - don't disable
- **Sanitize Output**: Phoenix escapes by default - only use `raw/1` for trusted content
- **Rate Limiting**: Implement rate limiting for expensive operations
- **Sensitive Data**: Don't store secrets or sensitive data in assigns (visible in DOM)

### Code Organization

- **Keep LiveViews Thin**: LiveViews are controllers - delegate to contexts for business logic
- **Context Functions**: All database queries and business logic in context modules
- **Component Modules**: Extract reusable components to dedicated modules
- **Separate Concerns**: LiveView handles socket/events, contexts handle domain logic
- **Consistent Naming**: Use clear, action-oriented names for events ("save_item", "delete_user")

### Anti-Patterns to Avoid

- **Never Mutate Socket**: Don't modify socket.assigns directly - use assign/2
- **Never Query in Templates**: All data loading happens in callbacks, not HEEx templates
- **Never Skip connected?**: Always check connected? before subscribing or expensive work
- **Never Store Everything**: Only store rendering-required data in assigns
- **Never Use LiveComponent for Simple UI**: Function components are simpler for stateless presentation
- **Never Return Wrong Tuple**: Event handlers MUST return `{:noreply, socket}` or `{:reply, map, socket}`
- **Never Bypass Contexts**: LiveViews call contexts, never touch Ecto/Repo directly

### Common Patterns

**Loading State:**
```elixir
def mount(_params, _session, socket) do
  {:ok, assign(socket, loading: true, data: [])
   |> assign_async(:data, fn -> {:ok, %{data: load_data()}} end)}
end
```

**Pagination with Streams:**
```elixir
def mount(_params, _session, socket) do
  {:ok, stream(socket, :items, load_items())}
end

def handle_event("load_more", _, socket) do
  {:noreply, stream(socket, :items, load_more_items(), at: -1)}
end
```

**Modal Pattern:**
```elixir
<.modal :if={@show_modal} id="user-modal">
  <.live_component module={UserFormComponent} id={@user.id} />
</.modal>
```

### Accessibility

- **Semantic HTML**: Use appropriate HTML elements (button, nav, main, article)
- **ARIA Attributes**: Add aria-label, aria-describedby for screen readers
- **Keyboard Navigation**: Ensure all interactions work with keyboard
- **Focus Management**: Use `JS.focus()` to manage focus after dynamic updates
- **Live Regions**: Use aria-live for dynamic content announcements
- **Form Labels**: Always associate labels with inputs for screen readers
