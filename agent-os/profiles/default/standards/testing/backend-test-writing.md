## Backend test writing standards (Ash Framework)

### Core Testing Philosophy

- **Write Minimal Tests During Development**: Do NOT write tests for every change or intermediate step - focus on completing feature implementation first
- **Test Only Core User Flows**: Write tests exclusively for critical paths and primary user workflows
- **Defer Edge Case Testing**: Do NOT test edge cases, error states, or validation logic unless business-critical
- **Test Behavior Not Implementation**: Focus on what code does, not how it does it, to reduce brittleness
- **Clear Test Names**: Use descriptive names that explain what's being tested and expected outcome
- **Fast Execution**: Keep tests fast (milliseconds) so developers run them frequently

### The Golden Rule: Always Use Ash API Layer

- **NEVER Bypass to Data Layer**: NEVER use `Ecto.Query` or `Repo` directly in application or test code
- **ALWAYS Use Ash APIs**: Use `Ash.Query`, `Ash.create!`, `Ash.read!`, `Ash.get!`, `Ash.load!` for all database operations
- **Testing Validates YOUR Logic**: Tests verify your business logic, not the framework
- **Struct Access Only**: Use `record.field` not `record[:field]` for attribute access

### Test Data Creation (ARRANGE Phase)

- **Domain Functions with authorize false**: Use `Domain.create!(params, authorize?: false)` to respect validations while bypassing authorization
- **Ash.Seed for Fixtures**: Use `Ash.Seed.seed!(Resource, %{...})` to bypass everything and set any attribute (including non-accepted fields)
- **Ash.Seed.upsert for Idempotency**: Use `Ash.Seed.upsert!(struct, identity: :field_name)` for fixtures that should be created once
- **Use Domain Functions When Possible**: Prefer domain functions unless you need to set attributes not in action's accept list
- **Bypass Authorization in Setup**: Test helpers should use `authorize?: false` to simplify test data creation

### Testing Actions (ACT Phase)

- **Always Use Domain Functions**: Call `Domain.action!(params, actor: user)` like `Accounts.register_user!` not direct `Ash.create!`
- **Test Real Authorization**: In ACT phase, pass real `actor:` to verify authorization policies work correctly
- **Use Raising Versions**: Prefer `create!`, `update!` over tuple returns for cleaner test code
- **Pass Tenant When Required**: Include `tenant: org.id` for multi-tenant resources
- **Avoid Direct Ash Calls**: Prefer domain code interface functions over `Ash.create/update/destroy` directly

### Querying Data (ASSERT Phase)

- **Domain Read Functions**: Use `Domain.get_resource(id, actor: user)` for reading specific records
- **Ash.Query for Filtering**: Use `Resource |> Ash.Query.filter(field == value) |> Ash.read!()` for filtered queries
- **Ash.get! for Single Records**: Use `Ash.get!(Resource, id, tenant: org.id)` when record must exist
- **Ash.load! for Relationships**: Use `Ash.load!(record, [:relationship1, :relationship2])` to load associations
- **Never Ecto.Query**: NEVER use `from(r in Resource) |> Repo.all()` - always go through Ash

### Testing Authorization and Policies

- **Domain can Functions**: Use `Domain.can_action_resource?(user, params)` when domain provides helpers
- **Ash.can? for Explicit Checks**: Use `Ash.can?({Resource, :action}, user, input: %{...})` to test policies
- **Test with Real Actor**: Always pass `actor:` in ACT phase to verify authorization enforcement
- **Cross-Tenant Returns NotFound**: Cross-tenant access should return `NotFound` not `Forbidden`

### Property Testing with Ash.Generator

- **Use changeset_generator**: Prefer `Ash.Generator.changeset_generator(Resource, :action)` for property tests
- **Tests Real Validations**: Changeset generator tests against real domain actions and validations
- **Use seed_generator Sparingly**: Only use `Ash.Generator.seed_generator` when you need to bypass validations
- **action_input for Input Generation**: Use `Ash.Generator.action_input(Resource, :action)` to generate valid inputs

### Test Helper Patterns

