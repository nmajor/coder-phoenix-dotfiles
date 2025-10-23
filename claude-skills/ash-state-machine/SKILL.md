---
name: ash-state-machine
description: State management and workflow states. Use for ANY state transitions, lifecycle management, status tracking, FSM patterns, approval workflows, and managing entity state changes with defined transitions.
---

# Ash-State-Machine Skill

Comprehensive assistance with ash-state-machine development, generated from official documentation.

## When to Use This Skill

This skill should be triggered when:
- Building finite state machines for workflows (orders, approvals, deliveries, etc.)
- Managing entity lifecycle states (pending → processing → completed)
- Implementing state transitions with validation rules
- Creating resources that need to track state changes
- Working with workflows that have specific allowed state progressions
- Generating state machine flow charts
- Validating state transitions in Ash policies
- Building systems with stateful entities (e.g., order tracking, approval workflows)

## Key Concepts

### State Machine
A **Finite State Machine** (FSM) manages an internal "state" with a defined set of possible states and allowed transitions between them. For example, a package delivery might have states: `[:pending, :confirmed, :on_its_way, :delivered]`.

### Transitions
**Transitions** define which states can move to which other states, and which actions can trigger those transitions. For example: `transition :ship, from: :confirmed, to: :on_its_way`

### State Attribute
By default, AshStateMachine creates a `:state` attribute on your resource. This can be customized using the `state_attribute` option.

### Wildcards
Use `:*` to represent "any action" or "any state" in transitions, providing flexibility for complex state machines.

## Quick Reference

### Pattern 1: Basic State Machine Setup

```elixir
defmodule MyApp.Order do
  use Ash.Resource,
    extensions: [AshStateMachine]

  state_machine do
    initial_states [:pending]
    default_initial_state :pending

    transitions do
      transition :confirm, from: :pending, to: :confirmed
      transition :ship, from: :confirmed, to: :on_its_way
      transition :deliver, from: :on_its_way, to: :delivered
    end
  end

  attributes do
    uuid_primary_key :id
  end

  actions do
    defaults [:read]

    update :confirm do
      accept []
      change transition_state(:confirmed)
    end
  end
end
```

### Pattern 2: Multiple Target States

```elixir
state_machine do
  initial_states [:pending]
  default_initial_state :pending

  transitions do
    # Can transition from pending to either started OR aborted
    transition :begin, from: :pending, to: [:started, :aborted]
  end
end
```

### Pattern 3: Using Wildcards for Flexible Transitions

```elixir
state_machine do
  initial_states [:pending]
  default_initial_state :pending

  transitions do
    # Any action can transition from any state to any state
    transition :*, from: :*, to: :*

    # Or more controlled: any action can cancel from any state
    transition :*, from: :*, to: :cancelled
  end
end
```

### Pattern 4: Custom State Attribute

```elixir
state_machine do
  initial_states [:draft]
  default_initial_state :draft
  state_attribute :status  # Use :status instead of :state
end

attributes do
  attribute :status, :atom do
    allow_nil? false
    default :draft
    constraints one_of: [:draft, :published, :archived]
  end
end
```

### Pattern 5: Using transition_state in Actions

```elixir
actions do
  update :publish do
    accept [:title, :body]
    change transition_state(:published)
  end

  update :archive do
    accept []
    change transition_state(:archived)
  end
end
```

### Pattern 6: Conditional State Transitions

```elixir
actions do
  update :process_order do
    argument :approved, :boolean, allow_nil?: false

    # Dynamically choose target state based on argument
    change fn changeset, _context ->
      target_state = if changeset.arguments.approved do
        :approved
      else
        :rejected
      end

      AshStateMachine.transition_state(changeset, target_state)
    end
  end
end
```

### Pattern 7: Validating Transitions with Policies

```elixir
policies do
  policy always() do
    # Only allow actions if the state transition is valid
    authorize_if AshStateMachine.Checks.ValidNextState
  end
end
```

### Pattern 8: Checking Possible Next States

```elixir
# Get all possible next states for a record
AshStateMachine.possible_next_states(order)
# => [:confirmed, :cancelled]

# Get possible next states for a specific action
AshStateMachine.possible_next_states(order, :ship)
# => [:on_its_way]
```

### Pattern 9: Generate Flow Charts

```bash
mix ash_state_machine.generate_flow_charts
```

This generates Mermaid diagrams showing your state transitions:

```
stateDiagram-v2
pending --> confirmed: confirm
confirmed --> on_its_way: begin_delivery
on_its_way --> arrived: package_arrived
on_its_way --> error: error
confirmed --> error: error
pending --> error: error
```

