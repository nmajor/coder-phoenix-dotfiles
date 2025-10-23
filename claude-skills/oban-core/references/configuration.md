# Oban-Core - Configuration

**Pages:** 13

---

## Oban.Notifiers.Postgres (Oban v2.20.1)

**URL:** https://hexdocs.pm/oban/Oban.Notifiers.Postgres.html

**Contents:**
- Oban.Notifiers.Postgres (Oban v2.20.1)
    - Connection Pooling
- Usage
  - Transactions and Testing
- Summary
- Functions
- Functions
- handle_call(arg, from, state)
- handle_connect(state)
- handle_disconnect(state)

A Postgres LISTEN/NOTIFY based Notifier.

Postgres PubSub is fine for most applications, but it doesn't work with connection poolers like PgBouncer when configured in transaction or statement mode, which is standard. Notifications are required for some core Oban functionality, and you should consider using an alternative notifier such as Oban.Notifiers.PG.

Specify the Postgres notifier in your Oban configuration:

The notifications system is built on PostgreSQL's LISTEN/NOTIFY functionality. Notifications are only delivered after a transaction completes and are de-duplicated before publishing. This means that notifications sent during a transaction will not be sent if the transaction is rolled back, providing consistency; this is the only notifer which provides that guarantee. However, it is not as scalable as other notifiers because each notification requires a separate query and notifications can't exceed 8kb.

Typically, applications run Ecto in sandbox mode while testing, but sandbox mode wraps each test in a separate transaction that's rolled back after the test completes. That means the transaction is never committed, which prevents delivering any notifications.

To test using notifications you must run Ecto without sandbox mode enabled, or use Oban.Notifiers.PG instead.

Hex Package Hex Preview Search HexDocs

Built using ExDoc (v0.38.2) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
config :my_app, Oban,
  notifier: Oban.Notifiers.Postgres,
  ...
```

---

## Oban.Notifiers.PG (Oban v2.20.1)

**URL:** https://hexdocs.pm/oban/Oban.Notifiers.PG.html

**Contents:**
- Oban.Notifiers.PG (Oban v2.20.1)
    - Distributed Erlang
- Usage
- Summary
- Functions
- Functions
- child_spec(init_arg)

A PG (Process Groups) based notifier implementation that runs with Distributed Erlang. This notifier scales much better than Oban.Notifiers.Postgres but lacks its transactional guarantees.

PG requires a functional Distributed Erlang cluster to broadcast between nodes. If your application isn't clustered, then you should consider an alternative notifier such as Oban.Notifiers.Postgres

Specify the PG notifier in your Oban configuration:

By default, all Oban instances using the same prefix option will receive notifications from each other. You can use the namespace option to separate instances that are in the same cluster without changing the prefix:

The namespace may be any term.

Returns a specification to start this module under a supervisor.

Returns a specification to start this module under a supervisor.

Hex Package Hex Preview Search HexDocs

Built using ExDoc (v0.38.2) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
config :my_app, Oban,
  notifier: Oban.Notifiers.PG,
  ...
```

Example 2 (unknown):
```unknown
config :my_app, Oban,
  notifier: {Oban.Notifiers.PG, namespace: :custom_namespace}
  ...
```

---

## Ready for Production

**URL:** https://hexdocs.pm/oban/ready_for_production.html

**Contents:**
- Ready for Production
- Logging
- Pruning Jobs
- Rescuing Jobs
- Error Handling
- Ship It!

There are a few additional bits of configuration to consider before you're ready to run Oban in production. In development and test environments, job data is short lived and there's no scale to contend with. Now we'll dig into enabling introspection, external observability, and maintaining database health.

Oban heavily utilizes Telemetry for instrumentation at every level. From job execution, plugin activity, through to every database call there's a telemetry event to hook into.

The simplest way to leverage Oban's telemetry usage is through the default logger, available with Oban.Telemetry.attach_default_logger/1. Attach the logger in your application.ex:

By default, the logger emits JSON encoded logs at the :info level. You can disable encoding and fall back to structured logging with encode: false, or change the log level with the :level option.

