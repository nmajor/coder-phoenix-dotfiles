# Ash-Core - Guides

**Pages:** 4

---

## Project Structure

**URL:** https://hexdocs.pm/ash/project-structure.html

**Contents:**
- Project Structure
  - These are recommendations
- Where do I put X thing
- Example 1: Reads & Calculations
- Example 2: Using external data in create actions

In this guide we'll discuss some best practices for how to structure your project. These recommendations align well with Elixir conventions around file and module naming. These conventions allow for a logical coupling of module and file names, and help keep your project organized and easy to navigate.

None of the things we show you here are requirements, only recommendations. Feel free to plot your own course here. Ash avoids any pattern that requires you to name a file or module in a specific way, or put them in a specific place. This ensures that all connections between one module and another module are explicit rather than implicit.

These recommendations all correspond to standard practice in most Elixir/Phoenix applications

Place your Ash application in the standard Elixir application directory lib/my_app. Your Ash.Domain modules should be at the root level of this directory. Each domain should have a directory named after it, containing the domain's Ash.Resource modules and any of the domain's supporting modules. All resource interaction ultimately goes through a domain module.

For resources that require additional files, create a dedicated folder in the domain context named after the resource. We suggest organizing these supplementary files into subdirectories by type (like changes/, preparations/, etc.), though this organization is optional.

The purpose of Ash is to be both the model of and the interface to your domain logic (A.K.A business logic). Applying this generally looks like building as much of your domain logic "behind" your resources. This does not mean, however, that everything has to go inside of your resources. For example, if you have a Purchase resource, and you want to be able to display a list of purchases that were taxable, and also calculate the percentage of the purchase that was taxable. You might have an action called :taxable and a calculation called :percentage_tax.

In practice, you may not need the taxable action, i.e perhaps you simply want a "taxable" checkbox on a list view in your application, in which case you may use the primary read, or some other read like :transaction_report. You would then, on the consumer, provide the filter for taxable == true, and load the :percentage_tax calculation.

Lets say you want the user to fill in a github issue id, and you will fetch information from that github issue to use as part of creating a "ticket" in your system.. You might be tempted to do something like this in a LiveVi

*[Content truncated]*

**Examples:**

Example 1 (unknown):
```unknown
lib/
├── my_app/                    # Your application's main namespace
│   ├── accounts.ex            # Accounts domain module
│   ├── helpdesk.ex            # Helpdesk domain module
│   │
│   ├── accounts/               # Accounts context
│   │   ├── user.ex             # User resource
│   │   ├── user/               # User resource files
│   │   ├── token.ex            # Token resource
│   │   └── password_helper.ex  # Support module
│   │
│   └── helpdesk/            # Helpdesk context
│       ├── ticket.ex        # Ticket resource
│       ├── notification.ex  # Notification resource
│    
...
```

Example 2 (unknown):
```unknown
actions do
  ...

  read :taxable do
    filter expr(taxable == true)
  end
end

calculations do
  calculate :percentage_tax, :decimal, expr(
    sum(line_items, field: :amount, query: [filter: tax == true]) /
    sum(line_items, field: :amount)
  )
end
```

Example 3 (javascript):
```javascript
def handle_event("link_ticket", %{"issue_id" => issue_id}, socket) do
  issue_info = GithubApi.get_issue(issue_id)

  MyApp.Support.update_ticket(socket.assigns.ticket_id, %{issue_info: %{
    title: issue_info.title,
    body: issue_info.body
  }})
end
```

Example 4 (python):
```python
defmodule MyApp.Ticket.FetchIssueInfo do
  use Ash.Resource.Change

  def change(changeset, _, _) do
    Ash.Changeset.before_transaction(changeset, fn changeset ->
      issue_info = GithubApi.get_issue(changeset.arguments.issue_id)

      Ash.Changeset.force_change_attributes(changeset, %{
        issue_info: %{
          title: issue_info.title,
          body: issue_info.body
        }
      })
    end)
  end
end
```

---

## Writing Extensions

**URL:** https://hexdocs.pm/ash/writing-extensions.html

**Contents:**
- Writing Extensions
- Creating an extension
  - DSL Extension
  - Transformers
  - Make the extension configurable
  - Ordering of transformers
- Using your extension
- Base Resources

Extensions allow you to make powerful modifications to DSL entities. If you are using AshPostgres, AshGraphql or AshJsonApi, they are all integrated into Ash using extensions. In this guide we will build a simple extension for Ash.Resource that adds timestamps to your resource. We'll also show some simple patterns that can help ensure that all of your resources are using your extension.

