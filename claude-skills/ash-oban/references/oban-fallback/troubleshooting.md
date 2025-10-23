# Oban-Core - Troubleshooting

**Pages:** 3

---

## Oban.CrashError exception (Oban v2.20.1)

**URL:** https://hexdocs.pm/oban/Oban.CrashError.html

**Contents:**
- Oban.CrashError exception (Oban v2.20.1)

Wraps unhandled exits and throws that occur during job execution.

Hex Package Hex Preview Search HexDocs

Built using ExDoc (v0.38.2) for the Elixir programming language

---

## Oban.TimeoutError exception (Oban v2.20.1)

**URL:** https://hexdocs.pm/oban/Oban.TimeoutError.html

**Contents:**
- Oban.TimeoutError exception (Oban v2.20.1)

Returned when a job is terminated early due to a custom timeout.

Hex Package Hex Preview Search HexDocs

Built using ExDoc (v0.38.2) for the Elixir programming language

---

## Troubleshooting

**URL:** https://hexdocs.pm/oban/troubleshooting.html

**Contents:**
- Troubleshooting
- Jobs Stuck Executing Forever
- Jobs or Plugins aren't Running
- Cron @reboot Not Running in Development
  - Solutions
- No Notifications with PgBouncer
- Unexpectedly Re-running All Migrations

During deployment or unexpected node restarts, jobs may be left in an executing state indefinitely. We call these jobs "orphans", but orphaning isn't a bad thing. It means that the job wasn't lost and it may be retried again when the system comes back online.

There are two mechanisms to mitigate orphans:

Increase the shutdown_grace_period to allow the system more time to finish executing before shutdown. During shutdown each queue stops fetching more jobs, but executing jobs have up to the grace period to complete. The default value is 15000ms, or 15 seconds.

Use the Lifeline plugin to automatically move those jobs back to available so they can run again.

Sometimes Cron or Pruner plugins appear to stop working unexpectedly. Typically, this happens in systems with multi-node setups where "web" nodes only enqueue jobs while "worker" nodes are configured to run queues and plugins. Most plugins require leadership to function, so when a "web" node becomes leader the plugins go dormant.

The solution is to disable leadership with peer: false on any node that doesn't run plugins:

The @reboot cron expression depends on leadership to prevent duplicate job insertion across nodes. In development, when you shut down your application (e.g., by exiting IEx), the node may not cleanly relinquish leadership in the database. This creates a delay before the node can become leader again on the next startup, making it appear as though @reboot jobs aren't working.

Wait for leadership - The default peer will eventually assume leadership, typically within 30 seconds.

Use the Global peer in development - The Global peer handles restarts more gracefully:

Clear leadership manually - If needed, you can clear the oban_peers table in your database to force immediate leadership.

Keep the default peer in production for better reliability and persistence across restarts.

Using PgBouncer's "Transaction Pooling" setup disables all of PostgreSQL's LISTEN and NOTIFY activity. Some functionality, such as triggering job execution, scaling queues, canceling jobs, etc. rely on those notifications.

There are several options available to ensure functional notifications:

Switch to the Oban.Notifiers.PG notifier. This alternative notifier relies on Distributed Erlang and exchanges messages within a cluster. The only drawback to the PG notifier is that it doesn't trigger job insertion events.

Switch PgBouncer to "Session Pooling". Session pooling isn't as resource efficient as transaction

*[Content truncated]*

**Examples:**

Example 1 (unknown):
```unknown
config :my_app, Oban,
    plugins: [Oban.Plugins.Lifeline],
    shutdown_grace_period: :timer.seconds(60),
    ...
```

Example 2 (unknown):
```unknown
config :my_app, Oban, peer: false, ...
```

Example 3 (unknown):
```unknown
# In config/dev.exs
config :my_app, Oban,
  peer: Oban.Peers.Global,
  ...
```

Example 4 (unknown):
```unknown
COMMENT ON TABLE public.oban_jobs IS '10'"
```

---
