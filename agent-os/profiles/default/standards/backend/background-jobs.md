## Ash background jobs standards (AshOban + Oban)

### Core Principle: Declarative Background Jobs

- **Use AshOban for Domain Logic**: Define background jobs as resource actions with AshOban triggers, not standalone Oban workers
- **Jobs are Actions**: Background processing logic lives in update/create actions, making it part of the domain model
- **Triggers are Declarative**: Resource changes automatically trigger background jobs without manual enqueueing
- **Single Source of Truth**: All job configuration (retries, queues, scheduling) lives in resource definition

### When to Use AshOban vs Standalone Oban

- **Use AshOban for**: Jobs tied to resource actions, domain-specific processing, data-driven workflows, state transitions
- **Use Standalone Oban for**: System maintenance tasks, jobs not tied to resources, legacy integrations, non-Ash code
- **Migration Path**: Transition standalone workers to AshOban triggers over time for better domain modeling

### Installation and Configuration

- **Install AshOban**: Add to `mix.exs` dependencies (`{:ash_oban, "~> 0.4"}`)
- **Add Extension**: Include `extensions: [AshOban]` in resource's `use Ash.Resource` options
- **Configure Domains**: Add `ash_domains: [MyApp.Domain1, MyApp.Domain2]` to `config/config.exs`
- **Update application.ex**: Replace `{Oban, oban_config}` with `{Oban, AshOban.config(Application.fetch_env!(:my_app, :ash_domains), oban_config)}`
- **Selective Domains**: Can enable AshOban for specific domains only: `AshOban.config([MyApp.Accounts, MyApp.Shop], oban_config)`

### Trigger Types

- **On-Demand Triggers**: Triggered by actions using `run_oban_trigger(:trigger_name)` - set `scheduler_cron false`
- **Scheduled Triggers**: Run on cron schedule to process matching records - set `scheduler_cron "*/5 * * * *"` (every 5 minutes)
- **Hybrid Triggers**: Can be both scheduled AND manually triggered - combine cron schedule with `run_oban_trigger`

### Trigger Configuration

- **Define in oban Block**: Add `oban` block to resource with `triggers` section
- **Explicit Worker Names**: Always set `worker_module_name MyApp.Resource.TriggerName` to prevent refactoring issues
- **Action Required**: Specify `action :action_name` - the update/create action that processes the job
- **Queue Assignment**: Set `queue :queue_name` to control which Oban queue processes the job (defaults to `:default`)
- **Max Attempts**: Configure `max_attempts 3` for retry behavior (defaults to 20)
- **Read Action**: Set `worker_read_action :read` to specify which read action loads the record for processing

### On-Demand Trigger Pattern

- **scheduler_cron false**: Disable automatic scheduling - only trigger via actions
- **run_oban_trigger Change**: Use `change run_oban_trigger(:trigger_name)` in create/update actions
- **Automatic Enqueueing**: Creating/updating resource automatically enqueues background job
- **Example Use Cases**: Send welcome email on user registration, process order after creation, notify on status change

### Scheduled Trigger Pattern

- **Cron Schedule**: Set `scheduler_cron "0 */6 * * *"` for periodic polling (every 6 hours)
- **where Clause**: Add `where expr(status == :pending and inserted_at < ago(1, :hour))` to filter matching records
- **Polling Behavior**: Scheduler queries for matching records and enqueues job for each
- **Batch Processing**: Process multiple records independently - each gets own job
- **Example Use Cases**: Clean up expired records, retry failed imports, process pending notifications

### Action Design for Jobs

- **Processing Logic in Changes**: Keep action clean, implement logic in custom change modules
- **accept Empty**: Job actions typically have `accept []` unless accepting job-specific parameters
- **State Transitions**: Combine with AshStateMachine to track job status (`:queued` → `:processing` → `:completed`)
- **Error Handling**: Let job fail and rely on Oban retry mechanism - don't catch errors unless specific handling needed
- **Timestamps**: Set completion timestamps in action (`change set_attribute(:processed_at, &DateTime.utc_now/0)`)