For example, to log without encoding at the :debug level:

Job introspection and uniqueness relies on keeping job rows in the database after they have executed. To prevent the oban_jobs table from growing indefinitely, the Oban.Plugins.Pruner plugin provides out-of-band deletion of completed, cancelled and discarded jobs.

Retaining jobs for 7 days is a good starting point, but depending on throughput, you may wish to keep jobs for even longer. Include Pruner in the list of plugins and configure it to retain jobs for 7 days, specified in seconds:

During deployment or unexpected node restarts jobs may be left in an executing state indefinitely. We call these jobs "orphans", but orphaning isn't a bad thing. It means that the job wasn't lost and it may be retried again when the system comes back online.

There are two mechanisms to mitigate orphans:

Even with a higher shutdown_grace_period it's possible to have orphans if there is an unexpected crash or extra long running jobs.

Consider adding the Lifeline plugin and configure it to rescue after a generous period of time, like 30 minutes:

Telemetry events can be used to report issues externally to services like Sentry or AppSignal. Write a handler that sends error notifications to a third party (use a mock, or something that sends a message back to the test process).

You can use exception events to send error reports to Honeybadger, Rollbar, AppSignal, ErrorTracker or any other application monitoring platform.

Some libraries like AppSignal, ErrorTracker or Sentry automatically handle these events without requiring any extra code on your application. You ca

*[Content truncated]*

**Examples:**

Example 1 (unknown):
```unknown
defmodule MyApp.Application do
  use Application

  @impl Application
  def start(_type, _args) do
    Oban.Telemetry.attach_default_logger()

    children = [
      ...
    ]
  end
end
```

Example 2 (unknown):
```unknown
Oban.Telemetry.attach_default_logger(encode: false, level: :debug)
```

Example 3 (unknown):
```unknown
config :my_app, Oban,
  plugins: [
    {Oban.Plugins.Pruner, max_age: 60 * 60 * 24 * 7},
  ...
```

Example 4 (unknown):
```unknown
config :my_app, Oban,
  plugins: [
    {Oban.Plugins.Lifeline, rescue_after: :timer.minutes(30)},
  ...
```

---

## Oban.Peers.Global (Oban v2.20.1)

**URL:** https://hexdocs.pm/oban/Oban.Peers.Global.html

**Contents:**
- Oban.Peers.Global (Oban v2.20.1)
- Usage

A cluster based peer that coordinates through a distributed registry.

Leadership is coordinated through global locks. It requires a functional distributed Erlang cluster, without one global plugins (Cron, Lifeline, etc.) will not function correctly.

Specify the Global peer in your Oban configuration.

Hex Package Hex Preview Search HexDocs

Built using ExDoc (v0.38.2) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
config :my_app, Oban,
  peer: Oban.Peers.Global,
  ...
```

---

## Testing Config

**URL:** https://hexdocs.pm/oban/testing_config.html

**Contents:**
- Testing Config
- Testing Dynamic Config
- Testing Dynamic Plugin Config

An Oban instance's config is built from options passed to Oban.start_link during initialization and it determines the supervision tree that Oban builds. The instance config is encapsulated by an Oban.Config struct, which is then referenced by plugins, queues, and most public functions.

Oban automatically normalizes and validates config options on initialization. That covers any static configuration, but it won't help when config is generated dynamically, at runtime.

The Oban.Config.validate/1 helper is used internally when the config initializes. Along with each top level option, like the :engine or :repo, it recursively verifies all queue and plugin options.

You can use validate/1 to verify dynamic configuration, e.g. options specified in runtime.exs:

When the configuration contains any invalid options, like an invalid engine, you'll see the test fail with an error like this:

Validation is especially helpful for plugins that have complex configuration, e.g. Cron or the Dynamic* plugins from Oban Pro. As of Oban v2.12.0 all plugins implement the Oban.Plugin.validate/1 callback and we can test them in isolation as well as through the top level config.

Suppose you have a helper function that returns a crontab config at runtime:

You can call that function within a test and then assert that it is valid with Oban.Plugin.validate/1:

Running this test will return an error tuple, showing that the cron expression isn't valid.

Switch the expression from 0 24 * * * to 0 23 * * *, run the tests again, and everything passes!

Hex Package Hex Preview (current file) Search HexDocs

Built using ExDoc (v0.38.2) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
test "production oban config is valid" do
  config =
    "config/config.exs"
    |> Config.Reader.read!(env: :prod)
    |> get_in([:my_app, Oban])

  assert :ok = Oban.Config.validate(config)
end
```

