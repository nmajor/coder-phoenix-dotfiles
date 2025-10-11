## Frontend test writing standards

### Core Testing Philosophy

- **Write Minimal Tests During Development**: Do NOT write tests for every change or intermediate step - focus on completing feature implementation first
- **Test Only Core User Flows**: Write tests exclusively for critical paths and primary user workflows
- **Defer Edge Case Testing**: Do NOT test edge cases, error states, or validation logic unless business-critical
- **Test User Interactions**: Focus on testing how users interact with the UI, not implementation details
- **Clear Test Names**: Use descriptive names that explain user behavior being tested

### Phoenix LiveView Testing Philosophy

- **Test User Perspective**: Write tests from the user's point of view - what they see and how they interact
- **Test State Transitions**: Focus on how state changes in response to events, not just HTML output
- **Fast and Reliable**: LiveView tests run entirely in Elixir/ExUnit - no browser, no JavaScript dependencies
- **Integration Over Unit**: Prefer testing complete user flows over isolated function tests
- **No JavaScript Testing**: Trust the LiveView framework handles JS - test your logic, not the framework

### LiveView Test Structure (Phoenix.LiveViewTest)

- **Import LiveViewTest**: Add `import Phoenix.LiveViewTest` to test modules
- **Use ExUnit.Case**: Start with `use MyAppWeb.ConnCase, async: true` for concurrent tests
- **Set Up Connection**: Create authenticated conn in setup block if needed
- **Mount LiveView**: Use `live/2` to mount LiveView and establish connection
- **Simulate Interactions**: Use `render_*` functions to simulate user actions
- **Assert Results**: Verify HTML output, assigns, redirects, and side effects

### Testing LiveView Mounting

- **Test Disconnected Mount**: Use `get(conn, "/path")` to test initial HTTP render without WebSocket
- **Test Connected Mount**: Use `{:ok, view, html} = live(conn, "/path")` to test full LiveView lifecycle
- **Combined Mount**: Use `live/2` directly when you don't need separate disconnected render
- **Verify Initial State**: Assert on initial HTML and socket assigns after mount
- **Test Loading States**: Verify loading placeholders render before async data loads

### Testing Connected vs Disconnected States

- **Separate When Needed**: Test disconnected mount separately if mount logic differs based on `connected?/1`
- **Combined for Simplicity**: Use single `live/2` call when mount behavior is same for both states
- **Check Subscriptions**: Verify PubSub subscriptions only happen in connected state
- **Verify Assigns**: Disconnected mount should set minimal assigns, connected should load full data

### Simulating User Events

- **render_click/2**: Simulate button clicks - `view |> element("#button-id") |> render_click()`
- **render_submit/2**: Simulate form submission - `view |> form("#form-id", user: params) |> render_submit()`
- **render_change/2**: Simulate input changes - `view |> form("#form-id") |> render_change(user: %{email: "test"})`
- **render_blur/2**: Simulate blur events - `view |> element("#input-id") |> render_blur()`
- **render_keydown/2**: Simulate keyboard events - `view |> element("#input-id") |> render_keydown(%{key: "Enter"})`
- **render_hook/3**: Trigger client hook events - `render_hook(view, "event-name", %{data: "value"})`

### Selecting Elements

- **element/2**: Select element by CSS selector - `element(view, "#user-#{user.id}")`
- **element/3**: Select with text filter - `element(view, "button", "Save")`
- **Form Helper**: Use `form/2` for form elements - `form(view, "#user-form")`
- **Specific Selectors**: Prefer IDs over classes for test stability
- **data-test Attributes**: Add `data-test` attributes to elements for reliable selection

### Testing Forms

- **Validate on Change**: Test phx-change validation - `render_change(form, user: %{email: "invalid"})`
- **Assert Validation Errors**: Check error messages appear - `assert html =~ "must include @"`
- **Submit Form**: Use `render_submit/2` to test submission
- **Handle Success**: Verify redirect or success message after valid submission
- **Handle Failure**: Assert error changeset assigns and error display on invalid submission
- **Test Disabled State**: Verify phx-disable-with shows loading state during submission

### Testing Async Assigns

- **Use render_async/1**: Wait for async operations - `html = render_async(view)` after mounting
- **Required for Async**: ALWAYS call `render_async/1` when testing `assign_async/3` or LiveViews load async data
- **Assert After Completion**: Only assert on async-loaded data AFTER calling `render_async/1`
- **Test Loading State**: Assert loading placeholder before calling `render_async/1`
- **Test Error State**: Trigger async errors and verify error display after `render_async/1`

### Testing Navigation

- **Test push_patch**: Verify URL updates - assert `view |> render()` updates without remount
- **Test push_navigate**: Verify navigation to different LiveView - use `follow_redirect/2`
- **Test redirect**: Follow redirects - `{:ok, view, html} = view |> follow_redirect(conn)`
- **Assert URL Changes**: Check `assert_patched/2` or `assert_redirected/2` for navigation
- **Verify handle_params**: Assert data loads correctly based on URL params after navigation

### Testing Real-Time Features (PubSub)

- **Mount LiveView**: Start LiveView in connected state to establish subscriptions
- **Broadcast Message**: Use `Phoenix.PubSub.broadcast/3` to send message to topic
- **Assert Update**: Verify rendered HTML updates in response to broadcast
- **Multiple Subscribers**: Mount multiple views and verify all receive updates
- **Test Exclusions**: Verify `broadcast_from/4` excludes sender from receiving message

