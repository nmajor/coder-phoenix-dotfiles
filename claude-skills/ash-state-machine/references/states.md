# Ash-State-Machine - States

**Pages:** 10

---

## 

**URL:** https://hexdocs.pm/ash_state_machine/ash_state_machine.epub

---

## AshStateMachine

**URL:** https://hexdocs.pm/ash_state_machine/dsl-ashstatemachine.html

**Contents:**
- AshStateMachine
- state_machine
  - Nested DSLs
  - Options
  - state_machine.transitions
  - Wildcards
  - Nested DSLs
  - state_machine.transitions.transition
  - Arguments
  - Options

Provides tools for defining and working with resource-backed state machines.

Use :* to represent "any action" when used in place of an action, or "any state" when used in place of a state.

The full list of states is derived at compile time from the transitions. Use the extra_states to express that certain types should be included in that list even though no transitions go to/from that state explicitly. This is necessary for cases where there are states that use :* and no transition explicitly leads to that transition.

Target: AshStateMachine.Transition

Hex Package Hex Preview (current file) Search HexDocs Download ePub version

Built using ExDoc (v0.38.2) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
transition :*, from: :*, to: :*
```

Example 2 (unknown):
```unknown
transition action
```

---

## Charts

**URL:** https://hexdocs.pm/ash_state_machine/charts.html

**Contents:**
- Charts

Run mix ash_state_machine.generate_flow_charts to generate flow charts for your resources. See the task documentation for more. Here is an example:

Hex Package Hex Preview (current file) Search HexDocs Download ePub version

Built using ExDoc (v0.38.2) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
stateDiagram-v2
pending --> confirmed: confirm
confirmed --> on_its_way: begin_delivery
on_its_way --> arrived: package_arrived
on_its_way --> error: error
confirmed --> error: error
pending --> error: error
```

---

## What is AshStateMachine?

**URL:** https://hexdocs.pm/ash_state_machine/what-is-ash-state-machine.html

**Contents:**
- What is AshStateMachine?
- What is a State Machine?
  - Why should we use state machines?
    - Flexible
    - Migrateable
    - Easy to reason about for humans
    - Compatible with any storage mechanism
- What does AshStateMachine do differently than other implementations?

A state machine is a program who's purpose is to manage an internal "state". The simplest example of a state machine could be a program representing a light switch. A light switch might have two states, "on" and "off". You can transition from "on" to "off", and back.

To build state machines with Ash.Resource, we use AshStateMachine.

When we refer to "state machines" in AshStateMachine, we're referring to a specific type of state machine known as a "Finite State Machine". It is "finite", because there are a statically known list of states that the machine may be in at any time, just like the Switch example above.

State machines are a simple and powerful way to represent complex workflows. They are flexible to modifications over time by adding new states, or new transitions between states.

State machines typically contain additional data about the state that they are in, or past states that they have been in, and this state must be migrated over time. When representing data as state machines, it becomes simple to do things like "update all package records that are in the pending_shipment state".

State machines, when compared to things like workflows, are easy for people to reason about. We have an intuition for things like "the package is currently on_its_way, with a current_location of New York, New York", or "your package is now out_for_delivery with an ETA of 6PM".

Since state machines are backed by simple state, you can often avoid any fancy workflow runners or complex storage mechanisms. You can store them in a database table, a json blob, a CSV file, at the end of the day its just a :state field and accompanying additional fields.

AshStateMachine is an Ash.Resource extension, meaning it enhances a resource with state machine capabilities. In Ash, all modifications go through actions. In accordance with this, AshStateMachine offers a DSL for declaring valid states and transitions, but does not, itself, perform those transitions. You will use a change called transition_state/1 in an action to move from one state to the other. For more, check out the CookBook

Hex Package Hex Preview (current file) Search HexDocs Download ePub version

Built using ExDoc (v0.38.2) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
classDiagram

class Switch {
  state on | off
  turnOn() off -> on
  turnOff() on -> off
}
```

---

## Getting Started with State Machines

**URL:** https://hexdocs.pm/ash_state_machine/getting-started-with-ash-state-machine.html

**Contents:**
- Getting Started with State Machines
- Get familiar with Ash resources
- Bring in the ash_state_machine dependency
- Add the extension to your resource
- Add initial states, and a default initial state
- Add allowed transitions
- Use transition_state in your actions
  - For simple/static state transitions
  - For dynamic/conditional state transitions
- Declaring a custom state attribute

If you haven't already, read the Ash Getting Started Guide, and familiarize yourself with Ash and Ash resources.

By default, a :state attribute is created on the resource that looks like this:

You can change the name of this attribute, without declaring an attribute yourself, like so:

If you need more control, you can declare the attribute yourself on the resource:

Be aware that the type of this attribute needs to be :atom or a type created with Ash.Type.Enum. Both the default and list of values need to be correct!

The concept of a state machine (in this case a "Finite State Machine"), essentially involves a single state, with specified transitions between states. For example, you might have an order state machine with states [:pending, :on_its_way, :delivered]. However, you can't go from :pending to :delivered (probably), and so you want to only allow certain transitions in certain circumstances, i.e :pending -> :on_its_way -> :delivered.

This extension's goal is to help you write clear and clean state machines, with all of the extensibility and power of Ash resources and actions.

Hex Package Hex Preview (current file) Search HexDocs Download ePub version

Built using ExDoc (v0.38.2) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
{:ash_state_machine, "~> 0.2.12"}
```

