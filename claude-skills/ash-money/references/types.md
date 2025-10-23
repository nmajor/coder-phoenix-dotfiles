# Ash-Money - Types

**Pages:** 5

---

## 

**URL:** https://hexdocs.pm/ash_money/ash_money.epub

---

## AshMoney.Types.Money (ash_money v0.2.4)

**URL:** https://hexdocs.pm/ash_money/AshMoney.Types.Money.html

**Contents:**
- AshMoney.Types.Money (ash_money v0.2.4)
- Constraints Options
  - Example
- Summary
- Functions
- Functions
- handle_change?()
- prepare_change?()

A money type for Ash that uses the ex_money library.

When constructing a composite type, use a tuple in the following structure:

composite_type(%{currency: "USD", amount: Decimal.new("0")}}, AshMoney.Types.Money)

If you've added a custom type, like :money:

:storage_type (atom/0) - The storage type for the money value. Can be :money_with_currency or :map. There is no difference between the two unless ex_money_sql is installed. The default value is :money_with_currency.

:ex_money_opts (keyword/0) - ex_money Money.new/3 Options - https://hexdocs.pm/ex_money/Money.html#new/3-options

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.2) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
composite_type(%{currency: "USD", amount: Decimal.new("0")}, :money)
```

Example 2 (unknown):
```unknown
attribute :charge, :money do
  constraints: [
    ex_money_opts: [
      no_fraction_if_integer: true,
      format: :short
    ]
  ]
end
```

---

## AshMoney.AshPostgresExtension (ash_money v0.2.4)

**URL:** https://hexdocs.pm/ash_money/AshMoney.AshPostgresExtension.html

**Contents:**
- AshMoney.AshPostgresExtension (ash_money v0.2.4)
- Summary
- Functions
- Functions
- extension()
- install(int)
- uninstall(v)

Installs the money_with_currency type and operators/functions for Postgres.

Callback implementation for AshPostgres.CustomExtension.install/1.

Callback implementation for AshPostgres.CustomExtension.uninstall/1.

Callback implementation for AshPostgres.CustomExtension.install/1.

Callback implementation for AshPostgres.CustomExtension.uninstall/1.

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.2) for the Elixir programming language

---

## Getting Started With AshMoney

**URL:** https://hexdocs.pm/ash_money/getting-started-with-ash-money.html

**Contents:**
- Getting Started With AshMoney
- Bring in the ash_money dependency
- Setup
  - Using Igniter (recommended)
  - Manual
- Add to known types
- Referencing with :money
- Adding AshPostgres Support
- AshPostgres Support
- AshGraphql Support

The primary thing that AshMoney provides is AshMoney.Types.Money. This is backed by ex_money. You can use it out of the box like so:

To support money operations in runtime expressions, which use Ash's operator overloading feature, we have to tell Ash about the Ash.Type.Money using the known_type configuration.

You can add it to your compile time list of types for easier reference:

Then compile ash again, mix deps.compile ash --force, and refer to it like so:

First, add the :ex_money_sql dependency to your mix.exs file.

Then add AshMoney.AshPostgresExtension to your list of installed_extensions in your repo, and generate migrations.

Thanks to ex_money_sql, there are excellent tools for lowering support for money into your postgres database. This allows for things like aggregates that sum amounts, and referencing money in expressions:

Add the following to your schema file:

Hex Package Hex Preview (current file) Search HexDocs Download ePub version

Built using ExDoc (v0.38.2) for the Elixir programming language

**Examples:**

Example 1 (python):
```python
def deps()
  [
    ...
    {:ash_money, "~> 0.2.4"}
  ]
end
```

Example 2 (unknown):
```unknown
mix igniter.install ash_money
```

Example 3 (unknown):
```unknown
attribute :balance, AshMoney.Types.Money
```

Example 4 (unknown):
```unknown
config :ash, :known_types, [AshMoney.Types.Money]
```

---

## Home

**URL:** https://hexdocs.pm/ash_money/readme.html

**Contents:**
- Home
- AshMoney
- Tutorials

Welcome! This is the extension for working with money types in Ash. This is a thin wrapper around the very excellent ex_money. It provides:

Hex Package Hex Preview (current file) Search HexDocs Download ePub version

Built using ExDoc (v0.38.2) for the Elixir programming language

---
