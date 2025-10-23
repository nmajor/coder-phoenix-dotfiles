# Ash-Oban - Triggers

**Pages:** 8

---

## AshOban.Trigger (ash_oban v0.4.12)

**URL:** https://hexdocs.pm/ash_oban/AshOban.Trigger.html

**Contents:**
- AshOban.Trigger (ash_oban v0.4.12)
- Summary
- Types
- Functions
- Types
- t()
- Functions
- transform(trigger)

A configured trigger.

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.2) for the Elixir programming language

---

## Triggers and Scheduled Actions

**URL:** https://hexdocs.pm/ash_oban/triggers-and-scheduled-actions.html

**Contents:**
- Triggers and Scheduled Actions
  - Cron Syntax
  - Triggers
  - Scheduled Actions

AshOban provides two primitives which, combined, should handle most use cases. Keep in mind, however, that you still have all of Oban at your disposal and, should the need arise, you can define "standard" oban jobs to do whatever you need to do.

You'll see cron syntax used throughout this guide. "@daily" is a shorthand for "0 0 *". See cron syntax for more examples.

A trigger describes an action that is run periodically for records that match a condition. It can also be used to trigger an action to happen "once in the background", but this "run later" pattern can often be a design issue.

For example, lets say we want to send a notification to a user when their subscription is about to expire. We could write a function like this, and run it once a day:

What are the problems with this approach?

Lets look at how it could be done using AshOban triggers.

First, we add an action with a change that contains the logic to send the email. (See the Ash docs for more on changes).

Next we use some application state to indicate when the last time we notified them of their subscription expiration was:

And we also add some calculations to determine if the user should get one of these emails:

Next, we add a trigger that checks for and runs these actions periodically.

Now, instead of relying on a "background job" to be the authoritative source of truth, we have everything modeled as a part of our domain model. For example, we can see without sending the emails, how many users have subscriptions expiring soon, and how many should get an email. If something goes wrong with the job on the first day (maybe our email provider is unavailable), those users will get an email the next day. Each individual call to send_subscription_expiration_notification gets its own oban job, meaning that if one fails, the others are unaffected. If someone says "Hey, I never got my email", you can look at their subscription state to see why, and potentially retrigger it by setting last_subscription_expiration_notification_sent_at to nil.

Scheduled actions are a much simpler concept than triggers. They are used to perform a generic action on a specified schedule. For example, lets say you want to trigger an import from an external service every 6 hours.

Then you could schedule it to run every 6 hours:

Hex Package Hex Preview (current file) Search HexDocs Download ePub version

Built using ExDoc (v0.38.2) for the Elixir programming language

**Examples:**

Example 1 (python):
```python
def send_subscription_expiration_notification(user) do
  Subscription
  |> Ash.Query.for_read(:subscriptions_about_to_expire)
  |> Ash.stream!()
  |> Enum.each(&send_expiring_subscription_email/1)
end
```

Example 2 (unknown):
```unknown
# on `Subscription`
#
# now we have a well defined action that expresses this logic
update :send_subscription_expiration_notification do
  change SendExpiringSubscriptionEmail
end
```

Example 3 (unknown):
```unknown
attributes do
  attribute :last_subscription_expiration_notification_sent_at, :utc_datetime_usec
  ...
end
```

Example 4 (unknown):
```unknown
calculations do
  calculate :subscription_expires_soon, :boolean do
    calculation expr(
      expires_at < from_now(30, :day)
    )
  end

  calculate :should_send_expiring_subscription_email, :boolean do
    calculation expr(
      subscription_expires_soon and
      (is_nil(last_subscription_expiration_notification_sent_at) ||
        last_subscription_expiration_notification_sent_at < ago(30, :day))
    )
  end
end
```

---

## mix ash_oban.set_default_module_names (ash_oban v0.4.12)

**URL:** https://hexdocs.pm/ash_oban/Mix.Tasks.AshOban.SetDefaultModuleNames.html

**Contents:**
- mix ash_oban.set_default_module_names (ash_oban v0.4.12)
- Example

Set module names to their default values for triggers and scheduled actions

Each trigger must have a defined module name, otherwise changing the name of the trigger will lead to "dangling" jobs. See the AshOban documentation for more.

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.2) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
mix ash_oban.set_default_module_names
```

---

## Getting Started With Ash Oban

**URL:** https://hexdocs.pm/ash_oban/getting-started-with-ash-oban.html

**Contents:**
- Getting Started With Ash Oban
- Get familiar with Ash resources
- Get familiar with AshOban Triggers & Scheduled Actions
- Bring in the ash_oban dependency
- Setup
  - Oban Pro
  - Using Igniter (recommended)
  - Manual
- Usage
- Handling Errors

If you haven't already, read the Ash Getting Started Guide, and familiarize yourself with Ash and Ash resources.

See Triggers and Scheduled Actions to read about what AshOban provides.

If you are using Oban Pro, set the following configuration:

Oban Pro lives in a separate hex repository, and therefore we, unfortunately, cannot have an explicit version dependency on it. What this means is that any version you use in hex will technically be accepted, and if you don't have the oban pro package installed and you use the above configuration, you will get compile time errors/warnings.

This will install oban as well.

Next, allow AshOban to alter your configuration in your Application module:

Finally, configure your triggers in your resources.

Add the AshOban extension and define a trigger.

Make sure to add the queue to the list of queues in Oban configuration. Default queue is resources short name plus the name of the trigger. For the above example you would add :resource_process queue to Oban queues in config. Alternatively, you can define your own queue in the trigger.

See the DSL documentation for more: AshOban

Error handling is done by adding an on_error to your trigger. This is an update action that will get the error as an argument called :error. The error will be an Ash error class. These error classes can contain many kinds of errors, so you will need to figure out handling specific errors on your own. Be sure to add the :error argument to the action if you want to receive the error.

This is not foolproof. You want to be sure that your on_error action is as simple as possible, because if an exception is raised during the on_error action, the oban job will fail. If you are relying on your on_error logic to alter the resource to make it no longer apply to a trigger, consider making your action do only that. Then you can add another trigger watching for things in an errored state to do more rich error handling behavior.

To remove or disable triggers, do not just remove them from your resource. Due to the way that Oban Pro implements cron jobs, if you just remove them from your resource, the cron will attempt to continue scheduling jobs. Instead, set state :paused or state :deleted on the trigger. See the oban docs for more: https://getoban.pro/docs/pro/0.14.1/Oban.Pro.Plugins.DynamicCron.html#module-using-and-configuring

PS: state :deleted is also idempotent, so there is no issue with deploying with that flag set to true multiple times. After y

*[Content truncated]*

**Examples:**

Example 1 (unknown):
```unknown
{:ash_oban, "~> 0.4.12"}
```

Example 2 (unknown):
```unknown
config :ash_oban, :pro?, true
```

Example 3 (unknown):
```unknown
mix igniter.install ash_oban
```

Example 4 (unknown):
```unknown
# Replace this
{Oban, your_oban_config}

