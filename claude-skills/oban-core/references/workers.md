# Oban-Core - Workers

**Pages:** 18

---

## Oban (Oban v2.20.1)

**URL:** https://hexdocs.pm/oban/Oban.html

**Contents:**
- Oban (Oban v2.20.1)
- Features
    - Advantages Over Other Tools
    - Advanced Features
- 🌟 Oban Pro
- Engines
- Requirements
- Installation
- Quick Getting Started
- Learning

Oban is a robust background job framework which uses PostgreSQL, MySQL, or SQLite3 for persistence.

Oban's primary goals are reliability, consistency and observability.

Oban is a powerful and flexible library that can handle a wide range of background job use cases, and it is well-suited for systems of any size. It provides a simple and consistent API for scheduling and performing jobs, and it is built to be fault-tolerant and easy to monitor.

Oban is fundamentally different from other background job processing tools because it retains job data for historic metrics and inspection. You can leave your application running indefinitely without worrying about jobs being lost or orphaned due to crashes.

Fewer Dependencies — If you are running a web app there is a very good chance that you're running on top of a SQL database. Running your job queue within a SQL database minimizes system dependencies and simplifies data backups.

Transactional Control — Enqueue a job along with other database changes, ensuring that everything is committed or rolled back atomically.

Database Backups — Jobs are stored inside of your primary database, which means they are backed up together with the data that they relate to.

Isolated Queues — Jobs are stored in a single table but are executed in distinct queues. Each queue runs in isolation, with its own concurrency limits, ensuring that a job in a single slow queue can't back up other faster queues.

Isolated Jobs — Every job runs in a dedicated process to provide fully concurrent execution, a clean environment between jobs, and efficient cleanup after the job runs.

Queue Control — Queues can be started, stopped, paused, resumed and scaled independently at runtime locally or across all running nodes (even in environments like Heroku, without distributed Erlang).

Resilient Queues — Failing queries won't crash the entire supervision tree, instead a backoff mechanism will safely retry them again in the future.

Job Canceling — Jobs can be canceled in the middle of execution regardless of which node they are running on. This stops the job at once and flags it as cancelled.

Triggered Execution — Insert triggers ensure that jobs are dispatched on all connected nodes as soon as they are inserted into the database.

Unique Jobs — Duplicate work can be avoided through unique job controls. Uniqueness can be enforced at the argument, queue, worker and even sub-argument level for any period of time.

Scheduled Jobs — Jobs can be schedu

*[Content truncated]*

**Examples:**

Example 1 (unknown):
```unknown
# In config/config.exs
config :my_app, Oban,
  repo: MyApp.Repo,
  queues: [mailers: 20]
```

Example 2 (javascript):
```javascript
defmodule MyApp.MailerWorker do
  use Oban.Worker, queue: :mailers

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"email" => email} = _args}) do
    _ = Email.deliver(email)
    :ok
  end
end
```

Example 3 (unknown):
```unknown
%{email: %{to: "foo@example.com", body: "Hello from Oban!"}}
|> MyApp.MailerWorker.new()
|> Oban.insert()
```

Example 4 (unknown):
```unknown
defmodule MyApp.Oban do
  use Oban, otp_app: :my_app
end
```

---

## Oban.Worker behaviour (Oban v2.20.1)

**URL:** https://hexdocs.pm/oban/Oban.Worker.html

**Contents:**
- Oban.Worker behaviour (Oban v2.20.1)
- Defining Workers
    - Options at Compile-Time
- Enqueuing Jobs
- Customizing Backoff
  - Contextual Backoff
- Execution Timeout
- Snoozing Jobs
    - 🌟 Snoozes and Attempts
- Workers in A Different Application

Defines a behavior and macro to guide the creation of worker modules.

Worker modules do the work of processing a job. At a minimum they must define a perform/1 function, which is called with the full Oban.Job struct.

Worker modules are defined by using Oban.Worker. use Oban.Worker supports the following options:

The following is a basic workers that uses the defaults:

Which is equivalent to this worker, which sets all options explicitly:

The following example defines a complex worker module to process jobs in the events queue. It then dials down the priority from 0 to 1, limits retrying on failures to ten attempts, adds a business tag, and ensures that duplicate jobs aren't enqueued within a 30 second period:

Like all use macros, options are defined at compile time. Avoid using Application.get_env/2 to define worker options. Instead, pass dynamic options at runtime by passing them to the worker's new/2 function:

The perform/1 function receives an Oban.Job struct as an argument. This allows workers to change the behavior of perform/1 based on attributes of the job, such as the args, number of execution attempts, or when it was inserted.

The value returned from perform/1 can control whether the job is a success or a failure:

:ok or {:ok, value} — the job is successful and marked as completed. The value from success tuples is ignored.

{:cancel, reason} — cancel executing the job and stop retrying it. An error is recorded using the provided reason. The job is marked as cancelled.

{:error, error} — the job failed, record the error. If max_attempts has not been reached already, the job is marked as retryable and scheduled to run again. Otherwise, the job is marked as discarded and won't be retried.

{:snooze, seconds} — mark the job as snoozed and schedule it to run again seconds in the future. See Snoozing for more details.

In addition to explicit return values, any unhandled exception, exit or throw will fail the job and schedule a retry under the same conditions as in the {:error, error} case.

As an example of error tuple handling, this worker will return an error tuple when the value is less than one:

The error tuple is wrapped in an Oban.PerformError with a formatted message. The error tuple itself is available through the exception's :reason field.

All workers implement a new/2 function that converts an args map into a job changeset suitable for inserting into the database for later execution:

The worker's defaults may be overridden by pass

*[Content truncated]*

**Examples:**

Example 1 (python):
```python
defmodule MyApp.Workers.Basic do
  use Oban.Worker

  @impl Oban.Worker
  def perform(%Oban.Job{args: args}) do
    IO.inspect(args)
    :ok
  end
end
```

