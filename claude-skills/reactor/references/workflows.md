# Reactor - Workflows

**Pages:** 64

---

## Reactor.Dsl.Template (reactor v0.17.0)

**URL:** https://hexdocs.pm/reactor/Reactor.Dsl.Template.html

**Contents:**
- Reactor.Dsl.Template (reactor v0.17.0)
- Summary
- Types
- Types
- t()

The template DSL entity struct.

See Reactor.template.

Hex Package Hex Preview Search HexDocs

Built using ExDoc (v0.38.3) for the Elixir programming language

---

## Reactor.Dsl.Switch.Default (reactor v0.17.0)

**URL:** https://hexdocs.pm/reactor/Reactor.Dsl.Switch.Default.html

**Contents:**
- Reactor.Dsl.Switch.Default (reactor v0.17.0)
- Summary
- Types
- Types
- t()

The default DSL entity struct.

See Reactor.switch.default.

Hex Package Hex Preview Search HexDocs

Built using ExDoc (v0.38.3) for the Elixir programming language

---

## Reactor.Dsl.Recurse (reactor v0.17.0)

**URL:** https://hexdocs.pm/reactor/Reactor.Dsl.Recurse.html

**Contents:**
- Reactor.Dsl.Recurse (reactor v0.17.0)
- Summary
- Types
- Types
- t()

The recurse DSL entity struct.

See the Reactor.recurse.

Hex Package Hex Preview Search HexDocs

Built using ExDoc (v0.38.3) for the Elixir programming language

---

## Reactor.Dsl.Around (reactor v0.17.0)

**URL:** https://hexdocs.pm/reactor/Reactor.Dsl.Around.html

**Contents:**
- Reactor.Dsl.Around (reactor v0.17.0)
- Summary
- Types
- Types
- t()

The around DSL entity struct.

Hex Package Hex Preview Search HexDocs

Built using ExDoc (v0.38.3) for the Elixir programming language

---

## Reactor.Error.Invalid.ForcedFailureError exception (reactor v0.17.0)

**URL:** https://hexdocs.pm/reactor/Reactor.Error.Invalid.ForcedFailureError.html

**Contents:**
- Reactor.Error.Invalid.ForcedFailureError exception (reactor v0.17.0)
- Summary
- Types
- Functions
- Types
- t()
- Functions
- exception(msg)
- Keys

This error is returned when the flunk DSL entity or the Reactor.Step.Fail step are called.

Create an Elixir.Reactor.Error.Invalid.ForcedFailureError without raising it.

Create an Elixir.Reactor.Error.Invalid.ForcedFailureError without raising it.

Hex Package Hex Preview Search HexDocs

Built using ExDoc (v0.38.3) for the Elixir programming language

---

## Reactor.Template.Result (reactor v0.17.0)

**URL:** https://hexdocs.pm/reactor/Reactor.Template.Result.html

**Contents:**
- Reactor.Template.Result (reactor v0.17.0)
- Summary
- Types
- Types
- t()

Hex Package Hex Preview Search HexDocs

Built using ExDoc (v0.38.3) for the Elixir programming language

---

## Reactor.Planner (reactor v0.17.0)

**URL:** https://hexdocs.pm/reactor/Reactor.Planner.html

**Contents:**
- Reactor.Planner (reactor v0.17.0)
- Summary
- Functions
- Functions
- plan(reactor)
- plan!(reactor)

Build an execution plan for a Reactor.

Converts any unplanned steps into vertices in a graph with directed edges between them representing their dependencies (arguments).

Build an execution plan for a Reactor.

Raising version of plan/1.

Build an execution plan for a Reactor.

Builds a graph of the step dependencies, resolves them and then builds an execution plan.

Raising version of plan/1.

Hex Package Hex Preview Search HexDocs

Built using ExDoc (v0.38.3) for the Elixir programming language

---

## Building Iterative Workflows with Recursive Execution

**URL:** https://hexdocs.pm/reactor/05-recursive-execution.html

**Contents:**
- Building Iterative Workflows with Recursive Execution
- What you'll build
- You'll learn
- Prerequisites
- Step 1: Set up the project
- Step 2: Understanding recursive execution
- Step 3: Build a simple countdown reactor
- Step 4: Build an accumulator
- Step 5: Advanced example - Convergence algorithm
- Step 6: Test the examples

In this tutorial, you'll learn how to build iterative workflows that process data repeatedly until a condition is met. This is perfect for mathematical algorithms, data processing pipelines, and convergence calculations.

Simple iterative algorithms demonstrating recursive patterns:

If you don't have a project from the previous tutorials:

Reactor's recursive execution allows you to:

Repeat until a condition is met:

Process data iteratively:

Let's start with a simple recursive algorithm. Create lib/countdown_reactor.ex:

Create lib/accumulator.ex:

Now let's look at a more sophisticated pattern - iterative convergence. Create lib/square_root_calculator.ex:

Let's test our recursive reactors:

You now understand Reactor's recursive execution:

You've mastered all core Reactor patterns! Ready for specialized guides:

Recursion never terminates: Ensure exit conditions can actually be met; always include max_iterations as backup

"Maximum iterations exceeded" error: Increase max_iterations or fix logic preventing proper convergence

State not passing correctly: Ensure output structure exactly matches input requirements; keep state flat and simple

Exit condition never triggers: Add debug logging to verify exit condition logic; check that condition field exists in state

Happy building iterative workflows! 🔄

Hex Package Hex Preview (current file) Search HexDocs

Built using ExDoc (v0.38.3) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
mix igniter.new reactor_tutorial --install reactor
cd reactor_tutorial
```

Example 2 (unknown):
```unknown
recurse :calculate, CalculatorReactor do
  argument :value, input(:start_value)
  exit_condition fn %{done: done} -> done == true end
  max_iterations 100
end
```

Example 3 (unknown):
```unknown
recurse :process, ProcessorReactor do
  argument :remaining, input(:data_list)
  exit_condition fn %{remaining: list} -> Enum.empty?(list) end
  max_iterations 1000
end
```

Example 4 (unknown):
```unknown
defmodule CountdownReactor do
  use Reactor

  input :current_number

  step :countdown_step do
    argument :current_number, input(:current_number)

    run fn %{current_number: num}, _context ->
      new_number = num - 1
      {:ok, %{current_number: new_number}}
    end
  end

  return :countdown_step
end

defmodule CountdownExample do
  use Reactor

  input :start_number

  recurse :countdown, CountdownReactor do
    argument :current_number, input(:start_number)
    max_iterations 100
    exit_condition fn %{current_number: num} -> num <= 0 end
  end

  step :show_result do
    argument 
...
```

---

## Reactor.Executor.StepRunner (reactor v0.17.0)

**URL:** https://hexdocs.pm/reactor/Reactor.Executor.StepRunner.html

**Contents:**
- Reactor.Executor.StepRunner (reactor v0.17.0)
- Summary
- Functions
- Functions
- run(reactor, state, step, concurrency_key)
- run_async(reactor, state, step, concurrency_key, process_contexts)
- undo(reactor, state, step, value, concurrency_key)

Run an individual step, including compensation if possible.

Collect the arguments and and run a step, with compensation if required.

Run a step inside a task.

Undo a step if possible.

Collect the arguments and and run a step, with compensation if required.

Run a step inside a task.

This is a simple wrapper around run/4 except that it emits more events.

Undo a step if possible.

Hex Package Hex Preview Search HexDocs

Built using ExDoc (v0.38.3) for the Elixir programming language

---

## How to Optimize Reactor Performance

**URL:** https://hexdocs.pm/reactor/performance-optimization.html

**Contents:**
- How to Optimize Reactor Performance
- Problem
- Solution Overview
- Prerequisites
- Understanding Performance Characteristics
  - Reactor's Performance Model
- Concurrency Optimization
  - 1. Configuring Basic Concurrency Limits
  - 2. Tuning Concurrency Settings
  - 3. Shared Concurrency Pools

You need to improve the performance of your reactor workflows, optimize concurrency, handle large-scale processing efficiently, and scale your system to handle high throughput with minimal resource usage.

This guide covers systematic performance optimization techniques for Reactor workflows, including concurrency tuning, resource management, memory optimization, and monitoring strategies. You'll learn to identify bottlenecks and apply targeted optimizations.

Reactor is designed for high-throughput, concurrent execution with these characteristics:

Bottlenecks to watch for:

Control how many steps can run concurrently within a single reactor:

Optimal concurrency settings depend on your specific workload and system characteristics. Start with these guidelines, then experiment and measure:

How to find your optimal settings:

Signs you need to adjust:

Share concurrency pools across reactor instances to prevent resource competition:

Configure batch sizes based on data characteristics and system capacity:

Critical memory considerations when using map steps:

Map steps have complex memory usage patterns that are a function of both batch size and mapped result size. Understanding this is crucial for processing large datasets efficiently.

1. Input Record Storage: Each batch of input records is converted into individual steps and added to the reactor state. These steps contain the input record as a value argument, contributing directly to memory usage until the step runs.

2. Intermediate Results Storage: A new map step is emitted which depends on the results of all batch steps. This means all batch step results are stored in Reactor's intermediate results until the map step completes.

3. Final Result Storage: The overall result of the map step (collection of all batch results) is likely to be depended upon by other steps, so remains in intermediate results storage.

Process large datasets without loading everything into memory:

Balance concurrency based on operation type - I/O operations can handle high concurrency, while CPU operations should use more conservative limits:

Handle CPU-intensive map operations efficiently:

Minimize memory usage by avoiding unnecessary intermediate result storage. Remember that undoable steps will have their results stored in the reactor's undo stack, so non-undoable steps save memory:

Monitor reactor performance with built-in telemetry:

When dealing with external services, proper backoff strategies can significantly imp

*[Content truncated]*

**Examples:**

Example 1 (unknown):
```unknown
defmodule DataProcessor do
  use Reactor

  input :user_ids

  # Multiple independent steps that can run in parallel
  step :fetch_profiles do
    argument :user_ids, input(:user_ids)
    run fn %{user_ids: ids}, _context ->
      profiles = fetch_user_profiles(ids)
      {:ok, profiles}
    end
  end

  step :fetch_preferences do
    argument :user_ids, input(:user_ids)
    run fn %{user_ids: ids}, _context ->
      preferences = fetch_user_preferences(ids)
      {:ok, preferences}
    end
  end

  step :fetch_activity do
    argument :user_ids, input(:user_ids)
    run fn %{user_ids: ids}, _
...
```

Example 2 (unknown):
```unknown
# Starting points for different workload types:

# For I/O-bound workloads (API calls, database queries)
max_concurrency: System.schedulers_online() * 4  # 4x CPU cores

# For CPU-bound workloads  
max_concurrency: System.schedulers_online()      # 1x CPU cores

# For mixed workloads
max_concurrency: System.schedulers_online() * 2  # 2x CPU cores

# For external service limits (rate limiting)
max_concurrency: 10  # Based on service constraints
```

Example 3 (unknown):
```unknown
# Create a shared pool
{:ok, pool_key} = Reactor.Executor.ConcurrencyTracker.allocate_pool(100)

# Use the pool across multiple reactor runs
opts = [concurrency_key: pool_key, max_concurrency: 100]

# All these reactors share the same 100-task limit
Task.async(fn -> Reactor.run(DataProcessor, inputs1, %{}, opts) end)
Task.async(fn -> Reactor.run(DataProcessor, inputs2, %{}, opts) end) 
Task.async(fn -> Reactor.run(DataProcessor, inputs3, %{}, opts) end)
```

Example 4 (unknown):
```unknown
defmodule BatchProcessingReactor do
  use Reactor

  input :records
  input :processing_type

  # For small, fast operations - larger batches
  map :process_lightweight_data do
    argument :source, input(:records)
    batch_size 1000  # Process 1000 items at once
    allow_async? true
    
    step :validate do
      argument :record, element(:source)
      run fn %{record: record}, _context ->
        # Fast validation logic
        {:ok, validate_record(record)}
      end
    end
    
    return :validate
  end

  # For expensive operations - smaller batches  
  map :process_heavy_computati
