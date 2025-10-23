# Ash-Double-Entry - Accounting

**Pages:** 7

---

## 

**URL:** https://hexdocs.pm/ash_double_entry/ash_double_entry.epub

---

## AshDoubleEntry.Balance

**URL:** https://hexdocs.pm/ash_double_entry/dsl-ashdoubleentry-balance.html

**Contents:**
- AshDoubleEntry.Balance
- balance
  - Options

An extension for creating a double entry ledger balance. See the getting started guide for more.

Hex Package Hex Preview (current file) Search HexDocs Download ePub version

Built using ExDoc (v0.38.2) for the Elixir programming language

---

## AshDoubleEntry.Account

**URL:** https://hexdocs.pm/ash_double_entry/dsl-ashdoubleentry-account.html

**Contents:**
- AshDoubleEntry.Account
- account
  - Options

An extension for creating a double entry ledger account. See the getting started guide for more.

Hex Package Hex Preview (current file) Search HexDocs Download ePub version

Built using ExDoc (v0.38.2) for the Elixir programming language

---

## AshDoubleEntry.ULID (ash_double_entry v1.0.15)

**URL:** https://hexdocs.pm/ash_double_entry/AshDoubleEntry.ULID.html

**Contents:**
- AshDoubleEntry.ULID (ash_double_entry v1.0.15)
- Summary
- Types
- Functions
- Types
- t()
- Functions
- bingenerate(timestamp \\ System.system_time(:millisecond))
- bingenerate_last(timestamp \\ System.system_time(:millisecond))
- cast_input(value, constraints)

An Ash type for ULID strings.

A hex-encoded ULID string.

Generates a binary ULID.

Generates a binary ULID.

Casts a string to ULID.

Converts a binary ULID into a Crockford Base32 encoded string.

Converts a Crockford Base32 encoded ULID into a binary.

Generates a Crockford Base32 encoded ULID.

Generates a Crockford Base32 encoded ULID, guaranteed to sort equal to or after any other ULID generated for the same timestamp.

The underlying schema type.

A hex-encoded ULID string.

Generates a binary ULID.

If a value is provided for timestamp, the generated ULID will be for the provided timestamp. Otherwise, a ULID will be generated for the current time.

Generates a binary ULID.

Do not use this for storage, only for generating comparators, i.e "balance as of a given ulid".

If a value is provided for timestamp, the generated ULID will be for the provided timestamp. Otherwise, a ULID will be generated for the current time.

Casts a string to ULID.

Converts a binary ULID into a Crockford Base32 encoded string.

Converts a Crockford Base32 encoded ULID into a binary.

Generates a Crockford Base32 encoded ULID.

If a value is provided for timestamp, the generated ULID will be for the provided timestamp. Otherwise, a ULID will be generated for the current time.

Generates a Crockford Base32 encoded ULID, guaranteed to sort equal to or after any other ULID generated for the same timestamp.

Do not use this for storage, only for generating comparators, i.e "balance as of a given ulid".

If a value is provided for timestamp, the generated ULID will be for the provided timestamp. Otherwise, a ULID will be generated for the current time.

The underlying schema type.

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.2) for the Elixir programming language

---

## Getting Started with Ash Double Entry

**URL:** https://hexdocs.pm/ash_double_entry/getting-started-with-ash-double-entry.html

**Contents:**
- Getting Started with Ash Double Entry
- What makes it special?
- Setup
  - Setup AshMoney
  - Add the dependency
  - Define your account resource
    - Example
    - What does this extension do?
  - Define your transfer resource
    - Example

Ash Double Entry is implemented as a set of Ash resource extensions. You build the resources yourself, and the extensions add the attributes, relationships, actions and validations required for them to constitute a double entry system.

Follow the setup guide for AshMoney. If you are using with AshPostgres, be sure to include the :ex_money_sql dependency in your mix.exs.

If you are not using a data layer capable of automatic cascade deletion, you must add destroy_balances? true to the transfer resource! We do this with the references block in ash_postgres as shown above.

And add the domain to your config

config :your_app, ash_domains: [..., YourApp.Ledger]

mix ash_postgres.generate_migrations --name add_double_entry_ledger

mix ash_postgres.migrate

If config :ash, :default_actions_require_atomic? is set to true, the Transfer resource update actions must define change get_and_lock_for_update() and require_atomic? false. It's OK to add require_atomic? false because the relevant accounts are locked before updating them.

There are tons of things you can do with your resources. You can add code interfaces to give yourself a nice functional api. You can add custom attributes, aggregates, calculations, relationships, validations, changes, all the great things built into Ash.Resource! See the docs for more: AshHq.

Hex Package Hex Preview (current file) Search HexDocs Download ePub version

Built using ExDoc (v0.38.2) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
{:ash_double_entry, "~> 1.0.3"}
```

Example 2 (unknown):
```unknown
defmodule YourApp.Ledger.Account do
  use Ash.Resource,
    domain: YourApp.Ledger,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshDoubleEntry.Account]

  postgres do
    table "accounts"
    repo YourApp.Repo
  end

  account do
    # configure the other resources it will interact with
    transfer_resource YourApp.Ledger.Transfer
    balance_resource YourApp.Ledger.Balance
    # accept custom attributes in the autogenerated `open` create action
    open_action_accept [:account_number]
  end

  attributes do
    # Add custom attributes
    attribute :account_number, :string do
   
...
```

Example 3 (unknown):
```unknown
defmodule YourApp.Ledger.Transfer do
  use Ash.Resource,
    domain: YourApp.Ledger,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshDoubleEntry.Transfer]

  postgres do
    table "transfers"
    repo YourApp.Repo
  end

  transfer do
    # configure the other resources it will interact with
    account_resource YourApp.Ledger.Account
    balance_resource YourApp.Ledger.Balance

    # you only need this if you are using `postgres`
    # and so cannot add the `references` block shown below

    # destroy_balances? true
  end
end
```

Example 4 (unknown):
```unknown
defmodule YourApp.Ledger.Balance do
  use Ash.Resource,
    domain: YourApp.Ledger,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshDoubleEntry.Balance]

  postgres do
    table "balances"
    repo YourApp.Repo

    references do
      reference :transfer, on_delete: :delete
    end
  end

  balance do
    # configure the other resources it will interact with
    transfer_resource YourApp.Ledger.Transfer
    account_resource YourApp.Ledger.Account
  end

  actions do
    read :read do
      primary? true
      # configure keyset pagination for streaming
      pagination keyset?: tru
...
```

---

## AshDoubleEntry.Transfer

**URL:** https://hexdocs.pm/ash_double_entry/dsl-ashdoubleentry-transfer.html

**Contents:**
- AshDoubleEntry.Transfer
- transfer
  - Options

An extension for creating a double entry ledger transfer. See the getting started guide for more.

Hex Package Hex Preview (current file) Search HexDocs Download ePub version

Built using ExDoc (v0.38.2) for the Elixir programming language

---

## Home

**URL:** https://hexdocs.pm/ash_double_entry/readme.html

**Contents:**
- Home
- AshDoubleEntry
- Tutorials
- Reference

Welcome! This is the extension for building a double entry accounting system in Ash. This extension provides the basic building blocks for you to extend as necessary.

Hex Package Hex Preview (current file) Search HexDocs Download ePub version

Built using ExDoc (v0.38.2) for the Elixir programming language

---