Example 2 (python):
```python
defmodule MyApp.Workers.Basic do
  use Oban.Worker,
    max_attempts: 20,
    priority: 0,
    queue: :default,
    tags: [],
    replace: [],
    unique: false

  @impl Oban.Worker
  def perform(%Oban.Job{args: args}) do
    IO.inspect(args)
    :ok
  end
end
```

Example 3 (python):
```python
defmodule MyApp.Workers.Business do
  use Oban.Worker,
    queue: :events,
    priority: 1,
    max_attempts: 10,
    tags: ["business"],
    replace: [scheduled: [:scheduled_at]],
    unique: [period: 30]

  @impl Oban.Worker
  def perform(%Oban.Job{attempt: attempt}) when attempt > 3 do
    IO.inspect(attempt)
  end

  def perform(job) do
    IO.inspect(job.args)
  end
end
```

Example 4 (unknown):
```unknown
MyApp.MyWorker.new(args, queue: dynamic_queue)
```

---

## Testing Queues

**URL:** https://hexdocs.pm/oban/testing_queues.html

**Contents:**
- Testing Queues
- Asserting Enqueued Jobs
- Asserting Multiple Jobs
- Integration Testing Queues

Where workers are the primary "unit" of an Oban system, queues are the "integration" point between the database and your application. That means to test queues and the jobs within them, your tests will have to interact with the database. To simplify that interaction, reduce boilerplate, and make assertions more expressive Oban.Testing provides a variety of helpers.

During test runs you don't typically want to execute jobs. Rather, you need to verify that the job was enqueued properly. With the recommended test setup queues and plugins are disabled, and jobs won't be inserted into the database at all. Instead, they'll be executed immediately within the calling process. The Oban.Testing.assert_enqueued/2 and Oban.Testing.refute_enqueued/2 helpers simplify running queries to check for those available or scheduled jobs sitting in the database.

Let's look at an example where we want to check that an activation job is enqueued after a user signs up:

It's also possible to assert that job args or meta have a particular shape, without matching exact values:

You can also refute that a job was enqueued. The refute_enqueued helper takes the same arguments as assert_enqueued, though you should take care to be as unspecific as possible.

Building on the example above, let's refute that a job is enqueued when account sign up fails:

Asserting and refuting about a single job isn't always enough. Sometimes you need to check for multiple jobs at once, or perform more complex assertions on the jobs themselves. In that situation, you can use all_enqueued instead.

The first example we'll look at asserts that multiple jobs from the same worker are enqueued all at once:

The enqueued helpers all build dynamic queries to check for jobs within the database. Dynamic queries don't work for complex objects with nested values or a partial set of keys. In that case, you can use all_enqueued to pull jobs into your tests and use the full power of pattern matching for assertions.

During integration tests it may be necessary to run jobs because they do work essential for the test to complete, i.e. sending an email, processing media, etc. You can execute all available jobs in a particular queue by calling Oban.drain_queue/1,2 directly from your tests.

For example, to process all pending jobs in the "mailer" queue while testing some business logic:

See Oban.drain_queue/1,2 for a myriad of options and additional details.

Hex Package Hex Preview (current file) Search HexDocs

Built us

*[Content truncated]*

**Examples:**

Example 1 (unknown):
```unknown
test "scheduling activation upon sign up" do
  {:ok, account} = MyApp.Account.sign_up(email: "parker@example.com")

  assert_enqueued worker: MyApp.ActivationWorker, args: %{id: account.id}, queue: :default
end
```

Example 2 (unknown):
```unknown
test "enqueued args have a particular key" do
  :ok = MyApp.Account.notify_owners(account())

  assert_enqueued queue: :default, args: %{email: _}
end
```

Example 3 (unknown):
```unknown
test "bypassing activation when sign up fails" do
  {:error, _reason} = MyApp.Account.sign_up(email: "parker@example.com")

  refute_enqueued worker: MyApp.ActivationWorker
end
```

Example 4 (unknown):
```unknown
test "enqueuing one job for each child record" do
  :ok = MyApp.Account.notify_owners(account())

  assert jobs = all_enqueued(worker: MyApp.NotificationWorker)
  assert 3 == length(jobs)
end
```

---

## Oban.Testing (Oban v2.20.1)

**URL:** https://hexdocs.pm/oban/Oban.Testing.html

**Contents:**
- Oban.Testing (Oban v2.20.1)
- Usage
  - Adding to Case Templates
- Examples
- Matching Timestamps
- Summary
- Types
- Functions
- Types
- perform_opts()

This module simplifies testing workers and making assertions about enqueued jobs when testing in :manual mode.

Assertions may be made on any property of a job, but you'll typically want to check by args, queue or worker.

The most convenient way to use Oban.Testing is to use the module:

That will define the helper functions you'll use to make assertions on the jobs that should (or should not) be inserted in the database while testing.

If you're using namespacing through Postgres schemas, also called "prefixes" in Ecto, you should set the prefix option:

Unless overridden, the default prefix is public.

To include helpers in all of your tests you can add it to your case template:

After the test helpers are imported, you can make assertions about enqueued (available or scheduled) jobs in your tests.

Here are a few examples that demonstrate what's possible:

Note that the final example, using all_enqueued/1, returns a raw list of matching jobs and does not make an assertion by itself. This makes it possible to test using pattern matching at the expense of being more verbose.

See the docs for assert_enqueued/1,2, refute_enqueued/1,2, and all_enqueued/1 for more examples.

In order to assert a job has been scheduled at a certain time, you will need to match against the scheduled_at attribute of the enqueued job.

By default, Oban will apply a 1 second delta to all timestamp fields of jobs, so that small deviations between the actual value and the expected one are ignored. You may configure this delta by passing a tuple of value and a delta option (in seconds) to corresponding keyword:

Retrieve all currently enqueued jobs matching a set of options.

Assert that a job with matching fields is enqueued.

Assert that a job with particular options is or will be enqueued within a timeout period.

Construct a job from a worker, args, and options.

Execute a job using the given config options.

Construct a job and execute it with a worker module.

Refute that a job with particular options has been enqueued.

