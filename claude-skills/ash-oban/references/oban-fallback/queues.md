# Oban-Core - Queues

**Pages:** 1

---

## Splitting Queues Between Nodes

**URL:** https://hexdocs.pm/oban/splitting-queues.html

**Contents:**
- Splitting Queues Between Nodes
- Use Case: Isolating Video Processing Intensive Jobs
  - Usage Examples
- Flexible Across all Environments

Running every job queue on every node isn't always ideal. Imagine that your application has some CPU intensive jobs that you'd prefer not to run on nodes that serve web requests. Perhaps you start temporary nodes that are only meant to insert jobs but should never execute any. Fortunately, we can control this by configuring certain node types, or even single nodes, to run only a subset of queues.

One notorious type of CPU intensive work is video processing. When our application is transcoding multiple videos simultaneously it is a major drain on system resources and may impact response times. To avoid this we can run dedicated worker nodes that don't serve any web requests and handle all of the transcoding.

While it's possible to separate our system into web and worker apps within an umbrella, that wouldn't allow us to dynamically change queues at runtime. Let's look at an environment variable based method for dynamically configuring queues at runtime.

Within config.exs our application is configured to run three queues: default, media and events:

We will use an OBAN_QUEUES environment variable to override the queues at runtime. For illustration purposes the queue parsing all happens within the application module, but it would work equally well in releases.exs (or runtime.exs).

The queues function's first three clauses ensure that we can fall back to the queues specified in our configuration (or false, for testing). The fourth clause is much more involved, and that is where the environment parsing happens. It expects the OBAN_QUEUES value to be a string formatted as queue,limit pairs and separated by spaces. For example, to run only the default and media queues with a limit of 5 and 10 respectively, you would pass the string default,5 media,10.

Note that the parsing clause has a couple of safety mechanisms to ensure that only real queues are specified:

In development (or when using mix rather than releases) we can specify the environment variable inline:

We can also explicitly opt in to running all of the configured queues:

Finally, without OBAN_QUEUES set at all it will implicitly fall back to the configured queues:

This environment variable based solution is more flexible than running separate umbrella apps because we can reconfigure at any time. In a limited environment, like staging, we can run all the queues on a single node using the exact same code we use in production. In the future, if other workers start to utilize too much CPU or RAM we

*[Content truncated]*

**Examples:**

Example 1 (unknown):
```unknown
config :my_app, Oban,
  repo: MyApp.Repo,
  queues: [default: 15, media: 10, events: 25]
```

Example 2 (python):
```python
defmodule MyApp.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      MyApp.Repo,
      MyApp.Endpoint,
      {Oban, oban_opts()}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: MyApp.Supervisor)
  end

  defp oban_opts do
    env_queues = System.get_env("OBAN_QUEUES")

    :my_app
    |> Application.get_env(Oban)
    |> Keyword.update(:queues, [], &queues(env_queues, &1))
  end

  defp queues("*", defaults), do: defaults
  defp queues(nil, defaults), do: defaults
  defp queues(_, false), do: false

  defp queues(valu
...
```

Example 3 (unknown):
```unknown
OBAN_QUEUES="default,10 media,5" mix phx.server # default: 10, media: 5
```

Example 4 (unknown):
```unknown
OBAN_QUEUES="*" mix phx.server # default: 15, media: 10, events: 25
```

---
