---
name: reactor
description: Complex multi-step processes and workflows. Use for ANY orchestrated workflows, saga patterns, multi-step operations, compensating transactions, process automation, and complex business processes that require step coordination.
---

# Reactor Skill

Comprehensive assistance with Reactor development for building declarative, fault-tolerant workflows in Elixir.

## When to Use This Skill

This skill should be triggered when:
- Building multi-step business processes or workflows
- Implementing compensating transactions or sagas
- Creating async/concurrent data processing pipelines
- Orchestrating multiple Ash actions in a coordinated workflow
- Implementing iterative/recursive algorithms
- Building batch processing systems
- Handling complex error recovery or rollback scenarios
- Setting up conditional branching logic in workflows
- Implementing retry logic or convergence algorithms
- Working with the Reactor DSL or step composition

## Key Concepts

### Reactor Basics
- **Reactor**: A declarative workflow engine that executes steps in a coordinated manner
- **Steps**: Individual units of work that can run synchronously or asynchronously
- **Inputs**: Named values passed into the reactor at execution time
- **Arguments**: Dependencies between steps, forming a directed acyclic graph (DAG)
- **Compensation**: Automatic rollback/undo capability when errors occur

### Execution Model
- **Concurrent Execution**: Steps with no dependencies run in parallel automatically
- **Dependency Resolution**: Reactor builds a graph and executes steps as dependencies become available
- **Fault Tolerance**: Failed steps can trigger compensation to undo completed work
- **Recursion**: Workflows can call themselves iteratively until exit conditions are met

### Advanced Features
- **Map Steps**: Process collections with batching and concurrency control
- **Switch/Conditional**: Branch execution based on runtime conditions
- **Templates**: Reusable step definitions with dynamic arguments
- **Sub-Reactors**: Compose reactors within reactors for modularity

## Quick Reference

### Basic Reactor with Steps

```elixir
defmodule UserRegistrationReactor do
  use Reactor

  input :email
  input :password

  step :validate_email do
    argument :email, input(:email)

    run fn %{email: email}, _context ->
      if String.contains?(email, "@") do
        {:ok, email}
      else
        {:error, "Invalid email format"}
      end
    end
  end

  step :hash_password do
    argument :password, input(:password)

    run fn %{password: password}, _context ->
      {:ok, hash_password(password)}
    end
  end

  step :create_user do
    argument :email, result(:validate_email)
    argument :hashed_password, result(:hash_password)

    run fn %{email: email, hashed_password: hash}, _context ->
      User.create(%{email: email, password_hash: hash})
    end
  end

  return :create_user
end
```

### Async Steps with Concurrency

```elixir
defmodule DataFetchReactor do
  use Reactor

  input :user_ids

  # These steps run concurrently
  step :fetch_profiles, async?: true do
    argument :user_ids, input(:user_ids)
    max_retries 3

    run fn %{user_ids: ids}, _context ->
      {:ok, fetch_user_profiles(ids)}
    end
  end

  step :fetch_preferences, async?: true do
    argument :user_ids, input(:user_ids)

    run fn %{user_ids: ids}, _context ->
      {:ok, fetch_user_preferences(ids)}
    end
  end

  # This step waits for both previous steps
  step :merge_data do
    argument :profiles, result(:fetch_profiles)
    argument :preferences, result(:fetch_preferences)

    run fn %{profiles: p, preferences: pref}, _context ->
      {:ok, Map.merge(p, pref)}
    end
  end

  return :merge_data
end
```

### Recursive Execution for Iteration

```elixir
defmodule CountdownReactor do
  use Reactor

  input :current_number

  step :countdown_step do
    argument :current_number, input(:current_number)

    run fn %{current_number: num}, _context ->
      {:ok, %{current_number: num - 1}}
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

  return :countdown
end
```

### Switch/Conditional Branching

```elixir
defmodule PaymentProcessorReactor do
  use Reactor

  input :amount
  input :payment_method

  switch :process_payment do
    on result(:payment_method)

    matches? :credit_card do
      step :charge_credit_card do
        argument :amount, input(:amount)
        run fn %{amount: amt}, _ctx ->
          {:ok, charge_card(amt)}
        end
      end
      return :charge_credit_card
    end

    matches? :paypal do
      step :charge_paypal do
        argument :amount, input(:amount)
        run fn %{amount: amt}, _ctx ->
          {:ok, charge_paypal(amt)}
        end
      end
      return :charge_paypal
    end

    default do
      step :invalid_payment do
        run fn _, _ctx ->
          {:error, "Unsupported payment method"}
        end
      end
      return :invalid_payment
    end
  end

  return :process_payment
end
```