Refute that a job with particular options is or will be enqueued within a timeout period.

Change the testing mode within the context of a function.

Retrieve all currently enqueued jobs matching a set of options.

Only jobs matching all of the provided arguments will be returned. Additionally, jobs are returned in descending order where the most recently enqueued job will be listed first.

Assert based on only some of a job's args:

Assert that exactly one j

*[Content truncated]*

**Examples:**

Example 1 (unknown):
```unknown
use Oban.Testing, repo: MyApp.Repo
```

Example 2 (unknown):
```unknown
use Oban.Testing, repo: MyApp.Repo, prefix: "business"
```

Example 3 (unknown):
```unknown
defmodule MyApp.DataCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      use Oban.Testing, repo: MyApp.Repo

      import Ecto
      import Ecto.Changeset
      import Ecto.Query
      import MyApp.DataCase

      alias MyApp.Repo
    end
  end
end
```

Example 4 (javascript):
```javascript
# Assert that a job was already enqueued
assert_enqueued worker: MyWorker, args: %{id: 1}

# Assert that a job was enqueued or will be enqueued in the next 100ms
assert_enqueued [worker: MyWorker, args: %{id: 1}], 100

# Refute that a job was already enqueued
refute_enqueued queue: "special", args: %{id: 2}

# Refute that a job was already enqueued or would be enqueued in the next 100ms
refute_enqueued queue: "special", args: %{id: 2}, 100

# Make assertions on a list of all jobs matching some options
assert [%{args: %{"id" => 1}}] = all_enqueued(worker: MyWorker)

# Assert that no jobs are en
...
```

---

## Oban.Job (Oban v2.20.1)

**URL:** https://hexdocs.pm/oban/Oban.Job.html

**Contents:**
- Oban.Job (Oban v2.20.1)
- Summary
- Types
- Functions
- Types
- args()
- changeset()
- changeset_fun()
- changeset_list()
- changeset_list_fun()

A Job is an Ecto schema used for asynchronous execution.

Job changesets are created by your application code and inserted into the database for asynchronous execution. Jobs can be inserted along with other application data as part of a transaction, which guarantees that jobs will only be triggered from a successful transaction.

Normalize, blame, and format a job's unsaved_error into the stored error format.

Construct a new job changeset ready for insertion into the database.

A canonical list of all possible job states.

Convert a Job changeset into a map suitable for database insertion.

A list of job states tailored to uniqueness constraints.

Construct a changeset for updating an existing job with the given changes.

Normalize, blame, and format a job's unsaved_error into the stored error format.

Formatted errors are stored in a job's errors field.

Construct a new job changeset ready for insertion into the database.

:max_attempts — the maximum number of times a job can be retried if there are errors during execution

:meta — a map containing additional information about the job

:priority — a numerical indicator from 0 to 9 of how important this job is relative to other jobs in the same queue. The lower the number, the higher priority the job.

:queue — a named queue to push the job into. Jobs may be pushed into any queue, regardless of whether jobs are currently being processed for the queue.

:replace - a list of keys to replace per state on a unique conflict

:scheduled_at - a time in the future after which the job should be executed

:schedule_in - the number of seconds until the job should be executed or a tuple containing a number and unit

:tags — a list of tags to group and organize related jobs, i.e. to identify scheduled jobs

:unique — a keyword list of options specifying how uniqueness will be calculated. The options define which fields will be used, for how long, with which keys, and for which states.

:worker — a module to execute the job in. The module must implement the Oban.Worker behaviour.

Insert a job with the :default queue:

Generate a pre-configured job for MyApp.Worker:

Schedule a job to run in 5 seconds:

Schedule a job to run in 5 minutes:

Insert a job, ensuring that it is unique within the past minute:

Insert a unique job where the period is compared to the scheduled_at timestamp rather than inserted_at:

Insert a unique job based only on the worker field, and within multiple states:

Insert a unique job considering 

*[Content truncated]*

**Examples:**

Example 1 (unknown):
```unknown
%{id: 1, user_id: 2}
|> Oban.Job.new(queue: :default, worker: MyApp.Worker)
|> Oban.insert()
```

Example 2 (unknown):
```unknown
MyApp.Worker.new(%{id: 1, user_id: 2})
```

Example 3 (unknown):
```unknown
MyApp.Worker.new(%{id: 1}, schedule_in: 5)
```

Example 4 (unknown):
```unknown
MyApp.Worker.new(%{id: 1}, schedule_in: {5, :minutes})
```

---

## Job Lifecycle

**URL:** https://hexdocs.pm/oban/job_lifecycle.html

**Contents:**
- Job Lifecycle
- Job States
- Initial States
- Executing State
- Retry Cycle
- Final States
    - Cleaning Up Jobs

Oban jobs follow a state machine that governs their lifecycle. Each job transitions through distinct states from the moment it's inserted until it reaches completion or another terminal state.

Jobs exist in one of six possible states:

When you first insert a job into Oban, it enters one of two initial states:

When a job becomes available, it waits for a queue with available capacity to claim it.

When a job fails but hasn't reached its max_attempts limit, it automatically schedules a retry. The retry cycle follows these steps:

This cycle continues until it reaches a final state.

After execution, a job will transition to one of these final states:

Oban's Pruner only removes final state jobs (completed, cancelled, and discarded). This prevents your database from growing indefinitely while still providing visibility into recently finished jobs.

Understanding the job lifecycle helps you build more resilient systems by properly handling failure cases, monitoring job progress, and designing appropriate retry strategies for your specific workloads.

Hex Package Hex Preview (current file) Search HexDocs

Built using ExDoc (v0.38.2) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
# Job inserted as "available"
%{id: 123} |> MyApp.Worker.new() |> Oban.insert()

