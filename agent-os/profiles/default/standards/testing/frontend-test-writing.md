## Frontend LiveView Test Standards

### Core Principles

**Test from user perspective, not implementation.** LiveView tests run server-side in ExUnit - no browser, no JS.

- Test only core user flows (critical paths)
- Skip edge cases unless business-critical
- Focus on what users see and do, not internal assigns
- Use `async: true` - tests are process-isolated

### Essential Patterns

**CRUD Operations:**
```elixir
test "user can create post", %{conn: conn} do
  {:ok, view, _html} = live(conn, "/posts/new")

  html = view
    |> form("#post-form", post: %{title: "Test", body: "Content"})
    |> render_submit()

  assert html =~ "Post created"
  assert_redirect(view, ~p"/posts/#{post}")
end
```

**Async Data (CRITICAL - Always use render_async):**
```elixir
test "user sees loaded data", %{conn: conn} do
  {:ok, view, html} = live(conn, "/dashboard")
  assert html =~ "Loading..."

  html = render_async(view)  # Required for assign_async!
  assert html =~ "Dashboard Data"
end
```

**Real-Time Updates:**
```elixir
test "user sees broadcast", %{conn: conn} do
  {:ok, view, _html} = live(conn, "/chat")

  Phoenix.PubSub.broadcast(MyApp.PubSub, "room:1", {:new_message, "Hello"})

  html = render(view)
  assert html =~ "Hello"
end
```

**Form Validation:**
```elixir
test "shows validation errors", %{conn: conn} do
  {:ok, view, _html} = live(conn, "/users/new")

  html = view
    |> form("#user-form", user: %{email: "invalid"})
    |> render_change()

  assert html =~ "must include @"
end
```

### Element Selection

**Always use `data-test` attributes for stability.** Never rely on CSS classes.

```elixir
# Template
<button data-test="save-button">Save</button>

# Test
view |> element("[data-test='save-button']") |> render_click()

# Or with IDs (acceptable)
view |> element("#save-button") |> render_click()
```

### Key Functions

- **`live(conn, path)`** - Mount LiveView in connected state
- **`element(view, selector)`** - Select element
- **`form(view, selector)`** - Select form
- **`render_click(element)`** - Click button/link
- **`render_submit(form)`** - Submit form
- **`render_change(form, params)`** - Trigger phx-change
- **`render_async(view)`** - Wait for async operations (REQUIRED for assign_async)
- **`follow_redirect(view, conn)`** - Follow navigation
- **`has_element?(view, selector)`** - Check element exists

### Critical Gotchas

**1. Forgetting `render_async` breaks async tests:**
```elixir
# ❌ Wrong - flaky/broken
{:ok, view, _html} = live(conn, "/page")
assert view.assigns.data  # May not be loaded yet!

# ✅ Correct
{:ok, view, _html} = live(conn, "/page")
render_async(view)  # Wait for assign_async to complete
assert view.assigns.data
```

**2. Not following redirects:**
```elixir
# ❌ Wrong
render_submit(form)  # Redirects but test doesn't follow

# ✅ Correct
render_submit(form)
{:ok, view, html} = follow_redirect(view, conn)
assert html =~ "Success"
```

**3. Testing assigns instead of rendered HTML:**
```elixir
# ❌ Wrong - testing implementation
assert view.assigns.user.name == "John"

# ✅ Correct - testing user-visible output
html = render(view)
assert html =~ "John"
```

### What NOT to Test

- Framework behavior (trust LiveView works)
- CSS/visual styling
- JavaScript execution (LiveViewTest doesn't run JS)
- Third-party library internals

### Component Testing

**Test via parent LiveView, not in isolation:**
```elixir
test "modal closes on click", %{conn: conn} do
  {:ok, view, _html} = live(conn, "/page")

  # Interact with component through parent
  view |> element("#modal .close-button") |> render_click()

  refute has_element?(view, "#modal")
end
```

### Authentication in Tests

**Create helper in ConnCase to register and log in users:**

```elixir
# test/support/conn_case.ex
def register_and_log_in_user(%{conn: conn}) do
  user = create_user()  # From fixtures
  conn = log_in_user(conn, user)
  %{conn: conn, user: user}
end

defp log_in_user(conn, user) do
  # Get authentication strategy
  strategy = AshAuthentication.Info.strategy!(MyApp.Accounts.User, :password)

  # Sign in directly (skip UI)
  {:ok, user} = AshAuthentication.Strategy.action(strategy, :sign_in, %{
    "username" => user.email,
    "password" => "password123"
  })

  # Store in session
  conn
  |> Phoenix.ConnTest.init_test_session(%{})
  |> AshAuthentication.Plug.Helpers.store_in_session(user)
end
```

**Use in tests:**

```elixir
describe "authenticated routes" do
  setup :register_and_log_in_user

  test "user can access dashboard", %{conn: conn, user: user} do
    {:ok, view, html} = live(conn, "/dashboard")
    assert html =~ user.email
  end
end
```

### Common Mistakes

- **Missing `render_async/1`** - Async data not loaded before assertions
- **Brittle selectors** - Using `.btn-primary` instead of `data-test` attributes
- **Testing too much per test** - Each test = one user flow
- **Not using `async: true`** - Tests slower than they should be