What we call an "extension" is typically one or more Spark.Dsl.Extension, and then any additional code that is used by that extension. For example, AshGraphql has a domain extension called AshGraphql.Domain, a resource extension called AshGraphql.Resource, and code to connect a GraphQL schema to your resources.

Here we create a DSL extension called MyApp.Extensions.Base, and configure a single transformer, called MyApp.Extensions.Base.AddTimestamps

Transformers are all run serially against a map of data called dsl_state, which is the data structure that we build as we use the DSL. For example:

Would, under the hood, look something like this:

A transformer exposes transform/1, which takes the dsl_state and returns either {:ok, dsl_state} or {:error, error}

This transformer builds adds a create_timestamp called :inserted_at and an update_timestamp called :updated_at, unless they already exist.

So far we've covered transformers, and using them to modify resources, but now lets say we want to make this behavior opt-out. Perhaps certain resources really shouldn't have timestamps, but we want it to be the default. Lets add a "DSL Section" to our extension.

Now we can use this configuration in our transformer, like so:

And now we have a configurable base extension! For more information on writing DSLs, see Spark. Spark is still lacking in documentation, unfortunately, as its something that mostly the adventurous/power users work with, and they often learn by way of examples, looking at Ash extensions. We would like to rectify this in the future. Please reach out if you're interested in assisting with that effort!

In this case, this transformer can run in any order. However, as we start adding transformers and/or modify the behavior of this one, we may need to ensure that our transformer runs before or after specific transformers. As of the writing of this guide, the best way to look at the list of transformers is to look at the source of the extension, and see what transformers it has and what they do. The Resource DSL for example.

If you need to affect the ordering, yo

*[Content truncated]*

**Examples:**

Example 1 (unknown):
```unknown
defmodule MyApp.Extensions.Base do
  use Spark.Dsl.Extension, transformers: [MyApp.Extensions.Base.AddTimestamps]
end
```

Example 2 (unknown):
```unknown
attributes do
  attribute :name, :string
end
```

Example 3 (javascript):
```javascript
%{
  [:attributes] => %{entities: [
      %Ash.Resource.Attribute{name: :name, type: :string}
    ]
  },
  ...
}
```

Example 4 (python):
```python
defmodule MyApp.Extensions.Base.AddTimestamps do
  use Spark.Dsl.Transformer
  alias Spark.Dsl.Transformer

  def transform(dsl_state) do
    dsl_state
    # Ash.Resource.Builder has utilities for extending resources
    |> Ash.Resource.Builder.add_new_create_timestamp(:inserted_at)
    |> Ash.Resource.Builder.add_new_update_timestamp(:updated_at)
  end
end
```

---

## Working with LLMs

**URL:** https://hexdocs.pm/ash/working-with-llms.html

**Contents:**
- Working with LLMs
  - Getting Support with LLM generated code
- What to know
- Tools
- Rules
  - Combine all of your (direct) dependencies usage rules
  - Pick specific dependencies
  - Guide it on tools/design
    - General Guidance
    - Tidewave

LLMs are a new technology, and the patterns on how best to leverage them evolve every day. It is also quite debatable whether it is a good idea to use them at all. Nothing in Ash will ever be predicated on the usage of these tools, but we do want to provide at least some level of base guidance on what we think are the best practices for those that do. This is also to help those who are interested in trying these tools but don't yet know where to start.

This guide is about working with LLM dev assistants, not about building LLM-related features or integrating them into your application. For that, see Ash AI.

Please note that LLMs often hallucinate despite our best intentions. If you need help with something, and you come to our support channels, you must make it clear when the code you are asking for help with was generated by an LLM. You must first understand the code you've written yourself, and provide a detailed explanation of the code and the issue you are facing when requesting help. The discord and forums are not a place for others to debug LLM hallucinations.

To take advantage of LLMs, you will want to explore the following. You will have to make up your own mind on which avenues to explore and leverage in the following areas. This is essentially a "big list of stuff you should research on your own".

We suggest setting up, where applicable, the following tools:

We are working on establishing a pattern whereby packages can provide a usage-rules.md which you can then combine into your own rules file. The idea here is to democratize the process of building rules, allowing you to adopt well vetted and quality rules files from the maintainers of projects. This has only been done for a few packages so far.

To leverage these rules files, you can simply copy them yourself if you'd prefer something more manual, or you can use a new mix task provided by the usage_rules package to combine them into your own rules file.

You can replace the .rules file with your own current rules file, and it will be appended to the contents. Repeated calls will only replace the package rules contents of the file, not the whole file contents.