# Job inserted as "scheduled"
%{id: 123} |> MyApp.Worker.new(schedule_in: 60) |> Oban.insert()
```

---

## Recursive Jobs

**URL:** https://hexdocs.pm/oban/recursive-jobs.html

**Contents:**
- Recursive Jobs
- Use Case: Backfilling Timezone Data
- Building On Recursive Jobs

Recursive jobs, like recursive functions, call themselves after they have executed. Except unlike recursive functions, where recursion happens in a tight loop, a recursive job enqueues a new version of itself and may add a slight delay to alleviate pressure on the queue.

Recursive jobs are a great way to backfill large amounts of data where a database migration or a mix task may not be suitable. Here are a few reasons that a recursive job may be better suited for backfilling data:

Let's explore recursive jobs with a use case that builds on several of those reasons.

Consider a worker that queries an external service to determine what timezone a user resides in. The external service has a rate limit and the response time is unpredictable. We have a lot of users in our database missing timezone information, and we need to backfill.

Our application has an existing TimezoneWorker that accepts a user's id, makes an external request and then updates the user's timezone. We can modify the worker to handle backfilling by adding a new clause to perform/1. The new clause explicitly checks for a backfill argument and will enqueue the next job after it executes:

There is a lot happening in the worker module, so let's unpack it a little bit.

With the new perform/1 clause in place and our code deployed we can kick off the recursive backfill. Assuming the id of the first user is 1, you can start the job from an iex console:

Now the jobs will chug along at a steady rate of one per second until the backfill is complete (or something fails). If there are any errors the backfill will pause until the failing job completes: especially useful for jobs relying on flaky external services. Finally, when there aren't any more user's without a timezone, the backfill is complete and recursion will stop.

This was a relatively simple example, and hopefully it illustrates the power and flexibility of recursive jobs. Recursive jobs are a general pattern and aren't specific to Oban. In fact, aside from the use Oban.Worker directive there isn't anything specific to Oban in the recipe!

Hex Package Hex Preview (current file) Search HexDocs

Built using ExDoc (v0.38.2) for the Elixir programming language

**Examples:**

Example 1 (javascript):
```javascript
defmodule MyApp.Workers.TimezoneWorker do
  use Oban.Worker

  import Ecto.Query

  alias MyApp.{Repo, User}

  @backfill_delay 1

  @impl true
  def perform(%{args: %{"id" => id, "backfill" => true}}) do
    with :ok <- perform(%{args: %{"id" => id}}) do
      case fetch_next(id) do
        next_id when is_integer(next_id) ->
          %{id: next_id, backfill: true}
          |> new(schedule_in: @backfill_delay)
          |> Oban.insert()

        nil ->
          :ok
      end
    end
  end

  def perform(%{args: %{"id" => id}}) do
    update_timezone(id)
  end

  defp fetch_next(current_id)
...
```

Example 2 (unknown):
```unknown
iex> %{id: 1, backfill: true} |> MyApp.Workers.TimezoneWorker.new() |> Oban.insert()
```

---

## Testing Workers

**URL:** https://hexdocs.pm/oban/testing_workers.html

**Contents:**
- Testing Workers
- Testing Perform
- Testing Other Callbacks

Worker modules are the primary "unit" of an Oban system. You can (and should) test a worker's callback functions locally, in-process, without touching the database.

Most worker callback functions take a single argument: an Oban.Job struct. A job encapsulates arguments, metadata, and other options. Creating jobs, and verifying that they're built correctly, requires some boilerplate...that's where Oban.Testing.perform_job/3 comes in!

The perform_job/3 helper reduces boilerplate when constructing jobs for unit tests and checks for common pitfalls. For example, it automatically converts args to string keys before calling perform/1, ensuring that perform clauses aren't erroneously trying to match on atom keys.

Let's work through test-driving a worker to demonstrate.

Start by defining a test that creates a user and then use perform_job to manually call an account activation worker. In this context "activation" could mean sending an email, notifying administrators, or any number of business-critical functions—what's important is how we're testing it.

Running the test at this point will raise an error that explains the module doesn't implement the Oban.Worker behaviour.

To fix it, define a worker module with the appropriate signature and return value:

The perform_job/3 helper's errors will guide you through implementing a complete worker with the following assertions:

If all of the assertions pass, then you'll get the result of perform/1 for you to make additional assertions on.

You may wish to test less-frequently used worker callbacks such as backoff/1 and timeout/1, but those callbacks don't have dedicated testing helpers. Never fear, it's adequate to build a job struct and test callbacks directly!

Here's a sample test that asserts the backoff value is simply two-times the job's attempt:

Similarly, here's a sample that verifies a timeout/1 callback always returns some number of milliseconds:

Jobs are Ecto schemas, and therefore structs. There isn't anything magical about them! Explore the Oban.Job documentation to see all of the types and fields available for testing.

Hex Package Hex Preview (current file) Search HexDocs

Built using ExDoc (v0.38.2) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
defmodule MyApp.ActivationWorkerTest do
  use MyApp.Case, async: true

  test "activating a new user" do
    user = MyApp.User.create(email: "parker@example.com")

    {:ok, _user} = perform_job(MyApp.ActivationWorker, %{id: user.id})
  end
end
```

Example 2 (unknown):
```unknown
1) test activating a new account (MyApp.ActivationWorkerTest)

   Expected worker to be a module that implements the Oban.Worker behaviour, got:

   MyApp.ActivationWorker

   code: {:ok, user} = perform_job(MyApp.ActivationWorker, %{id: user.id})
```

Example 3 (javascript):
```javascript
defmodule MyApp.ActivationWorker do
  use Oban.Worker

  @impl Worker
  def perform(%Job{args: %{"id" => user_id}}) do
    MyApp.Account.activate(user_id)
  end
end
```

Example 4 (unknown):
```unknown
test "calculating custom backoff as a multiple of job attempts" do
  assert 2 == MyWorker.backoff(%Oban.Job{attempt: 1})
  assert 4 == MyWorker.backoff(%Oban.Job{attempt: 2})
  assert 6 == MyWorker.backoff(%Oban.Job{attempt: 3})
end
```

---

## Unique Jobs

**URL:** https://hexdocs.pm/oban/unique_jobs.html

**Contents:**
- Unique Jobs
    - Unique Guarantees
