# Oban-Core - Other

**Pages:** 17

---

## Handling Expected Failures

**URL:** https://hexdocs.pm/oban/expected-failures.html

**Contents:**
- Handling Expected Failures
- Use Case: Silencing Initial Notifications for Flaky Services
  - Giving Time to Recover
  - Building Blocks

Reporting job errors by sending notifications to an external service is essential to maintaining application health. While reporting is essential, noisy reports for flaky jobs can become a distraction that gets ignored. Sometimes we expect that a job will error a few times. That could be because the job relies on an external service that is flaky, because it is prone to race conditions, or because the world is a crazy place. Regardless of why a job fails, reporting every failure may be undesirable.

One solution for reducing noisy error notifications is to start reporting only after a job has failed several times. Oban uses Telemetry to make reporting errors and exceptions a simple matter of attaching a handler function. In this example we will extend Honeybadger reporting from the Oban.Telemetry documentation, but account for the number of processing attempts.

To start, we'll define a Reportable protocol with a single reportable?/2 function:

The Reportable protocol has a default implementation which always returns true, meaning it reports all errors. Our application has a FlakyWorker that's known to fail a few times before succeeding. We don't want to see a report until after a job has failed three times, so we'll add an implementation of Reportable within the worker module:

Note that we've also used defstruct [] to make our worker a viable struct. This is necessary for our protocol to dispatch correctly, as protocols consider all modules to be a plain atom.

The final step is to call reportable?/2 from our application's error reporter, passing in the worker module and the attempt number:

Attach the failure handler somewhere in your application.ex module:

With the failure handler attached you will start getting error reports only after the third error.

If a service is especially flaky you may find that Oban's default backoff strategy is too fast. By defining a custom backoff function on the FlakyWorker we can set a linear delay before retries:

Now the first retry is scheduled 60s later, the second 120s later, and so on.

Elixir's powerful primitives of behaviours, protocols and event handling make flexible error reporting seamless and extensible. While our Reportable protocol only considered the number of attempts, this same mechanism is suitable for filtering by any other meta value.

Hex Package Hex Preview (current file) Search HexDocs

Built using ExDoc (v0.38.2) for the Elixir programming language

**Examples:**

Example 1 (python):
```python
defprotocol MyApp.Reportable do
  @fallback_to_any true
  def reportable?(worker, attempt)
end

defimpl MyApp.Reportable, for: Any do
  def reportable?(_worker, _attempt), do: true
end
```

Example 2 (javascript):
```javascript
defmodule MyApp.Workers.FlakyWorker do
  use Oban.Worker

  defstruct []

  defimpl MyApp.Reportable do
    @threshold 3

    def reportable?(_worker, attempt), do: attempt > @threshold
  end

  @impl true
  def perform(%{args: %{"email" => email}}) do
    MyApp.ExternalService.deliver(email)
  end
end
```

Example 3 (python):
```python
defmodule MyApp.ErrorReporter do
  alias MyApp.Reportable

  def handle_event(_, _, meta, _) do
    worker_struct = maybe_get_worker_struct(meta.job.worker)

    if Reportable.reportable?(worker_struct, meta.job.attempt) do
      context = Map.take(meta.job, [:id, :args, :queue, :worker])

      Honeybadger.notify(meta.reason, context, meta.stacktrace)
    end
  end

  def maybe_get_worker_struct(worker) do
    try do
      {:ok, module} = Oban.Worker.from_string(worker)

      struct(module)
    rescue
      UndefinedFunctionError -> worker
    end
  end
end
```

Example 4 (unknown):
```unknown
:telemetry.attach("oban-errors", [:oban, :job, :exception], &ErrorReporter.handle_event/4, nil)
```

---

## Changelog for Oban v2.20

**URL:** https://hexdocs.pm/oban/changelog.html

**Contents:**
- Changelog for Oban v2.20
- 🦋 Update Job
- ❄️ Unique State Groups
- 🪺 Nested Plugin Supervision
- v2.20.1 — 2025-08-15
  - Bug Fixes
- v2.20.0 — 2025-08-13
  - Enhancements
  - Bug Fixes

🌟 Looking for changes to Oban Pro? Check the Oban.Pro Changelog 🌟

This release brings a fantastic new helper function, an optional migration to aid pruning, some stability improvements, and a bevy of documentation updates.

See the Upgrade Guide for optional upgrade instructions.

This introduces the Oban.update_job/2,3 function to simplify updating existing jobs while ensuring data consistency and safety. Previously, updating jobs required manually constructing change operations or complex queries that could lead to race conditions or invalid state changes.

Only a curated subset of job fields, e.g. :args, :max_attempts, :meta, etc. may be updated and they use the same validation rules as insertion to prevent invalid data. Updates are also wrapped in a transaction with locking clauses to prevent concurrent modifications.

The function supports direct map changes:

It also has a convenient function-based mode for dynamic changes:

There are now named unique state groups to replace custom state lists for unique jobs, promoting better uniqueness design and reducing configuration errors.