...
```

---

## Reactor Architecture

**URL:** https://hexdocs.pm/reactor/architecture.html

**Contents:**
- Reactor Architecture
- Core Components
  - Architecture Overview
  - The Reactor Struct
  - DSL Implementation
    - DSL Processing Flow
    - DSL Architecture
  - Executor Components
    - Main Executor (Reactor.Executor)
    - Step Runner (Reactor.Executor.StepRunner)

This guide explains how Reactor works internally, providing insight into its components, execution flow, and design patterns. Understanding the architecture helps you make informed decisions about workflow design, performance optimization, and debugging.

Reactor's architecture follows a clear separation of concerns between planning, execution, and state management:

At the heart of Reactor is the Reactor struct, which contains all the information needed for workflow execution:

Reactor's DSL is built with Spark, providing a declarative way to define workflows:

The transformer ensures reactors are validated and optimised at compile-time, catching errors early and enabling efficient execution.

The executor system coordinates all aspects of reactor execution through several specialised components:

Implements the core execution algorithm with sophisticated async/sync coordination:

Execution Loop Priority:

Handles individual step execution with comprehensive error handling:

Runtime-only execution state separate from reactor definition:

This separation allows the reactor definition to remain immutable while execution state is managed separately.

ETS-based global concurrency pool manager enabling resource sharing:

Pool Sharing Benefits:

Converts step definitions into an executable dependency graph:

Graph Construction Process:

The planner uses the libgraph library for efficient DAG operations and ensures all dependencies exist before execution begins.

The executor follows a sophisticated priority-based algorithm designed for maximum concurrency:

Execution Priorities:

Each step follows a detailed execution pipeline:

Context Building: Each step receives enhanced context:

Result Storage Strategy:

Undo Stack Management:

Error Handling Cascade:

Compensation Options:

Multi-layered Context System:

Optimisation Strategies:

Optimisation Features:

Scalability Characteristics:

Performance Optimisations:

Sub-Reactor Integration:

Runtime Step Creation:

This architecture enables Reactor to efficiently orchestrate complex, concurrent workflows while maintaining transactional semantics and providing robust error handling capabilities. The design prioritises both performance and reliability, making it suitable for mission-critical applications requiring sophisticated workflow orchestration.

Hex Package Hex Preview (current file) Search HexDocs

Built using ExDoc (v0.38.3) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
graph TB
    subgraph "Reactor Framework"
        DSL[DSL Definition] --> Parser[DSL Parser]
        Parser --> Builder[Reactor Builder]
        Builder --> Planner[Execution Planner]
        Planner --> Executor[Concurrent Executor]
        
        subgraph "Core Components"
            Steps[Step Definitions]
            Args[Argument Dependencies]
            Guards[Guard Conditions]
            Middleware[Middleware Stack]
        end
        
        Steps --> Builder
        Args --> Builder
        Guards --> Builder
        Middleware --> Executor
        
        Executor --> Results
...
```

Example 2 (unknown):
```unknown
defstruct context: %{},
          id: nil,
          input_descriptions: %{},
          inputs: [],
          intermediate_results: %{},
          middleware: [],
          plan: nil,
          return: nil,
          state: :pending,
          steps: [],
          undo: []
```

Example 3 (unknown):
```unknown
DSL Definition → Spark Entities → Transformer → Validation → Runtime Struct
```

Example 4 (unknown):
```unknown
Argument Collection → Context Building → Guard Evaluation → Step Run → Result Processing
```

---

## Reactor.Dsl.Middleware (reactor v0.17.0)

**URL:** https://hexdocs.pm/reactor/Reactor.Dsl.Middleware.html

**Contents:**
- Reactor.Dsl.Middleware (reactor v0.17.0)
- Summary
- Types
- Types
- t()

The middleware DSL entity struct.

See Reactor.middleware.middleware.

Hex Package Hex Preview Search HexDocs

Built using ExDoc (v0.38.3) for the Elixir programming language

---

## Reactor.Step.Group (reactor v0.17.0)

**URL:** https://hexdocs.pm/reactor/Reactor.Step.Group.html

**Contents:**
- Reactor.Step.Group (reactor v0.17.0)
- Options
- Before function
  - Example
- After function
- Summary
- Types
- Types
- after_fun()
- after_option()

Wrap the execution of a number of steps with before/after functions.

Unlike Reactor.Step.Around, this step doesn't need to run a nested Reactor instance, but instead can emit the steps directly into the parent Reactor.

The before function will be passed the following arguments:

This provides you the opportunity to modify the arguments, context and list of steps to be executed.

The successful return value should be {:ok, arguments, context, steps}. The returned arguments will be used to provide any input arguments to nested steps.

The after function will be called with a single argument; a map of the nested step results.

The successful return value should be {:ok, any} where any will be treated as the result of the group.

The MFA or 1-arity function which this step will call after successfully running the steps.

Should the emitted steps be allowed to run asynchronously?

The MFA or 3-arity function which this step will call before running any steps.

The initial steps to pass into the "before" function.

The MFA or 1-arity function which this step will call after successfully running the steps.

Should the emitted steps be allowed to run asynchronously?

Optional. Defaults to true.

The MFA or 3-arity function which this step will call before running any steps.

The initial steps to pass into the "before" function.

Hex Package Hex Preview Search HexDocs

Built using ExDoc (v0.38.3) for the Elixir programming language

**Examples:**

Example 1 (python):
```python
def no_time_travel(arguments, context, steps) do
  steps = steps
    |> Enum.filter(&(&1.name == :program_time_circuits))

  arguments = arguments
    |> Map.delete(:destination_time)

  {:ok, arguments, context, steps}
end
```

Example 2 (python):
```python
def find_current_year(results) do
  case Map.fetch(results, :time_circuits) do
    {:ok, %{present_time: present_time}} -> {:ok, present_time.year}
    _ -> {:error, "Unable to read the present time from the time circuits"}
  end
end
```

---

## Reactor.Executor.ConcurrencyTracker (reactor v0.17.0)

**URL:** https://hexdocs.pm/reactor/Reactor.Executor.ConcurrencyTracker.html

**Contents:**
- Reactor.Executor.ConcurrencyTracker (reactor v0.17.0)
- Summary
- Types
- Functions
- Types
- pool_key()
- record()
- Functions
- acquire(key, how_many \\ 1)
- allocate_pool(concurrency_limit)

Manage shared concurrency pools for multiple Reactors.

When running a Reactor you can pass the concurrency_key option, which will cause the Reactor to use the specified pool to ensure that the combined Reactors never exceed the pool's available concurrency limit.

This avoids nested Reactors spawning too many workers and thrashing the system.

The process calling allocate_pool/1 is monitored, and when it terminates it's allocation is removed. Any processes which are using that pool will not be able to allocate any new resources.

Attempt to acquire a number of concurrency allocations from the pool.

Allocate a new concurrency pool and set the maximum limit.

Returns a specification to start this module under a supervisor.

Release concurrency allocation back to the pool.

Release the concurrency pool.

Report the available and maximum concurrency for a pool.

Attempt to acquire a number of concurrency allocations from the pool.

Returns {:ok, n} where n was the number of slots that were actually allocated. It's important to note that whilst you may request 16 slots, if there is only 3 available, then this function will return {:ok, 3} and you must abide by it.

It is possible for this function to return {:ok, 0} if there is no slots available.

Allocate a new concurrency pool and set the maximum limit.

Returns a specification to start this module under a supervisor.

Release concurrency allocation back to the pool.

Release the concurrency pool.

This deletes the pool, however doesn't affect any processes currently using it. No more resources can be acquired by users of the pool key.

Report the available and maximum concurrency for a pool.

Hex Package Hex Preview Search HexDocs

Built using ExDoc (v0.38.3) for the Elixir programming language

---

## Reactor.Dsl.Switch.Match (reactor v0.17.0)

**URL:** https://hexdocs.pm/reactor/Reactor.Dsl.Switch.Match.html

**Contents:**
- Reactor.Dsl.Switch.Match (reactor v0.17.0)
- Summary
- Types
- Types
- t()

The matches? DSL entity struct.

See Reactor.switch.matches?.

Hex Package Hex Preview Search HexDocs

Built using ExDoc (v0.38.3) for the Elixir programming language

---

## Reactor.Executor.State (reactor v0.17.0)

**URL:** https://hexdocs.pm/reactor/Reactor.Executor.State.html

**Contents:**
- Reactor.Executor.State (reactor v0.17.0)
- Summary
- Types
- Types
- t()

Contains the reactor execution state.

This is run-time only information.

Hex Package Hex Preview Search HexDocs

Built using ExDoc (v0.38.3) for the Elixir programming language

---

## How to Debug Reactor Workflows

**URL:** https://hexdocs.pm/reactor/debugging-workflows.html

**Contents:**
- How to Debug Reactor Workflows
- Problem
- Solution Overview
- Prerequisites
- Debugging Strategies
  - 1. Using Debug Steps
    - Basic Debug Step
    - Debug Output
  - 2. Synchronous Execution for Debugging
  - 3. Visual Workflow Debugging

Your reactor isn't behaving as expected and you need effective techniques to troubleshoot and debug workflow execution, identify bottlenecks, and understand what's happening during execution.

This guide shows you debugging techniques, tools, and patterns for identifying and fixing issues in your reactors using Reactor's built-in debugging features, telemetry, visualization tools, and error analysis.

The simplest way to understand what's happening in your reactor is to add debug steps that log intermediate values.

Debug steps log comprehensive information about arguments, context, and options:

When debugging, disable async execution to get predictable, deterministic behavior:

Generate visual diagrams to understand reactor structure and flow:

Use the built-in Mix task to generate visual diagrams:

Or generate diagrams programmatically:

The generated diagram shows:

Set up telemetry handlers to monitor reactor execution in real-time:

Understand and debug errors using Reactor's structured error system:

Identify performance bottlenecks in your workflows:

Use IEx for interactive debugging sessions:

This comprehensive debugging approach helps you quickly identify and resolve issues in your reactor workflows.

Hex Package Hex Preview (current file) Search HexDocs

Built using ExDoc (v0.38.3) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
defmodule UserProcessingReactor do
  use Reactor

  input :user_data

  step :validate_user, MyApp.Steps.ValidateUser do
    argument :user_data, input(:user_data)
  end

  debug :check_validation do
    argument :user, result(:validate_user)
    level :info
  end

  step :create_user, MyApp.Steps.CreateUser do
    argument :user, result(:validate_user)
  end

  debug :check_creation do
    argument :result, result(:create_user)
  end
end
```

Example 2 (unknown):
```unknown
[info] # Debug information for step `:check_validation`.

## Arguments
%{
  user: %{
    email: "user@example.com",
    name: "John Doe",
    validated: true
  }
}

## Context
%{
  concurrency_key: #Reference<0.123.456.789>,
  current_step: :check_validation
}

## Options
[]
```

Example 3 (unknown):
```unknown
defmodule DebuggingTest do
  test "debug complex workflow" do
    inputs = %{user_data: sample_data()}
    
    result = Reactor.run(UserProcessingReactor, inputs, async?: false)
    
    case result do
      {:ok, user} -> 
        IO.puts("Success: #{inspect(user)}")
      {:error, errors} -> 
        IO.puts("Failed: #{inspect(errors)}")
    end
  end
end
```

Example 4 (unknown):
```unknown
# Generate basic diagram
mix reactor.mermaid UserProcessingReactor

# Include descriptions and expand sub-reactors
mix reactor.mermaid UserProcessingReactor --describe --expand

# Save to specific file
mix reactor.mermaid UserProcessingReactor --output debug_flow.mmd

# Display diagram for copy-pasting into Mermaid Live
mix reactor.mermaid UserProcessingReactor --format copy

# Generate direct Mermaid Live Editor URL
mix reactor.mermaid UserProcessingReactor --format url
```

---

## Building Complex Workflows with Composition

**URL:** https://hexdocs.pm/reactor/04-composition.html

**Contents:**
- Building Complex Workflows with Composition
- What you'll build
- You'll learn
- Prerequisites
- Step 1: Set up the project
- Step 2: Understanding Reactor composition
- Step 3: Create simple domain reactors
- Step 4: Create the master orchestrator
- Step 5: Test the composition
- What you learned

In this tutorial, you'll learn how to build large, maintainable workflows by composing smaller reactors together. This is essential for managing complexity in real-world applications.

A multi-stage e-commerce order processing system that:

If you don't have a project from the previous tutorials:

Reactor composition allows you to:

Break down complexity - Instead of one massive reactor, create focused sub-reactors:

Enable reusability - Sub-reactors can be used in multiple contexts:

Improve testability - Test each sub-reactor independently.

Let's start by building focused reactors for each domain. Create lib/user_validation_reactor.ex:

Create lib/inventory_reactor.ex:

Create lib/payment_reactor.ex:

Now create the main reactor that composes all sub-reactors. Create lib/order_processing_reactor.ex:

Let's test our composed reactor:

You now understand Reactor composition:

Now that you understand composition, you're ready for advanced patterns:

Sub-reactor outputs don't match expectations: Use clear interface contracts and validate inputs/outputs in tests

Error handling doesn't work across boundaries: Ensure compensation and undo are implemented in the appropriate reactor layer

Composed reactors are hard to debug: Test each sub-reactor individually and use descriptive logging

Happy building modular workflows! 🧩

Hex Package Hex Preview (current file) Search HexDocs

Built using ExDoc (v0.38.3) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
mix igniter.new reactor_tutorial --install reactor
cd reactor_tutorial
```