### Map Steps for Batch Processing

```elixir
defmodule BatchProcessingReactor do
  use Reactor

  input :records

  map :process_records do
    argument :source, input(:records)
    batch_size 100
    allow_async? true

    step :validate do
      argument :record, element(:source)

      run fn %{record: record}, _context ->
        {:ok, validate_record(record)}
      end
    end

    step :transform do
      argument :validated, result(:validate)

      run fn %{validated: data}, _context ->
        {:ok, transform_data(data)}
      end
    end

    return :transform
  end

  return :process_records
end
```

### Compensation/Rollback

```elixir
defmodule TransactionReactor do
  use Reactor

  input :account_id
  input :amount

  step :withdraw_funds do
    argument :account_id, input(:account_id)
    argument :amount, input(:amount)

    run fn %{account_id: id, amount: amt}, _context ->
      {:ok, withdraw(id, amt)}
    end

    # Compensation function to undo withdrawal
    compensate fn %{account_id: id, amount: amt}, _result, _context ->
      deposit(id, amt)
      :ok
    end
  end

  step :send_notification do
    argument :account_id, input(:account_id)

    run fn %{account_id: id}, _context ->
      case send_email(id) do
        :ok -> {:ok, :sent}
        error -> {:error, error}
      end
    end
  end

  return :send_notification
end
```

### Concurrency Control

```elixir
# Limit concurrent execution within a reactor
defmodule ConcurrentReactor do
  use Reactor

  input :data_list

  map :process_items do
    argument :source, input(:data_list)
    batch_size 50
    allow_async? true

    step :heavy_processing do
      argument :item, element(:source)

      run fn %{item: item}, _context ->
        {:ok, expensive_operation(item)}
      end
    end

    return :heavy_processing
  end

  return :process_items
end

# Run with concurrency limit
Reactor.run(
  ConcurrentReactor,
  %{data_list: items},
  %{},
  max_concurrency: 10
)
```

### Convergence Algorithm Example

```elixir
defmodule ConvergenceReactor do
  use Reactor

  input :current
  input :target
  input :threshold

  step :check_convergence do
    argument :current, input(:current)
    argument :target, input(:target)
    argument :threshold, input(:threshold)

    run fn %{current: curr, target: tgt, threshold: thresh}, _ctx ->
      converged = abs(curr - tgt) < thresh
      next_value = (curr + tgt) / 2

      {:ok, %{
        current: next_value,
        target: tgt,
        threshold: thresh,
        converged: converged
      }}
    end
  end

  return :check_convergence
end

defmodule ConvergenceExample do
  use Reactor

  input :start_value
  input :target_value
  input :threshold

  recurse :converge, ConvergenceReactor do
    argument :current, input(:start_value)
    argument :target, input(:target_value)
    argument :threshold, input(:threshold)
    max_iterations 1000
    exit_condition fn %{converged: c} -> c == true end
  end

  return :converge
end
```

### Running Reactors

```elixir
# Basic execution
{:ok, result} = Reactor.run(MyReactor, %{input1: "value"}, %{})

# With context and options
{:ok, result} = Reactor.run(
  MyReactor,
  %{user_id: 123},
  %{current_user: user, tenant: "org1"},
  max_concurrency: 20,
  timeout: 30_000
)

# Shared concurrency pool across reactors
{:ok, pool_key} = Reactor.Executor.ConcurrencyTracker.allocate_pool(100)
opts = [concurrency_key: pool_key, max_concurrency: 100]

Task.async(fn -> Reactor.run(Reactor1, inputs1, %{}, opts) end)
Task.async(fn -> Reactor.run(Reactor2, inputs2, %{}, opts) end)
```

## Reference Files

This skill includes comprehensive documentation in `references/`:

- **workflows.md** (64 pages) - Complete Reactor documentation including:
  - Core DSL reference (templates, switches, recursion, around hooks)
  - Tutorial: Building iterative workflows with recursive execution
  - Performance optimization guide (concurrency tuning, memory management, batching)
  - Architecture deep-dive (executor components, planning, state management)
  - API documentation for all Reactor modules

Use `view references/workflows.md` to access the full documentation when you need:
- Detailed API reference for specific modules
- Performance tuning strategies
- Advanced architectural understanding
- Complex workflow patterns

## Working with This Skill