Previously, developers had to manually specify lists of job states for uniqueness, which was error-prone and could lead to subtle bugs when states were omitted or incorrectly combined. The new predefined groups ensure correctness and consistency across applications.

The new state groups are:

These groups eliminate the risk of accidentally creating incomplete or incorrect state lists that could allow duplicate jobs to be created when they shouldn't be, or prevent valid job creation when duplicates should be allowed.

Plugins and the internal Stager are now nested within a secondary supervision tree to improve system resilience and stability.

Previously, plugins were supervised directly under the main Oban supervisor alongside core process. This meant that plugin failures could potentially impact the entire Oban system, and frequent plugin restarts could trigger cascading failures in the primary supervision tree.

The new supervisor has more lenient restart limits to allow for more plugin restart attempts before giving up. This change makes Oban more robust in production environments where plugins may experience transient failures due to database or connectivity issues.

[Worker] Handle missing fields in unique Worker validation.

Workers that specified keys without fields would fail validation at compile time. Now default values are considered for use Oban.Worker as well 

*[Content truncated]*

**Examples:**

Example 1 (unknown):
```unknown
Oban.update_job(job, %{priority: 0, tags: ["urgent"]})
```

Example 2 (unknown):
```unknown
Oban.update_job(job, fn job ->
  %{meta: Map.put(job.meta, "processed_by", current_node())}
end)
```

---

## Oban.Engines.Dolphin (Oban v2.20.1)

**URL:** https://hexdocs.pm/oban/Oban.Engines.Dolphin.html

**Contents:**
- Oban.Engines.Dolphin (Oban v2.20.1)
- Usage

An engine for running Oban with MySQL (via the MyXQL adapter).

Start an Oban instance using the Dolphin engine:

Hex Package Hex Preview Search HexDocs

Built using ExDoc (v0.38.2) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
Oban.start_link(
  engine: Oban.Engines.Dolphin,
  queues: [default: 10],
  repo: MyApp.Repo
)
```

---

## Oban.Engines.Lite (Oban v2.20.1)

**URL:** https://hexdocs.pm/oban/Oban.Engines.Lite.html

**Contents:**
- Oban.Engines.Lite (Oban v2.20.1)
- Usage

An engine for running Oban with SQLite3.

Start an Oban instance using the Lite engine:

Hex Package Hex Preview Search HexDocs

Built using ExDoc (v0.38.2) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
Oban.start_link(
  engine: Oban.Engines.Lite,
  queues: [default: 10],
  repo: MyApp.Repo
)
```

---

## Oban.Notifier behaviour (Oban v2.20.1)

**URL:** https://hexdocs.pm/oban/Oban.Notifier.html

**Contents:**
- Oban.Notifier behaviour (Oban v2.20.1)
- Notifiers
- Channels
- Examples
- Summary
- Types
- Callbacks
- Functions
- Types
- channel()

The Notifier coordinates listening for and publishing notifications for events in predefined channels.

Oban functions such as pause_queue, scale_queue, and cancel_job all require a connected notifier to operate. Use status/1 to check the notifier's connectivity status and diagnose issues.

Every Oban supervision tree contains a notifier process, registered as Oban.Notifier, which is an implementation of the Oban.Notifier behaviour.

Choosing a notifer comes with some tradeoffs; see each module for details.

Oban.Notifiers.Postgres — A Postgres notifier that uses LISTEN/NOTIFY to broadcast messages.

Oban.Notifiers.PG — A process groups notifier that relies on Distributed Erlang to broadcast messages.

Oban.Notifiers.Phoenix — A notifier that uses Phoenix.PubSub to broadcast messages. In addition to centralizing PubSub communications, it opens up the possible transports to all PubSub adapters.

All incoming notifications are relayed through the notifier to any processes listening on a given channel. Internally, Oban uses a variety of predefined channels with distinct responsibilities:

insert — as jobs are inserted an event is published on the insert channel. Processes such as queue producers use this as a signal to dispatch new jobs.

leader — messages regarding node leadership exchanged between peers

signal — instructions to take action, such as scale a queue or kill a running job, are sent through the signal channel

sonar — periodic notification checks to monitor pubsub health and determine connectivity

Broadcasting after a job is completed:

Listening for job complete events from another process:

Register the current process to receive messages from one or more channels.

Broadcast a notification to all subscribers of a channel.

Starts a notifier instance.

Unregister current process from channels.

Register the current process to receive relayed messages for the provided channels.

Broadcast a notification to listeners on all nodes.

Check a notifier's connectivity level to see whether it's able to publish or receive messages from other nodes.

Unregister the current process from receiving relayed messages on provided channels.

Register the current process to receive messages from one or more channels.

Broadcast a notification to all subscribers of a channel.

Starts a notifier instance.

Unregister current process from channels.

Register the current process to receive relayed messages for the provided channels.

All messages are received as J

*[Content truncated]*

**Examples:**

Example 1 (python):
```python
defmodule MyApp.Worker do
  use Oban.Worker

  @impl Oban.Worker
  def perform(job) do
    :ok = MyApp.do_work(job.args)

    Oban.Notifier.notify(Oban, :my_app_jobs, %{complete: job.id})

    :ok
  end
end
```