Example 2 (unknown):
```unknown
# Use composition:
defmodule OrderProcessor do
  use Reactor
  
  compose :user_management, UserManagementReactor
  compose :inventory_check, InventoryReactor  
  compose :payment_processing, PaymentReactor
  compose :fulfillment, FulfillmentReactor
end
```

Example 3 (unknown):
```unknown
compose :validate_buyer, UserManagementReactor
compose :validate_seller, UserManagementReactor
```

Example 4 (unknown):
```unknown
defmodule UserValidationReactor do
  use Reactor

  input :user_id

  step :fetch_user do
    argument :user_id, input(:user_id)
    
    run fn %{user_id: user_id}, _context ->
      {:ok, %{
        id: user_id,
        name: "User #{user_id}",
        email: "user#{user_id}@example.com",
        active: true
      }}
    end
  end

  step :validate_user do
    argument :user, result(:fetch_user)
    
    run fn %{user: user}, _context ->
      if user.active do
        {:ok, user}
      else
        {:error, "User is not active"}
      end
    end
  end

  return :validate_user
end
```

---

## Reactor.Dsl.Switch (reactor v0.17.0)

**URL:** https://hexdocs.pm/reactor/Reactor.Dsl.Switch.html

**Contents:**
- Reactor.Dsl.Switch (reactor v0.17.0)
- Summary
- Types
- Types
- t()

The switch DSL entity struct.

Hex Package Hex Preview Search HexDocs

Built using ExDoc (v0.38.3) for the Elixir programming language

---

## Error Handling with Compensation and Undo

**URL:** https://hexdocs.pm/reactor/02-error-handling.html

**Contents:**
- Error Handling with Compensation and Undo
- What you'll build
- You'll learn
- Error Handling Flow
- Prerequisites
- Step 1: Set up the project
- Step 2: Understanding Reactor error handling
  - Compensation
  - Undo
- Step 3: Create services with realistic error handling

In this tutorial, you'll learn how to make your reactors resilient by adding proper error handling, retry logic, and rollback capabilities.

You'll enhance the user registration workflow from the first tutorial to handle:

Here's how Reactor handles errors through compensation and undo:

If you don't have the project from the previous tutorial, create it:

Reactor provides two main mechanisms for error handling:

When: A step fails during executionPurpose: Decide whether to retry, continue, or fail the reactorReturn values:

When: A step succeeded but a later step failedPurpose: Roll back the successful step's changesReturn values:

Let's create services that demonstrate different types of failures. Create lib/email_service.ex:

Now create lib/notification_service.ex for internal admin notifications:

Create lib/database_service.ex:

Now create lib/resilient_user_registration.ex:

Let's test our reactor in IEx:

When you run the tests, you'll see different behaviours based on the email content:

Successful execution (alice@example.com): All steps succeed, user is created, welcome email is sent, and admin notification is sent.

Validation failures: Invalid input (short passwords, malformed emails) fails immediately without retries - these are caught by the validation steps before reaching the email service.

When steps retry immediately, they might overwhelm failing external services. Reactor supports backoff - adding delays between retry attempts. Importantly, the executor doesn't block during backoff - it continues processing other ready steps while the failed step waits to be rescheduled.

Backoff delays are minimum delays - the actual retry time will be at least the specified delay, but may be longer because the executor prioritises processing other ready steps before checking for expired backoffs. Let's enhance our email service with intelligent retry delays.

Here's how backoff integrates with Reactor's retry flow:

Update the EmailService to include backoff logic:

You can also define backoff logic directly in DSL steps when using anonymous functions for run, compensate, etc. (The DSL backoff option is not available when using implementation modules):

Test the improved retry behaviour:

Exponential backoff: Doubles delay each retry (1s, 2s, 4s, 8s...) - good for network issues and service overload.

Fixed backoff: Same delay each time - good for rate limiting where you know the reset interval.

No backoff: Use :now for errors that don't benefit from

*[Content truncated]*

**Examples:**

Example 1 (unknown):
```unknown
sequenceDiagram
    participant Reactor
    participant StepA
    participant StepB
    participant StepC
    
    Reactor->>StepA: run()
    StepA-->>Reactor: {:ok, result}
    
    Reactor->>StepB: run()
    StepB-->>Reactor: {:ok, result}
    
    Reactor->>StepC: run()
    StepC-->>Reactor: {:error, reason}
    
    Note over Reactor: Begin compensation
    Reactor->>StepB: compensate()
    StepB-->>Reactor: {:continue, context}
    
    Reactor->>StepA: compensate()
    StepA-->>Reactor: {:continue, context}
    
    Reactor-->>Reactor: Return compensated error
```

Example 2 (unknown):
```unknown
mix igniter.new reactor_tutorial --install reactor
cd reactor_tutorial
```

Example 3 (python):
```python
defmodule EmailService do
  use Reactor.Step

  # Simulate realistic email service failures based on email content
  @impl true
  def run(arguments, _context, _options) do
    email = arguments.email
    
    cond do
      # Simulate network timeout (temporary failure)
      String.contains?(email, "timeout") ->
        {:error, %{type: :network_timeout, message: "Network timeout - please retry"}}
      
      # Simulate rate limiting (temporary failure)  
      String.contains?(email, "ratelimit") ->
        {:error, %{type: :rate_limit, message: "Rate limit exceeded - please retry"}}
      

...
```

Example 4 (python):
```python
defmodule NotificationService do
  use Reactor.Step

  @impl true
  def run(arguments, _context, _options) do
    user = arguments.user
    
    # Admin notifications always succeed (internal system)
    {:ok, %{
      notification_id: "notif_#{:rand.uniform(10000)}",
      sent_at: DateTime.utc_now(),
      message: "New user registered: #{user.email}"
    }}
  end

  @impl true
  def undo(result, _arguments, _context, _options) do
    IO.puts("🔔 Canceling admin notification #{result.notification_id}")
    :ok
  end
end
```

---

## Reactor.Middleware behaviour (reactor v0.17.0)

**URL:** https://hexdocs.pm/reactor/Reactor.Middleware.html

**Contents:**
- Reactor.Middleware behaviour (reactor v0.17.0)
- Summary
- Types
- Callbacks
- Types
- context()
- error_or_errors()
- result()
- step_event()
- t()

The Middleware behaviour.

By implementing this behaviour you can modify the internal state of the Reactor during startup, execution and shutdown.

Middlewares can be added to the reactor either with the middlewares DSL section or by the add_middleware/2, etc, functions in Reactor.Builder.

All callbacks in this behaviour are optional so you can define only the parts you need for your feature.

The complete callback will be called with the successful result of the Reactor.

The error callback will be called the final error value(s) of the Reactor.

Receive events about the execution of the Reactor.

Called before starting an asynchronous step in order to retrieve any context information that needs to be passed into the new process.

The halt callback will be called with the Reactor context when halting.

The init callback will be called with the Reactor context when starting up.

Called inside a new asynchronous step in order to set context information into the new process.

The complete callback will be called with the successful result of the Reactor.

This gives you the opportunity to modify the return value or to perform clean up of any non-reactor-managed resources (eg notifications).

Note that these callbacks are called in an arbitrary order meaning that the result value passed may have already been altered by another callback.

If any callback returns an error then any remaining callbacks will not be called.

The error callback will be called the final error value(s) of the Reactor.

This gives you the opportunity to modify the return value or to perform clean up of any non-reactor-managed resources (eg notifications).

Note that these callbacks are called in an arbitrary order meaning that the error value passed may have already been altered by another callback.

Here a return value of :ok will continue calls to other callbacks without modifying the error value.

Receive events about the execution of the Reactor.

This callback will block the Reactor, so it's encouraged that you do anything expensive in another process.

Called before starting an asynchronous step in order to retrieve any context information that needs to be passed into the new process.

This is most likely used by tracers to copy span information from the parent process to the child process.

The halt callback will be called with the Reactor context when halting.

This allows you to clean up any non-reactor-managed resources or modify the context for later re-use by a future init

*[Content truncated]*

---

## Reactor.Step behaviour (reactor v0.17.0)

**URL:** https://hexdocs.pm/reactor/Reactor.Step.html

**Contents:**
- Reactor.Step behaviour (reactor v0.17.0)
- Summary
- Types
- Callbacks
- Functions
- Types
- arguments()
- backoff_result()
- capability()
- compensate_result()

The Step behaviour and struct.

Implement this behaviour to make steps for your Reactor.

Possible valid return values for the backoff/4 callback.

Optional capabilities which may be implemented by the step module.

Possible valid return values for the compensate/4 callback.

Possible valid return values for the run/3 callback.

Possible valid return values for the undo/4 callback.

Detect if the step can be run asynchronously at runtime.

Generate a backoff time (in milliseconds) before the step is retried.

Detect the capabilities of the step at runtime.

Compensate for the failure of the step.

Extract nested steps from the step's options.

Undo a previously successful execution of the step.

Is the step able to be run asynchronously?

Generate the backoff for a step

Find out of a step has a capability.

Extract nested steps from a step.

Possible valid return values for the backoff/4 callback.

Optional capabilities which may be implemented by the step module.

This allows us to optimise out calls steps which cannot be undone, etc.

Possible valid return values for the compensate/4 callback.

Possible valid return values for the run/3 callback.

Possible valid return values for the undo/4 callback.

Detect if the step can be run asynchronously at runtime.

This callback is automatically defined by use Reactor.Step however you're free to override it if you need a specific behaviour.

This callback is called when Reactor is deciding whether to run a step asynchronously.

The default implementation of this callback checks returns the the value of the steps's async? key if it is boolean, or calls it with the steps's options if it is a function.

Generate a backoff time (in milliseconds) before the step is retried.

This callback is automatically defined by use Reactor.Step however you should override it if you wish to perform any step backoff on retry.

This callback is called when Reactor is scheduling a retry. If a positive integer is returned then Reactor will wait at least as many milliseconds before calling the step's run/3 callback again. If :now is returned then the step is available to the next scheduler run.

The default implementation returns :now, meaning that the step is retried immediately without any backoff.

Detect the capabilities of the step at runtime.

This callback is automatically defined by use Reactor.Step however you're free to override it if you need specific behaviour.

Whenever Reactor would like to either undo a change made by

*[Content truncated]*

---

## Reactor.Template.Value (reactor v0.17.0)

**URL:** https://hexdocs.pm/reactor/Reactor.Template.Value.html

**Contents:**
- Reactor.Template.Value (reactor v0.17.0)
- Summary
- Types
- Types
- t()

A statically value template.

Hex Package Hex Preview Search HexDocs

Built using ExDoc (v0.38.3) for the Elixir programming language

---

## Reactor

**URL:** https://hexdocs.pm/reactor/dsl-reactor.html

**Contents:**
- Reactor
- reactor
  - Nested DSLs
  - Options
  - reactor.middlewares
  - Nested DSLs
  - reactor.middlewares.middleware
  - Arguments
  - Options
  - Introspection

The top-level reactor DSL

Middleware to be added to the Reactor

Name a middleware to be added to the Reactor.

Target: Reactor.Dsl.Middleware

Wrap a function around a group of steps.

Specifies an argument to a Reactor step.

Each argument is a value which is either the result of another step, or an input value.

Individual arguments can be transformed with an arbitrary function before being passed to any steps.

Target: Reactor.Dsl.Argument

Wait for the named step to complete before allowing this one to start.

Desugars to argument :_, result(step_to_wait_for)

Target: Reactor.Dsl.WaitFor

Only execute the surrounding step if the predicate function returns true.

This is a simple version of guard which provides more flexibility at the cost of complexity.

Target: Reactor.Dsl.Where

Provides a flexible method for conditionally executing a step, or replacing it's result.

Expects a two arity function which takes the step's arguments and context and returns one of the following:

Target: Reactor.Dsl.Guard

Target: Reactor.Dsl.Around

A Reactor step which simply collects and returns it's arguments.

Arguments can optionally be transformed before returning.

Specifies an argument to a Reactor step.

Each argument is a value which is either the result of another step, or an input value.

Individual arguments can be transformed with an arbitrary function before being passed to any steps.

Target: Reactor.Dsl.Argument

Wait for the named step to complete before allowing this one to start.

Desugars to argument :_, result(step_to_wait_for)

Target: Reactor.Dsl.WaitFor

Only execute the surrounding step if the predicate function returns true.

This is a simple version of guard which provides more flexibility at the cost of complexity.

Target: Reactor.Dsl.Where

Provides a flexible method for conditionally executing a step, or replacing it's result.

Expects a two arity function which takes the step's arguments and context and returns one of the following:

Target: Reactor.Dsl.Guard

Target: Reactor.Dsl.Collect

Compose another Reactor into this one.

Allows place another Reactor into this one as if it were a single step.

compose :create_user, UserReactor do argument :name, input(:user_name) argument :email, input(:user_email) allow_async? false end

Specifies an argument to a Reactor step.

Each argument is a value which is either the result of another step, or an input value.