- Uniqueness vs Concurrency
- Detecting Conflicts
- Replacing Values
    - Jobs in the :executing State
- Specifying Fields and Keys

The uniqueness of a job is a somewhat complex topic. This guide is here to help you understand its complexities!

The unique jobs feature allows you to specify constraints to prevent enqueuing duplicate jobs. These constraints only apply when jobs are inserted. Uniqueness has no bearing on whether jobs are executed concurrently. Uniqueness is based on a combination of job attributes based on the following options:

:period — The number of seconds until a job is no longer considered duplicate. You should always specify a period, otherwise Oban will default to 60 seconds. :infinity can be used to indicate the job be considered a duplicate as long as jobs are retained (see Oban.Plugins.Pruner).

:fields — The fields to compare when evaluating uniqueness. The available fields are :args, :queue, :worker, and :meta. :fields defaults to [:worker, :queue, :args]. It's recommended that you leave the default :fields, otherwise you risk unexpected conflicts between unrelated jobs.

:keys — A specific subset of the :args or :meta to consider when comparing against historic jobs. This allows a job with multiple key/value pairs in its arguments to be compared using only a subset of them.

:states — The job states that are checked for duplicates. You can use a named group or a list of individual states. The available named groups are:

By default, :successful is used, which prevents duplicates even if the previous job has been completed.

:timestamp — Which job timestamp to check the period against. The available timestamps are :inserted_at or :scheduled_at. Defaults to :inserted_at for legacy reasons.

The simplest form of uniqueness will configure uniqueness for as long as a matching job exists in the database, regardless of state:

Here's a more complex example which uses multiple options:

Oban strives for uniqueness of jobs through transactional locks and database queries. Uniqueness does not rely on unique constraints in the database, which leaves it prone to race conditions in some circumstances.

🌟 Pro's Smart Engine does rely on unique constraints and provides strong uniqueness guarantees.

Understanding the distinction between uniqueness and concurrency is crucial for designing efficient processing pipelines. While these concepts may seem related, they operate at different stages of a job's lifecycle.

Uniqueness operates at job insertion time. When a job is marked as unique, Oban checks whether an identical job already exists in the queue before inserting a ne

*[Content truncated]*

**Examples:**

Example 1 (unknown):
```unknown
use Oban.Worker, unique: true
```

Example 2 (unknown):
```unknown
use Oban.Worker,
  unique: [
    # Jobs should be unique for 2 minutes...
    period: {2, :minutes},
    # ...after being scheduled, not inserted
    timestamp: :scheduled_at,
    # Don't consider the whole :args field, but just the :url field within :args
    keys: [:url],
    # Consider a job unique across all states, including :cancelled/:discarded
    states: :all,
    # Consider a job unique across queues; only compare the :worker and :url key within
    # the :args, as per the :keys configuration above
    fields: [:worker, :args]
  ]
```

Example 3 (unknown):
```unknown
config :my_app, Oban, queues: [emails: 10]
```

Example 4 (unknown):
```unknown
1..10
|> Enum.map(&MyApp.EmailWorker.new(%{user_id: &1}, unique: true))
|> Oban.insert_all()
```

---

## Error Handling

**URL:** https://hexdocs.pm/oban/error_handling.html

**Contents:**
- Error Handling
- Error Details
- Retries
  - Limiting Retries
- Reporting Errors
  - Built-in Reporting

This page guides you through handling and reporting errors in Oban.

Jobs can fail in expected or unexpected ways. To mark a job as failed, you can return {:error, reason} from a worker's perform/1 callback, as documented in the Oban.Worker.result/0 type. A job can also fail because of unexpected raised errors or exits.

In any case, when a job fails the details of the failure are recorded in the errors array on the Oban.Job struct.

Oban stores execution errors as a list of maps (Oban.Job.errors/0). Each error contains the following keys:

See the Instrumentation docs for an example of integrating with external error reporting systems.

When a job fails and the number of execution attempts is below the configured max_attempts limit for that job, the job will automatically be retried in the future. If the number of failures reaches max_attempts, the job gets discarded.

The retry delay has an exponential backoff with jitter. This means that the delay between attempts grows exponentially (8s, 16s, and so on), and a randomized "jitter" is introduced for each attempt, so that chances of jobs overlapping when being retried go down. So, a job could be retried after 7.3s, then 17.1s, and so on.

See the Oban.Worker documentation on "Customizing Backoff" for alternative backoff strategies.

By default, jobs are retried up to 20 times. The number of retries is controlled by the :max_attempts value, which can be set at the worker or job level. For example, to instruct a worker to discard jobs after three failures:

Another great use of execution data and instrumentation is error reporting. Here is an example of an event handler module that integrates with Honeybadger to report job failures:

You can use exception events to send error reports to Sentry, AppSignal, Honeybadger, Rollbar, or any other application monitoring platform.

Some error-reporting and application-monitoring services support reporting Oban errors out of the box:

Hex Package Hex Preview (current file) Search HexDocs

Built using ExDoc (v0.38.2) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
use Oban.Worker, queue: :limited, max_attempts: 3
```

Example 2 (python):
```python
defmodule MyApp.ErrorReporter do
  def attach do
    :telemetry.attach(
      "oban-errors",
      [:oban, :job, :exception],
      &__MODULE__.handle_event/4,
      []
    )
  end

  def handle_event([:oban, :job, :exception], measure, meta, _) do
    Honeybadger.notify(meta.reason, stacktrace: meta.stacktrace)
  end
end