Example 2 (javascript):
```javascript
def insert_and_listen(args) do
  :ok = Oban.Notifier.listen([:my_app_jobs])

  {:ok, %{id: job_id} = job} =
    args
    |> MyApp.Worker.new()
    |> Oban.insert()

  receive do
    {:notification, :my_app_jobs, %{"complete" => ^job_id}} ->
      IO.puts("Other job complete!")
  after
    30_000 ->
      IO.puts("Other job didn't finish in 30 seconds!")
  end
end
```

Example 3 (unknown):
```unknown
{:notification, channel :: channel(), decoded :: map()}
```

Example 4 (unknown):
```unknown
Oban.Notifier.listen(:gossip)
```

---

## Oban.Peers.Database (Oban v2.20.1)

**URL:** https://hexdocs.pm/oban/Oban.Peers.Database.html

**Contents:**
- Oban.Peers.Database (Oban v2.20.1)
- Usage

A peer that coordinates centrally through a database table.

Database peers don't require clustering through distributed Erlang or any other interconnectivity between nodes. Leadership is coordinated through the oban_peers table in your database. With a standard Oban config the oban_peers table will only have one row, and that node is the leader.

Applications that run multiple Oban instances will have one row per instance. For example, an umbrella application that runs Oban.A and Oban.B will have two rows in oban_peers.

This is the default peer for the Basic and Dolphin engines and no configuration is necessary. However, to be explicit, specify the Database peer in your configuration.

Hex Package Hex Preview Search HexDocs

Built using ExDoc (v0.38.2) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
config :my_app, Oban,
  peer: Oban.Peers.Database,
  ...
```

---

## Upgrading to v2.11

**URL:** https://hexdocs.pm/oban/v2-11.html

**Contents:**
- Upgrading to v2.11
- Bump Your Deps
- Run Oban.Migrations for v11
- Update Notifier Names
- Check Configuration for Multi-Node Setups
- Swap the Compound Index (Optional, but Recommended)

This Oban release includes a required migration and a couple of optional, but recommended, changes.

Update Oban, Web, and Pro to the latest versions:

Oban's new leadership mechanism uses an unlogged table to track state globally. The v11 migration creates a new oban_peers table, and is required for leadership—without it many plugins won't run.

To get started, create a migration to create the table:

Within the generated migration module:

If you have multiple Oban instances or use an alternate prefix you'll need to run the migration for each prefix.

The Oban.Peer module will safely handle a missing oban_peers table and log a warning.

Now that we've pulled the PG notifier in from Oban Pro there are a few naming changes you should make.

This release introduces centralized leadership through the Oban.Peer behaviour. To prevent duplicate plugin work across nodes, only one Oban instance within a cluster may be the leader. Unfortunately, if a node that doesn't run plugins becomes the leader then jobs may get stuck as available and plugins like Cron or Pruner won't run.

The simplest solution is avoid plugins: false altogether:

See the Troubleshooting guide for more context.

Oban uses a single compound index for most queries. The index is comprised of job state, queue, priority, scheduled_at, and id. That single index is flexible enough to power most of Oban's queries. However, the column order is important, and the order created by Oban's migrations isn't optimal in all situations.

If you're experiencing slow plugin queries, e.g. the Stager, then you may benefit from swapping the indexes. To do so, create a migration:

Within the generated migration module:

Be sure to reference the correct prefix if your oban_jobs table uses a prefix other than public.

Hex Package Hex Preview (current file) Search HexDocs

Built using ExDoc (v0.38.2) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
[
  {:oban, "~> 2.11"},
  {:oban_pro, "~> 0.10", repo: "oban"},
  {:oban_web, "~> 2.9", repo: "oban"}
]
```

Example 2 (unknown):
```unknown
$ mix ecto.gen.migration create_oban_peers
```

Example 3 (python):
```python
use Ecto.Migration

def up, do: Oban.Migrations.up(version: 11)

def down, do: Oban.Migrations.down(version: 11)
```

Example 4 (unknown):
```unknown
-notifier: Oban.PostgresNotifier
+notifier: Oban.Notifiers.Postgres
```

---

## Oban.Migration behaviour (Oban v2.20.1)

**URL:** https://hexdocs.pm/oban/Oban.Migration.html

**Contents:**
- Oban.Migration behaviour (Oban v2.20.1)
- Usage
- Isolation with Prefixes
- Migrating Without Ecto
- Summary
- Callbacks
- Functions
- Callbacks
- down(t)
- migrated_version(t)

Migrations create and modify the database tables Oban needs to function.

To use migrations in your application you'll need to generate an Ecto.Migration that wraps calls to Oban.Migration:

Open the generated migration in your editor and call the up and down functions on Oban.Migration:

This will run all of Oban's versioned migrations for your database.

Now, run the migration to create the table:

Migrations between versions are idempotent. As new versions are released, you may need to run additional migrations. To do this, generate a new migration:

Open the generated migration in your editor and call the up and down functions on Oban.Migration, passing a version number:

Oban supports namespacing through PostgreSQL schemas, also called "prefixes" in Ecto. With prefixes your jobs table can reside outside of your primary schema (usually public) and you can have multiple separate job tables.

To use a prefix you first have to specify it within your migration:

The migration will create the "private" schema and all tables, functions and triggers within that schema. With the database migrated you'll then specify the prefix in your configuration:

In some cases, for example if your "private" schema already exists and your database user in production doesn't have permissions to create a new schema, trying to create the schema from the migration will result in an error. In such situations, it may be useful to inhibit the creation of the "private" schema:

If your application uses something other than Ecto for migrations, be it an external system or another ORM, it may be helpful to create plain SQL migrations for Oban database schema changes.

The simplest mechanism for obtaining the SQL changes is to create the migration locally and run mix ecto.migrate --log-migrations-sql. That will log all of the generated SQL, which you can then paste into your migration system of choice.

Alternatively, if you'd like a more automated approach, try using the oban_migations_sql project to generate up and down SQL migrations for you.

Migrates storage down to the previous version.

Identifies the last migrated version.

Migrates storage up to the latest version.

Run the down changes for all migrations between the current version and the initial version.

Check the latest version the database is migrated to.

Run the up changes for all migrations between the initial version and the current version.

Migrates storage down to the previous version.

Identifies the last migrat

*[Content truncated]*

**Examples:**

Example 1 (unknown):
```unknown
mix ecto.gen.migration add_oban
```

Example 2 (python):
```python
defmodule MyApp.Repo.Migrations.AddOban do
  use Ecto.Migration

  def up, do: Oban.Migrations.up()

  def down, do: Oban.Migrations.down()
end
```

Example 3 (unknown):
```unknown
mix ecto.migrate
```

Example 4 (unknown):
```unknown
mix ecto.gen.migration upgrade_oban_to_v13
```

---

## Clustering

**URL:** https://hexdocs.pm/oban/clustering.html

**Contents:**
- Clustering
- Leadership and Peer Configuration
  - How Leadership Works
  - Available Peer Implementations
  - Configuring Peers

Oban supports running in clusters of nodes. It supports both nodes that are connected to each other (via distributed Erlang), as well as nodes that are not connected to each other but that communicate via the database's pubsub mechanism.

Usually, scheduled job management operates in global mode and notifies queues of available jobs via pub/sub to minimize database load. However, when pubsub isn't available, staging switches to a local mode where each queue polls independently.

Local mode is less efficient and will only happen if you're running in an environment where neither PostgreSQL nor PG notifications work. That situation should be rare and limited to the following conditions:

If both of those criteria apply and pubsub notifications won't work, then staging will switch to polling in local mode.

Oban uses a peer-based leadership system to coordinate work across nodes in a cluster. Leadership is essential for preventing duplicate work—only the leader node runs global plugins like Cron, Lifeline, and Stager.

Oban provides two peer implementations:

Oban.Peers.Database — Uses the oban_peers table for leadership coordination. Works in any environment, with or without clustering. This is the default and recommended for production.

Oban.Peers.Global — Uses Erlang's :global module for leadership. Requires Distributed Erlang, but handles development restarts more gracefully. Recommended for development environments where leadership delays can be problematic.

A third, psuedo, mode is to disable leadership entirely with peer: false or plugins: false. This is useful when you explicitly don't want a node to become leader (e.g., web-only nodes that don't run plugins).

Hex Package Hex Preview (current file) Search HexDocs

Built using ExDoc (v0.38.2) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
# Use in development for faster leadership transitions
config :my_app, Oban,
  peer: Oban.Peers.Global,
  ...

# Disable leadership on web-only nodes that don't run plugins
config :my_app, Oban,
  peer: false,
  ...