Example 2 (unknown):
```unknown
use Ash.Resource,
  extensions: [AshStateMachine]
```

Example 3 (unknown):
```unknown
use Ash.Resource,
  extensions: [AshStateMachine]

...

state_machine do
  initial_states [:pending]
  default_initial_state :pending
end
```

Example 4 (unknown):
```unknown
state_machine do
  initial_states [:pending]
  default_initial_state :pending

  transitions do
    # `:begin` action can move state from `:pending` to `:started`/`:aborted`
    transition :begin, from: :pending, to: [:started, :aborted]
  end
end
```

---

## AshStateMachine (ash_state_machine v0.2.12)

**URL:** https://hexdocs.pm/ash_state_machine/AshStateMachine.html

**Contents:**
- AshStateMachine (ash_state_machine v0.2.12)
- Summary
- Functions
- Functions
- possible_next_states(record)
- possible_next_states(record, action_name)
- state_machine(body)
- transition_state(changeset, target)

Provides tools for defining and working with resource-backed state machines.

A reusable helper which returns all possible next states for a record (regardless of action).

A reusable helper which returns all possible next states for a record given a specific action.

A utility to transition the state of a changeset, honoring the rules of the resource.

A reusable helper which returns all possible next states for a record (regardless of action).

A reusable helper which returns all possible next states for a record given a specific action.

A utility to transition the state of a changeset, honoring the rules of the resource.

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.2) for the Elixir programming language

---

## Home

**URL:** https://hexdocs.pm/ash_state_machine/readme.html

**Contents:**
- Home
- AshStateMachine
- Tutorials
- Topics
- Reference

Welcome! This is the extension for building state machines with Ash resources.

Hex Package Hex Preview (current file) Search HexDocs Download ePub version

Built using ExDoc (v0.38.2) for the Elixir programming language

---

## AshStateMachine.Transition (ash_state_machine v0.2.12)

**URL:** https://hexdocs.pm/ash_state_machine/AshStateMachine.Transition.html

**Contents:**
- AshStateMachine.Transition (ash_state_machine v0.2.12)
- Summary
- Types
- Types
- t()

The configuration for an transition.

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.2) for the Elixir programming language

---

## mix ash_state_machine.generate_flow_charts (ash_state_machine v0.2.12)

**URL:** https://hexdocs.pm/ash_state_machine/Mix.Tasks.AshStateMachine.GenerateFlowCharts.html

**Contents:**
- mix ash_state_machine.generate_flow_charts (ash_state_machine v0.2.12)
- Prerequisites
- Command line options
- Summary
- Functions
- Functions
- run(argv)

Generates a Mermaid Flow Chart for each Ash.Resource with the AshStateMachine extension alongside the resource.

This mix task requires the Mermaid CLI to be installed on your system.

See https://github.com/mermaid-js/mermaid-cli

Callback implementation for Mix.Task.run/1.

Callback implementation for Mix.Task.run/1.

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.2) for the Elixir programming language

---

## Working with Ash.can?

**URL:** https://hexdocs.pm/ash_state_machine/working-with-ash-can.html

**Contents:**
- Working with Ash.can?

Using Ash.can?/3 won't return false if a given state machine transition is invalid. This is because Ash.can?/3 is only concerned with policies, not changes/validations. However, many folks use Ash.can?/3 in their UI to determine whether a given button/form/etc should be shown. To help with this you can add the following to your resource:

This check is only used in pre_flight authorization checks (i.e calling Ash.can?/3), but it will return true in all cases when running real authorization checks. This is because the change is validated when you use the transition_state/1 change and AshStateMachine.transition_state/2, and so you would be doing extra work for no reason.

Hex Package Hex Preview (current file) Search HexDocs Download ePub version

Built using ExDoc (v0.38.2) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
policies do
  policy always() do
    authorize_if AshStateMachine.Checks.ValidNextState
  end
end
```

---