### Pattern 10: Deprecated and Extra States

```elixir
state_machine do
  initial_states [:new]
  default_initial_state :new

  # States that are deprecated but still valid
  deprecated_states [:legacy_pending]

  # States that may be used by wildcard transitions
  extra_states [:system_cancelled]

  transitions do
    transition :start, from: :new, to: :active
    transition :cancel, from: :*, to: :cancelled
  end
end
```

## Reference Files

This skill includes comprehensive documentation in `references/`:

### states.md
Complete documentation of AshStateMachine DSL and concepts including:
- **DSL Reference**: Complete `state_machine` block options and syntax
- **Getting Started Guide**: Step-by-step tutorial on adding state machines to resources
- **Working with Ash.can?**: How to integrate state validation with authorization
- **Charts**: Generating visual flow charts for your state machines
- **API Documentation**: Functions like `transition_state/2` and `possible_next_states/1`
- **Real-world examples**: From the official Ash Framework books

### book-domain-modeling.md
Excerpts from the Ash Framework book covering domain modeling concepts that apply to state machines.

### book-pragmatic-ash.md
Practical examples and patterns from the Pragmatic Ash book, showing real-world state machine implementations.

## Working with This Skill

### For Beginners
1. Start with the **Getting Started** section in `references/states.md`
2. Review the basic setup patterns in Quick Reference (Patterns 1-2)
3. Add the extension to a resource and define simple transitions
4. Use `transition_state/1` in your actions
5. Generate flow charts to visualize your state machine

### For Intermediate Users
1. Explore wildcards and flexible transitions (Pattern 3)
2. Implement conditional state transitions (Pattern 6)
3. Integrate with Ash policies (Pattern 7)
4. Use `possible_next_states/1` for UI logic
5. Customize the state attribute (Pattern 4)

### For Advanced Users
1. Use deprecated and extra states for complex migrations (Pattern 10)
2. Build multi-stage workflows with multiple state machines
3. Integrate with Ash notifiers for state change events
4. Implement custom state validation logic
5. Use state machines across multi-tenant resources

### Common Workflows

**Creating a new state machine:**
1. Add `extensions: [AshStateMachine]` to your resource
2. Define `state_machine` block with initial states
3. Add transitions between states
4. Use `transition_state/1` in actions

**Checking valid transitions:**
```elixir
# In your LiveView or controller
if order.state in [:pending, :confirmed] do
  # Show "Ship" button
end

# Or use possible_next_states
next_states = AshStateMachine.possible_next_states(order)
if :shipped in next_states do
  # Show "Ship" button
end
```

**Integrating with UI authorization:**
```elixir
# Only show button if action is authorized AND transition is valid
if Ash.can?({order, :ship}, actor) do
  # Render ship button (Ash.can? checks ValidNextState policy)
end
```

## Why Use AshStateMachine?

### Flexible
Easily add new states or transitions without refactoring existing code. State machines grow naturally with your application.

### Migrateable
Simple to update records in bulk: "update all packages in `:pending_shipment` state".

### Easy to Reason About
Humans naturally understand states: "the package is `:on_its_way` with current location 'New York'".

### Storage Agnostic
Works with any data layer - PostgreSQL, ETS, external APIs. Just a `:state` field and transitions.

### Type-Safe
State validation happens at the framework level, preventing invalid transitions before they reach your database.

## Resources

### references/
Organized documentation extracted from official sources:
- **states.md**: Complete DSL reference, guides, examples
- **book-*.md**: Real-world patterns from official Ash books

### Scripts & Assets
Add helper scripts and templates here for:
- Common state machine generators
- Test fixtures for state transitions
- Migration scripts for adding state machines to existing resources

## Notes

- State machines in Ash are **action-driven**: transitions happen through actions, not direct state changes
- The `transition_state/1` change validates transitions against your defined rules
- Use `Ash.can?` with `ValidNextState` check to prevent invalid UI states
- Flow charts require the Mermaid CLI to be installed
- State attributes must be `:atom` type or `Ash.Type.Enum`
- Default state attribute is `:state`, but this is fully customizable

## Troubleshooting

**Invalid transition errors**: Check that your `transitions` block includes the from/to states you're attempting.

**Ash.can? returns true but transition fails**: `Ash.can?` checks policies, not validations. Use the `ValidNextState` policy check.

**States not showing in list**: If using wildcards (`:*`), add missing states to `extra_states`.

**Type errors on state attribute**: Ensure your state attribute is `:atom` type with proper constraints.

## Updating

To refresh this skill with updated documentation:
1. Re-run the documentation scraper
2. Review new patterns and add to Quick Reference
3. Update reference file descriptions if structure changes
