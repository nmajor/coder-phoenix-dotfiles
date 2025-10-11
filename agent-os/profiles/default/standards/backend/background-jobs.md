## Background jobs

### Declarative Background Jobs

**Define background jobs as actions with AshOban triggers, not standalone Oban workers.**

When you need background processing that's triggered by resource changes, use AshOban's declarative approach:

```elixir
# ✅ CORRECT - Declarative AshOban pattern
defmodule MyApp.Resource do
  use Ash.Resource,
    extensions: [AshOban]

  oban do
    triggers do
      trigger :process do
        action :process_record
        worker_module_name MyApp.Resource.ProcessTrigger
        scheduler_cron false  # Only trigger on demand
        max_attempts 3
        queue :my_queue
      end
    end
  end

  actions do
    create :create do
      accept [:field]
      # Automatically trigger background processing
      change run_oban_trigger(:process)
    end

    update :process_record do
      # Background job logic goes here as a change
      change MyApp.Changes.ProcessRecord
    end
  end
end

# ❌ WRONG - Manual Oban worker with manual enqueueing
defmodule MyApp.Workers.ProcessRecord do
  use Oban.Worker

  def perform(%{args: %{"record_id" => id}}) do
    # Processing logic...
  end
end

### Key Benefits

1. **Domain Modeling**: Background jobs become part of your resource definition
2. **Declarative**: Creating/updating a resource automatically triggers processing
3. **Visibility**: Jobs are defined where the data lives, not in separate worker modules
4. **Testing**: Test the action directly instead of mocking Oban workers
5. **Maintainability**: All related logic in one place

### Best Practices

1. **Use explicit worker_module_name** - Prevents issues during refactoring:
   ```elixir
   worker_module_name MyApp.Resource.ProcessTrigger
   ```

2. **Set scheduler_cron false for on-demand jobs** - Only use cron for scheduled tasks:
   ```elixir
   scheduler_cron false  # Triggered by run_oban_trigger, not on schedule
   ```

3. **Define processing logic as changes** - Keep action clean:
   ```elixir
   update :process_record do
     change ProcessRecordChange
   end
   ```

4. **Test actions, not workers** - More direct and maintainable:
   ```elixir
   test "processes record" do
     {:ok, _result} =
       record
       |> Ash.Changeset.for_update(:process_record)
       |> Ash.update()
   end
   ```

5. **Configure Oban with AshOban.config** - Required in application.ex:
   ```elixir
   {Oban, AshOban.config(
     Application.fetch_env!(:my_app, :ash_domains),
     Application.fetch_env!(:my_app, Oban)
   )}
   ```