### Queue Configuration

- **Multiple Queues**: Define queues in Oban config with concurrency limits: `queues: [default: 10, critical: 20, low_priority: 5]`
- **Queue Isolation**: Each queue runs independently - slow jobs in one queue don't block others
- **Queue Assignment**: Assign triggers to appropriate queues based on priority and concurrency needs
- **Critical Jobs**: Use higher concurrency queue for time-sensitive jobs (payment processing, notifications)
- **Bulk Jobs**: Use lower concurrency queue for resource-intensive jobs (imports, exports, reports)

### Retry and Error Handling

- **Automatic Retries**: Oban retries failed jobs automatically using exponential backoff (15s base + jitter)
- **max_attempts**: Configure per-trigger - defaults to 20 retries but usually set lower (3-5)
- **Backoff Algorithm**: Exponential backoff with jitter prevents thundering herd on retries
- **Permanent Failure**: After max_attempts exhausted, job moves to `:discarded` state
- **Error Inspection**: Use Oban Web dashboard or telemetry to inspect failed jobs and error messages
- **Manual Retry**: Can manually retry discarded jobs via Oban.retry_job/1 or dashboard

### Unique Jobs

- **Prevent Duplicates**: Use `unique: [period: 60, fields: [:args, :worker]]` to prevent duplicate jobs
- **Period**: Specify seconds until job no longer considered duplicate (always set explicitly, defaults to 60)
- **Fields**: Determine uniqueness by `:args`, `:queue`, `:worker`, `:meta` (defaults to `[:worker, :queue, :args]`)
- **Use Cases**: Prevent double-processing from duplicate triggers, rate-limit recurring jobs, ensure single active job per resource
- **Replace Strategy**: Use `unique: [period: 60, states: [:available, :scheduled], replace: [:scheduled]]` to replace older scheduled jobs

### Priority

- **Priority Range**: Integer from 0 (highest) to 9 (lowest), defaults to 0
- **Set in Trigger**: Configure `priority 1` in trigger definition for consistent prioritization
- **Queue vs Priority**: Queues provide hard isolation, priority orders jobs within a queue
- **Use Sparingly**: Most jobs should use default priority - only use for truly critical or truly low-priority work

### Testing Background Jobs

- **Test Actions Not Workers**: Test the update action directly, not Oban worker execution
- **Use Oban Testing Mode**: Set `Oban.config(testing: :inline)` in test.exs for synchronous execution
- **Manual Mode**: Use `testing: :manual` to assert job enqueueing without executing
- **Integration Tests**: Test full flow including job execution with `Oban.drain_queue(:queue_name)`
- **Verify Enqueueing**: In manual mode, use `assert_enqueued worker: WorkerModule, args: %{...}`
- **Test Retries**: Simulate failures and verify retry behavior with appropriate backoff

### Monitoring and Observability

- **Telemetry Integration**: Oban emits telemetry events for job lifecycle (`:start`, `:stop`, `:exception`)
- **Error Reporting**: Integrate with Sentry/Honeybadger to capture job exceptions automatically
- **Job Metrics**: Track job counts, durations, failure rates via telemetry or Oban Web dashboard
- **Queue Health**: Monitor queue depth and processing rate to detect bottlenecks
- **Graceful Shutdown**: Oban pauses queues and waits for jobs to finish before shutdown (configurable timeout)

### Scheduled Actions (Alternative to Triggers)

- **Generic Actions**: Use `scheduled_action` for jobs not tied to specific resource records
- **Cron Syntax**: `scheduled_action :import, "0 */6 * * *", action: :import` runs every 6 hours
- **No Record Loading**: Scheduled actions don't load records - execute action directly
- **Use Cases**: System-wide imports, cleanup tasks, report generation, external API polling
- **Supports**: Generic actions and create actions (not read, update, destroy)

### AshOban with AshStateMachine