- **Ash.Seed for Complex Fixtures**: Use `Ash.Seed.seed!` in helpers when you need to set status/state fields not in accept lists
- **Domain Functions for Standard Creation**: Use domain functions with `authorize?: false` for typical test data
- **Unique Identifiers**: Use `System.unique_integer([:positive])` or UUIDs for unique test data
- **Default Attributes Pattern**: Merge user-provided attrs with defaults in helper functions
- **Fixture Modules**: Create dedicated `MyApp.Fixtures` module for reusable test data creation

### Concurrent Testing (async: true)

- **Always Start with async true**: Every test file MUST start with `use ExUnit.Case, async: true`
- **Database Isolation**: Ash with Ecto SQL Sandbox provides transaction isolation for concurrent tests
- **No Shared Mutable State**: Avoid global state, singletons, or shared processes in tests
- **Fast Test Suites**: Concurrent execution means test suite runs as fast as slowest individual test file

### What NOT to Do

- **Never Ecto.Query or Repo**: Don't use `from(r in "table") |> Repo.all()` or `Repo.insert!` - use Ash APIs
- **Never Map Access**: Don't use `record[:field]` - use struct access `record.field`
- **Never Bypass Validations in ACT**: Don't use `authorize?: false` when testing the action itself
- **Never Test Framework**: Don't test that Ash's features work - test YOUR business logic
- **Never Hardcode IDs**: Use fixtures and generated IDs, not hardcoded UUIDs in tests

### Testing Pattern Summary

**ARRANGE** - Create test data:
```elixir
# Use domain functions with authorize?: false
user = Accounts.register_user!(
  %{email: "test@example.com", password: "password123"},
  authorize?: false
)

# Or Ash.Seed for attributes not in accept list
report = Ash.Seed.seed!(Report, %{
  organization_id: org.id,
  status: :failed  # Not in accept list
})
```

**ACT** - Execute the action being tested:
```elixir
# Use domain function with real actor
{:ok, report} = Reports.generate_report(
  %{name: "Test", report_type: :daily},
  actor: user,
  tenant: org.id
)
```

**ASSERT** - Verify results:
```elixir
# Use Ash.Query, Ash.read!, Ash.get!, Ash.load!
assert report.status == :completed

report = Ash.load!(report, [:sections])
assert length(report.sections) > 0

pending_reports = Report
  |> Ash.Query.filter(status == :pending)
  |> Ash.read!(tenant: org.id)

assert length(pending_reports) == 0
```

### Integration with External APIs

- **Follow External API Standards**: See `backend/external-apis.md` for Mox-based testing patterns
- **Mock External Dependencies**: Use Mox for external API clients in backend tests
- **No Real HTTP Calls**: Never make actual external API calls in test suite (use mocks)
- **One Integration Test**: Create ONE real integration test per API endpoint (tagged, skipped by default)

### Common Patterns

**Testing Nested Relationships:**
```elixir
# Create parent with nested child
business = Ash.Seed.seed!(Business, %{
  name: "Test Business",
  location: %{
    city: "Portland",
    google_business_profile: %{place_id: "test123"}
  }
})

# Load and assert on nested data
business = Ash.load!(business, location: [:google_business_profile])
assert business.location.city == "Portland"
```

**Testing State Machines:**
```elixir
# Use Ash.Seed to create in specific state
order = Ash.Seed.seed!(Order, %{status: :processing})

# Test transition
{:ok, updated} = order
  |> Ash.Changeset.for_update(:complete)
  |> Ash.update(actor: user)

assert updated.status == :completed
```

**Testing Background Jobs (AshOban):**
```elixir
# Set Oban to manual mode in test.exs
config :my_app, Oban, testing: :manual

# In test
user = create_user()

# Job should be enqueued but not executed
assert_enqueued worker: MyApp.Workers.SendWelcome

# Manually drain queue to execute
Oban.drain_queue(:default)

# Assert side effects happened
assert_email_sent(to: user.email)
```

### Best Practices

- **Test Domain Logic**: Focus on testing YOUR business rules, not Ash features
- **Use Test Helpers**: Extract common setup into `test/support/fixtures.ex` or `test/support/helpers.ex`
- **Keep Tests Simple**: Each test should verify one behavior or outcome
- **Descriptive Assertions**: Use clear assertion messages to explain what failed
- **Avoid Test Interdependence**: Each test should be independent and runnable in isolation