# With this
{Oban, AshOban.config(Application.fetch_env!(:my_app, :ash_domains), your_oban_config)}
# OR this, to selectively enable AshOban only for specific domains
{Oban, AshOban.config([YourDomain, YourOtherDomain], your_oban_config)}
```

---

## AshOban (ash_oban v0.4.12)

**URL:** https://hexdocs.pm/ash_oban/AshOban.html

**Contents:**
- AshOban (ash_oban v0.4.12)
- Module Names
- Summary
- Types
- Functions
- Types
- result()
- triggerable()
- Functions
- authorize?()

Tools for working with AshOban triggers.

Each trigger and scheduled action must have a defined module name, otherwise changing the name of the trigger will lead to "dangling" jobs. Because Oban uses the module name to determine which code should execute when a job runs, changing the module name associated with a trigger will cause those jobs to fail and be lost if their worker's module name was configured. By configuring the module name explicitly, renaming the resource or the trigger will not cause an issue.

This was an oversight in the initial design of AshOban triggers and scheduled actions, and in the future the module names will be required to ensure that this does not happen.

Use mix ash_oban.set_default_module_names to set the module names to their appropriate default values.

Builds a specific trigger for the record provided, but does not insert it into the database.

Alters your oban configuration to include the required AshOban configuration.

Runs a specific trigger for the record provided.

Runs a specific trigger for the records provided.

Schedules all relevant jobs for the provided trigger or scheduled action

Runs the schedulers for the given resource, domain, or otp_app, or list of resources, domains, or otp_apps.

Builds a specific trigger for the record provided, but does not insert it into the database.

All other options are passed through to Oban.Worker.new/2

Alters your oban configuration to include the required AshOban configuration.

Runs a specific trigger for the record provided.

Options are passed through to build_trigger/3 check its documentation for the possible values

Runs a specific trigger for the records provided.

Options are passed through to build_trigger/3 check its documentation for the possible values

Schedules all relevant jobs for the provided trigger or scheduled action

Runs the schedulers for the given resource, domain, or otp_app, or list of resources, domains, or otp_apps.

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.2) for the Elixir programming language

---

## AshOban

**URL:** https://hexdocs.pm/ash_oban/dsl-ashoban.html

**Contents:**
- AshOban
- Module Names
- oban
  - Nested DSLs
  - Examples
  - Options
  - oban.triggers
  - Nested DSLs
  - Examples
  - oban.triggers.trigger

Tools for working with AshOban triggers.

Each trigger and scheduled action must have a defined module name, otherwise changing the name of the trigger will lead to "dangling" jobs. Because Oban uses the module name to determine which code should execute when a job runs, changing the module name associated with a trigger will cause those jobs to fail and be lost if their worker's module name was configured. By configuring the module name explicitly, renaming the resource or the trigger will not cause an issue.

This was an oversight in the initial design of AshOban triggers and scheduled actions, and in the future the module names will be required to ensure that this does not happen.

Use mix ash_oban.set_default_module_names to set the module names to their appropriate default values.

Target: AshOban.Trigger

A section for configured scheduled actions. Supports generic and create actions.

Target: AshOban.Schedule

Hex Package Hex Preview (current file) Search HexDocs Download ePub version

Built using ExDoc (v0.38.2) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
oban do
  triggers do
    trigger :process do
      action :process
      where expr(processed != true)
      worker_read_action(:read)
    end
  end
end
```

Example 2 (unknown):
```unknown
triggers do
  trigger :process do
    action :process
    where expr(processed != true)
    worker_read_action(:read)
  end
end
```

Example 3 (unknown):
```unknown
trigger name
```

Example 4 (unknown):
```unknown
trigger :process do
  action :process
  where expr(processed != true)
  worker_read_action(:read)
end
```

---

## Home

**URL:** https://hexdocs.pm/ash_oban/readme.html

**Contents:**
- Home
- AshOban
- Tutorials
- Topics
- Reference

Welcome! This is the extension for integrating Ash resources with Oban. This extension allows you to easily execute resource actions in the background, and trigger actions based on data conditions.

Hex Package Hex Preview (current file) Search HexDocs Download ePub version

Built using ExDoc (v0.38.2) for the Elixir programming language

---

## AshOban.Schedule (ash_oban v0.4.12)

**URL:** https://hexdocs.pm/ash_oban/AshOban.Schedule.html

**Contents:**
- AshOban.Schedule (ash_oban v0.4.12)
- Summary
- Types
- Types
- t()

A configured scheduled action.

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.2) for the Elixir programming language

---
