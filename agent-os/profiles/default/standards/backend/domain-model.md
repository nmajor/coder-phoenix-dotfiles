## Ash resource design standards

**CRITICAL REQUIREMENT**: This application's backend domain layer MUST follow declarative design principles using Ash Framework and its ecosystem. Imperative and procedural approaches are explicitly forbidden in favor of Ash's declarative DSLs.

This document governs backend domain modeling only—resources, actions, relationships, policies, and business logic. Frontend concerns are separate, except where they interface with the domain (code interfaces, form definitions).

## What is Declarative Design?

**Declarative programming** means describing *what* your system should do, not *how* to do it. Instead of writing step-by-step instructions (imperative), you define rules and constraints (declarative), and the framework executes them optimally.

### The Power of Declarative Design

1. **Single Source of Truth**: Domain model becomes the canonical definition from which everything derives
2. **Introspectable**: Framework can analyze declarations at compile-time and runtime
3. **Composable**: Declarations combine and extend without modification
4. **Maintainable**: Changes to declarations propagate automatically
5. **Auditable**: All behavior flows through defined, traceable paths

### Ash Framework's Implementation

Ash transforms declarative resource definitions into:
- Database schemas and migrations (AshPostgres)
- API endpoints (AshJsonApi, AshGraphql)
- Authorization rules (Policies)
- Background jobs (AshOban)
- State machines (AshStateMachine)
- Authentication flows (AshAuthentication)
- UI forms (AshPhoenix)
- Complex workflows (Reactor)

**The paradigm shift**: You don't write code to *implement* these features. You *declare* your domain, and Ash *derives* them.

## The Golden Rule

> **ALL backend business logic MUST be expressed through Ash's declarative primitives: resources, actions, policies, calculations, aggregates, validations, changes, and lifecycle hooks. Imperative functions that bypass these primitives are forbidden.**

If you find yourself writing functions that manipulate data outside of Ash actions, **stop**. You're doing it wrong.

### Core Principles

- **Declarative First**: Express ALL backend domain logic through Ash primitives (resources, actions, policies, calculations, aggregates). NEVER write imperative functions that bypass these primitives, except as an absolute last resort where ash primitives fail to define the desired functionality
- **Resources as Complete Domain Models**: Resources define data structure, behavior, derivations, rules, workflows, and background processing in one place
- **Actions as Domain Operations**: Define domain-specific actions (`:create_post`, `:list_pending_products`, `:get_business_by_id`) instead of generic CRUD (`:create`, `:update`)
- **Single Source of Truth**: Resource definitions are the canonical specification from which everything derives (API endpoints, database schema, forms, authorization)

### Resource Structure

- **Singular Names**: Use singular names for resources (e.g., `User`, `Post`, `Order`)
- **Domain Organization**: Group resources into logical domains (e.g., `MyApp.Accounts`, `MyApp.Shop`, `MyApp.Content`)
- **Required Extensions**: Include `data_layer: AshPostgres.DataLayer` and `authorizers: [Ash.Policy.Authorizer]` on all resources
- **Complete Definitions**: Define attributes, relationships, actions, policies, calculations, aggregates, and validations within the resource module

### Attributes & Data Types

- **Appropriate Types**: Use Ash type atoms (`:uuid`, `:string`, `:ci_string`, `:integer`, `:decimal`, `:boolean`, `:utc_datetime`, `:date`, `:map`, `:atom`)
- **Timestamps**: Use `timestamps()` macro for automatic `inserted_at` and `updated_at` fields
- **Primary Keys**: Use `:uuid` primary keys by default for distributed systems and security
- **Constraints**: Define constraints on attributes (`:one_of`, `:min`, `:max`, `:match`, `:trim`) instead of separate validations when possible
- **Sensitive Data**: Mark sensitive attributes (passwords, tokens) with `sensitive? true` to prevent logging
- **Public Attributes**: Mark attributes as `public? true` only if they should be accessible in API responses

### Money Attributes (AshMoney)

- **Always Use :money Type**: NEVER use `:decimal` or `:integer` for money - always use `:money` type from AshMoney library
- **Install AshMoney**: Add `{:ash_money, "~> 0.2"}` and `{:ex_money_sql, "~> 1.11"}` to dependencies
- **Add Postgres Extension**: Include `AshMoney.AshPostgresExtension` in repo's `installed_extensions` list
- **Composite Type**: Money type stores both amount (as Decimal) and currency code (as string) together in database
- **Storage Type Constraint**: Use `constraints storage_type: :money_with_currency` to map to exact SQL composite type
- **Precision Preserved**: Decimal arithmetic maintains up to 28 decimal places - no automatic rounding unless explicit
- **Currency-Aware Aggregates**: Filter aggregates by currency (`sum :usd_total, :orders, :amount do filter expr(amount[:currency_code] == "USD") end`)
- **Expression Support**: Reference money in filters and calculations (`expr(price[:amount] > 100)`, `expr(balance[:currency_code] == "USD")`)
- **Known Type Config**: Add `config :my_app, :ash, known_types: [AshMoney.Types.Money]` to enable money operations in runtime expressions
- **Input Format**: Accept maps with `:amount` and `:currency` keys (`%{amount: "29.99", currency: "USD"}`) or parseable strings (`"USD 29.99"`)
- **Never Mix Currencies**: Don't perform arithmetic on money values with different currencies - convert first or use currency-specific aggregates
- **Avoid Float**: NEVER use float/double for money - always Decimal to prevent rounding errors and precision loss
- **Round Late**: Defer rounding to display layer - store and compute with full precision, round only for presentation

### Relationships

- **Clear Naming**: Name relationships clearly (`belongs_to :author, User`, `has_many :posts, Post`)
- **Define Both Sides**: Always define both sides of relationships (parent defines `has_many`, child defines `belongs_to`)
- **Foreign Key Constraints**: Let AshPostgres handle foreign key constraints automatically through relationship definitions
- **Manage Relationships**: Use `manage_relationship` in actions instead of manually setting foreign keys

### Validations

- **Declarative Validations**: Use built-in validators in `validations` block (`validate present(:email)`, `validate match(:email, ~r/@/)`)
- **Attribute Constraints**: Prefer attribute constraints over validations when possible (they're enforced at database level)
- **Custom Validations**: Create validation modules in `MyApp.Resources.Validations` namespace for reusable custom validators
- **Action-Specific**: Use `validate` in action definitions for validation logic specific to that operation

### Actions

- **Domain-Specific Actions**: Replace generic CRUD with business operations (`:register` instead of `:create` for users, `:publish` instead of `:update` for posts)
- **Explicit Accept**: Always explicitly list accepted fields in `accept []` - never accept all attributes
- **Arguments**: Use `argument` for inputs not stored as attributes (`:password_confirmation`, `:discount_code`)
- **Action Changes**: Compose behavior with `change` functions (`:set_attribute`, `:manage_relationship`, custom change modules)
- **Transaction Boundaries**: Remember actions run in database transactions by default - use this for data integrity

### Derived Data

- **Never Store Calculated Data**: Use `calculations` for derived values instead of storing them as attributes
- **Aggregates for Relationships**: Use `aggregates` for counts, sums, averages from related resources (`:comment_count`, `:total_revenue`)
- **Expression Calculations**: Prefer expression-based calculations (pushed to database) over runtime calculations when possible
- **Load on Demand**: Load calculations and aggregates explicitly with `Ash.Query.load/2` instead of computing them eagerly