Individual arguments can be transformed with an arbitrary function before being pa

*[Content truncated]*

**Examples:**

Example 1 (unknown):
```unknown
middleware module
```

Example 2 (unknown):
```unknown
around name, fun \\ nil
```

Example 3 (unknown):
```unknown
argument name, source \\ nil
```

Example 4 (unknown):
```unknown
argument :name, input(:name)
```

---

## Building Async Workflows

**URL:** https://hexdocs.pm/reactor/03-async-workflows.html

**Contents:**
- Building Async Workflows
- What you'll build
- You'll learn
- Prerequisites
- Step 1: Set up the project
- Step 2: Understanding Reactor's concurrency model
  - Async vs Sync execution
- Step 3: Create simple data operations
- Step 4: Build a concurrent data reactor
- Step 5: Test the concurrent execution

In this tutorial, you'll learn how to build efficient concurrent workflows that take advantage of Reactor's dependency resolution and async execution capabilities.

A data processing pipeline that:

If you don't have a project from the previous tutorials:

Reactor runs steps asynchronously by default:

Let's create some data operations that will run concurrently. Create lib/data_sources.ex:

Now let's build a reactor that fetches data concurrently. Create lib/async_user_data_reactor.ex:

Let's test our reactor to see the difference between concurrent and sequential execution:

The reactor completes in about 300ms instead of 650ms (200+150+300) because:

Compare with synchronous execution:

This takes the full 650ms because each step runs sequentially.

You can control which steps run synchronously when needed:

You now understand Reactor's concurrency model:

Now that you understand concurrency, you're ready for advanced workflow patterns:

Steps aren't running in parallel: Check for hidden dependencies in arguments - each argument creates a dependency

For comprehensive performance and concurrency troubleshooting, see Performance Optimization.

Happy building concurrent workflows! ⚡

Hex Package Hex Preview (current file) Search HexDocs

Built using ExDoc (v0.38.3) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
mix igniter.new reactor_tutorial --install reactor
cd reactor_tutorial
```

Example 2 (unknown):
```unknown
# Async (default) - runs in a separate task
step :fetch_data do
  async? true  # This is the default
  run &fetch_from_api/1
end

# Sync - runs in the main process
step :critical_operation do
  async? false  # Forces synchronous execution
  run &update_database/1
end
```

Example 3 (python):
```python
defmodule DataSources do
  def fetch_user_profile(user_id) do
    Process.sleep(200)
    
    {:ok, %{
      id: user_id,
      name: "User #{user_id}",
      email: "user#{user_id}@example.com"
    }}
  end

  def fetch_user_preferences(user_id) do
    Process.sleep(150)
    
    {:ok, %{
      user_id: user_id,
      theme: "light",
      language: "en"
    }}
  end

  def fetch_user_activity(user_id) do
    Process.sleep(300)
    
    {:ok, %{
      user_id: user_id,
      last_login: DateTime.utc_now(),
      login_count: 42
    }}
  end
end
```

Example 4 (unknown):
```unknown
defmodule AsyncUserDataReactor do
  use Reactor

  input :user_id

  # These steps have no dependencies on each other, so they run in parallel
  step :fetch_profile do
    argument :user_id, input(:user_id)
    run fn %{user_id: user_id}, _context ->
      DataSources.fetch_user_profile(user_id)
    end
  end

  step :fetch_preferences do
    argument :user_id, input(:user_id)  
    run fn %{user_id: user_id}, _context ->
      DataSources.fetch_user_preferences(user_id)
    end
  end

  step :fetch_activity do
    argument :user_id, input(:user_id)
    run fn %{user_id: user_id}, _context ->

...
```

---

## Reactor.Guard.Build protocol (reactor v0.17.0)

**URL:** https://hexdocs.pm/reactor/Reactor.Guard.Build.html

**Contents:**
- Reactor.Guard.Build protocol (reactor v0.17.0)
- Summary
- Types
- Functions
- Types
- t()
- Functions
- build(input)

A protocol which can be used to convert something into a guard.

All the types that implement this protocol.

Convert the input into one or more guards.

All the types that implement this protocol.

Convert the input into one or more guards.

Hex Package Hex Preview Search HexDocs

Built using ExDoc (v0.38.3) for the Elixir programming language

---

## Your First Reactor

**URL:** https://hexdocs.pm/reactor/01-getting-started.html

**Contents:**
- Your First Reactor
- What you'll build
- You'll learn
- Workflow Overview
- Prerequisites
- Step 1: Create a new project with Reactor
- Step 2: Your first reactor
- Step 3: Understanding your reactor
- Step 4: Run your reactor
- Step 5: Execution order

Welcome to Reactor! In this tutorial, you'll build your first reactor step by step, learning the core concepts through hands-on practice.

A user registration workflow that validates email, hashes passwords, and creates user records.

Here's what we'll build - a simple user registration workflow:

Let's start by creating a new project with Reactor already installed and configured:

This creates a new Elixir project and automatically:

Create a new file lib/user_registration.ex and define your first reactor:

Before running it, let's understand what you've built:

Inputs define the parameters your reactor accepts, like function arguments.

Steps are units of work with three key parts:

Notice how :create_user depends on results from both :validate_email and :hash_password. This creates an execution order where the first two steps can run concurrently, then :create_user runs after both complete.

Return specifies what value the reactor should return when everything succeeds.

Let's test your reactor! Start an IEx session:

Now run your reactor:

Try with invalid data:

Here's something important: Reactor doesn't execute steps in the order you wrote them. Instead, it builds a dependency graph and runs steps as soon as their dependencies are available.

This automatic parallelization is one of Reactor's key features - you get concurrent execution without having to think about it!

You've built your first reactor and learned the fundamentals:

Now that you understand the basics, you're ready to learn more advanced concepts:

Or explore specific use cases in our How-to Guides section.

For quick syntax reference, see the Reactor Cheatsheet.

Happy building with Reactor! 🚀

Hex Package Hex Preview (current file) Search HexDocs

Built using ExDoc (v0.38.3) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
graph TB
    A[input: email] --> B[validate_email]
    A2[input: password] --> C[hash_password]
    B --> D[create_user]
    C --> D
    D --> E[Registration Complete]
    
    style A fill:#e1f5fe
    style A2 fill:#e1f5fe
    style E fill:#c8e6c9
    style D fill:#fff3e0
```

Example 2 (unknown):
```unknown
mix igniter.new reactor_tutorial --install reactor
cd reactor_tutorial
```

Example 3 (unknown):
```unknown
defmodule UserRegistration do
  use Reactor

  # Define what inputs this reactor expects
  input :email
  input :password

  # Define a simple step that validates email
  step :validate_email do
    argument :email, input(:email)
    
    run fn %{email: email}, _context ->
      if String.contains?(email, "@") do
        {:ok, email}
      else
        {:error, "Email must contain @"}
      end
    end
  end

  # Define a step that hashes the password
  step :hash_password do
    argument :password, input(:password)
    
    run fn %{password: password}, _context ->
      hashed = :crypto.has
...
```

Example 4 (unknown):
```unknown
# Test with valid data
{:ok, user} = Reactor.run(UserRegistration, %{
  email: "alice@example.com",
  password: "secret123"
})

IO.inspect(user)
# Should output something like:
# %{
#   id: 1234,
#   email: "alice@example.com", 
#   password_hash: "2BB80D537B1DA3E38BD30361AA855686BDE0EACD7162FEF6A25FE97BF527A25B",
#   created_at: ~U[2024-01-15 10:30:00.123456Z]
# }
```

---

## How to Orchestrate HTTP APIs with Reactor

**URL:** https://hexdocs.pm/reactor/api-orchestration.html

**Contents:**
- How to Orchestrate HTTP APIs with Reactor
- Problem
- Solution Overview
- Prerequisites
- Setup
- HTTP Client Integration with Reactor
- Authentication Management
- API Versioning
- Testing API Integration
- Related Guides

You need to integrate with multiple HTTP APIs in production workflows, handling authentication, rate limits, circuit breakers, API versioning, and service discovery patterns.

This guide shows you how to build production-ready API orchestration using reactor_req, covering real-world concerns like authentication management, circuit breakers, rate limiting, and service resilience patterns.

Add reactor_req to your dependencies:

The reactor_req package provides direct integration between Reactor and the Req HTTP client. Create lib/api_client.ex:

Handle API authentication and token refresh patterns:

Handle different API versions by composing version-specific reactors:

Test your API orchestration patterns:

Hex Package Hex Preview (current file) Search HexDocs

Built using ExDoc (v0.38.3) for the Elixir programming language

**Examples:**

Example 1 (python):
```python
# mix.exs
def deps do
  [
    {:reactor, "~> 0.15"},
    {:reactor_req, "~> 0.1"},
    {:req, "~> 0.5"}
  ]
end
```

Example 2 (javascript):
```javascript
defmodule ApiClient do
  use Reactor

  input :base_url
  input :user_id

  req_new :setup_client do
    base_url input(:base_url)
    headers value([{"user-agent", "MyApp/1.0"}])
    retry value(:transient)
    retry_delay value(fn attempt -> 200 * attempt end)
  end

  template :build_profile_url do
    argument :user_id, input(:user_id)
    template "/users/<%= @user_id %>"
  end

  template :build_preferences_url do
    argument :user_id, input(:user_id)
    template "/users/<%= @user_id %>/preferences"
  end

  req_get :fetch_profile do
    request result(:setup_client)
    url result(:bu
...
```

Example 3 (unknown):
```unknown
defmodule AuthenticatedApiClient do
  use Reactor

  input :client_id
  input :client_secret
  input :api_endpoint

  step :build_oauth_payload do
    argument :client_id, input(:client_id)
    argument :client_secret, input(:client_secret)
    
    run fn %{client_id: client_id, client_secret: client_secret}, _context ->
      payload = %{
        grant_type: "client_credentials",
        client_id: client_id,
        client_secret: client_secret
      }
      {:ok, payload}
    end
  end

  req_post :get_auth_token do
    url value("https://auth.example.com/oauth/token")
    json result(:bui
...
```

Example 4 (unknown):
```unknown
defmodule UserApiV1 do
  use Reactor

  input :user_id

  req_new :client do
    base_url value("https://api.example.com/v1")
  end

  template :build_user_path do
    argument :user_id, input(:user_id)
    template "/users/<%= @user_id %>"
  end

  req_get :fetch_user do
    request result(:client)
    url result(:build_user_path)
  end

  step :normalize_response do
    argument :response, result(:fetch_user, [:body])
    
    run fn %{response: resp}, _context ->
      normalized = %{
        id: resp["user_id"],
        name: resp["full_name"],
        email: resp["email_address"]
      }

...
```

---

## Reactor.Dsl.WaitFor (reactor v0.17.0)

**URL:** https://hexdocs.pm/reactor/Reactor.Dsl.WaitFor.html

**Contents:**
- Reactor.Dsl.WaitFor (reactor v0.17.0)
- Summary
- Types
- Types
- t()

The struct used to store wait_for DSL entities.

See Reactor.step.wait_for.

Hex Package Hex Preview Search HexDocs

Built using ExDoc (v0.38.3) for the Elixir programming language

---

## Reactor.Template (reactor v0.17.0)

**URL:** https://hexdocs.pm/reactor/Reactor.Template.html

**Contents:**
- Reactor.Template (reactor v0.17.0)
- Summary
- Types
- Functions
- Types
- t()
- Functions
- is_element_template(template)
- is_input_template(template)
- is_result_template(template)

Templates used to refer to some sort of computed value.

A guard for element templates

A guard for input templates

A guard for result templates

A guard to detect all template types

A guard for value templates

The type for use in option schemas

A guard for element templates

A guard for input templates

A guard for result templates

A guard to detect all template types

A guard for value templates

The type for use in option schemas

Hex Package Hex Preview Search HexDocs

Built using ExDoc (v0.38.3) for the Elixir programming language

---

## Reactor.Info (reactor v0.17.0)

**URL:** https://hexdocs.pm/reactor/Reactor.Info.html

**Contents:**
- Reactor.Info (reactor v0.17.0)
- Summary
- Functions
- Functions
- reactor(dsl_or_extended)
- reactor_description(dsl_or_extended)
- reactor_description!(dsl_or_extended)
- reactor_middlewares(dsl_or_extended)
- reactor_options(dsl_or_extended)
- reactor_return(dsl_or_extended)

Introspection for the Reactor DSL.

An optional description for the Reactor.

An optional description for the Reactor.

reactor.middlewares DSL entities

Specify which step result to return upon completion.

Specify which step result to return upon completion.

Convert a reactor DSL module into a reactor struct.

Raising version of to_struct/1.

An optional description for the Reactor.

An optional description for the Reactor.

reactor.middlewares DSL entities

Returns a map containing the and any configured or default values.

Specify which step result to return upon completion.

