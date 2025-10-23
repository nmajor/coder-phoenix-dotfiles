# Ash-Postgres - Getting Started

**Pages:** 1

---

## Get Started With Postgres

**URL:** https://hexdocs.pm/ash_postgres/get-started-with-ash-postgres.html

**Contents:**
- Get Started With Postgres
- Installation
  - Using Igniter (recommended)
  - Manually
    - Add AshPostgres
    - Create and configure your Repo
- Adding AshPostgres to your resources
  - With Igniter
  - Manually
    - Create the database and tables

We recommend reading up on postgresql if you haven't.

Add the :ash_postgres dependency to your application

{:ash_postgres, "~> 2.0.0"}

Add :ash_postgres to your .formatter.exs file

Create lib/helpdesk/repo.ex with the following contents. AshPostgres.Repo is a thin wrapper around Ecto.Repo, so see their documentation for how to use it if you need to use it directly. For standard Ash usage, all you will need to do is configure your resources to use your repo.

Next we will need to create configuration files for various environments. Run the following to create the configuration files we need.

Place the following contents in those files, ensuring that the credentials match the user you created for your database. For most conventional installations this will work out of the box. If you've followed other guides before this one, they may have had you create these files already, so just make sure these contents are there.

And finally, add the repo to your application

You can add AshPostgres to a resource with mix ash.patch.extend Your.Resource.Name postgres. For example:

The basic configuration for a resource requires the AshPostgres.postgres.table and the AshPostgres.postgres.repo.

First, we'll create the database with mix ash.setup.

Then we will generate database migrations. This is one of the many ways that AshPostgres can save time and reduce complexity.

If you are unfamiliar with database migrations, it is a good idea to get a rough idea of what they are and how they work. See the links at the bottom of this guide for more. A rough overview of how migrations work is that each time you need to make changes to your database, they are saved as small, reproducible scripts that can be applied in order. This is necessary both for clean deploys as well as working with multiple developers making changes to the structure of a single database.

Typically, you need to write these by hand. AshPostgres, however, will store snapshots each time you run the command to generate migrations and will figure out what migrations need to be created.

You should always look at the generated migrations to ensure that they look correct. Do so now by looking at the generated file in priv/repo/migrations.

Finally, we will create the local database and apply the generated migrations:

This is based on the Get Started guide. If you haven't already, you should read that first.

And now we're ready to try it out! Run the following in iex:

Lets create some data. We'll make a re

*[Content truncated]*

**Examples:**

Example 1 (unknown):
```unknown
mix igniter.install ash_postgres
```

Example 2 (python):
```python
[
  # import the formatter rules from `:ash_postgres`
  import_deps: [..., :ash_postgres],
  inputs: [...]
]
```

Example 3 (python):
```python
# in lib/helpdesk/repo.ex

defmodule Helpdesk.Repo do
  use AshPostgres.Repo, otp_app: :helpdesk

  def installed_extensions do
    # Ash installs some functions that it needs to run the
    # first time you generate migrations.
    ["ash-functions"]
  end
end
```

Example 4 (unknown):
```unknown
mkdir -p config
touch config/config.exs
touch config/dev.exs
touch config/runtime.exs
touch config/test.exs
```

---