### Testing LiveComponents

- **Test via Parent LiveView**: Mount parent LiveView and interact with component through it
- **Scope Events**: Use `element(view, "#component-id button")` to target component elements
- **Test send_update**: Call `send_update(Component, id: "foo", field: value)` and assert render
- **Test Isolation**: Verify component state doesn't affect parent or sibling components
- **render_component/3**: Test component in isolation - `html = render_component(Component, %{assigns})`

### Testing Function Components

- **render_component/3**: Test simple components - `html = render_component(&CoreComponents.button/1, %{label: "Click"})`
- **rendered_to_string/1**: Test with HEEx - `html = rendered_to_string(~H"<.button label='Click' />")`
- **Test Slots**: Verify slot rendering - pass `inner_block: "Content"` to assigns
- **Test Attributes**: Verify attrs render correctly in HTML output
- **Keep Tests Simple**: Function components are pure - simple input/output tests sufficient

### Testing JavaScript Hooks

- **No JavaScript Testing**: Phoenix.LiveViewTest does NOT execute JavaScript hooks
- **Test Server Side**: Test server-side event handlers that hooks communicate with
- **Test pushEvent**: Verify `handle_event/3` callbacks that hooks call
- **Test handleEvent**: Manually trigger events hooks would send from client
- **Integration Testing**: Use Wallaby or Cypress for full hook behavior testing if critical

### Assertions and Verification

- **Assert HTML Content**: Use `assert html =~ "expected text"` to verify rendered output
- **Assert Assigns**: Use `assert view.assigns.field == value` to check socket state
- **Assert Element Presence**: Use `has_element?(view, "#id")` to verify elements exist
- **Assert Element Absence**: Use `refute has_element?(view, "#id")` to verify elements removed
- **Assert Flash Messages**: Use `assert_flash(view, :info, "Success message")`
- **Assert Redirects**: Use `assert_redirect/2` or `assert_redirected/2` for navigation

### Test Organization Patterns

- **Describe Blocks**: Group related tests - `describe "create user" do ... end`
- **Setup Helpers**: Extract common setup to setup blocks or helper functions
- **Test Helpers Module**: Create `test/support/live_view_helpers.ex` for reusable interactions
- **One Flow Per Test**: Each test should verify one user interaction flow
- **Descriptive Names**: Test names should read like user stories - "user can create post"

### Testing Best Practices

- **Test User Flows Not Implementation**: Focus on what users see and do, not internal functions
- **Keep Tests Readable**: Tests document how features work - make them clear
- **Avoid Brittle Selectors**: Don't rely on styling classes - use IDs or data-test attributes
- **Test Error Paths**: Verify error handling, validation failures, and edge cases
- **Fast Tests**: LiveView tests should run in milliseconds - no network or external dependencies
- **Concurrent Safe**: Use `async: true` - LiveView tests are process-isolated

### Common Testing Patterns

**Testing CRUD Operations:**
```elixir
test "user can create post", %{conn: conn} do
  {:ok, view, _html} = live(conn, "/posts/new")

  html = view
    |> form("#post-form", post: %{title: "Test", body: "Content"})
    |> render_submit()

  assert html =~ "Post created successfully"
  assert_redirect(view, ~p"/posts/#{post}")
end
```

**Testing Real-Time Updates:**
```elixir
test "user sees new message broadcast", %{conn: conn} do
  {:ok, view, _html} = live(conn, "/chat")

  Phoenix.PubSub.broadcast(MyApp.PubSub, "room:1", {:new_message, "Hello"})

  html = render(view)
  assert html =~ "Hello"
end
```

**Testing Async Data Loading:**
```elixir
test "user sees loaded data", %{conn: conn} do
  {:ok, view, html} = live(conn, "/dashboard")
  assert html =~ "Loading..."

  html = render_async(view)
  assert html =~ "Dashboard Data"
end
```

### What NOT to Test

- **Framework Behavior**: Don't test that LiveView framework works - trust it does
- **CSS/Styling**: Don't test visual appearance - only functional behavior
- **JavaScript Execution**: LiveViewTest doesn't run JS - test server-side effects only
- **Every Template Change**: Don't test every UI tweak - focus on user-facing behavior
- **Third-Party Libraries**: Don't test that external libraries work correctly

### Anti-Patterns to Avoid

- **Testing Without render_async**: Forgetting `render_async/1` when testing async assigns causes flaky tests
- **Testing Only Disconnected**: Only testing disconnected mount misses WebSocket behavior
- **Asserting on Implementation**: Testing socket.assigns internals instead of rendered HTML
- **Overly Specific Selectors**: Using fragile CSS selectors that break on markup changes
- **Testing Too Much Per Test**: Each test should verify one user interaction, not entire flows
- **Not Following Redirects**: Forgetting `follow_redirect/2` after navigation actions
- **Ignoring Test Errors**: Tests that seem to pass but don't actually exercise LiveView code

### Testing vs End-to-End Testing

- **LiveView Tests**: Test server-side rendering, state management, event handling (fast, no browser)
- **E2E Tests (Wallaby/Cypress)**: Test JavaScript behavior, complex interactions, visual regression (slow, browser required)
- **Use LiveView Tests for 95%**: Most testing should be LiveViewTest - fast and reliable
- **Use E2E Tests Sparingly**: Only for critical JavaScript hooks, complex UI interactions, or visual verification
- **No Overlap**: Don't duplicate LiveView tests in E2E - test different concerns
