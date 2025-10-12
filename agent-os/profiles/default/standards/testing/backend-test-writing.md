## Backend Ash Test Standards

### The Golden Rules

1. **NEVER use Ecto/Repo directly** - Always use Ash APIs (domain functions, `Ash.Query`, `Ash.read!`)
2. **ARRANGE: Use domain functions with `authorize?: false`** - Respects validations, skips auth
3. **ACT: Use domain functions with `actor:`** - Tests real authorization
4. **ASSERT: Use `Ash.load!`, `Ash.get!`, or `Ash.Query.filter`** - Never bypass Ash layer
5. **Use `Ash.Seed.seed!` ONLY for non-accepted attributes** - Like setting `status: :failed` directly

### Test Structure (Arrange-Act-Assert)

```elixir
test "user can generate report", %{conn: conn} do
  # ARRANGE - Create test data with authorize?: false
  user = Accounts.register_user!(
    %{email: "test@example.com", password: "pass123"},
    authorize?: false
  )
  org = Organizations.create_org!(%{name: "Acme"}, authorize?: false)

  # ACT - Test the actual action with real actor
  {:ok, report} = Reports.generate_report(
    %{name: "Q1 Report", report_type: :daily},
    actor: user,
    tenant: org.id
  )

  # ASSERT - Query through Ash layer
  assert report.status == :completed

  report = Ash.load!(report, [:sections])
  assert length(report.sections) > 0
end
```

### When to Use What

**Domain Functions (Preferred):**

```elixir
# ✅ ARRANGE phase - bypass auth, keep validations
user = Accounts.create_user!(%{email: "test@example.com"}, authorize?: false)

# ✅ ACT phase - test with real authorization
{:ok, post} = Blog.create_post(%{title: "Test"}, actor: user)

# ✅ ASSERT phase - read through domain
post = Blog.get_post!(post.id, actor: user)
```

**Ash.Seed (For Non-Accepted Attributes Only):**

```elixir
# ✅ Setting state machine status not in accept list
order = Ash.Seed.seed!(Order, %{
  user_id: user.id,
  status: :processing  # Can't pass this to create action
})

# ✅ Setting system timestamps directly
report = Ash.Seed.seed!(Report, %{
  name: "Test",
  completed_at: DateTime.utc_now()  # Not in accept list
})

# ❌ Don't use Ash.Seed when domain function works
user = Ash.Seed.seed!(User, %{email: "test@example.com"})  # Use domain function!
```

**Ash.Query (For Complex Filtering):**

```elixir
# ✅ Multi-field filtering in assertions
pending_orders = Order
  |> Ash.Query.filter(status == :pending and total > 100)
  |> Ash.read!(actor: user, tenant: org.id)

assert length(pending_orders) == 3
```

**Ash.load! (For Relationships):**

```elixir
# ✅ Load relationships for assertions
order = Ash.load!(order, [:line_items, :customer])
assert length(order.line_items) == 2

# ✅ Nested loading
order = Ash.load!(order, line_items: [:product])
```

### Testing Authorization

```elixir
test "user cannot delete other user's post" do
  owner = create_user()
  other_user = create_user()
  post = Blog.create_post!(%{title: "Test"}, actor: owner, authorize?: false)

  # Test authorization failure
  assert {:error, %Ash.Error.Forbidden{}} =
    Blog.delete_post(post.id, actor: other_user)
end

test "checks permission before showing UI" do
  user = create_user()
  post = create_post()

  # Use Ash.can? for UI permission checks
  assert Ash.can?({post, :update}, user)
  refute Ash.can?({post, :delete}, user)
end
```

### Critical Gotchas

**1. Never use Ecto/Repo:**

```elixir
# ❌ Wrong - bypasses Ash completely
users = Repo.all(User)

# ✅ Correct - through Ash
users = Ash.read!(User)
```

**2. Don't use `authorize?: false` in ACT phase:**

```elixir
# ❌ Wrong - not testing authorization!
{:ok, post} = Blog.create_post(%{title: "Test"}, authorize?: false)

# ✅ Correct - tests real authorization
{:ok, post} = Blog.create_post(%{title: "Test"}, actor: user)
```

**3. Use `Ash.Seed` only when necessary:**

```elixir
# ❌ Wrong - domain function would work
user = Ash.Seed.seed!(User, %{email: "test@example.com"})

# ✅ Correct - Ash.Seed only for non-accepted fields
order = Ash.Seed.seed!(Order, %{status: :completed})  # status not in accept
```

### Common Patterns

**Testing State Machines:**

```elixir
# Create in specific state with Ash.Seed
order = Ash.Seed.seed!(Order, %{status: :processing, user_id: user.id})

# Test transition action
{:ok, completed} = Shop.complete_order(order.id, actor: user)
assert completed.status == :completed
```

**Testing Nested Relationships:**

```elixir
# Create with domain function
{:ok, order} = Shop.create_order(
  %{
    total: 100,
    line_items: [
      %{product_id: p1.id, quantity: 2},
      %{product_id: p2.id, quantity: 1}
    ]
  },
  actor: user,
  authorize?: false
)

# Load and assert
order = Ash.load!(order, [:line_items])
assert length(order.line_items) == 2
```

**Testing Multi-Tenancy:**

```elixir
org1 = create_org()
org2 = create_org()

# Create in org1
report = Reports.create!(%{name: "Test"}, tenant: org1.id, authorize?: false)

# Can't access from org2 (returns NotFound, not Forbidden)
assert {:error, %Ash.Error.Query.NotFound{}} =
  Reports.get(report.id, tenant: org2.id)
```

### Authentication in Tests

**Use helper to create authenticated test users:**

```elixir
# test/support/fixtures.ex
def create_user(attrs \\ %{}) do
  Accounts.register_user!(
    Map.merge(%{
      email: "user#{System.unique_integer()}@example.com",
      password: "password123"
    }, attrs),
    authorize?: false
  )
end
```

**ARRANGE: Create users with `authorize?: false`. ACT: Pass real actor.**

```elixir
test "user can create post" do
  # ARRANGE - bypass auth for test data
  user = create_user()

  # ACT - test with real authorization
  {:ok, post} = Blog.create_post(%{title: "Test"}, actor: user)

  assert post.user_id == user.id
end
```

### Config for Testing

```elixir
# config/test.exs
config :ash, :disable_async?, true  # Required for SQL Sandbox
config :ash, :missed_notifications, :ignore  # Silence PubSub warnings
config :my_app, Oban, testing: :manual  # Manual job execution
config :bcrypt_elixir, log_rounds: 1  # Fast password hashing in tests
```

### What NOT to Test

- Framework features (trust Ash works)
- Library features (trust that things like Oban, AshOban, Hammer, etc... work)
- That validations run (unless testing custom validation)
- Ecto schema definitions
- Default Ash behavior

### Use `async: true`

```elixir
use ExUnit.Case, async: true  # Always start with this!
```

Ash with SQL Sandbox provides transaction isolation - tests run concurrently and safely.

If you have a test file that uses both async: true and import Mox, you should always add Mox.set_mox_private() in the setup block.