# Attach it with:
MyApp.ErrorReporter.attach()
```

---

## Upgrading to v2.20

**URL:** https://hexdocs.pm/oban/v2-20.html

**Contents:**
- Upgrading to v2.20
- Bump Your Deps
- Run Oban.Migrations for v13 (Optional)
- Update Unique States (Optional)
  - Migration Examples

This Oban release includes an optional, but recommended migration.

Update Oban (and optionally Pro) to the latest versions:

The v13 migration adds compound indexes for cancelled_at and discarded_at columns. This is done to improve Oban.Plugins.Pruner performance for cancelled and discarded jobs.

To get started, create a migration to create the table:

Within the generated migration module:

If you have multiple Oban instances, or use an alternate prefix, you'll need to run the migration for each prefix.

Prior to v2.20, you may have specified unique states as custom lists:

Now you can use predefined unique groups that are safer and more standardized. The available groups are:

Replace custom state lists with the appropriate group:

These groups reduce the chance of misconfiguration and make unique constraints more predictable across your application.

Hex Package Hex Preview (current file) Search HexDocs

Built using ExDoc (v0.38.2) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
[
  {:oban, "~> 2.20"},
]
```

Example 2 (unknown):
```unknown
$ mix ecto.gen.migration upgrade_oban_jobs_to_v13
```

Example 3 (python):
```python
use Ecto.Migration

def up, do: Oban.Migrations.up(version: 13)

def down, do: Oban.Migrations.down(version: 13)
```

Example 4 (unknown):
```unknown
use Oban.Worker, unique: [states: [:scheduled, :available, :executing]]
use Oban.Worker, unique: [states: [:available, :scheduled, :executing, :retryable]]
```

---

## Reliable Scheduled Jobs

**URL:** https://hexdocs.pm/oban/reliable-scheduling.html

**Contents:**
- Reliable Scheduled Jobs
- Use Case: Delivering Daily Digest Emails
- More Flexible Than CRON Scheduling
- Considerations for Scheduling Jobs in the Very-Near-Future

A common variant of recursive jobs are "scheduled jobs", where the goal is for a job to repeat indefinitely with a fixed amount of time between executions. The part that makes it "reliable" is the guarantee that we'll keep retrying the job's business logic when the job retries, but we'll only schedule the next occurrence once. In order to achieve this guarantee we'll make use of the perform function to receive a complete Oban.Job struct.

Time for illustrative example!

When a new user signs up to use our site we need to start sending them daily digest emails. We want to deliver the emails around the same time a user signed up, repeating every 24 hours. It is important that we don't spam them with duplicate emails, so we ensure that the next email is only scheduled on our first attempt.

You'll notice that the first perform/1 clause only matches a job struct on the first attempt. When it matches, the first clause schedules the next iteration immediately, before attempting to deliver the email. Any subsequent retries fall through to the second perform/1 clause, which only attempts to deliver the email again. Combined, the clauses get us close to at-most-once semantics for scheduling, and at-least-once semantics for delivery.

Delivering around the same time using cron-style scheduling would need extra book-keeping to check when a user signed up, and then only deliver to those users that signed up within that window of time. The recursive scheduling approach is more accurate and entirely self contained—when and if the digest interval changes the scheduling will pick it up automatically once our code deploys.

An extensive discussion on the Oban issue tracker prompted this example along with the underlying feature that made it possible.

If you use the schedule_in or scheduled_at options with a value that will resolve to the very-near-future, for example:

your workers may not be aware of/attempt to perform the job until the next tick as specified by the :stage_interval configuration option. By default this is set to 1_000ms.

Be aware: Configuring the :stage_interval option below the recommended default can have a considerable impact on database performance! It is not advised to lower this value and should only be done as a last resort after considering other ways to achieve your desired outcome.

Hex Package Hex Preview (current file) Search HexDocs

Built using ExDoc (v0.38.2) for the Elixir programming language

**Examples:**

Example 1 (javascript):
```javascript
defmodule MyApp.Workers.ScheduledWorker do
  use Oban.Worker, queue: :scheduled, max_attempts: 10

  alias MyApp.Mailer

  @one_day 60 * 60 * 24

  @impl true
  def perform(%{args: %{"email" => email} = args, attempt: 1}) do
    args
    |> new(schedule_in: @one_day)
    |> Oban.insert!()

    Mailer.deliver_email(email)
  end

  def perform(%{args: %{"email" => email}}) do
    Mailer.deliver_email(email)
  end
end
```

Example 2 (unknown):
```unknown
# 1 second from now
%{}
|> new(schedule_in: 1)
|> Oban.insert()

# 500 milliseconds from now
very_soon = DateTime.utc_now() |> DateTime.add(500, :millisecond)

%{}
|> new(scheduled_at: very_soon)
|> Oban.insert()
```

---

## Reporting Job Progress

**URL:** https://hexdocs.pm/oban/reporting-progress.html

**Contents:**
- Reporting Job Progress
- Use Case: Exporting a Large Zip File
  - Before We Start
- Coordinating Processes
- Made Possible by Unlimited Execution

Most applications provide some way to generate an artifact—something that may take the server a long time to accomplish. If it takes several minutes to render a video, crunch some numbers or generate an export, users may be left wondering whether your application is working. Providing periodic updates to end users assures them that the work is being done and keeps the application feeling responsive.

Reporting progress is something that any background job processor with unlimited execution time can do! Naturally, we'll look at an example built on Oban.