Specify which step result to return upon completion.

Convert a reactor DSL module into a reactor struct.

Raising version of to_struct/1.

Hex Package Hex Preview Search HexDocs

Built using ExDoc (v0.38.3) for the Elixir programming language

---

## Reactor.Dsl.Flunk (reactor v0.17.0)

**URL:** https://hexdocs.pm/reactor/Reactor.Dsl.Flunk.html

**Contents:**
- Reactor.Dsl.Flunk (reactor v0.17.0)
- Summary
- Types
- Types
- t()

The struct used to store flunk DSL entities.

Hex Package Hex Preview Search HexDocs

Built using ExDoc (v0.38.3) for the Elixir programming language

---

## Reactor.Executor (reactor v0.17.0)

**URL:** https://hexdocs.pm/reactor/Reactor.Executor.html

**Contents:**
- Reactor.Executor (reactor v0.17.0)
- Summary
- Functions
- Functions
- run(reactor, inputs \\ %{}, context \\ %{}, options \\ [])
- undo(reactor, context, options)

The Reactor executor.

The executor handles the main loop of running a Reactor.

The algorithm is somewhat confusing, so here it is in pseudocode:

Whenever a step is run, whether run synchronously or asynchronously, the following happens:

Undo a previously successful Reactor.

Provided a Reactor which has been planned and the correct inputs, then run the Reactor until completion, halting or failure.

You probably shouldn't call this directly, but use Reactor.run/4 instead.

Undo a previously successful Reactor.

Hex Package Hex Preview Search HexDocs

Built using ExDoc (v0.38.3) for the Elixir programming language

---

## Reactor.Dsl.Map (reactor v0.17.0)

**URL:** https://hexdocs.pm/reactor/Reactor.Dsl.Map.html

**Contents:**
- Reactor.Dsl.Map (reactor v0.17.0)
- Summary
- Types
- Types
- t()

The map DSL entity struct.

Hex Package Hex Preview Search HexDocs

Built using ExDoc (v0.38.3) for the Elixir programming language

---

## Reactor.Builder (reactor v0.17.0)

**URL:** https://hexdocs.pm/reactor/Reactor.Builder.html

**Contents:**
- Reactor.Builder (reactor v0.17.0)
- Example
- Summary
- Types
- Functions
- Types
- arguments_transform()
- async?()
- context()
- description()

Build a new Reactor programmatically.

You don't have to use the Reactor DSL to create a Reactor. The functions in this module allow you to define a Reactor programmatically. This is especially useful if you need to create a reactor dynamically (maybe based on a UI such as React Flow).

Optionally transform all the arguments into new arguments

Should the step be run asynchronously?

Optional context which will be merged with the reactor context when calling this step.

An optional step description

How many times is the step allowed to retry?

Add a named input to the Reactor.

Raising version of add_input/2..3.

Add a middleware to the Reactor.

Raising version of add_middleware/2.

Add a step to the Reactor.

Raising version of add_step/3..5.

Compose another Reactor inside this one.

Raising version of compose/4.

Ensure that a middleware is present on the Reactor.

Raising version of ensure_middleware/2.

Build a new, empty Reactor.

Build a step which can be added to a reactor at runtime.

Raising version of new_step/2..4.

Recurse a Reactor until an exit condition is met or maximum iterations are reached.

Raising version of recurse/4.

Specify the return value of the Reactor.

Raising version of return/2.

Optionally transform all the arguments into new arguments

Should the step be run asynchronously?

Optional context which will be merged with the reactor context when calling this step.

An optional step description

How many times is the step allowed to retry?

Add a named input to the Reactor.

This both places the input in the Reactor for later input validation and adds steps to the Reactor which will emit and (possibly) transform the input.

Raising version of add_input/2..3.

Add a middleware to the Reactor.

Returns an error if the middleware is already present on the Reactor.

Raising version of add_middleware/2.

Add a step to the Reactor.

Add a new step to the Reactor. Rewrites input arguments to use the result of the input steps and injects transformation steps as required.

Raising version of add_step/3..5.

Compose another Reactor inside this one.

Whenever possible this function will extract the steps from inner Reactor and place them inside the parent Reactor. In order to achieve this the composer will rename the steps to ensure that there are no conflicts.

If you're attempting to create a recursive Reactor (ie compose a Reactor within itself) then this will be detected and runtime composition will be used instead. See Reactor.Ste

*[Content truncated]*

**Examples:**

Example 1 (unknown):
```unknown
reactor = Builder.new()
{:ok, reactor} = Builder.add_input(reactor, :name)
argument = Argument.from_input(:name)
{:ok, reactor} = Builder.add_step(reactor, :greet, [argument])
{:ok, reactor} = Builder.return(reactor, :greet)
```

---

## Reactor Cheatsheet

**URL:** https://hexdocs.pm/reactor/reactor-cheatsheet.html

**Contents:**
- Reactor Cheatsheet
- Basic Reactor Definition
  - Simple Reactor
  - Running Reactors
- Step Types
  - Basic Steps
  - Debug Steps
  - Map Steps
  - Compose Steps
- Advanced Step Types

Reactor is a dynamic, concurrent, dependency resolving saga orchestrator for Elixir.

Hex Package Hex Preview (current file) Search HexDocs

Built using ExDoc (v0.38.3) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
defmodule MyReactor do
  use Reactor

  input :email
  input :password

  step :hash_password do
    argument :password, input(:password)
    run &Bcrypt.hash_pwd_salt/1
  end

  step :create_user, MyApp.CreateUser do
    argument :email, input(:email)
    argument :password_hash, result(:hash_password)
  end

  return :create_user
end
```

Example 2 (unknown):
```unknown
# Basic execution
{:ok, result} = Reactor.run(MyReactor, 
  email: "user@example.com", 
  password: "secret"
)

# With context and options
{:ok, result} = Reactor.run(MyReactor, 
  inputs, 
  %{current_user: user},
  async?: false,
  max_concurrency: 10
)

# Halting and resuming
{:halted, state} = Reactor.run(MyReactor, inputs)
{:ok, result} = Reactor.run(state, %{}, %{})
```

Example 3 (unknown):
```unknown
# Anonymous function
step :transform do
  argument :data, input(:raw_data)
  run fn %{data: data}, _context ->
    {:ok, String.upcase(data)}
  end
end

# Module implementation
step :create_user, MyApp.Steps.CreateUser do
  argument :email, result(:validate_email)
  argument :data, input(:user_data)
end

# Sync/async control
step :critical_operation do
  async? false
  run &important_work/1
end
```

Example 4 (unknown):
```unknown
debug :log_user do
  argument :user, result(:create_user)
  argument :message, value("User created")
