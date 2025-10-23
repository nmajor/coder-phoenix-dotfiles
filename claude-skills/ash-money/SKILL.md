---
name: ash-money
description: Money and currency handling. Use for monetary values, currency management, financial calculations, decimal precision in financial contexts, money types, multi-currency support, and handling monetary amounts.
---

# Ash-Money Skill

Comprehensive assistance with ash-money development, a library that integrates the excellent `ex_money` library with the Ash Framework for declarative money/currency handling.

## When to Use This Skill

This skill should be triggered when:
- Defining money or currency attributes in Ash resources
- Working with financial calculations, pricing, or monetary values
- Setting up PostgreSQL money types with `ex_money_sql`
- Performing money operations in Ash expressions or aggregates
- Configuring currency constraints or formatting options
- Implementing e-commerce, billing, or financial systems with Ash
- Converting between currencies or working with decimal precision
- Storing monetary values with currency information in the database
- Using GraphQL with money types in AshGraphql

## Key Concepts

### Money Type Fundamentals
- **AshMoney.Types.Money**: Core Ash type backed by the `ex_money` library
- **Composite Structure**: Money is stored as `%{currency: "USD", amount: Decimal.new("100.00")}`
- **Storage Types**: `:money_with_currency` (default, PostgreSQL) or `:map` (generic)
- **Currency Codes**: ISO 4217 currency codes (USD, EUR, GBP, etc.)
- **Precision**: Uses `Decimal` for arbitrary precision arithmetic

### Integration Layers
1. **Ash Layer**: Type definitions and validations
2. **Database Layer**: PostgreSQL money_with_currency type (via ex_money_sql)
3. **API Layer**: GraphQL money type support (via AshGraphql)

## Quick Reference

### 1. Basic Money Attribute

Define a simple money attribute in an Ash resource:

```elixir
attribute :price, AshMoney.Types.Money
```

### 2. Money with Custom Type Alias

Use a short `:money` alias after registering the type:

```elixir
# In config.exs
config :ash, :known_types, [AshMoney.Types.Money]

# In your resource
attribute :balance, :money
attribute :charge, :money
```

### 3. Money with Formatting Constraints

Configure ex_money formatting options:

```elixir
attribute :charge, :money do
  constraints [
    ex_money_opts: [
      no_fraction_if_integer: true,
      format: :short
    ]
  ]
end
```

### 4. Composite Type Construction

Create money values programmatically:

```elixir
# Using AshMoney.Types.Money
composite_type(
  %{currency: "USD", amount: Decimal.new("0")},
  AshMoney.Types.Money
)

# Using :money alias (after configuration)
composite_type(
  %{currency: "EUR", amount: Decimal.new("99.99")},
  :money
)
```

### 5. PostgreSQL Setup with ex_money_sql

Enable database-level money operations:

```elixir
# In your repo
defmodule MyApp.Repo do
  use AshPostgres.Repo, otp_app: :my_app

  def installed_extensions do
    [
      "uuid-ossp",
      AshMoney.AshPostgresExtension  # Add this
    ]
  end
end
```

### 6. Money in Aggregates

Sum monetary values across related records:

```elixir
# In your resource
aggregates do
  sum :total_revenue, :orders, :amount
  # Works with money_with_currency type in PostgreSQL
end
```

### 7. Money in Expressions

Use money in runtime calculations:

```elixir
# In a calculation
calculation :discounted_price, :money do
  expr(price * 0.9)  # 10% discount
end

# In a filter
filter expr(balance > ^Money.new(:USD, 1000))
```

### 8. GraphQL Money Type

Add GraphQL support for money types:

```elixir
# In schema.ex
import_types AshGraphql.Types.Money

# Your resource will automatically expose money fields
# as: { amount: Decimal, currency: String }
```

### 9. Complete E-Commerce Example

A product resource with money handling:

```elixir
defmodule MyApp.Shop.Product do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer

  attributes do
    uuid_primary_key :id

    attribute :name, :string, allow_nil?: false

    attribute :price, :money do
      allow_nil? false
      constraints [
        ex_money_opts: [
          no_fraction_if_integer: true
        ]
      ]
    end

    attribute :cost, :money  # Wholesale cost
  end

  calculations do
    calculate :profit_margin, :money, expr(price - cost)
  end
end
```

