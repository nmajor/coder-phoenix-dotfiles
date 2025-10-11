## Ash state machine standards (AshStateMachine)

### When to Use State Machines

- **Lifecycle with Defined Transitions**: Resource has states with specific allowed transitions (order: pending → processing → completed)
- **Workflow Management**: Multi-step processes with clear progression rules (document approval, assignment lifecycle)
- **State Validation Required**: Need to prevent invalid state changes (can't go from completed back to pending without explicit retry)
- **Background Job Orchestration**: Job status tracking with state-driven triggers (queued → running → completed/failed)
- **Approval Processes**: Resources requiring review stages (submitted → under_review → approved/rejected)
- **Invitation Systems**: Time-sensitive state transitions (pending → accepted/expired)
- **Payment Processing**: Financial workflows requiring strict state control and audit trails

### When NOT to Use State Machines

- **Simple Boolean Flags**: Resources with `is_active`, `is_published` without transition rules - use regular boolean attributes
- **No Transition Constraints**: Status can be any value at any time without validation - use atom attribute with constraints
- **Rapid State Changes**: States changing multiple times per second - use GenServer for in-memory state instead
- **Real-time Feedback Loops**: Interactions with sub-minute delays - prefer GenServer over AshStateMachine + AshOban
- **Simple Field Validation**: Just need to validate field value, not manage state lifecycle - use attribute constraints

### Installation

- **Use Igniter**: Always install with `mix igniter.install ash_state_machine` for proper setup and configuration
- **Never Manual**: Don't add dependency manually - Igniter handles version compatibility and required setup code
- **Extension Required**: Add `extensions: [AshStateMachine]` to resource's `use Ash.Resource` options

### State Machine Definition

- **Declare in Resource**: Define `state_machine` block directly in resource module, not separate file
- **State Attribute**: Specify which attribute tracks state with `state_attribute :status` (defaults to `:state`)
- **Attribute Configuration**: State attribute must be atom type with `constraints one_of: [...]` listing all valid states
- **Initial States**: Define `initial_states [...]` as list of allowed starting states
- **Default Initial**: Set `default_initial_state :state_name` for automatic initialization on create
- **Non-nullable**: State attribute should have `allow_nil? false` to ensure state always exists

### Transition Configuration

- **Explicit Transitions**: Define all allowed transitions in `transitions` block - only these paths are permitted
- **From Single State**: Use `transition :action_name, from: :current_state, to: :next_state` for single source
- **From Multiple States**: Use `transition :action_name, from: [:state1, :state2], to: :target` for multiple sources
- **Wildcard Transitions**: Use `from: :*` to allow transition from any state (use sparingly, breaks state machine guarantees)
- **Multiple Target States**: Use `to: [:state1, :state2]` when action can transition to different states (requires dynamic logic)
- **Transition Names**: Name transitions after business operations (`:approve`, `:cancel`, `:retry`), not state names

### Action Integration

- **Static Transitions**: Use `change transition_state(:target_state)` in action for fixed destination state
- **Dynamic Transitions**: Use custom change module with `AshStateMachine.transition_state(changeset, state)` for conditional logic
- **Accept Empty**: Transition actions typically have `accept []` unless accepting additional fields beyond state change
- **Add Validations**: Include validations in action before transition (verify prerequisites are met)
- **Set Timestamps**: Use `change set_attribute(:completed_at, &DateTime.utc_now/0)` to track transition timing
- **Side Effects**: Combine with `after_action`, `run_oban_trigger`, or notifiers for transition-triggered behavior

### Authorization with State Machines

- **ValidNextState Check**: Add `authorize_if AshStateMachine.Checks.ValidNextState` to policies for UI authorization checks
- **Pre-flight Only**: ValidNextState only works in `Ash.can?/3` pre-flight checks, returns true in actual authorization
- **Not a Blocker**: ValidNextState does NOT block invalid transitions during execution - transition_state handles validation
- **UI Button Logic**: Use `Ash.can?({record, :action}, actor: user)` to conditionally show/hide transition buttons in UI
- **Policy Pattern**: Typical pattern is `policy always() do authorize_if AshStateMachine.Checks.ValidNextState end`

### Background Jobs with AshOban

- **Perfect Pairing**: State machines work excellently with AshOban for asynchronous state-driven workflows
- **Trigger on Transition**: Use `change run_oban_trigger(:trigger_name)` in transition action to queue background job
- **State in Worker**: Background job action should transition state (`:queued` → `:running`, then `:completed` or `:failed`)
- **Retry Pattern**: Define retry transition (`from: :failed, to: :queued`) to re-queue failed jobs
- **Multi-minute Delays**: Use AshOban for processes with 1+ minute intervals between state changes
- **Sub-minute Delays**: Use GenServer instead of AshOban for real-time state feedback loops

### Advanced Patterns

- **Retry Failed States**: Define `transition :retry, from: :failed, to: :pending` with `change run_oban_trigger(:process)` to re-attempt
- **Auto-transitions**: Use change modules to check conditions and auto-transition (scan completes when all children complete)
- **Multiple End States**: Allow transitions to multiple terminal states (`:approved`, `:rejected` both can go to `:archived`)
- **State-dependent Calculations**: Use state attribute in calculations and aggregates for derived data
- **on_transition Hooks**: Use `on_transition` block for declarative side effects that only fire on state changes, not all updates
- **Conditional Routing**: Use custom change module to determine target state at runtime based on resource data

### Documentation and Visualization

- **Generate Flow Charts**: Run `mix ash_state_machine.generate_flow_charts` to create visual state diagrams
- **Onboarding Tool**: Use generated charts for documentation and onboarding new developers
- **Identify Complexity**: Flow charts help identify overly complex transition paths that need simplification
- **Keep Updated**: Regenerate charts after adding/modifying transitions to keep documentation current

### Testing State Machines

- **Test Actions Not Transitions**: Test the update actions that trigger transitions, not `transition_state` directly
- **Test Valid Paths**: Verify allowed transitions succeed and set correct target state
- **Test Invalid Paths**: Verify disallowed transitions raise `Ash.Error.Invalid` and don't change state
- **Test Full Lifecycle**: Create integration tests that walk through entire state lifecycle from start to end
- **Test Timestamps**: Verify transition actions set timing attributes correctly (`:completed_at`, `:started_at`)
- **Test Side Effects**: Verify background jobs, notifiers, or other side effects trigger on state transitions
- **Test Rollback**: Verify failed transitions don't partially update state or related resources

### Common Pitfalls

- **Forgetting Extension**: Not adding `AshStateMachine` to resource extensions causes undefined behavior
- **Missing Constraints**: State attribute without `constraints one_of: [...]` allows invalid states
- **No Transition Defined**: Attempting state change without corresponding transition definition fails
- **Wrong Transition Direction**: Defining transition with `from`/`to` reversed causes unexpected failures
- **Overusing Wildcards**: Using `from: :*` undermines state machine guarantees - use explicit transitions
- **ValidNextState Misunderstanding**: Expecting ValidNextState to block invalid transitions during execution (it's pre-flight only)
- **Static vs Dynamic**: Using static `transition_state(:state)` when conditional logic needed (use custom change module)
- **Missing require_atomic?**: Some complex transitions may need `require_atomic? false` in action definition

### Integration with Domain Modeling

- **Resource-centric Logic**: State machine logic lives in resource definition, not scattered across controllers/services
- **Self-documenting**: Transitions clearly show allowed state changes - no need to hunt through code
- **Composable**: Combine with calculations, aggregates, policies, validations, and relationship management
- **Policy Integration**: Use state attribute in policy conditions (`authorize_if expr(status == :approved)`)
- **Calculation Input**: Reference state in calculations (`calculate :is_active, :boolean, expr(status in [:processing, :completed])`)
- **Aggregate Filters**: Filter aggregates by state (`count :active_orders, :orders, filter: expr(status == :processing)`)

### Best Practices

- **Start with Simple States**: Begin with minimal states (`:pending`, `:completed`), add intermediate states as needed
- **Name States Clearly**: Use descriptive state names that reflect business meaning (`:awaiting_payment` not `:state_2`)
- **Limit Terminal States**: Minimize number of end states - consider if multiple ends can be consolidated
- **Document Transition Logic**: Add comments explaining business rules behind complex transitions
- **Use Timestamps**: Track when transitions occur with timestamp attributes for audit trails
- **Combine with Notifiers**: Use Phoenix.PubSub in `on_transition` to broadcast state changes to LiveView
- **Test Edge Cases**: Test transitions from all valid source states, especially with `from: [:multiple, :states]`
- **Visualize Early**: Generate flow charts early in development to identify design issues before implementation
- **Consider Reversibility**: Think about which transitions should be reversible and which should be one-way

### Decision Checklist

```
□ Resource has status/state field with specific allowed transitions
□ Transitions are slower than 1 minute apart (use GenServer if faster)
□ Need to prevent invalid state changes (not just validate values)
□ State changes should be auditable and traceable
□ Will integrate with background jobs or async workflows
□ Need UI to show/hide actions based on current state

If all checked: ✅ Use AshStateMachine
If any unchecked: ⚠️  Evaluate if simpler solution (boolean, atom attribute) sufficient
```