Only dependencies of your current project will be added, and any dependencies that don't have rules are skipped.

It's also important to guide your AI on overall design decisions, and which tools to use. The majority of Elixir code LLMs are trained on will be using Phoenix contexts and direct Ecto calls.

Here are some recommendatio

*[Content truncated]*

**Examples:**

Example 1 (unknown):
```unknown
mix usage_rules.sync .rules --all
```

Example 2 (unknown):
```unknown
mix usage_rules.sync .rules \
  ash ash_postgres ash_phoenix ash_graphql ash_json_api ash_ai
```

Example 3 (unknown):
```unknown
## Ash First

Always use Ash concepts, almost never Ecto concepts directly. Think hard about the "Ash way" to do things. If you don't know, look for information in the rules & docs of Ash & associated packages.

## Code Generation

Start with generators wherever possible. They provide a starting point for your code and can be modified if needed.

## Logs & Tests

When you're done executing code, try to compile the code, and check the logs or run any applicable tests to see what effect your changes have had.
```

Example 4 (javascript):
```javascript
## Tools

Use Tidewave MCP tools, as they let you interrogate the running application in various useful ways.

- Never attempt to start or stop a Phoenix application. Tidewave tools work by being connected to the running application, and starting or stopping it can cause issues.
- Use the `project_eval` tool to execute code in the running instance of the application. Eval `h Module.fun` to get documentation for a module or function.
- Always use `search_package_docs` to find relevant documentation before beginning work.
```

---

## Write Queries

**URL:** https://hexdocs.pm/ash/write-queries.html

**Contents:**
- Write Queries
- Introduction
- Setup
  - Basic Queries
- Read everything
- Count all comments
- Filtering
- Sorting
- Distinct
- Load calculations/aggregates

Here we will show practical examples of using Ash.Query. To understand more about its capabilities, limitations, and design, see the module docs of Ash.Query.

This guide is here to provide a slew of examples, for more information on any given function or option please search the documentation. Please propose additions for any useful patterns that are not demonstrated here!

First, lets create some resources and some data to query.

Let's start with some basic query examples. To use Ash.Query.filter/2, we'll need to require Ash.Query.

Hex Package Hex Preview (current file) Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
Mix.install([{:ash, "~> 3.0"}],
  consolidate_protocols: false
)

Application.put_env(:ash, :validate_domain_resource_inclusion?, false)
Application.put_env(:ash, :validate_domain_config_inclusion?, false)

ExUnit.start()
```

Example 2 (unknown):
```unknown
defmodule MyApp.Posts do
  use Ash.Domain

  resources do
    resource MyApp.Posts.Post
    resource MyApp.Posts.Comment
  end
end

defmodule MyApp.Posts.Post do
  use Ash.Resource,
    domain: MyApp.Posts,
    data_layer: Ash.DataLayer.Ets

  actions do
    defaults [:read, :destroy, create: :*]
  end
  
  attributes do
    uuid_primary_key :id
    
    attribute :text, :string do
      allow_nil? false
      public? true
    end
  end

  calculations do
    calculate :text_length, :integer, expr(string_length(text))
  end

  aggregates do
    count :count_of_comments, :comments
  end

  rela
...
```

Example 3 (unknown):
```unknown
{:module, MyApp.Posts.Comment, <<70, 79, 82, 49, 0, 0, 110, ...>>,
 [
   Ash.Expr,
   Ash.Resource.Dsl.Relationships.BelongsTo,
   Ash.Resource.Dsl.Relationships.ManyToMany,
   Ash.Resource.Dsl.Relationships.HasMany,
   Ash.Resource.Dsl.Relationships.HasOne,
   %{...}
 ]}
```

Example 4 (unknown):
```unknown
# Get rid of any existing comments/posts
Ash.bulk_destroy!(MyApp.Posts.Comment, :destroy, %{})
Ash.bulk_destroy!(MyApp.Posts.Post, :destroy, %{})

# Create some posts
post1 =
  Ash.create!(MyApp.Posts.Post, %{text: "First post about Ash!"})

post2 =
  Ash.create!(MyApp.Posts.Post, %{text: "Learning to write queries"})

comment1 =
  Ash.create!(MyApp.Posts.Comment, %{text: "Great post!", post_id: post1.id})

comment2 =
  Ash.create!(MyApp.Posts.Comment, %{text: "Very helpful!", post_id: post1.id})

comment3 =
  Ash.create!(MyApp.Posts.Comment, %{text: "Thanks for the explanation", post_id: post
...
```

---