Example 2 (unknown):
```unknown
{:error, "expected :engine to be an Oban.Queue.Engine, got: MyApp.Repo"}
```

Example 3 (python):
```python
defmodule MyApp.Oban do
  def cron_config do
    [crontab: [{"0 24 * * *", MyApp.Worker}]]
  end
end
```

Example 4 (unknown):
```unknown
test "testing cron plugin configuration" do
  config = MyApp.Oban.cron_config()

  assert :ok = Oban.Plugins.Cron.validate(config)
end
```

---

## Defining Queues

**URL:** https://hexdocs.pm/oban/defining_queues.html

**Contents:**
- Defining Queues
- Basic Queue Configuration
- Advanced Queue Configuration
  - Paused Queues
- Queue Planning Guidelines
    - Resource Considerations
    - Concurrency and Distribution
    - Queue Planning
    - External Process Considerations

Queues are the foundation of how Oban organizes and processes jobs. They allow you to:

Each queue operates independently with its own set of worker processes and concurrency limits.

Queues are defined as a keyword list where the key is the name of the queue and the value is the maximum number of concurrent jobs. The following configuration would start four queues with concurrency ranging from 5 to 50:

For more control, you can use an expanded form to configure queues with individual overrides:

This expanded configuration demonstrates several advanced options:

When a queue is configured with paused: true, it won't process any jobs until explicitly started. This is useful for:

You can resume a paused queue programmatically:

And pause an active queue:

There isn't a limit to the number of queues or how many jobs may execute concurrently in each queue. However, consider these important guidelines:

Each queue will run as many jobs as possible concurrently, up to the configured limit. Make sure your system has enough resources (such as database connections) to handle the concurrent load.

Consider the total concurrency across all queues. For example, if you have 4 queues with limits of 10, 20, 30, and 40, your system needs to handle up to 100 concurrent jobs, each potentially requiring database connections and other resources.

Only jobs in the configured queues will execute. Jobs in any other queue will stay in the database untouched. Be sure to configure all queues you intend to use.

Organize queues by workload characteristics. For example:

Pay attention to the number of concurrent jobs making expensive system calls (such as calls to resource-intensive tools like FFMpeg or ImageMagick). The BEAM ensures that the system stays responsive under load, but those guarantees don't apply when using ports or shelling out commands.

Consider creating dedicated queues with lower concurrency for jobs that interact with external processes or services that have their own concurrency limitations.

Hex Package Hex Preview (current file) Search HexDocs

Built using ExDoc (v0.38.2) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
config :my_app, Oban,
  queues: [default: 10, mailers: 20, events: 50, media: 5],
  repo: MyApp.Repo
```

Example 2 (unknown):
```unknown
config :my_app, Oban,
  queues: [
    default: 10,
    mailers: [limit: 20, dispatch_cooldown: 50],
    events: [limit: 50, paused: true],
    media: [limit: 1, global_limit: 10]
  ],
  repo: MyApp.Repo