### 10. Installation Steps

Quick setup guide:

```bash
# 1. Add to mix.exs
{:ash_money, "~> 0.2.4"}

# 2. For PostgreSQL support
{:ex_money_sql, "~> 1.12"}

# 3. Use Igniter (recommended)
mix igniter.install ash_money

# 4. Manual: Add to config.exs
config :ash, :known_types, [AshMoney.Types.Money]

# 5. Recompile Ash
mix deps.compile ash --force
```

## Reference Files

This skill includes comprehensive documentation in `references/`:

### types.md (5 pages)
Complete type reference covering:
- **AshMoney.Types.Money**: Core money type with constraints and options
- **Storage types**: `:money_with_currency` vs `:map`
- **Constraints**: `ex_money_opts` for formatting (no_fraction_if_integer, format, etc.)
- **AshMoney.AshPostgresExtension**: PostgreSQL extension installation
- **Composite type usage**: How to construct money values programmatically

### book-domain-modeling.md
Excerpts from "Ash Framework: Domain Modeling" book:
- Domain modeling with Ash resources
- Attributes, relationships, and aggregates
- Actions and lifecycle callbacks
- Real-world examples (project management app)
- Testing and validation patterns

### book-pragmatic-ash.md
Excerpts from "Ash Framework: Create Declarative Elixir Web Apps":
- Building resources and business logic
- Authentication and authorization with money
- API generation (REST, GraphQL)
- Real-world application examples

Use `view references/types.md` when you need detailed type information or constraint options.

## Working with This Skill

### For Beginners
1. Start with the basic money attribute example (#1)
2. Set up the `:money` type alias for convenience (#2)
3. Read `references/types.md` for core concepts
4. Try the installation steps (#10)

### For Implementing Features
1. Use the e-commerce example (#9) as a template
2. Configure ex_money formatting options (#3) for display
3. Set up PostgreSQL extension (#5) for database operations
4. Add aggregates (#6) for summing monetary values

### For Advanced Use Cases
1. Use money in expressions (#7) for complex calculations
2. Configure GraphQL support (#8) for APIs
3. Review the book excerpts for architectural patterns
4. Explore aggregate and calculation combinations

### For Troubleshooting
- **Type not recognized**: Ensure `AshMoney.Types.Money` is in `config :ash, :known_types`
- **Database errors**: Verify `AshMoney.AshPostgresExtension` is installed and migrations run
- **Precision issues**: Money uses `Decimal` for exact arithmetic - avoid floats
- **Currency mismatches**: ex_money validates currency codes (ISO 4217)

## Common Patterns

### Pattern: Product Pricing
```elixir
attribute :price, :money, allow_nil?: false
attribute :sale_price, :money

calculation :effective_price, :money do
  expr(sale_price || price)
end
```

### Pattern: Order Totals
```elixir
# On Order resource
aggregates do
  sum :subtotal, :line_items, :total
end

calculation :total, :money do
  expr(subtotal + tax + shipping)
end
```

### Pattern: Currency Validation
```elixir
attribute :amount, :money do
  constraints [
    ex_money_opts: [
      permitted_currencies: ["USD", "EUR", "GBP"]
    ]
  ]
end
```

## Resources

### Official Documentation
- **ex_money**: https://hexdocs.pm/ex_money/
- **ash_money**: https://hexdocs.pm/ash_money/
- **Ash Framework**: https://hexdocs.pm/ash/

### Key Dependencies
- `ex_money`: Underlying money/currency library
- `ex_money_sql`: PostgreSQL money type support
- `decimal`: Precise decimal arithmetic

### Related Skills
- Use the **ash** skill for core Ash Framework concepts
- Use the **ash-postgres** skill for database layer details
- Use the **ash-graphql** skill for GraphQL API integration

## Notes

- This skill was generated from official ash_money v0.2.4 documentation
- Money values are immutable and use `Decimal` for precision
- Always use the PostgreSQL extension for production money operations
- The `:money_with_currency` storage type enables database-level aggregations
- ex_money handles currency conversions when exchange rates are configured

## Updating

To refresh this skill with updated documentation:
1. Re-run the documentation scraper with the same configuration
2. The skill will be rebuilt with the latest information from HexDocs