```

---

## Scaling Applications

**URL:** https://hexdocs.pm/oban/scaling.html

**Contents:**
- Scaling Applications
- Notifications
- Triggers
- Uniqueness
    - 🌟 Pro Uniqueness
- Reindexing
- Pruning
    - 🌟 Partitioning
- Pooling
- High Concurrency

Oban uses PubSub notifications for communication between nodes, like job inserts, pausing queues, resuming queues, and metrics for Web. The default notifier is Oban.Notifiers.Postgres, which sends all messages through the database. This provides transactional consistency, but Postgres' notifications adds up at scale because each one requires a separate query.

If you're clustered, consider switching to an alternative notifier like Oban.Notifiers.PG. That keeps notifications out of the db, reduces total queries, and allows larger messages, with the tradeoff that notifications from within a database transaction may be sent even if the transaction is rolled back. As long as you have a functional Distributed Erlang cluster, switching is a single line change to your Oban config.

If you're not clustered, consider using Oban.Notifiers.Phoenix to send notifications through an alternative service like Redis.

Inserting jobs emits a trigger notification to let queues know there are jobs to process immediately, without waiting up to 1s for the next polling interval. Triggers may create many notifications for active queues.

Evaluate if you need sub-second job dispatch. Without it, jobs may wait up to 1s before running, but that’s not a concern for busy queues since they’re constantly fetching and dispatching.

Disable triggers in your Oban configuration:

Frequently, people set uniqueness for jobs that don’t really need it. Not you, of course. Before setting uniqueness, ensure the following, in a very checklist type fashion:

If you're still committed to setting uniquness for your jobs, consider tweaking your configuration as follows:

Oban Pro uses an alternative mechanism for unique jobs that works for bulk inserts, and is designed for speed, correctness, scalability, and simplicity. Uniqueness is enforced and makes insertion entirely safe between processes and nodes, without the load added by multiple queries.

To stop oban_jobs indexes from taking up so much space on disk, use the Oban.Plugins.Reindexer plugin to rebuild indexes periodically. The Postgres transactional model applies to indexes as well as tables. That leaves bloat from inserting, updating, and deleting jobs that auto-vacuuming won’t always fix.

The reindexer rebuilds key indexes on a fixed schedule, concurrently. Concurrent rebuilds are low impact, they don’t lock the table, and they free up space while optimizing indexes.

The Oban.Plugins.Reindexer plugin is part of OSS Oban. It runs every day

*[Content truncated]*

**Examples:**

Example 1 (unknown):
```unknown
config :my_app, Oban,
+  notifier: Oban.Notifiers.PG,
```

Example 2 (unknown):
```unknown
config :my_app, Oban,
+  insert_trigger: false,
```

Example 3 (unknown):
```unknown
use Oban.Worker, unique: [
-   period: {1, :hour},
+   period: :infinity,
+   keys: [:some_key]
```

Example 4 (unknown):
```unknown
config :my_app, Oban,
   plugins: [
+   {Oban.Plugins.Reindexer, schedule: "@weekly"},
    …
   ]
```

---

## Migrating from Other Languages

**URL:** https://hexdocs.pm/oban/migrating-from-other-languages.html

**Contents:**
- Migrating from Other Languages
- Use Case: Inserting Jobs from Rails
- Safety Guaranteed

Migrating background jobs to Elixir is easy with Oban because everything lives in your PostgreSQL database. Oban relies on a structured oban_jobs table as its job queue, and purposefully uses JSON as a portable data structures for serialization. That makes enqueueing jobs into Oban simple for any language with a PostgreSQL adapter—no Oban client necessary.

It's no secret that Ruby to Elixir is a common migration path for developers and existing applications alike. Let's explore how to write an adapter for inserting Oban jobs from a Rails application.

To start, define a skeletal ActiveRecord model with a few conveniences for scheduling jobs:

The insert class method is a convenience that uses named arguments to force passing a worker while providing some defaults. The only semi-magical thing within insert is determining the correct state for scheduled jobs. In Oban, jobs that are ready to execute have an available state, while jobs slated for the future are scheduled.

To insert a single job using the insert class method:

Provided your Elixir application has a worker named MyWorker and the default queue is running, Oban will pick up and execute the job immediately. To schedule the job to run a minute in the future instead, pass a scheduled_at timestamp:

Now, if you're using Rails 6+, you can also use insert_all to batch insert jobs:

Most columns in oban_jobs have sensible defaults, so only the worker and args are typically required. For integrity, all required columns are marked as NON NULL, and several have CHECK constraints as well for extra enforcement.

That's all you need to start migrating background jobs from Rails to Elixir (if you're using Oban, that is). Naturally, the same pattern would work for Python, Node, PHP, or any other language with a Postgres adapter.

Hex Package Hex Preview (current file) Search HexDocs

Built using ExDoc (v0.38.2) for the Elixir programming language

**Examples:**

Example 1 (python):
```python
class Oban::Job < ApplicationRecord
  # This column is in use, but not used for the insert workflow.
  self.ignored_columns = %w[errors]

  # A simple wrapper around `create` that ensures the job is scheduled immediately.
  def self.insert(worker:, args: {}, queue: "default", scheduled_at: nil)
    create(
      worker: worker,
      queue: queue,
      args: args,
      scheduled_at: scheduled_at || Time.now.utc,
      state: scheduled_at ? "scheduled" : "available"
    )
  end
end
```

Example 2 (unknown):
```unknown
Oban::Job.insert(worker: "MyWorker", args: {id: 1}, queue: "default")
```

Example 3 (unknown):
```unknown
Oban::Job.insert(worker: "MyWorker", args: {id: 1}, scheduled_at: 1.minute.from_now.utc)
```

Example 4 (unknown):
```unknown
Oban::Job.insert_all([
  {worker: "MyWorker", args: {id: 1}, queue: "default"},
  {worker: "MyWorker", args: {id: 2}, queue: "default"},
  {worker: "MyWorker", args: {id: 3}, queue: "default"},
])
```

---

## Instrumentation and Logging

**URL:** https://hexdocs.pm/oban/instrumentation.html

**Contents:**
- Instrumentation and Logging
- Default Logger
- Custom Handlers

Oban provides integration with Telemetry, a dispatching library for metrics and instrumentation. It is easy to report Oban metrics to any backend by attaching to Telemetry events prefixed with :oban.

The Oban.Telemetry module provides a robust structured logger that handles all of Oban's telemetry events. As in the example above, attach it within your application module:

For more details on the default structured logger and information on event metadata see docs for the Oban.Telemetry module.

Here is an example of an unstructured log handler:

Attach the handler to success and failure events in your application's Application.start/2 callback (usually in lib/my_app/application.ex):

Hex Package Hex Preview (current file) Search HexDocs

Built using ExDoc (v0.38.2) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
:ok = Oban.Telemetry.attach_default_logger()
```

Example 2 (python):
```python
defmodule MyApp.ObanLogger do
  require Logger

  def handle_event([:oban, :job, :start], measure, meta, _) do
    Logger.warning("[Oban] :started #{meta.worker} at #{measure.system_time}")
  end

  def handle_event([:oban, :job, event], measure, meta, _) do
    Logger.warning("[Oban] #{event} #{meta.worker} ran in #{measure.duration}")
  end
end
```

Example 3 (python):
```python
def start(_type, _args) do
  events = [
    [:oban, :job, :start],
    [:oban, :job, :stop],
    [:oban, :job, :exception]
  ]

  :telemetry.attach_many("oban-logger", events, &MyApp.ObanLogger.handle_event/4, [])

  Supervisor.start_link(...)
end
```

---

## Oban.Telemetry (Oban v2.20.1)

**URL:** https://hexdocs.pm/oban/Oban.Telemetry.html

**Contents:**
- Oban.Telemetry (Oban v2.20.1)
- Initialization Events
- Job Events
    - Metadata
- Engine Events
    - Metadata
- Notifier Events
    - Metadata
    - Metadata
- Plugin Events

Telemetry integration for event metrics, logging and error reporting.

Oban emits the following telemetry event when an Oban supervisor is started:

The initialization event contains the following measurements:

The initialization event contains the following metadata:

Oban emits the following telemetry events for each job:

All job events share the same details about the job that was executed. In addition, failed jobs provide the error type, the error itself, and the stacktrace. The following chart shows which metadata you can expect for each event:

For :exception events the metadata also includes details about what caused the failure.

:kind — describes how an error occurred. Here are the possible kinds:

:reason — a raised exception, wrapped crash, or wrapped error that caused the job to fail. Raised exceptions are passes as is, crashes are wrapped in an Oban.CrashError, timeouts in Oban.TimeoutError, and all other errors are normalized into an Oban.PerformError.

:stacktrace — the Exception.stacktrace/0 for crashes or raised exceptions. Failures from manual error returns won't contain any application code entries and may have an empty stacktrace.

Oban emits telemetry span events for the following Engine operations:

[:oban, :engine, :init, :start | :stop | :exception]

[:oban, :engine, :refresh, :start | :stop | :exception]

[:oban, :engine, :put_meta, :start | :stop | :exception]

[:oban, :engine, :check_available, :start | :stop | :exception]

Events for bulk operations also include :jobs for the :stop event:

[:oban, :engine, :cancel_all_jobs, :start | :stop | :exception]

[:oban, :engine, :delete_all_jobs, :start | :stop | :exception]

[:oban, :engine, :fetch_jobs, :start | :stop | :exception]

[:oban, :engine, :insert_all_jobs, :start | :stop | :exception]

[:oban, :engine, :prune_jobs, :start | :stop | :exception]

[:oban, :engine, :rescue_jobs, :start | :stop | :exception]

[:oban, :engine, :retry_all_jobs, :start | :stop | :exception]

[:oban, :engine, :stage_jobs, :start | :stop | :exception]

Events for job-level Engine operations also include the job, with the exception of :insert_job, :start, because the job isn't available yet.

[:oban, :engine, :cancel_job, :start | :stop | :exception]

[:oban, :engine, :complete_job, :start | :stop | :exception]

[:oban, :engine, :delete_job, :start | :stop | :exception]

[:oban, :engine, :discard_job, :start | :stop | :exception]

[:oban, :engine, :error_job, :start | :stop | :exception]

[:oban, :en

*[Content truncated]*

**Examples:**

Example 1 (unknown):
```unknown
{
  "args":{"action":"OK","ref":1},
  "attempt":1,
  "duration":4327295,
  "event":"job:stop",
  "id":123,
  "max_attempts":20,
  "meta":{},
  "queue":"alpha",
  "queue_time":3127905,
  "source":"oban",
  "state":"success",
  "tags":[],
  "worker":"Oban.Integration.Worker"
}
```

Example 2 (python):
```python
defmodule MicroLogger do
  require Logger

  def handle_event([:oban, :job, :exception], %{duration: duration}, meta, nil) do
    Logger.warning("[#{meta.queue}] #{meta.worker} failed in #{duration}")
  end
end

:telemetry.attach("oban-logger", [:oban, :job, :exception], &MicroLogger.handle_event/4, nil)
```

Example 3 (python):
```python
defmodule ErrorReporter do
  def handle_event([:oban, :job, :exception], _, %{attempt: attempt} = meta, _) do
    if attempt >= 3 do
      context = Map.take(meta, [:id, :args, :queue, :worker])

      Honeybadger.notify(meta.reason, metadata: context, stacktrace: meta.stacktrace)
    end
  end
end

:telemetry.attach("oban-errors", [:oban, :job, :exception], &ErrorReporter.handle_event/4, [])
```

Example 4 (unknown):
```unknown
Oban.Telemetry.attach_default_logger()
```

---

## Upgrading to v2.6

**URL:** https://hexdocs.pm/oban/v2-6.html

**Contents:**
- Upgrading to v2.6
- Bump Your Deps
- Switch to the SmartEngine
- Start Gossiping
- Remove the Workflow Manager
- Remove Extra Lifeline Options
- Drop the Beats Table

For Oban OSS users the v2.6 upgrade is a drop in replacement—there isn't anything to do! However, Web+Pro users will need to make some changes to unlock the goodness of engines.

Update Oban, Web, and Pro to the latest versions:

Be sure to specify both :oban_web and :oban_pro if you use them both. There aren't any dependencies between Web and Pro now. That means you're free to use Pro for workers and only include Web for Phoenix servers, etc.

The SmartEngine uses centralized records to track and exchange state globally, enabling features such as global concurrency.

First, create a migration to add the new oban_producers table:

Within the migration module:

If you have multiple Oban instances or use prefixes, you can specify the prefix and create multiple tables in one migration:

Next, update your config to use the SmartEngine:

If you have multiple Oban instances you need to configure each one to use the SmartEngine, otherwise they'll default to the Basic engine.

Oban Pro no longer writes heartbeat records to oban_beats. Instead, any Oban instance that runs queues must use the Gossip plugin to broadcast status via PubSub.

To start, include the Gossip plugin in your Oban config:

With the default configuration the plugin will broadcast every 1 second. If that is too frequent you can configure the interval:

Due to an improvement in how configuration is passed to workers the WorkflowManager plugin is no longer needed. You can remove it from your list of plugins:

The Lifeline plugin is simplified and doesn't accept as many configuration options. If you previously configured the record_interval or delete_interval you can remove them:

Once you've rolled out the switch to producer records, the smart engine and the gossip plugin you are free to remove the oban_beats table at your discretion (preferably in a follow up release, to prevent errors):

Within the generated migration module:

Hex Package Hex Preview (current file) Search HexDocs

Built using ExDoc (v0.38.2) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
[
  {:oban, "~> 2.6"},
  {:oban_web, "~> 2.6", repo: "oban"},
  {:oban_pro, "~> 0.7", repo: "oban"}
  ...
]
```

Example 2 (unknown):
```unknown
$ mix ecto.gen.migration add_oban_producers
```

Example 3 (unknown):
```unknown
use Ecto.Migration

defdelegate change, to: Oban.Pro.Migrations.Producers
```

Example 4 (python):
```python
use Ecto.Migration

def change do
  Oban.Pro.Migrations.Producers.change()
  Oban.Pro.Migrations.Producers.change(prefix: "special")
  Oban.Pro.Migrations.Producers.change(prefix: "private")
end
```

---

## Operational Maintenance

**URL:** https://hexdocs.pm/oban/operational_maintenance.html

**Contents:**
- Operational Maintenance
- Understanding Job Persistence
- Pruning Historic Jobs
    - How Pruning Works
- Indexes
    - Understanding Oban Indexes
    - Using the Reindexer Plugin
  - Caveats & Guidelines

This guide walks you through maintaining a production Oban setup from an operational perspective. Proper maintenance ensures your job processing system remains efficient, responsive, and reliable over time.

Oban stores all jobs in the database, which offers several advantages:

However, this persistence strategy means that without proper maintenance, your job table will grow indefinitely.

Job stats and queue introspection are built on keeping job rows in the database after they have completed. This allows administrators to review completed jobs and build informative aggregates, at the expense of storage and an unbounded table size. To prevent the oban_jobs table from growing indefinitely, Oban actively prunes completed, cancelled, and discarded jobs.

By default, the pruner plugin retains jobs for 60 seconds. You can configure a longer retention period by providing a :max_age in seconds to the pruner plugin.

The pruner plugin periodically runs SQL queries to delete jobs that:

This happens in the background without impacting job execution.

Oban relies on database indexes to efficiently query and process jobs. As the oban_jobs table experiences high write activity, index bloat and fragmentation can occur over time, potentially degrading performance.

Oban creates several important indexes on the oban_jobs table:

With heavy usage, these indexes can become less efficient due to:

Oban provides a dedicated plugin for maintaining index health: Oban.Plugins.Reindexer. This plugin periodically rebuilds indexes concurrently to ensure optimal performance.

To enable automatic index maintenance, add the Reindexer to your Oban configuration:

Pruning is best-effort and performed out-of-band. This means that all limits are soft; jobs beyond a specified age may not be pruned immediately after jobs complete.

Pruning is only applied to jobs that are completed, cancelled, or discarded. It'll never delete a new job, a scheduled job, or a job that failed and will be retried.

Schedule reindexing during low-traffic periods when possible because it can be resource-intensive.

Hex Package Hex Preview (current file) Search HexDocs

Built using ExDoc (v0.38.2) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
config :my_app, Oban,
  plugins: [{Oban.Plugins.Pruner, max_age: _5_minutes_in_seconds = 300}],
  # ...
```

Example 2 (unknown):
```unknown
config :my_app, Oban,
  plugins: [Oban.Plugins.Pruner, Oban.Plugins.Reindexer],
  # ...
```

---

## Instance and Database Isolation

**URL:** https://hexdocs.pm/oban/isolation.html

**Contents:**
- Instance and Database Isolation
- Running Multiple Oban Instances
  - Facades
  - Isolated Instances Via Names
  - Umbrella Apps
- Database Isolation
  - Database Prefixes
  - Dynamic Repositories
  - Ecto Multi-tenancy

This guide will walk you through options for isolating Oban instances as well as Oban database tables.

You can run multiple Oban instances with different prefixes on the same system and have them entirely isolated, provided you give each Oban supervisor a distinct name. You can do this in one of two ways: explicit names or facades.

You can create an Oban facade by defining a module that calls use Oban:

Configure facades through the application environment, for example in config/config.exs:

You can then start these facades in your application's supervision tree:

Oban facades define all the functions that the Oban module defines, so use the facade in place of Oban:

Here we configure our application to start three Oban supervisors using the "public" (default), "special", and "private" prefixes, respectively:

When you do this, you'll have to use the correct Oban supervisor name when performing Oban-related operations. You'll see that most functions in the Oban module, for example, take an optional first argument which represents the name of the Oban supervisor. By default, that's Oban, which is why this works if you don't explicitly start an Oban supervisor in your application:

In the example above, with ObanA/ObanB/ObanC, you can specify which Oban instance you want to use for scheduling by passing its name in:

If you need to run Oban from an umbrella application where more than one of the child apps need to interact with Oban, you may need to set the :name for each child application that configures Oban.

For example, your umbrella contains two apps: MyAppA and MyAppB. MyAppA is responsible for inserting jobs, while only MyAppB actually runs any queues.

Configure Oban with a custom name for MyAppA:

Then configure Oban for MyAppB with a different name and different options:

Now, use the configured name when calling functions like Oban.insert/2, Oban.insert_all/2, Oban.drain_queue/2, and so on, to reference the correct Oban process for the current application.

Let's look at a few options for isolating or scoping Oban database queries.

Oban supports namespacing through PostgreSQL schemas, also called "prefixes" in Ecto. With prefixes, your job table can reside outside of your primary schema (usually public) and you can have multiple separate job tables.

To use a prefix you first have to specify it within your migration:

The migration will create the private schema and all Oban-related tables within that schema. With the database migrated, you'll

*[Content truncated]*

**Examples:**

Example 1 (unknown):
```unknown
defmodule MyApp.ObanA do
  use Oban, otp_app: :my_app
end

defmodule MyApp.ObanB do
  use Oban, otp_app: :my_app
end
```

Example 2 (unknown):
```unknown
config :my_app, MyApp.ObanA, repo: MyAppo.Repo, prefix: "special"
config :my_app, MyApp.ObanB, repo: MyAppo.Repo, prefix: "private"
```

Example 3 (python):
```python
@impl true
def start(_type, _args) do
  children = [
    MyApp.Repo,
    MyApp.ObanA,
    MyApp.ObanB
  ]

  Supervisor.start_link(children, strategy: :one_for_one, name: MyApp.Supervisor)
end
```

Example 4 (unknown):
```unknown
MyApp.ObanA.insert(MyApp.Worker.new(%{}))
```

---

## Oban.Registry (Oban v2.20.1)

**URL:** https://hexdocs.pm/oban/Oban.Registry.html

**Contents:**
- Oban.Registry (Oban v2.20.1)
- Summary
- Types
- Functions
- Types
- key()
- role()
- value()
- Functions
- config(oban_name)

Local process storage for Oban instances.

Fetch the config for an Oban supervisor instance.

Find the {pid, value} pair for a registered Oban process.

Select details of registered Oban processes using a full match spec.

Build a via tuple suitable for calls to a supervised Oban process.

Returns the pid of a supervised Oban process, or nil if the process can't be found.

Fetch the config for an Oban supervisor instance.

Get the default instance config:

Get config for a custom named instance:

Find the {pid, value} pair for a registered Oban process.

Get the default instance config:

Get a supervised module's pid:

Select details of registered Oban processes using a full match spec.

Get a list of all running Oban instances:

Build a via tuple suitable for calls to a supervised Oban process.

For an Oban supervisor:

For a supervised module:

Returns the pid of a supervised Oban process, or nil if the process can't be found.

Get the Oban supervisor's pid:

Get a supervised module's pid:

Get the pid for a plugin:

Get the pid for a queue's producer:

Hex Package Hex Preview Search HexDocs

Built using ExDoc (v0.38.2) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
Oban.Registry.config(Oban)
```

Example 2 (unknown):
```unknown
Oban.Registry.config(MyApp.Oban)
```

Example 3 (unknown):
```unknown
Oban.Registry.lookup(Oban)
```

Example 4 (unknown):
```unknown
Oban.Registry.lookup(Oban, Oban.Notifier)
```

---