end
```

---

## Reactor.Template.Input (reactor v0.17.0)

**URL:** https://hexdocs.pm/reactor/Reactor.Template.Input.html

**Contents:**
- Reactor.Template.Input (reactor v0.17.0)
- Summary
- Types
- Types
- t()

Hex Package Hex Preview Search HexDocs

Built using ExDoc (v0.38.3) for the Elixir programming language

---

## Core Reactor Concepts

**URL:** https://hexdocs.pm/reactor/concepts.html

**Contents:**
- Core Reactor Concepts
- Sagas and Compensation Patterns
  - What is the Saga Pattern?
  - How Compensation Works
- Directed Acyclic Graphs (DAGs)
  - Dependency Graph Construction
  - Execution Order Determination
  - Cycle Detection
- Dependency Resolution
  - Argument Types

This guide explains the fundamental concepts that make Reactor work, providing deep insight into how the framework approaches workflow orchestration, error handling, and concurrent execution.

The Saga pattern provides transaction-like semantics across multiple distinct resources without requiring distributed transactions. Instead of traditional ACID properties, sagas use compensation to handle failures.

In Reactor, each step can optionally implement compensation logic that defines how to handle failures specific to that step's operation:

When a step fails, Reactor automatically calls its compensate/4 callback if it exists. The compensation function can return:

This approach gives each step control over how its failures are handled, enabling sophisticated error recovery strategies.

Reactor builds a directed acyclic graph where:

Dependencies are created automatically when step arguments reference results from other steps:

The planner uses the DAG to determine which steps can run:

This dependency-driven approach maximises concurrency while ensuring correctness.

Reactor validates that the dependency graph is acyclic during planning. Circular dependencies would create deadlocks, so they're detected and reported as errors before execution begins.

The one exception is when a step emits a new step with its own name during execution - this allows for iterative patterns where a step can retry itself or implement loops by re-emitting itself with updated context or arguments.

Reactor supports three types of step arguments:

You can access nested values from step results using subpaths:

Arguments can be transformed before being passed to steps:

During execution, Reactor resolves arguments by:

Note that argument transformations are actually extracted into separate transform steps during the planning phase and inserted into the dependency graph. This means transforms become their own steps with proper dependency tracking, rather than being applied inline during argument resolution.

Steps run asynchronously by default to maximise throughput. This means:

Reactor uses a concurrency tracker to prevent resource exhaustion:

Async steps run as supervised tasks:

Some scenarios require synchronous execution:

Reactor implements a sophisticated three-level error handling strategy:

When a step fails, its compensation function decides how to handle the failure:

When compensation can't resolve the error, Reactor undoes previously successful steps:

If undo operati

*[Content truncated]*

**Examples:**

Example 1 (unknown):
```unknown
graph TB
    subgraph "Forward Execution (Happy Path)"
        A[Step A: Reserve Inventory] --> B[Step B: Authorize Payment]
        B --> C[Step C: Create Order]
        C --> D[Step D: Send Confirmation]
        D --> Success[Transaction Complete]
    end
    
    subgraph "Compensation Chain (Error Path)"
        FailPoint[Failure Point] --> CompD[Compensate D: Cancel Confirmation]
        CompD --> CompC[Compensate C: Cancel Order]
        CompC --> CompB[Compensate B: Void Payment]
        CompB --> CompA[Compensate A: Release Inventory]
        CompA --> Compensated[Transaction Compensat
...
```

Example 2 (python):
```python
defmodule MyStep do
  use Reactor.Step

  def run(_arguments, _context, _step) do
    # Main step logic that might fail
    {:ok, result}
  end

  def compensate(reason, _arguments, _context, _step) do
    # Handle the failure - can retry, provide fallback, or continue rollback
    case reason do
      %RetryableError{} -> :retry
      %FallbackError{value: value} -> {:continue, value}
      _other -> :ok  # Continue with rollback
    end
  end
end
```

Example 3 (unknown):
```unknown
defmodule UserRegistrationReactor do
  use Reactor

  input :email
  input :password

  step :validate_email do
    argument :email, input(:email)
    run fn %{email: email}, _context ->
      # Validation logic
      {:ok, validated_email}
    end
  end

  step :hash_password do
    argument :password, input(:password)
    # This step can run concurrently with :validate_email
  end

  step :create_user do
    argument :email, result(:validate_email)     # Creates dependency edge
    argument :password, result(:hash_password)   # Creates dependency edge
    # This step waits for both validate_
...
```

Example 4 (unknown):
```unknown
step :process_user do
  argument :user_id, result(:create_user, :id)        # Extract :id field
  argument :profile, result(:create_user, [:profile, :data])  # Nested access
end
```

---

## Reactor.Template.Element (reactor v0.17.0)

**URL:** https://hexdocs.pm/reactor/Reactor.Template.Element.html

**Contents:**
- Reactor.Template.Element (reactor v0.17.0)
- Summary
- Types
- Types
- t()

The element template.

Hex Package Hex Preview Search HexDocs

Built using ExDoc (v0.38.3) for the Elixir programming language

---

## Reactor Glossary

**URL:** https://hexdocs.pm/reactor/glossary.html

**Contents:**
- Reactor Glossary
- Core Reactor Concepts
- Technical Architecture Terms
- DSL-Specific Terminology
- Error Handling Concepts
- Concurrency and Execution Terms
- Integration and Ecosystem Terms
- Performance and Scalability Terms
- Testing and Development Terms

This glossary defines key terms, concepts, and technical vocabulary used throughout Reactor documentation.

Argument - A dependency declaration in a step that specifies what data the step needs and where it comes from (inputs, results from other steps, or static values).

Argument Transformation - A function applied to an argument value before it's passed to a step, automatically extracted as separate transform steps during planning.

Compensation - Error handling mechanism where a step defines how to handle its own failures, returning :retry, :ok, {:continue, value}, or {:error, reason}.

Compose - A DSL step type that embeds another reactor as a single step, allowing hierarchical workflow composition.

Context - Runtime execution environment shared across steps, containing user data, step metadata, retry information, and concurrency details.

Dependency Graph - A directed acyclic graph (DAG) where vertices represent steps and edges represent dependencies, used to determine execution order.

DSL (Domain Specific Language) - Declarative syntax built with Spark for defining reactors with inputs, steps, and their relationships.

Dynamic Step Creation - The ability for steps to emit new steps during execution using {:ok, result, new_steps} return format.

Input - A named parameter that a reactor accepts when executed, similar to function arguments.

Intermediate Results - Storage for step outputs that are needed by dependent steps or the reactor's return value.

Reactor - A workflow definition containing inputs, steps, dependencies, and execution logic for orchestrating complex business processes.

Result - The output value from a successfully executed step, accessible to dependent steps via result(:step_name) syntax.

Saga Pattern - Transaction-like coordination pattern across multiple resources without requiring distributed transactions, using compensation for failure handling.

Step - A unit of work in a reactor with a unique name, dependencies, implementation, and optional error handling callbacks.

Subpath Access - Ability to extract nested values from step results using syntax like result(:step, [:key, :subkey]).

Undo - Rollback mechanism called when a step succeeded but a later step failed, used to maintain system consistency.

Concurrency Pool - Shared resource allocation system that limits concurrent step execution across reactor hierarchies to prevent resource exhaustion.

Concurrency Tracker - ETS-based global system managing concurrency pools wit

*[Content truncated]*

---

## Reactor.Error.Invalid.RetriesExceededError exception (reactor v0.17.0)

**URL:** https://hexdocs.pm/reactor/Reactor.Error.Invalid.RetriesExceededError.html

**Contents:**
- Reactor.Error.Invalid.RetriesExceededError exception (reactor v0.17.0)
- Summary
- Functions
- Functions
- exception(args)
- Keys

This error is returned when a step attempts to retry more times that is allowed.

Create an Elixir.Reactor.Error.Invalid.RetriesExceededError without raising it.

Create an Elixir.Reactor.Error.Invalid.RetriesExceededError without raising it.

Hex Package Hex Preview Search HexDocs

Built using ExDoc (v0.38.3) for the Elixir programming language

---

## Reactor.Dsl.Input (reactor v0.17.0)

**URL:** https://hexdocs.pm/reactor/Reactor.Dsl.Input.html

**Contents:**
- Reactor.Dsl.Input (reactor v0.17.0)
- Summary
- Types
- Types
- t()

The struct used to store input DSL entities.

Hex Package Hex Preview Search HexDocs

Built using ExDoc (v0.38.3) for the Elixir programming language

---

## Reactor.Executor.Init (reactor v0.17.0)

**URL:** https://hexdocs.pm/reactor/Reactor.Executor.Init.html

**Contents:**
- Reactor.Executor.Init (reactor v0.17.0)

Handle argument checking and state setup for a Reactor run.

Hex Package Hex Preview Search HexDocs

Built using ExDoc (v0.38.3) for the Elixir programming language

---

## Design Decisions

**URL:** https://hexdocs.pm/reactor/design-decisions.html

**Contents:**
- Design Decisions
- Why Dependency-Based Execution?
  - The Decision
  - Reasoning Behind the Choice
  - Benefits and Trade-offs
- Saga Pattern with Three-Tier Error Handling
  - The Decision
  - Why Saga Pattern?
  - Three-Tier Error Handling
  - Design Philosophy

This guide explains the reasoning behind Reactor's key design choices, helping you understand why the framework works the way it does and how these decisions benefit different use cases.

Reactor uses argument dependencies to determine execution order rather than requiring explicit step sequencing. When a step declares argument :user_id, result(:fetch_user), it automatically creates a dependency that ensures fetch_user runs before the current step.

Traditional Sequential Approach:

Reactor's Dependency Approach:

Reactor implements the saga pattern with a three-tier error handling approach: retry → compensation → undo, rather than traditional distributed transactions or simple error propagation.

Distributed Transaction Limitations:

Saga Pattern Benefits:

Level 2: Compensation (Smart Recovery)

Level 3: Undo (Rollback)

Step-Level Autonomy with Global Coordination:

Multiple Recovery Paths:

Reactor provides both a declarative DSL (using Spark) and a programmatic Builder API, rather than choosing just one approach.

DSL Strengths - Static Workflows:

Builder API Strengths - Dynamic Workflows:

Use Builder API When:

Both approaches produce identical runtime structures and can be composed together.

Steps run asynchronously by default (async?: true) with sophisticated concurrency management and deadlock prevention.

Modern Computing Reality:

Performance Benefits:

Performance by Default:

Safety and Reliability:

Reactor is built on the Spark library and designed to integrate seamlessly with the Ash ecosystem, while still being a standalone workflow engine that works with any Elixir application.

Shared DSL Infrastructure:

Complementary Capabilities:

Constraints Accepted:

These design decisions work together to create a framework that:

Understanding these decisions helps you make better choices when designing workflows and contributes to effective use of Reactor in complex applications.

Hex Package Hex Preview (current file) Search HexDocs

Built using ExDoc (v0.38.3) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
# Sequential workflow - explicit ordering
step_1 → step_2 → step_3 → step_4
```

Example 2 (unknown):
```unknown
# Dependency-driven workflow - automatic ordering
defmodule UserWorkflow do
  use Reactor
  
  step :fetch_user do
    argument :user_id, input(:user_id)
  end
  
  step :fetch_profile do
    argument :user_id, input(:user_id)  # Can run concurrently with fetch_user
  end
  
  step :merge_data do
    argument :user, result(:fetch_user)      # Waits for fetch_user
    argument :profile, result(:fetch_profile) # Waits for fetch_profile
  end
end
```

Example 3 (python):
```python
def compensate(%NetworkTimeoutError{}, _arguments, context, _step) do
  # Exponential backoff - Reactor handles max_retries automatically
  delay = :math.pow(2, context.current_try) * 1000
  Process.sleep(delay)
  :retry
end
```

Example 4 (python):
```python
def compensate(%PaymentGatewayError{backup_gateway: backup}, arguments, _context, _step) do
  # Try backup payment gateway
  case BackupGateway.charge(arguments.amount, arguments.card) do
    {:ok, charge} -> {:continue, charge}
    {:error, _} -> :ok  # Proceed to undo
  end
end
```

---

## Reactor.Dsl.Debug (reactor v0.17.0)

**URL:** https://hexdocs.pm/reactor/Reactor.Dsl.Debug.html

**Contents:**
- Reactor.Dsl.Debug (reactor v0.17.0)
- Summary
- Types
- Types
- t()

The debug DSL entity struct.

Hex Package Hex Preview Search HexDocs

Built using ExDoc (v0.38.3) for the Elixir programming language

---

## Reactor in the Elixir Ecosystem

**URL:** https://hexdocs.pm/reactor/ecosystem.html

**Contents:**
- Reactor in the Elixir Ecosystem
- Framework Independence
  - Core Design Philosophy
- Reactor Ecosystem Packages
  - Core Ecosystem Packages
  - Extension Pattern
- Ash Framework Integration
  - Ash.Reactor Extension
  - Ash-Specific Capabilities
  - When to Use Ash.Reactor vs Core Reactor

Reactor is a framework-independent, dynamic, concurrent, dependency-resolving saga orchestrator for Elixir. While it's part of the ash-project organization and has excellent Ash framework integration, Reactor is designed to work with any Elixir application and can orchestrate workflows across diverse systems and frameworks.

Reactor's architecture is deliberately framework-agnostic:

The Reactor ecosystem includes several specialized packages that extend its capabilities:

Ecosystem packages provide additional DSL entities that become available when you include them as extensions:

While Reactor is framework-independent, the Ash.Reactor extension provides deep integration with Ash resources and actions:

Resource Action Integration:

Transaction Management:

Notification Handling:

Use Ash.Reactor when:

Use Core Reactor when:

Task/Async Advantages:

Choose Reactor when your workflow has:

Specific use cases include:

Choose alternatives when:

Framework-Independent Learning:

Ash-Specific Learning:

Reactor's framework-independent design makes it adaptable to new technologies and integration requirements. The ecosystem could potentially grow in many directions:

Possible Integration Areas:

Framework Integration Opportunities:

Contributing to the Ecosystem: What integrations would be valuable for your use cases? The Reactor community welcomes contributions that extend its capabilities while maintaining its core strengths in workflow orchestration, dependency resolution, and error handling. Whether used standalone or with framework-specific extensions like Ash.Reactor, it provides a solid foundation for building reliable, maintainable business workflows.

Hex Package Hex Preview (current file) Search HexDocs

Built using ExDoc (v0.38.3) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
# Reactor works with any Elixir code
defmodule GenericWorkflowReactor do
  use Reactor

  input :data

  step :process_with_genserver do
    argument :data, input(:data)
    run fn args, _context ->
      GenServer.call(MyService, {:process, args.data})
    end
  end

  step :call_external_api do
    argument :processed_data, result(:process_with_genserver)
    run fn args, _context ->
      HTTPoison.post("https://api.example.com", args.processed_data)
    end
  end

  step :store_in_ets do
    argument :api_response, result(:call_external_api)
    run fn args, _context ->
      :ets.insert(:
...
```

Example 2 (unknown):
```unknown
# Example ecosystem integration
defmodule MyWorkflowReactor do
  use Reactor, extensions: [Reactor.Req, Reactor.File, Reactor.Process]
  
  input :file_path
  input :upload_url
  
  # File operations from reactor_file (DSL entities)
  file_read :process_file do
    path input(:file_path)
  end
  
  # HTTP requests from reactor_req (DSL entities)
  req_post :upload_data do
    url input(:upload_url)
    body result(:process_file)
  end
  
  # Process management from reactor_process (DSL entities)
  start_child :start_worker do
    supervisor value(MyApp.WorkerSupervisor) 
    child_spec templat
...
```

Example 3 (unknown):
```unknown
defmodule UserOnboardingReactor do
  # Using the Ash.Reactor extension
  use Ash.Reactor

  input :user_params

  # Ash-specific create action step
  create :user, MyApp.User, :create do
    inputs %{
      email: input(:user_params, [:email]),
      name: input(:user_params, [:name])
    }
  end

  # Ash-specific update action step  
  update :activate_user, MyApp.User, :activate do
    record result(:user)
    inputs %{activated_at: value(DateTime.utc_now())}
  end

  # Ash action with automatic undo support
  action :send_welcome_email, MyApp.Notifications, :send_welcome do
    inputs %{use
...
```

Example 4 (unknown):
```unknown
defmodule E2EProcessingReactor do
  use Reactor

  input :upload_params

  # Phoenix file upload handling
  step :handle_upload do
    argument :params, input(:upload_params)
    run &MyAppWeb.UploadController.process_upload/2
  end

  # Ash resource operations (if using Ash.Reactor)
  step :store_metadata do
    argument :file_info, result(:handle_upload)
    run fn args, _context ->
      MyApp.FileMetadata.create(args.file_info)
    end
  end

  # External service integration
  step :process_with_ai do
    argument :file_path, result(:handle_upload, [:path])
    run fn args, _context ->
   
...
```

---

## How to Build a Payment Processing Workflow

**URL:** https://hexdocs.pm/reactor/payment-processing.html

**Contents:**
- How to Build a Payment Processing Workflow
- Problem
- Solution Overview
- Workflow Architecture
- Prerequisites
- Complete Working Example
- Step Implementations
  - 1. Inventory Reservation (Undoable)
  - 2. Payment Authorization (Undoable)
  - 3. Payment Capture (Compensatable with Retry)

You need to coordinate payment authorization, inventory reservation, and order fulfillment with proper rollback on failures. When any step fails, you need to clean up previous successful operations to maintain data consistency.

This guide shows you how to build a robust payment processing workflow using Reactor's compensation and undo patterns. You'll learn to handle failures gracefully with automatic rollback.

Here's the complete payment processing flow with error handling:

Here's a complete e-commerce payment workflow with proper error handling:

Undo is called when a step succeeded but a later step failed:

Compensate is called when the step itself failed:

Use wait_for to control execution order without passing data:

Inventory not released after payment failure:

Payment captured but order not fulfilled:

For general error handling and retry issues, see Error Handling Tutorial.

Add debug steps to track workflow progress:

Use telemetry middleware for observability:

Hex Package Hex Preview (current file) Search HexDocs

Built using ExDoc (v0.38.3) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
flowchart TB
    Start([Order Received]) --> ValidatePayment[Validate Payment Details]
    ValidatePayment --> CheckInventory[Check Inventory]
    ValidatePayment --> ValidateAddress[Validate Shipping Address]
    
    CheckInventory --> ReserveItems[Reserve Items]
    ValidateAddress --> CalculateShipping[Calculate Shipping Cost]
    ValidatePayment --> AuthorizePayment[Authorize Payment]
    
    ReserveItems --> ProcessOrder{All Valid?}
    CalculateShipping --> ProcessOrder
    AuthorizePayment --> ProcessOrder
    
    ProcessOrder -->|Success| CapturePayment[Capture Payment]
    ProcessO
...
```

Example 2 (unknown):
```unknown
defmodule ECommerce.PaymentWorkflow do
  use Reactor

  input :order_id
  input :payment_details
  input :customer_id

  # Step 1: Validate order and check inventory
  step :validate_order, ECommerce.Steps.ValidateOrder do
    argument :order_id, input(:order_id)
  end

  # Step 2: Reserve inventory (can be undone)
  step :reserve_inventory, ECommerce.Steps.ReserveInventory do
    argument :order, result(:validate_order)
  end

  # Step 3: Authorize payment (can be undone)  
  step :authorize_payment, ECommerce.Steps.AuthorizePayment do
    argument :payment_details, input(:payment_details)
  
...
```

Example 3 (python):
```python
defmodule ECommerce.Steps.ReserveInventory do
  use Reactor.Step

  @impl true
  def run(%{order: order}, _context, _options) do
    case InventoryService.reserve_items(order.items) do
      {:ok, reservation} -> {:ok, reservation}
      {:error, :insufficient_stock} -> {:error, "Not enough inventory for order"}
      {:error, reason} -> {:error, reason}
    end
  end

  @impl true
  def undo(reservation, _arguments, _context, _options) do
    # Release the reserved inventory if later steps fail
    case InventoryService.release_reservation(reservation.id) do
      :ok -> :ok
      {:error, :a
...
```

Example 4 (python):
```python
defmodule ECommerce.Steps.AuthorizePayment do
  use Reactor.Step

  @impl true
  def run(%{payment_details: details, order: order}, _context, _options) do
    case PaymentGateway.authorize(details, order.total) do
      {:ok, authorization} -> {:ok, authorization}
      {:error, :card_declined} -> {:error, "Payment was declined"}
      {:error, :insufficient_funds} -> {:error, "Insufficient funds"}
      {:error, reason} -> {:error, reason}
    end
  end

  @impl true 
  def undo(authorization, _arguments, _context, _options) do
    # Void the authorization if fulfillment fails
    case Paymen
...
```

---

## Reactor.Dsl.Argument (reactor v0.17.0)

**URL:** https://hexdocs.pm/reactor/Reactor.Dsl.Argument.html

**Contents:**
- Reactor.Dsl.Argument (reactor v0.17.0)
- Summary
- Types
- Functions
- Types
- t()
- Functions
- element(name, sub_path \\ [])
- Example
- input(input_name, sub_path \\ [])

The struct used to store argument DSL entities.

See Reactor.step.argument.

The element template helper for the Reactor DSL.

The input template helper for the Reactor DSL.

The result template helper for the Reactor DSL.

The value template helper for the Reactor DSL.

The element template helper for the Reactor DSL.

The input template helper for the Reactor DSL.

You can provide a list of keys to extract from a data structure, similar to Kernel.get_in/2 with the condition that the input value is either a struct or implements the Access protocol.

The result template helper for the Reactor DSL.

You can provide a list of keys to extract from a data structure, similar to Kernel.get_in/2 with the condition that the result is either a struct or implements the Access protocol.

The value template helper for the Reactor DSL.

Hex Package Hex Preview Search HexDocs

Built using ExDoc (v0.38.3) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
defmodule ExampleReactor do
  use Reactor

  input :numbers

  map :double_numbers do
    source input(:numbers)

    step :double do
      argument :number, element(:double_numbers)

      run fn args, _ ->
        {:ok, args.number * 2}
      end
    end

    return :double
  end
end
```

Example 2 (unknown):
```unknown
defmodule ExampleReactor do
  use Reactor

  input :name

  step :greet do
    # here: --------↓↓↓↓↓
    argument :name, input(:name)
    run fn
      %{name: nil}, _, _ -> {:ok, "Hello, World!"}
      %{name: name}, _, _ -> {:ok, "Hello, #{name}!"}
    end
  end
end
```

Example 3 (unknown):
```unknown
defmodule ExampleReactor do
  use Reactor

  step :whom do
    run fn _, _ ->
      {:ok, Enum.random(["Marty", "Doc", "Jennifer", "Lorraine", "George", nil])}
    end
  end

  step :greet do
    # here: --------↓↓↓↓↓↓
    argument :name, result(:whom)
    run fn
      %{name: nil}, _, _ -> {:ok, "Hello, World!"}
      %{name: name}, _, _ -> {:ok, "Hello, #{name}!"}
    end
  end
end
```

Example 4 (unknown):
```unknown
defmodule ExampleReactor do
  use Reactor

  input :number

  step :times_three do
    argument :lhs, input(:number)
    # here: -------↓↓↓↓↓
    argument :rhs, value(3)

    run fn args, _ ->
      {:ok, args.lhs * args.rhs}
    end
  end
end
```

---

## Reactor.Dsl.Guard (reactor v0.17.0)

**URL:** https://hexdocs.pm/reactor/Reactor.Dsl.Guard.html

**Contents:**
- Reactor.Dsl.Guard (reactor v0.17.0)
- Summary
- Types
- Types
- t()

A struct used to store the guard DSL entity.

See Reactor.step.guard

Hex Package Hex Preview Search HexDocs

Built using ExDoc (v0.38.3) for the Elixir programming language

---

## Reactor.Step.Compose (reactor v0.17.0)

**URL:** https://hexdocs.pm/reactor/Reactor.Step.Compose.html

**Contents:**
- Reactor.Step.Compose (reactor v0.17.0)
- Summary
- Functions
- Functions
- extract_result(arg1, _)
- perform_reactor_run(arguments, context, options)
- schedule_undoable_reactor_run(context)

A built-in step which can embed one reactor inside another.

This step calls Reactor.run/3 on the inner reactor and returns it's result. Reactor will correctly share the concurrency availability over both the parent and child Reactors.

Hex Package Hex Preview Search HexDocs

Built using ExDoc (v0.38.3) for the Elixir programming language

---

## Reactor.Dsl.Group (reactor v0.17.0)

**URL:** https://hexdocs.pm/reactor/Reactor.Dsl.Group.html

**Contents:**
- Reactor.Dsl.Group (reactor v0.17.0)
- Summary
- Types
- Types
- t()

The group DSL entity struct.

Hex Package Hex Preview Search HexDocs

Built using ExDoc (v0.38.3) for the Elixir programming language

---

## Reactor.Dsl.Where (reactor v0.17.0)

**URL:** https://hexdocs.pm/reactor/Reactor.Dsl.Where.html

**Contents:**
- Reactor.Dsl.Where (reactor v0.17.0)
- Summary
- Types
- Types
- t()

A struct used to store the where DSL entity.

See Reactor.step.where.

Hex Package Hex Preview Search HexDocs

Built using ExDoc (v0.38.3) for the Elixir programming language

---

## README

**URL:** https://hexdocs.pm/reactor/readme.html

**Contents:**
- README
- Reactor
- Sponsors
- Installation
- Documentation
  - 🎓 Learning Reactor - Tutorials
  - 🔧 Solving Problems - How-to Guides
  - 📚 API Reference
  - 💡 Understanding Reactor - Explanations
- Contributing

Reactor is a dynamic, concurrent, dependency resolving saga orchestrator.

Woah. That's a lot. Let's break it down:

Thanks to Alembic Pty Ltd for sponsoring a portion of this project's development.

Reactor contains an igniter installer, so if you have igniter installed already you can run mix igniter.install reactor to add Reactor to your app.

The package can be installed by adding reactor to your list of dependencies in mix.exs:

Our documentation is organized to help you find exactly what you need:

Step-by-step guides that teach Reactor through hands-on practice:

Practical solutions for real-world scenarios:

Complete technical reference:

Conceptual guides about how and why Reactor works:

Quick Start: New to Reactor? Start with the Getting Started tutorial!

reactor is licensed under the terms of the MIT license. See the LICENSE file in this repository for details.

Hex Package Hex Preview (current file) Search HexDocs

Built using ExDoc (v0.38.3) for the Elixir programming language

**Examples:**

Example 1 (python):
```python
def deps do
  [
    {:reactor, "~> 0.17.0"}
  ]
end
```

---

## Reactor.Dsl.Collect (reactor v0.17.0)

**URL:** https://hexdocs.pm/reactor/Reactor.Dsl.Collect.html

**Contents:**
- Reactor.Dsl.Collect (reactor v0.17.0)
- Summary
- Types
- Types
- t()

The struct used to store collect DSL entities.

Hex Package Hex Preview Search HexDocs

Built using ExDoc (v0.38.3) for the Elixir programming language

---

## Reactor (reactor v0.17.0)

**URL:** https://hexdocs.pm/reactor/Reactor.html

**Contents:**
- Reactor (reactor v0.17.0)
- Usage
  - Options
- Summary
- Types
- Functions
- Types
- async_option()
- concurrency_key_option()
- context()

Reactor is a dynamic, concurrent, dependency resolving saga orchestrator.

You can construct a reactor using the Reactor Spark DSL:

or you can build it programmatically:

:extensions (list of module that adopts Spark.Dsl.Extension) - A list of DSL extensions to add to the Spark.Dsl

:otp_app (atom/0) - The otp_app to use for any application configurable options

:fragments (list of module/0) - Fragments to include in the Spark.Dsl. See the fragments guide for more.

When set to false forces the Reactor to run every step synchronously, regardless of the step configuration.

Use a Reactor.Executor.ConcurrencyTracker.pool_key to allow this Reactor to share it's concurrency pool with other Reactor instances.

When this option is set the Reactor will return a copy of the completed Reactor struct for potential future undo.

How long to wait for asynchronous steps to complete when halting.

Specify the maximum number of asynchronous steps which can be run in parallel.

The maximum number of iterations which after which the Reactor will halt.

Specify the amount of execution time after which to halt processing.

A guard which returns true if the value is a Reactor struct

Attempt to run a Reactor.

Raising version of run/4.

Attempt to undo a previously successful Reactor.

A raising version of undo/2

When set to false forces the Reactor to run every step synchronously, regardless of the step configuration.

Use a Reactor.Executor.ConcurrencyTracker.pool_key to allow this Reactor to share it's concurrency pool with other Reactor instances.

If you do not specify one then the Reactor will initialise a new pool and place it in it's context for any child Reactors to re-use.

Only used if async? is set to true.

When this option is set the Reactor will return a copy of the completed Reactor struct for potential future undo.

How long to wait for asynchronous steps to complete when halting.

Specify the maximum number of asynchronous steps which can be run in parallel.

Defaults to the result of System.schedulers_online/0. Only used if async? is set to true.

The maximum number of iterations which after which the Reactor will halt.

Defaults to :infinity.

Specify the amount of execution time after which to halt processing.

Note that this is not a hard limit. The Reactor will stop when the first step completes after the timeout has expired.

Defaults to :infinity.

A guard which returns true if the value is a Reactor struct

Attempt to run a Reactor.

:max_concurren

*[Content truncated]*

**Examples:**

Example 1 (unknown):
```unknown
defmodule HelloWorldReactor do
  @moduledoc false
  use Reactor

  input :whom

  step :greet, Greeter do
    argument :whom, input(:whom)
  end

  return :greet
end
```

Example 2 (unknown):
```unknown
iex> Reactor.run(HelloWorldReactor, %{whom: "Dear Reader"})
{:ok, "Hello, Dear Reader!"}
```

Example 3 (unknown):
```unknown
iex> reactor = Builder.new()
...> {:ok, reactor} = Builder.add_input(reactor, :whom)
...> {:ok, reactor} = Builder.add_step(reactor, :greet, Greeter, whom: {:input, :whom})
...> {:ok, reactor} = Builder.return(reactor, :greet)
...> Reactor.run(reactor, %{whom: nil})
{:ok, "Hello, World!"}
```

---

## Reactor.Step.Around (reactor v0.17.0)

**URL:** https://hexdocs.pm/reactor/Reactor.Step.Around.html

**Contents:**
- Reactor.Step.Around (reactor v0.17.0)
- Options
- Wrapper function
- Callback function
- Example
- Summary
- Types
- Types
- allow_async_option()
- around_fun()

Wrap the execution of a number of steps in a function.

This allows you to provide custom context and filter the provided steps as needed.

Your around function will be called by this step and will be passed the following arguments:

This provides you the opportunity to modify the arguments, context and list of steps to be executed. You then can call the callback with the modified arguments, context and steps and they will be executed in a Reactor of their own. The callback will return {:ok, results} where results is a map of all of the step results by name, or an error tuple.

You can then modify the result in any way before returning it as the return of the around step.

The callback function will spawn a separate Reactor and run provided steps to completion using arguments as input.

It expects the following three arguments to be passed:

You could use a function like that below to cause some steps to be executed inside an Ecto database transaction.

Should the inner Reactor be allowed to run tasks asynchronously?

The type signature for the "around" function.

The type signature for the provided callback function.

The MFA or 4-arity function which this step will call.

The initial steps to pass into the "around" function.

Should the inner Reactor be allowed to run tasks asynchronously?

Optional. Defaults to true.

The type signature for the "around" function.

The type signature for the provided callback function.

The MFA or 4-arity function which this step will call.

The initial steps to pass into the "around" function.

Hex Package Hex Preview Search HexDocs

Built using ExDoc (v0.38.3) for the Elixir programming language

**Examples:**

Example 1 (python):
```python
def in_transaction(arguments, context, steps, callback) do
  MyApp.Repo.transaction(fn ->
    case callback.(arguments, context, steps) do
      {:ok, results} -> result
      {:error, reason} -> raise reason
    end
  end)
end
```

---

## Reactor.Step.Fail (reactor v0.17.0)

**URL:** https://hexdocs.pm/reactor/Reactor.Step.Fail.html

**Contents:**
- Reactor.Step.Fail (reactor v0.17.0)

A very simple step which immediately returns an error.

Hex Package Hex Preview Search HexDocs

Built using ExDoc (v0.38.3) for the Elixir programming language

---

## How to Test Reactors and Steps

**URL:** https://hexdocs.pm/reactor/testing-strategies.html

**Contents:**
- How to Test Reactors and Steps
- Problem
- Solution Overview
- Prerequisites
- Testing Strategies
  - 1. Unit Testing Individual Steps
    - Basic Step Testing
    - Testing Anonymous Function Steps
  - 2. Integration Testing Complete Reactors
    - Module-Based Reactor Testing

You need comprehensive testing strategies for your reactors, including unit tests for individual steps, integration tests for complete workflows, and proper testing of error handling and compensation logic.

This guide shows you different approaches to testing reactors, from testing individual step modules to full workflow integration tests. We'll cover unit testing, integration testing, error scenario testing, and concurrent execution testing.

The most granular level is testing individual step modules directly.

Instead of testing anonymous functions inline, extract them to public functions that can be unit tested:

Test entire workflows by running complete reactors.

Test your actual reactor modules directly. When testing reactors that interact with databases or other shared resources, you'll typically want to disable async execution to ensure proper isolation with test sandboxes:

Test how your reactors handle failures and compensation using Mimic to control step behavior.

We recommend using Mimic as your mocking library for testing Reactor steps. Mimic allows you to stub function calls without modifying your production code.

First, set up your test helper to copy the step modules you want to mock:

This comprehensive testing approach ensures your reactors are reliable, maintainable, and perform well under various conditions.

Hex Package Hex Preview (current file) Search HexDocs

Built using ExDoc (v0.38.3) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
defmodule MyApp.Steps.ValidateEmailTest do
  use ExUnit.Case, async: true
  
  alias MyApp.Steps.ValidateEmail
  
  test "validates correct email format" do
    arguments = %{email: "user@example.com"}
    context = %{}
    options = []
    
    assert {:ok, "user@example.com"} = ValidateEmail.run(arguments, context, options)
  end
  
  test "returns error for invalid email" do
    arguments = %{email: "invalid-email"}
    context = %{}
    options = []
    
    assert {:error, %ArgumentError{}} = ValidateEmail.run(arguments, context, options)
  end
end
```

Example 2 (python):
```python
defmodule MyApp.UserReactor do
  use Reactor
  
  input :name
  
  step :greet do
    argument :name, input(:name)
    run &greet_user/2
  end
  
  def greet_user(%{name: name}, _context) do
    {:ok, "Hello, #{name}!"}
  end
end

defmodule MyApp.UserReactorTest do
  use ExUnit.Case, async: true
  
  test "greet_user formats greeting correctly" do
    assert {:ok, "Hello, Marty!"} = 
      MyApp.UserReactor.greet_user(%{name: "Marty"}, %{})
  end
  
  test "greet_user handles edge cases" do
    assert {:ok, "Hello, !"} = 
      MyApp.UserReactor.greet_user(%{name: ""}, %{})
  end
end
```

Example 3 (unknown):
```unknown
defmodule MyApp.UserRegistrationReactor do
  use Reactor
  
  input :email
  input :password
  
  step :validate_email, MyApp.Steps.ValidateEmail do
    argument :email, input(:email)
  end
  
  step :hash_password, MyApp.Steps.HashPassword do
    argument :password, input(:password)
  end
  
  step :create_user, MyApp.Steps.CreateUser do
    argument :email, result(:validate_email)
    argument :password_hash, result(:hash_password)
  end
end

defmodule MyApp.UserRegistrationReactorTest do
  use ExUnit.Case, async: false
  
  alias MyApp.UserRegistrationReactor
  
  test "successful user regi
...
```

Example 4 (unknown):
```unknown
# test/test_helper.exs
Mimic.copy(MyApp.Steps.ProcessPayment)
Mimic.copy(MyApp.Steps.ReserveInventory)
Mimic.copy(MyApp.Steps.SendConfirmation)
ExUnit.start()
```

---

## Reactor.Dsl.Compose (reactor v0.17.0)

**URL:** https://hexdocs.pm/reactor/Reactor.Dsl.Compose.html

**Contents:**
- Reactor.Dsl.Compose (reactor v0.17.0)
- Summary
- Types
- Types
- t()

The compose DSL entity struct.

See the Reactor.compose.

Hex Package Hex Preview Search HexDocs

Built using ExDoc (v0.38.3) for the Elixir programming language

---

## How to Build Data Processing Pipelines

**URL:** https://hexdocs.pm/reactor/data-pipelines.html

**Contents:**
- How to Build Data Processing Pipelines
- Problem
- Solution Overview
- Prerequisites
- Processing Large Datasets
- Complete ETL Pipeline Example
- Step Implementations
  - 1. Data Extraction
  - 2. Data Quality Validation
  - 3. User Transformation Functions

You need to process large datasets through multiple transformation steps with error handling, progress tracking, and efficient batch processing. Your data pipeline should handle millions of records while being resilient to failures.

This guide shows you how to build robust ETL (Extract, Transform, Load) and batch processing workflows using Reactor's map steps, async processing, and collect patterns. You'll learn to process data efficiently at scale.

Reactor uses Iterex internally for efficient, resumable iteration over large datasets. This provides several advantages over standard Elixir streams:

When you need these patterns:

Here's a complete data processing pipeline that extracts user data, transforms it, and loads it into multiple destinations:

For very large files, process data in chunks to avoid memory issues and enable efficient error handling:

Pause and resume processing across reactor executions:

Reactor provides observability using the conventional telemetry package. Add the telemetry middleware to emit events for monitoring your data pipelines:

For memory and performance issues, see Performance Optimization.

Add debug steps to monitor data flow:

Hex Package Hex Preview (current file) Search HexDocs

Built using ExDoc (v0.38.3) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
defmodule DataPipeline.UserETL do
  use Reactor

  input :source_file
  input :output_destinations

  # Step 1: Extract - Read and parse data
  step :extract_data, DataPipeline.Steps.ExtractCSV do
    argument :file_path, input(:source_file)
  end

  # Step 2: Validate data quality
  step :validate_data_quality, DataPipeline.Steps.DataQualityCheck do
    argument :raw_data, result(:extract_data)
  end

  # Step 3: Transform users in batches
  map :transform_users do
    source result(:extract_data, [:users])
    allow_async? true
    return :validate_user

    step :clean_user do
      argumen
...
```

Example 2 (python):
```python
defmodule DataPipeline.Steps.ExtractCSV do
  use Reactor.Step

  @impl true
  def run(%{file_path: path}, _context, _options) do
    case File.exists?(path) do
      true ->
        users = 
          path
          |> File.stream!()
          |> CSV.decode!(headers: true)
          |> Enum.to_list()
        
        stats = %{
          total_count: length(users),
          file_size: File.stat!(path).size,
          extracted_at: DateTime.utc_now()
        }
        
        {:ok, %{users: users, stats: stats}}
        
      false ->
        {:error, "Source file not found: #{path}"}
    en
...
```

Example 3 (python):
```python
defmodule DataPipeline.Steps.DataQualityCheck do
  use Reactor.Step

  @impl true
  def run(%{raw_data: %{users: users}}, _context, _options) do
    # Analyze data quality
    quality_issues = analyze_quality(users)
    
    rules = %{
      email_required: true,
      phone_format: ~r/^\+?[\d\s\-\(\)]+$/,
      name_min_length: 2,
      max_age: 120
    }
    
    case quality_issues do
      [] -> 
        {:ok, %{rules: rules, issues: [], status: :passed}}
      issues when length(issues) < 100 ->
        {:ok, %{rules: rules, issues: issues, status: :warnings}}
      issues ->
        {:er
...
```

Example 4 (python):
```python
def clean_and_normalize_user(%{user: user, rules: _rules}) do
  cleaned = %{
    id: user["id"],
    email: String.downcase(String.trim(user["email"] || "")),
    name: String.trim(user["name"] || ""),
    phone: normalize_phone(user["phone"]),
    age: parse_age(user["age"]),
    created_at: DateTime.utc_now()
  }
  
  {:ok, cleaned}
rescue
  e -> {:error, "Failed to clean user #{user["id"]}: #{inspect(e)}"}
end

def enrich_with_external_data(%{clean_user: user}) do
  case ExternalAPI.get_user_profile(user.email) do
    {:ok, profile} ->
      enriched = Map.merge(user, %{
        company: pr
...
```

---

## Reactor.Guard (reactor v0.17.0)

**URL:** https://hexdocs.pm/reactor/Reactor.Guard.html

**Contents:**
- Reactor.Guard (reactor v0.17.0)
- Summary
- Types
- Types
- t()

Guard types should implement the Reactor.Guard.Build protocol.

This struct contains a single two arity function, which when called with a step's arguments and context returns one of the following:

Hex Package Hex Preview Search HexDocs

Built using ExDoc (v0.38.3) for the Elixir programming language

---

## Reactor.Builder.Input (reactor v0.17.0)

**URL:** https://hexdocs.pm/reactor/Reactor.Builder.Input.html

**Contents:**
- Reactor.Builder.Input (reactor v0.17.0)
- Summary
- Types
- Functions
- Types
- options()
- transform()
- Functions
- add_input(reactor, name, options)

Handle adding inputs to Reactors for the builder.

You should not use this module directly, but instead use Reactor.Builder.add_input/3.

Add a named input to the reactor.

Add a named input to the reactor.

Hex Package Hex Preview Search HexDocs

Built using ExDoc (v0.38.3) for the Elixir programming language

---

## Reactor.Argument (reactor v0.17.0)

**URL:** https://hexdocs.pm/reactor/Reactor.Argument.html

**Contents:**
- Reactor.Argument (reactor v0.17.0)
- Summary
- Types
- Functions
- Types
- options()
- t()
- transform()
- Functions
- from_element(name, element_name, options \\ nil)

Build an argument which refers to to an element within a map step with an optional transformation applied.

Build an argument which refers to a reactor input with an optional transformation applied.

Build an argument which refers to the result of another step with an optional transformation applied.

Build an argument directly from a template.

Build an argument which refers to a statically defined value.

Validate that the argument source has a sub_path

Validate that the argument has a transform.

Validate that the argument is an Argument struct.

Validate that the argument contains an element.

Validate that the argument refers to a reactor input.

Validate that the argument refers to a step result.

Validate that the argument contains a static value.

Set a sub-path on the argument.

Build an argument which refers to to an element within a map step with an optional transformation applied.

Build an argument which refers to a reactor input with an optional transformation applied.

:transform - An optional transformation function which can be used to modify the argument before it is passed to the step. The default value is nil.

:description - An optional description for the argument. The default value is nil.

Build an argument which refers to the result of another step with an optional transformation applied.

Build an argument directly from a template.

Build an argument which refers to a statically defined value.

Validate that the argument source has a sub_path

Validate that the argument has a transform.

Validate that the argument is an Argument struct.

Validate that the argument contains an element.

Validate that the argument refers to a reactor input.

Validate that the argument refers to a step result.

Validate that the argument contains a static value.

Set a sub-path on the argument.

Hex Package Hex Preview Search HexDocs

Built using ExDoc (v0.38.3) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
iex> Argument.from_element(:argument_name, &Atom.to_string/1)
```

Example 2 (unknown):
```unknown
iex> Argument.from_input(:argument_name, :input_name, transform: &String.to_integer/1)
```

Example 3 (unknown):
```unknown
iex> Argument.from_result(:argument_name, :step_name, &Atom.to_string/1)
```

Example 4 (unknown):
```unknown
iex> Argument.from_template(:argument_name, Reactor.Dsl.Argument.input(:input_name))
```

---

## Reactor.Dsl.Step (reactor v0.17.0)

**URL:** https://hexdocs.pm/reactor/Reactor.Dsl.Step.html

**Contents:**
- Reactor.Dsl.Step (reactor v0.17.0)
- Summary
- Types
- Types
- t()

The struct used to store step DSL entities.

Hex Package Hex Preview Search HexDocs

Built using ExDoc (v0.38.3) for the Elixir programming language

---