Users of our site can export a zip of all the files they have uploaded. A zip file (no, not a tar, our users don't have neck-beards) is generated on the fly, when the user requests it. Lazily generating archives is great for our server's utilization, but it means that users may wait a while when there are many files. Fortunately, we know how many files will be included in the zip and we can use that information to send progress reports! We will compute the archive's percent complete as each file is added and push a message to the user.

In the forum question that prompted this guide the work was done externally by a port process. Working with ports is well outside the scope of this guide, so I've modified it for the sake of simplicity. The result is slightly contrived as it puts both processes within the same module, which isn't necessary if the only goal is to broadcast progress. This guide is ultimately about coordinating processes to report progress from a background job, so that's what we'll focus on (everything else will be rather hand-wavy).

Our worker, the creatively titled ZippingWorker, handles both building the archive and reporting progress to the client. Showing the entire module at once felt distracting, so we'll start with only the module definition and the perform/1 function:

The function accepts an Oban Job with a channel name and a list of file paths, which it immediately passes on to the private build_zip/1:

The function grabs the current pid, which belongs to the job, and kicks off an asynchronous task to handle the zipping. With a few calls to a fictional Zipper module the task works through each file path, adding it to the zip. After adding a file the task sends a :progress message with the percent complete back to the job. Finally, when the zip finishes, the task sends a :complete message with a path to the archive.

The asynchronous call spawns a separate process and returns immedi

*[Content truncated]*

**Examples:**

Example 1 (javascript):
```javascript
defmodule MyApp.Workers.ZippingWorker do
  use Oban.Worker, queue: :exports, max_attempts: 1

  alias MyApp.{Endpoint, Zipper}

  def perform(%_{args: %{"channel" => channel, "paths" => paths}}) do
    build_zip(paths)
    await_zip(channel)
  end

  # ...
end
```

Example 2 (unknown):
```unknown
defp build_zip(paths) do
    job_pid = self()

    Task.async(fn ->
      zip_path = Zipper.new()

      paths
      |> Enum.with_index(1)
      |> Enum.each(fn {path, index} ->
        :ok = Zipper.add_file(zip_path, path)
        send(job_pid, {:progress, trunc(index / length(paths) * 100)})
      end)

      send(job_pid, {:complete, zip_path})
    end)
  end
```

Example 3 (unknown):
```unknown
defp await_zip(channel) do
    receive do
      {:progress, percent} ->
        Endpoint.broadcast(channel, "zip:progress", percent)
        await_zip(channel)

      {:complete, zip_path} ->
        Endpoint.broadcast(channel, "zip:complete", zip_path)
    after
      30_000 ->
        Endpoint.broadcast(channel, "zip:failed", "zipping failed")
        raise RuntimeError, "no progress after 30s"
    end
  end
```

---

## Oban.PerformError exception (Oban v2.20.1)

**URL:** https://hexdocs.pm/oban/Oban.PerformError.html

**Contents:**
- Oban.PerformError exception (Oban v2.20.1)

Wraps the reason returned by {:error, reason}, {:cancel, reason}, or {:discard, reason} in a proper exception.

The original return tuple is available in the :reason key.

Hex Package Hex Preview Search HexDocs

Built using ExDoc (v0.38.2) for the Elixir programming language

---

## Oban.Plugins.Cron (Oban v2.20.1)

**URL:** https://hexdocs.pm/oban/Oban.Plugins.Cron.html

**Contents:**
- Oban.Plugins.Cron (Oban v2.20.1)
    - 🌟 DynamicCron
- Usage
  - Identifying Cron Jobs
- Options
- Instrumenting with Telemetry
- Summary
- Types
- Functions
- Types

Periodically enqueue jobs through cron-based scheduling.

This plugin registers workers a cron-like schedule and enqueues jobs automatically. To know more about periodic jobs in Oban, see the Periodic Jobs guide.

This plugin only loads the crontab statically, at boot time. To configure cron scheduling at runtime, globally, across an entire cluster with scheduling guarantees and timezone overrides, see the DynamicCron plugin in Oban Pro.

Periodic jobs are declared as a list of {cron, worker} or {cron, worker, options} tuples:

Jobs inserted by the cron plugin are marked with a cron flag and the original expression is stored as cron_expr in the job's meta field. For example, the meta for a @daily cron job would look like this:

You can pass the following options to this plugin:

:crontab — a list of cron expressions that enqueue jobs on a periodic basis. See Periodic Jobs guide for syntax and details.

:timezone — which timezone to use when scheduling cron jobs. To use a timezone other than the default of Etc/UTC you must have a timezone database like tz installed and configured.

The Oban.Plugins.Cron plugin adds the following metadata to the [:oban, :plugin, :stop] event (see Oban.Telemetry):

Parse a crontab expression into a cron struct.

Parse a crontab expression into a cron struct.

This is provided as a convenience for validating and testing cron expressions. As such, the cron struct itself is opaque and the internals may change at any time.

The parser can handle common expressions that use minutes, hours, days, months and weekdays, along with ranges and steps. It also supports common extensions, also called nicknames.

Returns {:error, %ArgumentError{}} with a detailed error if the expression cannot be parsed.

The following special nicknames are supported in addition to standard cron expressions:

Hex Package Hex Preview Search HexDocs

Built using ExDoc (v0.38.2) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
config :my_app, Oban,
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

Example 2 (javascript):
```javascript
%Oban.Job{meta: %{"cron" => true, "cron_expr" => "@daily", "cron_tz" => "Etc/UTC"}}
```

Example 3 (unknown):
```unknown
iex> Oban.Plugins.Cron.parse("@hourly")
{:ok, #Oban.Cron.Expression<...>}

iex> Oban.Plugins.Cron.parse("0 * * * *")
{:ok, #Oban.Cron.Expression<...>}

iex> Oban.Plugins.Cron.parse("60 * * * *")
{:error, %ArgumentError{message: "expression field 60 is out of range 0..59"}}
```

---

## Oban.Plugins.Pruner (Oban v2.20.1)

**URL:** https://hexdocs.pm/oban/Oban.Plugins.Pruner.html

**Contents:**
- Oban.Plugins.Pruner (Oban v2.20.1)
    - 🌟 DynamicPruner
- Using the Plugin
- Options
- Instrumenting with Telemetry
- Summary
- Types
- Types
- option()

Periodically delete completed, cancelled, and discarded jobs based on their age.

Pruning is critical for maintaining table size and continued responsive job processing. It is recommended for all production applications. See also the Operational Maintenance guide.

This plugin is limited to a fixed interval and a single max_age check for all jobs. To prune on a cron-style schedule, retain jobs by a limit or age, or provide overrides for specific queues, workers, and job states; see Oban Pro's DynamicPruner.

The following example demonstrates using the plugin without any configuration, which will prune jobs older than the default of 60 seconds:

Override the default options to prune jobs after 5 minutes:

:interval — the number of milliseconds between pruning attempts. The default is 30_000ms.

:limit — the maximum number of jobs to prune at one time. The default is 10,000 to prevent request timeouts. Applications that steadily generate more than 10k jobs a minute should increase this value.

:max_age — the number of seconds after which a job may be pruned. Defaults to 60s.

The Oban.Plugins.Pruner plugin adds the following metadata to the [:oban, :plugin, :stop] event:

Note: jobs only include id, queue, state fields.

Hex Package Hex Preview Search HexDocs

Built using ExDoc (v0.38.2) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
config :my_app, Oban,
  plugins: [Oban.Plugins.Pruner],
  ...
```

Example 2 (unknown):
```unknown
config :my_app, Oban,
  plugins: [{Oban.Plugins.Pruner, max_age: 300}],
  ...
```

---

## Scheduling Jobs

**URL:** https://hexdocs.pm/oban/scheduling_jobs.html

**Contents:**
- Scheduling Jobs
  - Schedule in Relative Time
  - Schedule at a Specific Time
- Time Zone Considerations
- How Scheduling Works
- Distributed Scheduling

Oban provides flexible options to schedule jobs for future execution. This is useful for scenarios like delayed notifications, periodic maintenance tasks, or scheduling work during off-peak hours.

You can schedule jobs to run after a specific dalay (in seconds):

This is useful for tasks that need to happen after a short delay, such as sending a follow-up email or retrying a failed operation.

For tasks that need to run at a precise moment, you can schedule jobs at a specific timestamp:

This is particularly useful for time-sensitive operations like sending birthday messages, executing a maintenance task at off-hours, or preparing monthly reports.

Scheduling in Oban is always done in UTC. If you're working with timestamps in different time zones, you must convert them to UTC before scheduling:

This ensures consistent behavior across different server locations and prevents daylight saving time issues.

Behind the scenes, Oban stores your job in the database with the specified scheduled time. The job remains in a "scheduled" state until that time arrives, at which point it becomes available for execution by the appropriate worker.

Scheduled jobs don't consume worker resources until they're ready to execute, allowing you to queue thousands of future jobs without impacting current performance.

Scheduling works seamlessly across a cluster of nodes. A job scheduled on one node will execute on whichever node has an available worker when the scheduled time arrives. See the Clustering guide for more detailed information about how Oban manages jobs in a distributed environment.

Hex Package Hex Preview (current file) Search HexDocs

Built using ExDoc (v0.38.2) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
%{id: 1}
|> MyApp.SomeWorker.new(schedule_in: _seconds = 5)
|> Oban.insert()
```

Example 2 (unknown):
```unknown
%{id: 1}
|> MyApp.SomeWorker.new(scheduled_at: ~U[2020-12-25 19:00:00Z])
|> Oban.insert()
```

Example 3 (unknown):
```unknown
# Convert a datetime in a local timezone to UTC for scheduling
utc_datetime = DateTime.shift_zone!(local_datetime, "Etc/UTC")

%{id: 1}
|> MyApp.SomeWorker.new(scheduled_at: utc_datetime)
|> Oban.insert()
```

---

## Upgrading to v2.0

**URL:** https://hexdocs.pm/oban/v2-0.html

**Contents:**
- Upgrading to v2.0
- Bump Your Deps
- Oban.Worker Changes
- Update Your Config
- Update Your Tests
- Update Telemetry
- Update Oban.Web (Optional)

This information is extracted and expanded from the CHANGELOG.

This is a big release with a ton of new features and fixes, but also a few breaking changes. This guide will walk you through the upgrade process.

Update Oban to the latest version:

If you're an Oban Web+Pro user you'll also need to bump Oban.Web and add Oban.Pro:

The perform/2 callback is replaced with perform/1, where the only argument is an Oban.Job struct. This unifies the interface for all Oban.Worker callbacks and helps to eliminate confusion around pattern matching on arguments.

Change all worker definitions from accepting args and a job to only accept a job and match on the nested args key:

For finer control of job backoff the backoff/1 callback now expects a job struct instead of an integer. Change any workers that expect an attempt number to match on the full job struct:

The :verbose setting was renamed to :log to better align with values accepted by Ecto.Repo.

Pruning is now handled by the new plugin system. Replace :prune in your config and pass a :max_age value to the plugin:

In test mode you can disable pruning by setting plugins to false instead:

🌟 Oban.Pro users may opt to use the DynamicPruner instead for finer control. For example, to set per-state retention periods:

Pulse tracking and orphaned job rescue are removed from base Oban. This change means that you will need to manually rescue any jobs left executing state after a crash or forced shutdown.

Remove any :beats_maxage, :rescue_after or :rescue_interval settings from your config:

🌟 Oban.Pro users may use the Lifeline plugin to retain automatic orphaned job rescue with lightweight heartbeat recording:

The new perform_job test helper automates validating, normalizing and perform jobs in unit tests.

To update your tests replace any calls to perform with the new helper:

The perform_job helper will verify the worker, the arguments and any provided options. It will then verify that your worker returns a valid result and return the value for you to assert on.

Within integration tests replace drain_queue/3 with drain_queue/2:

Telemetry event names have changed, along with some of the metadata and timing units. The new event names are consistent and align with the now-standard telemetry:span conventions.

Update handlers to match on the new event names:

And update the attach calls:

Finally, replace references to meta.stack with meta.stacktrace:

Here is a conversion chart for any other handlers you may have:



*[Content truncated]*

**Examples:**

Example 1 (unknown):
```unknown
defp deps do
    [
      {:oban, "~> 2.0.0"}
      ...
    ]
  end
```

Example 2 (unknown):
```unknown
defp deps do
    [
      {:oban, "~> 2.0.0"},
      {:oban_web, "~> 2.0.0", organization: "oban"},
      {:oban_pro, "~> 0.3.0", organization: "oban"}
      ...
    ]
  end
```

Example 3 (javascript):
```javascript
- def perform(%{"id" => id}, _job)
+ def perform(%Job{args: %{"id" => id}})
```

Example 4 (python):
```python
- def backoff(attempt)
+ def backoff(%Job{attempt: attempt})
```

---
