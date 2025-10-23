# Oban-Core - Getting Started

**Pages:** 2

---

## Installation

**URL:** https://hexdocs.pm/oban/installation.html

**Contents:**
- Installation
- Semi-Automatic Installation
- Igniter Installation
- Manual Installation
  - Postgres
  - SQLite3
  - MySQL

Before starting ensure your application has Ecto configured to use Postgrex for Postgres, EctoSQLite3 for SQLite3, or MyXQL for use with MySQL.

There are three installation mechanisms available:

It's possible to use the oban.install task without the igniter.install escript available. First, add oban and igniter to your deps in mix.exs:

Run mix deps.get to fetch oban, then run the install task:

That will automate all of the manual steps listed below!

For projects that have igniter available, Oban may be installed and configured with a single command:

That will add the latest version of oban to your dependencies before running the installer. Installation will use the application's default Ecto repo, select the corresponding engine, and set the pubsub notifier accordingly.

Use the --repo flag to specify an alternate repo manually:

Add :oban to your list of deps in mix.exs:

Then run mix deps.get to install Oban and its dependencies. After the packages are installed you must create a database migration to add the oban_jobs table to your database:

Open the generated migration in your editor and call the up and down functions on Oban.Migration:

This will run all of Oban's versioned migrations for your database. Migrations between versions are idempotent and rarely change after a release. As new versions are released you may need to run additional migrations.

Now, run the migration to create the table:

Before you can run an Oban instance you must provide some base configuration:

Running with Postgres requires using the Oban.Engines.Basic engine:

Running with SQLite3 requires using the Oban.Engines.Lite engine:

Running with MySQL requires using the Oban.Engines.Dolphin engine:

To prevent Oban from running jobs and plugins during test runs, enable :testing mode in test.exs:

Oban instances are isolated supervision trees and must be included in your application's supervisor to run. Use the application configuration you've just set and include Oban in the list of supervised children:

Finally, verify that Oban is configured and running properly. Within a new iex -S mix session:

You're all set! Add the Oban Web dashboard for monitoring, get started creating jobs and configuring queues in Usage, or head to the testing guide to learn how to test with Oban.

Hex Package Hex Preview (current file) Search HexDocs

Built using ExDoc (v0.38.2) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
{:oban, "~> 2.19"},
{:igniter, "~> 0.5", only: [:dev]},
```

Example 2 (unknown):
```unknown
mix oban.install
```

Example 3 (unknown):
```unknown
mix igniter.install oban
```

Example 4 (unknown):
```unknown
mix igniter.install oban --repo MyApp.LiteRepo
```

---

## Introduction to Testing

**URL:** https://hexdocs.pm/oban/testing.html

**Contents:**
- Introduction to Testing
- Setup Application Config
  - Changing Testing Modes
- Setup Testing Helpers

Automated testing is an essential component of building reliable, long-lived applications. Oban orchestrates your application's background tasks, so naturally, testing Oban is highly recommended.

Ensure your app is configured for testing before you begin running tests.

There are two testing modes available:

If you're just starting out, :inline mode is recommended:

For more complex applications, or if you'd like complete control over when jobs run, then use :manual mode instead:

Both testing modes prevent Oban from running any database queries in the background. This simultaneously prevents Sandbox errors from plugin queries and prevents queues from executing jobs unexpectedly.

Once the application starts in a particular testing mode it can't be changed. That's inconvenient if you're running in :inline mode and don't want a particular job to execute inline! Oban.Testing provides a helper to temporarily change testing modes within the context of a function.

For example, to switch to :manual mode when Oban is configured for :inline testing:

Or vice-versa, switch to :inline mode when the application is configured for :manual mode:

Oban provides helpers to facilitate manual testing. These helpers handle the boilerplate of making assertions on which jobs are enqueued.

The most convenient way to use the helpers is to use the module within your test case:

Alternatively, you can use the testing module in individual tests if you'd prefer not to include helpers in every test.

Whichever way you choose, using use Oban.Testing requires the repo option because it's injected into many of the generated helpers.

If you are using isolation with namespaces through PostgreSQL schemas (Ecto "prefixes"), you can also specify this prefix when using Oban.Testing:

With Oban configured for testing and helpers in the appropriate places, you're ready for testing. Learn about unit testing with Testing Workers, integration testing with Testing Queues, or prepare for production with Testing Config.

Hex Package Hex Preview (current file) Search HexDocs

Built using ExDoc (v0.38.2) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
config :my_app, Oban, testing: :inline
```

Example 2 (unknown):
```unknown
config :my_app, Oban, testing: :manual
```

Example 3 (unknown):
```unknown
Oban.Testing.with_testing_mode(:manual, fn ->
  Oban.insert(MyWorker.new(%{id: 123}))

  assert_enqueued worker: MyWorker, args: %{id: 123}
end)
```

Example 4 (unknown):
```unknown
Oban.Testing.with_testing_mode(:inline, fn ->
  {:ok, %Job{state: "completed"}} = Oban.insert(MyWorker.new(%{id: 123}))
end)
```

---