### For Beginners
Start with these concepts:
1. **Basic Workflow**: Understand inputs, steps, and return values
2. **Dependencies**: Learn how steps depend on each other using `result(:step_name)`
3. **Error Handling**: See how Reactor handles failures
4. **Simple Examples**: Try the basic reactor and async steps examples above

Key learning path:
- Build a simple 2-3 step reactor
- Add error handling
- Experiment with async steps
- Try map steps for batch processing

### For Intermediate Users
Focus on these areas:
1. **Conditional Logic**: Master switch statements for branching
2. **Compensation**: Implement rollback logic for fault tolerance
3. **Concurrency Control**: Tune `max_concurrency` and batch sizes
4. **Map Steps**: Process collections efficiently
5. **Sub-Reactors**: Compose reactors for modularity

Reference `references/workflows.md` for:
- Performance optimization techniques
- Advanced map step patterns
- Concurrency pool sharing

### For Advanced Users
Explore these advanced topics:
1. **Recursive Execution**: Build iterative algorithms with exit conditions
2. **Custom Steps**: Create reusable step modules
3. **Performance Tuning**: Optimize for your specific workload
4. **Architecture**: Understand executor internals for debugging
5. **Telemetry Integration**: Monitor reactor performance

Dive into the architecture section in `references/workflows.md` for:
- Executor implementation details
- Planning and graph construction
- State management strategies
- Memory optimization techniques

### For Ash Framework Integration
When using Reactor with Ash:
- Use Reactor to orchestrate multiple Ash actions
- Implement complex business processes spanning multiple resources
- Handle compensating transactions across Ash operations
- Build async workflows for background processing

## Performance Optimization Tips

### Concurrency Settings
```elixir
# I/O-bound workloads (API calls, database queries)
max_concurrency: System.schedulers_online() * 4

# CPU-bound workloads
max_concurrency: System.schedulers_online()

# Mixed workloads
max_concurrency: System.schedulers_online() * 2
```

### Batch Size Guidelines
- Small, fast operations: `batch_size: 1000`
- Expensive operations: `batch_size: 10-50`
- Memory-intensive: `batch_size: 10-20`

### Memory Considerations
- Map steps store all batch results in memory until completion
- Use smaller batch sizes for large result sets
- Consider streaming for very large datasets
- Mark steps as non-undoable when compensation isn't needed

## Common Patterns

### Saga Pattern
Use compensation to implement distributed sagas:
```elixir
step :reserve_inventory, compensate: &release_inventory/3
step :charge_payment, compensate: &refund_payment/3
step :send_confirmation, compensate: &send_cancellation/3
```

### Fan-Out/Fan-In
Run multiple operations concurrently, then merge:
```elixir
step :fetch_a, async?: true
step :fetch_b, async?: true
step :fetch_c, async?: true
step :merge, depends_on: [:fetch_a, :fetch_b, :fetch_c]
```

### Retry Logic
```elixir
step :api_call do
  max_retries 3
  run fn args, ctx -> call_external_api(args) end
end
```

## Troubleshooting

**Recursion never terminates**
- Ensure exit conditions can actually be met
- Always include `max_iterations` as backup
- Add debug logging to verify exit condition logic

**"Maximum iterations exceeded" error**
- Increase `max_iterations`
- Fix logic preventing proper convergence
- Check that condition field exists in state

**High memory usage**
- Reduce `batch_size` in map steps
- Mark non-critical steps as non-undoable
- Avoid storing large results in intermediate steps

**Poor performance**
- Tune `max_concurrency` for your workload type
- Use `async?: true` for I/O-bound steps
- Consider concurrency pool sharing for multiple reactors

## Resources

### Documentation Structure
- **Core Concepts**: Understanding reactors, steps, and execution
- **Tutorials**: Step-by-step guides for common patterns
- **API Reference**: Detailed module and function documentation
- **Performance**: Optimization strategies and benchmarking
- **Architecture**: Internal design and implementation details

### External Links
- [Reactor Hex Documentation](https://hexdocs.pm/reactor)
- [Ash Framework Documentation](https://hexdocs.pm/ash)
- Reactor GitHub repository (check hex.pm for latest)

## Notes

- Reactor is designed for high-throughput, concurrent execution
- All steps form a directed acyclic graph (DAG) - no circular dependencies
- Compensation runs in reverse order of execution
- Context is passed to all steps and can carry metadata, tenant info, etc.
- Reactor integrates seamlessly with Ash Framework for resource orchestration
- Telemetry events are emitted for monitoring and observability
