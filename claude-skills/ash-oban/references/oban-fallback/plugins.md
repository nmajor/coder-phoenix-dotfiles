# Oban-Core - Plugins

**Pages:** 5

---

## Oban.Plugins.Lifeline (Oban v2.20.1)

**URL:** https://hexdocs.pm/oban/Oban.Plugins.Lifeline.html

**Contents:**
- Oban.Plugins.Lifeline (Oban v2.20.1)
    - 🌟 DynamicLifeline
- Using the Plugin
- Options
- Instrumenting with Telemetry
- Summary
- Types
- Types
- option()

Naively transition jobs stuck executing back to available.

The Lifeline plugin periodically rescues orphaned jobs, i.e. jobs that are stuck in the executing state because the node was shut down before the job could finish. Rescuing is purely based on time, rather than any heuristic about the job's expected execution time or whether the node is still alive.

If an executing job has exhausted all attempts, the Lifeline plugin will mark it discarded rather than available.

This plugin may transition jobs that are genuinely executing and cause duplicate execution. For more accurate rescuing or to rescue jobs that have exhausted retry attempts see the DynamicLifeline plugin in Oban Pro.

Rescue orphaned jobs that are still executing after the default of 60 minutes:

Override the default period to rescue orphans after a more aggressive period of 5 minutes:

:interval — the number of milliseconds between rescue attempts. The default is 60_000ms.

:rescue_after — the maximum amount of time, in milliseconds, that a job may execute before being rescued. 60 minutes by default, and rescuing is performed once a minute.

The Oban.Plugins.Lifeline plugin adds the following metadata to the [:oban, :plugin, :stop] event:

:rescued_jobs — a list of jobs transitioned back to available

:discarded_jobs — a list of jobs transitioned to discarded

Note: jobs only include id, queue, state fields.

Hex Package Hex Preview Search HexDocs

Built using ExDoc (v0.38.2) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
config :my_app, Oban,
  plugins: [Oban.Plugins.Lifeline],
  ...
```

Example 2 (unknown):
```unknown
config :my_app, Oban,
  plugins: [{Oban.Plugins.Lifeline, rescue_after: :timer.minutes(5)}],
  ...
```

---

## Oban.Peer behaviour (Oban v2.20.1)

**URL:** https://hexdocs.pm/oban/Oban.Peer.html

**Contents:**
- Oban.Peer behaviour (Oban v2.20.1)
- Available Peer Implementations
- Examples
- Summary
- Types
- Callbacks
- Functions
- Types
- conf_or_name()
- option()

The Peer module maintains leadership for a particular Oban instance within a cluster.

Leadership is used by plugins, primarily, to prevent duplicate work across nodes. For example, only the leader's Cron plugin will try inserting new jobs. You can use peer leadership to extend Oban with custom plugins, or even within your own application.

Note a few important details about how peer leadership operates:

Each peer checks for leadership at a 30 second interval. When the leader exits it broadcasts a message to all other peers to encourage another one to assume leadership.

Each Oban instance supervises a distinct Oban.Peer instance. That means that with multiple Oban instances on the same node one instance may be the leader, while the others aren't.

Without leadership, global plugins (Cron, Lifeline, Stager, etc.), will not run on any node.

There are two built-in peering modules:

Oban.Peers.Database — uses table-based leadership through the oban_peers table and works in any environment, with or without clustering. Only one node (per instance name) will have a row in the peers table, that node is the leader. This is the default.

Oban.Peers.Global — coordinates global locks through distributed Erlang, requires distributed Erlang.

You can specify the peering module to use in your Oban configuration:

If in doubt, you can call Oban.config() to see which module is being used.

Check leadership for the default Oban instance:

That is identical to using the name Oban:

Check leadership for a couple of instances:

Check which node's peer instance currently leads the cluster.

Check whether the current peer instance leads the cluster.

Starts a peer instance.

Get the name and node of the instance that currently leads the cluster.

Check whether the current instance leads the cluster.

Check which node's peer instance currently leads the cluster.

Check whether the current peer instance leads the cluster.

Starts a peer instance.

Get the name and node of the instance that currently leads the cluster.

Get the leader node for the default Oban instance:

Get the leader node for an alternate instance named Oban.Private

Check whether the current instance leads the cluster.

Check leadership for the default Oban instance:

Check leadership for an alternate instance named Oban.Private:

Hex Package Hex Preview Search HexDocs

Built using ExDoc (v0.38.2) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
config :my_app, Oban,
  peer: Oban.Peers.Database, # default value
  ...
```