```

Example 3 (unknown):
```unknown
Oban.resume_queue(queue: :events)
```

Example 4 (unknown):
```unknown
Oban.pause_queue(queue: :media)
```

---

## Upgrading to v2.14

**URL:** https://hexdocs.pm/oban/v2-14.html

**Contents:**
- Upgrading to v2.14
- Bump Your Deps
- Remove Repeater and Stager Plugins
- Ensure Configuration for Testing

This Oban release includes a number of configuration changes and deprecations for redundant functionality.

Update Oban (and optionally Pro) to the latest versions:

The Repeater plugin is no longer necessary as the new Stager falls back to polling mode automatically. Remove the Repeater from your plugins:

The Stager is no longer a plugin because it's essential for queue operation. If you've overridden the staging interval:

Now that Stager isn't a plugin, it isn't disabled by plugins: false. Be sure to use the :testing option introduced in v2.12 to automate configuration:

Without this change you may see a flurry of DBConnection.OwnershipError errors during test runs.

Hex Package Hex Preview (current file) Search HexDocs

Built using ExDoc (v0.38.2) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
[
  {:oban, "~> 2.14"},
  {:oban_pro, "~> 0.13", repo: "oban"}
]
```

Example 2 (unknown):
```unknown
plugins: [
   Oban.Plugins.Lifeline,
   Oban.Plugins.Pruner,
-  Oban.Plugins.Repeater
```

Example 3 (unknown):
```unknown
plugins: [
   Oban.Plugins.Lifeline,
   Oban.Plugins.Pruner,
-  {Oban.Plugins.Stager, interval: 5_000}
 ],
+ stage_interval: 5_000
```

Example 4 (unknown):
```unknown
# test.exs
- config :my_app, Oban, queues: false, plugins: false
+ config :my_app, Oban, testing: :manual
```

---

## Periodic Jobs

**URL:** https://hexdocs.pm/oban/periodic_jobs.html

**Contents:**
- Periodic Jobs
- Setting Up Periodic Jobs
- How Periodic Jobs Work
- Cron Expressions
    - Crontab Guru
  - Cron Extensions
  - The @reboot Expression
  - Examples
  - Practical Examples
- Caveats & Guidelines

Periodic jobs allow you to schedule recurring tasks that execute on a predictable schedule. Unlike one-time scheduled jobs, periodic jobs repeat automatically without requiring you to insert new jobs after each execution.

Oban uses a cron plugin to manage these recurring jobs, allowing you to define schedules using familiar cron syntax.

Periodic jobs are declared in your Oban configuration as a list of tuples in one of these formats:

Here's an example configuration:

In this configuration:

The Cron plugin automatically inserts jobs according to the schedule you define. When the time comes for a job to run, Oban:

Jobs are always inserted by the leader node in a cluster, which prevents duplicate jobs regardless of cluster size, restarts, or crashes.

Cron syntax can be difficult to write and read. We recommend using a tool like Crontab Guru to make sense of cron expressions and write new ones.

Standard cron expressions consist of five fields that specify when the job should run:

Each field supports several notation types:

Each part may have multiple rules, where rules are separated by a comma. The allowed values for each field are as follows:

Oban supports these common cron aliases for better readability:

The @reboot expression is special—it runs once when a node becomes the leader, rather than at a specific time. This behavior depends on Oban's leadership system, which can cause unexpected delays in development environments.

In development, when you shut down your application the node may not cleanly relinquish leadership. This creates a delay before the node can become leader again on the next startup, making it appear as though @reboot jobs aren't working.

To avoid this delay in development, you can use the Global peer instead of the default:

The Global peer uses Erlang's global registration, which handles development restarts more gracefully. Keep the default peer in production for better reliability.

Here are some specific examples to help you understand the full range of expressions:

For more in depth information, see the man documentation for cron and crontab in your system.

Timezone Considerations: All schedules are evaluated as UTC unless a different timezone is provided. See Oban.Plugins.Cron documentation for information about configuring a timezone to ensure jobs run at the expected local time.

Dual-Purpose Workers: Workers can be used for both regular one-time jobs and scheduled periodic jobs, as long as they're designed to acce

*[Content truncated]*

**Examples:**

Example 1 (unknown):
```unknown
config :my_app, Oban,
  repo: MyApp.Repo,
  plugins: [
    {Oban.Plugins.Cron,
     crontab: [
       {"* * * * *", MyApp.MinuteWorker},
       {"0 * * * *", MyApp.HourlyWorker, args: %{custom: "arg"}},
       {"0 0 * * *", MyApp.DailyWorker, max_attempts: 1},
       {"0 12 * * MON", MyApp.MondayWorker, queue: :scheduled, tags: ["mondays"]},
       {"@daily", MyApp.AnotherDailyWorker}
     ]}
  ]
```