- **Perfect Pairing**: Combine state machines with background jobs for status-driven workflows
- **Trigger on Transition**: Use `change run_oban_trigger(:process)` in state transition actions
- **State in Worker**: Background job action transitions state (`:queued` → `:running` → `:completed`/`:failed`)
- **Retry Pattern**: Define `:retry` transition from `:failed` to `:queued` to re-trigger processing
- **Example**: Order processing (create → queued → processing → shipped), document workflow (submitted → reviewing → approved)

### Transaction Safety

- **Database-Backed**: Oban uses database for job persistence - jobs survive crashes and restarts
- **Transactional Enqueue**: Jobs enqueued in same transaction as resource changes - atomic commit/rollback
- **Outbox Pattern**: Database-backed queuing provides outbox pattern automatically for free
- **Distributed**: Jobs distributed across multiple nodes - any node can process jobs from shared queue

### Common Patterns

- **Welcome Email**: On-demand trigger on user creation (`create :register` with `run_oban_trigger(:send_welcome)`)
- **Cleanup Jobs**: Scheduled trigger to delete old records (`where expr(inserted_at < ago(30, :day))`)
- **Retry Failed Imports**: Scheduled trigger for failed imports (`where expr(status == :failed and attempts < 3)`)
- **State-Driven Processing**: Trigger on state transition to process next workflow step
- **Batch Processing**: Scheduled trigger processes pending records in batches

### Best Practices

- **Explicit Worker Names**: Always set `worker_module_name` to prevent module rename issues
- **Appropriate Queues**: Use multiple queues to separate critical from bulk processing
- **Reasonable Retries**: Set `max_attempts` to 3-5, not default 20 (most jobs won't succeed after 3 failures)
- **Keep Jobs Idempotent**: Jobs should be safe to retry - don't assume first execution
- **Log Context**: Include resource ID and relevant context in job errors for debugging
- **Monitor Queue Depth**: Alert when queue depth exceeds threshold (indicates processing bottleneck)
- **Test Job Execution**: Use `Oban.drain_queue` in integration tests to verify full job lifecycle
- **Use Telemetry**: Hook into Oban telemetry events for observability and alerting

### Common Pitfalls

- **Forgetting worker_module_name**: Renaming trigger breaks existing queued jobs
- **scheduler_cron true for On-Demand**: Setting cron schedule when job should only trigger manually
- **No where Clause on Scheduled Triggers**: Scheduled trigger without filter processes all records repeatedly
- **Catching All Errors**: Rescuing exceptions prevents Oban retry mechanism - let jobs fail naturally
- **Too Many Retries**: Using default 20 max_attempts when 3-5 sufficient for most jobs
- **Single Queue for All Jobs**: Not separating critical from bulk jobs causes priority inversion
- **Not Testing Jobs**: Only testing action logic without verifying job enqueueing and execution
- **Forgetting AshOban.config**: Using standard `{Oban, config}` instead of `{Oban, AshOban.config(domains, config)}`

### Decision Tree

```
Is background processing needed?
├─ YES → Is it tied to a resource action?
│  ├─ YES → Is it triggered by resource changes OR scheduled polling?
│  │  ├─ Resource Changes → ✅ Use on-demand trigger (scheduler_cron false, run_oban_trigger)
│  │  └─ Scheduled Polling → ✅ Use scheduled trigger (scheduler_cron "cron", where clause)
│  └─ NO → Is it a generic scheduled task?
│     ├─ YES → ✅ Use scheduled_action
│     └─ NO → ⚠️  Consider standalone Oban worker (non-domain logic)
└─ NO → ❌ No background job needed
```

### Migration from Standalone Oban Workers

- **Identify Domain Logic**: Find Oban workers that manipulate Ash resources
- **Create Trigger**: Define AshOban trigger with same job logic as action change
- **Replace Oban.insert**: Replace manual `Oban.insert` calls with `run_oban_trigger` in actions
- **Remove Worker Module**: Delete standalone worker after trigger tested and deployed
- **Benefits**: Better domain modeling, co-located logic, declarative configuration, easier testing
