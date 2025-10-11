## Ash State Machine Standards

### When to Use

**Use for mutually exclusive states with enforced transitions.** Not for independent boolean flags.

```elixir
# ✅ State machine - exclusive states, defined transitions
Order: :pending → :processing → :completed → :archived

# ❌ Just use booleans - independent toggles
User: is_active, is_verified, is_premium
```

### Basic Setup

**Install with Igniter.** Define state attribute, initial states, and explicit transitions.

```elixir
use Ash.Resource, extensions: [AshStateMachine]

attribute :status, :atom do
  constraints one_of: [:pending, :processing, :completed, :failed]
  allow_nil? false
end

state_machine do
  initial_states [:pending]
  default_initial_state :pending

  transitions do
    transition :begin, from: :pending, to: :processing
    transition :complete, from: :processing, to: :completed
    transition :fail, from: :processing, to: :failed
    transition :retry, from: :failed, to: :pending
  end
end
```

### Integrate with Actions

**Use `change transition_state()` in update actions.** Name transitions after business operations.

```elixir
update :complete do
  accept []
  change transition_state(:completed)
  change set_attribute(:completed_at, &DateTime.utc_now/0)
end

update :fail do
  argument :reason, :string, allow_nil?: false
  change transition_state(:failed)
  change set_attribute(:error, arg(:reason))
end
```

### Authorization for UI

**Use `ValidNextState` check for showing/hiding buttons.** It's pre-flight only, not enforcement.

```elixir
# In resource policies
policy always() do
  authorize_if AshStateMachine.Checks.ValidNextState
end

# In LiveView - conditionally show button
if Ash.can?({order, :complete}, actor: current_user) do
  <.button phx-click="complete">Complete Order</.button>
end
```

### Key Pitfalls

- **Missing extension** - Add `AshStateMachine` to resource extensions
- **No constraints** - State attribute needs `constraints one_of: [...]`
- **Undefined transition** - Every state change needs a transition definition
- **Wildcard abuse** - Avoid `from: :*` (breaks guarantees)
- **ValidNextState confusion** - It doesn't block transitions, only helps with `Ash.can?/3`