Example 2 (unknown):
```unknown
┌───────────── minute (0 - 59)
│ ┌───────────── hour (0 - 23)
│ │ ┌───────────── day of the month (1 - 31)
│ │ │ ┌───────────── month (1 - 12 or JAN-DEC)
│ │ │ │ ┌───────────── day of the week (0 - 6 or SUN-SAT)
│ │ │ │ │
│ │ │ │ │
* * * * *
```

Example 3 (unknown):
```unknown
# In config/dev.exs
config :my_app, Oban,
  peer: Oban.Peers.Global,
  ...
```

---

## Upgrading to v2.17

**URL:** https://hexdocs.pm/oban/v2-17.html

**Contents:**
- Upgrading to v2.17
    - Prevent Duplicate Insert Notifications
- Bump Your Deps
- Run Oban.Migrations for v12 (Optional)
- Disable Insert Notifications (Optional)
- Remove the Gossip Plugin

This Oban release includes an optional, but recommended migration.

You must either run the v12 migrations or disable insert triggers in your Oban configuration, otherwise you'll receive duplicate insert notifications for each job.

Update Oban (and optionally Pro) to the latest versions:

The v12 migration removes insert triggers and relaxes the priority column's check constraint to allow values in the new range of 0..9.

To get started, create a migration to create the table:

Within the generated migration module:

If you have multiple Oban instances, or use an alternate prefix, you'll need to run the migration for each prefix.

If you opt not to run the v12 migration to disable Postgres triggers, then you should disable insert notifications in your configuration:

The Gossip plugin is no longer used by Oban Web and now useless. You can safely remove it from your configuration:

Hex Package Hex Preview (current file) Search HexDocs

Built using ExDoc (v0.38.2) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
[
  {:oban, "~> 2.17"},
  {:oban_pro, "~> 1.2", repo: "oban"}
]
```

Example 2 (unknown):
```unknown
$ mix ecto.gen.migration upgrade_oban_jobs_to_v12
```

Example 3 (python):
```python
use Ecto.Migration

def up, do: Oban.Migrations.up(version: 12)

def down, do: Oban.Migrations.down(version: 12)
```

Example 4 (unknown):
```unknown
config :my_app, Oban,
+  insert_trigger: false,
   ...
```

---

## Upgrading to v2.12

**URL:** https://hexdocs.pm/oban/v2-12.html

**Contents:**
- Upgrading to v2.12
- Bump Your Deps
- Modify Configuration for Testing

This Oban release includes a couple of optional configuration changes to aid in testing and development.

Update Oban (and optionally Pro) to the latest versions:

The new :testing option automates configuring an Oban instance for testing. Make the following change to your test.exs to opt into :manual testing mode:

If you'd prefer to run jobs inline as they're inserted, without involving the database, then you can use :inline mode instead:

See the testing guide to learn more about test configuration.

Hex Package Hex Preview (current file) Search HexDocs

Built using ExDoc (v0.38.2) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
[
  {:oban, "~> 2.12"},
  {:oban_pro, "~> 0.11", repo: "oban"}
]
```

Example 2 (unknown):
```unknown
# test.exs
- config :my_app, Oban, queues: false, plugins: false
+ config :my_app, Oban, testing: :manual
```

Example 3 (unknown):
```unknown
config :my_app, Oban, testing: :inline
```

---

## Oban.Engines.Basic (Oban v2.20.1)

**URL:** https://hexdocs.pm/oban/Oban.Engines.Basic.html

**Contents:**
- Oban.Engines.Basic (Oban v2.20.1)
- Usage

The default engine for use with Postgres databases.

This is the default engine, no additional configuration is necessary:

Hex Package Hex Preview Search HexDocs