Example 2 (javascript):
```javascript
Oban.Peer.leader?()
# => true
```

Example 3 (javascript):
```javascript
Oban.Peer.leader?(Oban)
# => true
```

Example 4 (javascript):
```javascript
Oban.Peer.leader?(Oban.A)
# => true

Oban.Peer.leader?(Oban.B)
# => false
```

---

## Writing Plugins

**URL:** https://hexdocs.pm/oban/writing_plugins.html

**Contents:**
- Writing Plugins
- Example Plugin
- Calling Interface Functions
- Caveats

Oban supports the use of plugins to extend its base functionality. A plugin is any module that begins a process and exposes a start_link/1 function. That means a plugin may be a GenServer, an Agent, a Task, or any other OTP behaviour that manages a process. Realistically you'll want a long lived process to complement Oban's behaviour, which makes a GenServer or GenStateMachine ideal.

Upon startup, Oban dynamically injects each plugin into its supervision tree and passes a few base options along with any custom configuration for the plugin.

Every plugin receives these base options:

Let's look at a tiny example plugin to get a feel for how options are passed in and how they run. Our plugin will periodically generate a table of counts for each queue / state combination and then print it out. It isn't an amazingly useful plugin, but it demonstrates how to handle options, work with the Oban.Config struct, and periodically interact with the oban_jobs table.

The plugin's start_link/1 function expects a keyword list with :name, :conf, and :interval values. After extracting the :name for process registration, it passes the options through to init/1. The init function converts the keyword list of options into a map for easier access and then begins a polling loop.

Each iteration of the loop will query the oban_jobs table and print out a list of {queue, state, count} tuples like this:

Now all that is left is to adding the Breakdown module to Oban's plugin list:

In the configuration we're only providing the :interval value. Oban injects the :name and :conf automatically.

Plugins are named dynamically using via tuples, which is an effective way to manage process registration for multiple unique Oban instances. However, it makes writing interface functions for plugins a little more complicated. The solution is to make use of the Oban.Registry for process discovery.

Imagine adding a pause interface function to the Breakdown plugin we built above:

The function accepts an oban_name argument with a default of Oban, which is the default name for an Oban supervision tree. It then calls whereis/2 with a {:plugin, plugin_name} tuple and uses the returned pid to call the plugin process.

You can then call pause/1 from elsewhere in the application:

Plugins run directly within Oban's supervision tree. A badly behaving plugin, e.g. a plugin that crashes repeatedly, may bring down the entire supervision tree. Be sure that your plugin has safety mechanisms in place to prev

*[Content truncated]*

**Examples:**

Example 1 (python):
```python
defmodule MyApp.Plugins.Breakdown do
  @behaviour Oban.Plugin

  use GenServer

  import Ecto.Query, only: [group_by: 3, select: 3]

  @impl Oban.Plugin
  def start_link(opts) do
    name = Keyword.get(opts, :name, __MODULE__)

    GenServer.start_link(__MODULE__, opts, name: name)
  end

  @impl Oban.Plugin
  def validate(opts) do
    Oban.Validation.validate_schema(opts,
      conf: :any,
      name: :any,
      interval: :pos_integer
    )
  end

  @impl GenServer
  def init(opts) do
    state = Map.new(opts)

    {:ok, schedule_poll(state)}
  end

  @impl GenServer
  def handle_info(:poll,
...
```

Example 2 (unknown):
```unknown
[
  {"default", "executing", 8},
  {"default", "retryable", 1},
  {"default", "completed", 3114},
  {"default", "discarded", 1},
  {"events", "scheduled", 3},
  {"events", "executing", 21},
  {"events", "retryable", 2},
  {"events", "completed", 1783},
  {"events", "discarded", 1},
]
```

