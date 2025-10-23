# Ash-Core - Getting Started

**Pages:** 2

---

## Manual Installation

**URL:** https://hexdocs.pm/ash/manual-installation.html

**Contents:**
- Manual Installation
- Install & Setup Dependencies
- Skip protocol consolidation
- Setup The Formatter
- Configure Dev/Test environments
- Setup Backwards Compatibility Configurations

This guide will walk you through the process of manually installing Ash into your project. If you are starting from scratch, you can use mix new or mix igniter.new and follow these instructions. These installation instructions apply both to new projects and existing ones.

See the readmes for spark and reactor for more information on their installation. We've included their changes here for your convenience.

Create .formatter.exs:

Create config/config.exs:

Update .formatter.exs:

To avoid warnings about protocol consolidation when recompiling in dev, we set protocolc onsolidation to happen only in non-dev environments.

Configure the DSL auto-formatter. This tells the formatter to remove excess parentheses and how to sort sections in your Ash.Resource & Ash.Domain modules for consistency.

Update .formatter.exs:

Update config/config.exs:

Configure backwards compatibility settings. See the backwards compatibility guide for an explanation of each of the configurations.

Update config/config.exs:

Create config/dev.exs:

Create config/prod.exs:

Create config/test.exs:

Configure backwards compatibility settings. See the backwards compatibility guide for an explanation of each of the configurations.

Update config/config.exs:

Hex Package Hex Preview (current file) Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
# Used by "mix format"
[
  inputs: ["{mix,.formatter}.exs", "{config,lib,test}/**/*.{ex,exs}"],
  plugins: [Spark.Formatter]
]
```

Example 2 (unknown):
```unknown
import Config
config :spark, formatter: [remove_parens?: true]
```

Example 3 (unknown):
```unknown
...
    defp deps do
      [
+       {:sourceror, "~> 1.8", only: [:dev, :test]}
        # {:dep_from_hexpm, "~> 0.3.0"},
        # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
...
```

Example 4 (unknown):
```unknown
...
  [
    inputs: ["{mix,.formatter}.exs", "{config,lib,test}/**/*.{ex,exs}"],
-   plugins: [Spark.Formatter]
+   plugins: [Spark.Formatter],
+   import_deps: [:reactor]
  ]
```

---

## Get Started

**URL:** https://hexdocs.pm/ash/get-started.html

**Contents:**
- Get Started
  - Learn with Livebook
- Goals
- Requirements
- Steps
  - Create a new project
  - What is igniter?
  - New project
  - New Phoenix project
  - Existing Project

We have a basic step by step tutorial in Livebook that introduces you to Ash. No prior Ash knowledge is required. The Livebook tutorial is self contained and separate from the documentation below.

In this guide we will:

If you want to follow along yourself, you will need the following things:

For this tutorial, we'll use examples based around creating a Help Desk system.

We will make the following resources:

The actions we will be able to take on these resources include:

This guide focuses on getting you introduced to Ash quickly. For that reason, we recommend starting a fresh project to explore the concepts. You can, however, add Ash to your existing project if desired. See the options below for more.

Igniter is a code generation and project setup tool that automates the installation and configuration of Elixir packages. Instead of manually adding dependencies and writing boilerplate code, Igniter handles this for you. When you run mix igniter.install ash, it automatically adds Ash to your project and sets up the necessary configuration files.

First, to use mix igniter.new, the archive must be installed.

If you already know that you want to use Phoenix and Ash together, you can use

You can use igniter to add Ash to your existing project as well.

Finally, if you want to install Ash manually, step by step, follow the manual installation guide.

If you have trouble compiling picosat_elixir, then alter your mix.exs file to replace {:picosat_elixir, "~> 0.2"} with {:simple_sat, "~> 0.1"} to use a simpler (but mildly slower) solver. You can always switch back to picosat_elixir later once you're done with the tutorial. Then, run mix deps.get && mix deps.compile ash --force

The basic building blocks of an Ash application are Ash resources. They are tied together by a domain module, which will allow you to interact with those resources.

We have CLI commands that will do this for you, for example mix ash.gen.resource. In this getting started guide, we will create the resources by hand. This is primarily because there are not actually very many steps, and we want you to be familiar with each moving piece. For more on the generators, run mix help ash.gen.resource.

Let's start by creating our first resource along with our first domain. We will create the following files:

To create the required folders and files, you can use the following command in your terminal:

Your project structure should now include the following files:

Add the following contents

*[Content truncated]*

**Examples:**

Example 1 (unknown):
```unknown
# install igniter.new
mix archive.install hex igniter_new

# create a new application with Ash in it
mix igniter.new helpdesk --install ash && cd helpdesk
```

Example 2 (unknown):
```unknown
# install the archive
mix archive.install hex phx_new
mix archive.install hex igniter_new

# use the `--with` flag to generate the project with phx.new and add Ash
mix igniter.new helpdesk --install ash,ash_phoenix --with phx.new && cd helpdesk
```

Example 3 (unknown):
```unknown
mix archive.install hex igniter_new
mix igniter.install ash
```

Example 4 (unknown):
```unknown
mkdir -p lib/helpdesk/support && \
  touch $_/ticket.ex && \
  touch lib/helpdesk/support.ex
```

---