Built using ExDoc (v0.38.2) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
Oban.start_link(repo: MyApp.Repo, queues: [default: 10])
```

---

## Release Configuration

**URL:** https://hexdocs.pm/oban/release_configuration.html

**Contents:**
- Release Configuration
- Using Config Providers

While having the same Oban configuration for every environment might be fine, there are certainly times you might want to make changes for a specific environment. For example, you may want to increase or decrease a queue's concurrency.

If you are using Elixir Releases, this is straight forward to do using Config Providers:

Our config provider ensures that the Jason app is loaded so that we can parse a JSON configuration file. Once the JSON is loaded we must extract the queues map and convert it to a keyword list where all of the keys are atoms. The use of String.to_atom/1 is safe because all of our queue names are already defined.

Then you include this in your mix.exs file, where your release is configured:

Then when you release your app, you ensure that you have a JSON file mounted at whatever path you specified above and that it contains all of your desired queues:

Hex Package Hex Preview (current file) Search HexDocs

Built using ExDoc (v0.38.2) for the Elixir programming language

**Examples:**

Example 1 (python):
```python
defmodule MyApp.ConfigProvider do
  @moduledoc """
  Provide release configuration for Oban Queue Concurrency
  """

  @behaviour Config.Provider

  def init(path) when is_binary(path), do: path

  def load(config, path) do
    case parse_json(path) do
      nil ->
        config

      queues ->
        Config.Reader.merge(config, ingestion: [{Oban, [queues: queues]}])
    end
  end

  defp parse_json(path) do
    if File.exists?(path) do
      path
      |> File.read!()
      |> JSON.decode!()
      |> Map.fetch!("queues")
      |> Keyword.new(fn {key, value} -> {String.to_atom(key), value} 
...
```

Example 2 (unknown):
```unknown
releases: [
  umbrella_app: [
    version: "0.0.1",
    applications: [
      child_app: :permanent
    ],
    config_providers: [{Path.To.ConfigProvider, "/etc/config.json"}]
  ]
]
```

Example 3 (unknown):
```unknown
{"queues": {"special": 1, "default": 10, "events": 20}}
```

---

## Oban.Config (Oban v2.20.1)

**URL:** https://hexdocs.pm/oban/Oban.Config.html

**Contents:**
- Oban.Config (Oban v2.20.1)
- Summary
- Types
- Functions
- Types
- t()
- Functions
- new(opts)
- Example
- validate(opts)

The Config struct validates and encapsulates Oban instance state.

Typically, you won't use the Config module directly. Oban automatically creates a Config struct on initialization and passes it through to all supervised children with the :conf key.

To fetch a running Oban supervisor's config, see Oban.config/1.

Generate a Config struct after normalizing and verifying Oban options.

Verify configuration options.

Generate a Config struct after normalizing and verifying Oban options.

See Oban.start_link/1 for a comprehensive description of available options.

Generate a minimal config with only a :repo:

Verify configuration options.

This helper is used by new/1, and therefore by Oban.start_link/1, to verify configuration options when an Oban supervisor starts. It is provided publicly to aid in configuration testing, as test config may differ from prod config.

Validating top level options:

Validating plugin options:

Hex Package Hex Preview Search HexDocs

Built using ExDoc (v0.38.2) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
Oban.Config.new(repo: Oban.Test.Repo)
```

Example 2 (unknown):
```unknown
iex> Oban.Config.validate(name: Oban)
:ok

iex> Oban.Config.validate(name: Oban, log: false)
:ok

iex> Oban.Config.validate(node: {:not, :binary})
{:error, "expected :node to be a binary, got: {:not, :binary}"}

iex> Oban.Config.validate(plugins: true)
{:error, "invalid value for :plugins, expected :plugins to be a list, got: true"}
```

Example 3 (unknown):
```unknown
iex> Oban.Config.validate(plugins: [{Oban.Plugins.Pruner, max_age: 60}])
:ok

iex> Oban.Config.validate(plugins: [{Oban.Plugins.Pruner, max_age: 0}])
{:error, "invalid value for :plugins, expected :max_age to be a positive integer, got: 0"}
```

---