Example 3 (unknown):
```unknown
config :my_app, Oban,
  plugins: [
    {MyApp.Plugins.Breakdown, interval: :timer.seconds(10)}
  ]
  ...
```

Example 4 (python):
```python
alias Oban.Registry

def pause(oban_name \\ Oban) do
  oban_name
  |> Registry.whereis({:plugin, __MODULE__})
  |> GenServer.call(:pause)
end
```

---

## Oban.Plugin behaviour (Oban v2.20.1)

**URL:** https://hexdocs.pm/oban/Oban.Plugin.html

**Contents:**
- Oban.Plugin behaviour (Oban v2.20.1)
- Example
- Summary
- Types
- Callbacks
- Types
- option()
- Callbacks
- format_logger_output(t, map)
- start_link(list)

Defines a shared behaviour for Oban plugins.

In addition to implementing the Plugin behaviour, all plugins must be a GenServer, Agent, or another OTP compliant module.

Defining a basic plugin that satisfies the minimum behaviour:

Format telemetry event meta emitted by the for inclusion in the default logger.

Starts a Plugin process linked to the current process.

Validate the structure, presence, or values of keyword options.

Format telemetry event meta emitted by the for inclusion in the default logger.

Starts a Plugin process linked to the current process.

Plugins are typically started as part of an Oban supervision tree and will receive the current configuration as :conf, along with a :name and any other provided options.

Validate the structure, presence, or values of keyword options.

Hex Package Hex Preview Search HexDocs

Built using ExDoc (v0.38.2) for the Elixir programming language

**Examples:**

Example 1 (python):
```python
defmodule MyPlugin do
  @behaviour Oban.Plugin

  use GenServer

  @impl Oban.Plugin
  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: opts[:name])
  end

  @impl Oban.Plugin
  def validate(opts) do
    if is_atom(opts[:mode])
      :ok
    else
      {:error, "expected opts to have a :mode key"}
    end
  end

  @impl GenServer
  def init(opts) do
    case validate(opts) do
      :ok -> {:ok, opts}
      {:error, reason} -> {:stop, reason}
    end
  end
end
```

---

## Oban.Plugins.Reindexer (Oban v2.20.1)

**URL:** https://hexdocs.pm/oban/Oban.Plugins.Reindexer.html

**Contents:**
- Oban.Plugins.Reindexer (Oban v2.20.1)
- Using the Plugin
- Options
- Summary
- Types
- Types
- option()

Periodically rebuild indexes to minimize database bloat.

Over time various Oban indexes may grow without VACUUM cleaning them up properly. When this happens, rebuilding the indexes will release bloat.

The plugin uses REINDEX with the CONCURRENTLY option to rebuild without taking any locks that prevent concurrent inserts, updates, or deletes on the table.

Note: This plugin requires the CONCURRENTLY option, which is only available in Postgres 12 and above.

By default, the plugin will reindex once a day, at midnight UTC:

To run on a different schedule you can provide a cron expression. For example, you could use the "@weekly" shorthand to run once a week on Sunday:

:indexes — a list of indexes to reindex on the oban_jobs table. Defaults to only the oban_jobs_args_index and oban_jobs_meta_index.

:schedule — a cron expression that controls when to reindex. Defaults to "@midnight".

:timeout - time in milliseconds to wait for each query call to finish. Defaults to 15 seconds.

:timezone — which timezone to use when evaluating the schedule. To use a timezone other than the default of "Etc/UTC" you must have a timezone database like tz installed and configured.

Hex Package Hex Preview Search HexDocs

Built using ExDoc (v0.38.2) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
config :my_app, Oban,
  plugins: [Oban.Plugins.Reindexer],
  ...
```

Example 2 (unknown):
```unknown
config :my_app, Oban,
  plugins: [{Oban.Plugins.Reindexer, schedule: "@weekly"}],
  ...
```

---
