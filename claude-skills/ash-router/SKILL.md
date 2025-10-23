---
name: Ash Framework Ecosystem Router
description: Master router for complete Ash Framework ecosystem in Elixir. Routes all questions about Ash resources, authentication, APIs, state machines, workflows, databases, admin UIs, and extensions. Use whenever user mentions Ash, declarative Elixir, Phoenix with Ash, or any Ash library.
---

# Ash Framework Ecosystem Router

**The Ash Framework** is a declarative, resource-oriented application framework for Elixir that revolutionizes how you build web applications.

## 🎯 When to Use This Skill

**Use this router skill when the user mentions:**
- Ash Framework, Ash.Resource, or any Ash library
- Declarative Elixir development
- Phoenix with Ash integration
- Resource-oriented application design
- Questions about Ash authentication, authorization, APIs, or extensions
- Problems with Ash code or errors
- "How do I..." questions about Ash features
- Architecture or design decisions for Ash applications

**Specific trigger patterns:**
- "How do I create an Ash resource?"
- "How does Ash authentication work?"
- "How to build GraphQL API with Ash?"
- "Ash policy error" or "Ash authorization"
- "Phoenix + Ash integration"
- "Ash state machine" or "Ash workflow"
- Any mention of ash-postgres, ash-graphql, ash-json-api, etc.

---

## 🚀 Philosophy: Declarative Design

Ash's core philosophy is **declare what you want, not how to build it**.

### Example: Imperative vs. Declarative

**❌ Traditional Imperative Approach:**
```elixir
def create_user(params) do
  changeset = User.changeset(%User{}, params)
  validate_email(changeset)
  check_uniqueness(changeset)
  hash_password(changeset)
  insert_to_db(changeset)
  send_welcome_email(user)
end
```

**✅ Ash Declarative Approach:**
```elixir
defmodule User do
  use Ash.Resource

  attributes do
    attribute :email, :string, allow_nil?: false
    attribute :password, :string, sensitive?: true
  end

  actions do
    create :register do
      accept [:email, :password]
      validate attribute_unique(:email)
      change hash_password()
      change send_welcome_email()
    end
  end
end
```

**Key Insight**: Resources declare their structure and behavior. Ash handles the implementation automatically.

---

## 📚 Quick Reference: Essential Code Examples

### 1. Basic Resource Definition

```elixir
defmodule MyApp.Accounts.User do
  use Ash.Resource, domain: MyApp.Accounts

  attributes do
    uuid_primary_key :id
    attribute :email, :string, allow_nil?: false
    attribute :name, :string
    timestamps()
  end

  actions do
    defaults [:read, :destroy]
    create :register
    update :change_email
  end
end
```

### 2. Domain Setup

```elixir
defmodule MyApp.Accounts do
  use Ash.Domain

  resources do
    resource MyApp.Accounts.User
  end
end
```

### 3. Querying Data

```elixir
# Simple query
MyApp.Accounts.User
|> Ash.Query.filter(email == "user@example.com")
|> Ash.read!()

# Query with filtering and sorting
MyApp.Accounts.User
|> Ash.Query.filter(name: "John")
|> Ash.Query.sort(inserted_at: :desc)
|> Ash.Query.limit(10)
|> Ash.read!()
```

### 4. Creating Records with Changesets

```elixir
# Basic create
MyApp.Accounts.User
|> Ash.Changeset.for_create(:register, %{
  email: "user@example.com",
  password: "secret"
})
|> Ash.create!()

# Update with changeset
user
|> Ash.Changeset.for_update(:change_email, %{email: "new@example.com"})
|> Ash.update!()
```

### 5. Relationships

```elixir
# belongs_to
defmodule Post do
  use Ash.Resource, domain: MyApp.Blog

  relationships do
    belongs_to :author, MyApp.Accounts.User
  end
end

# has_many
defmodule User do
  use Ash.Resource, domain: MyApp.Accounts

  relationships do
    has_many :posts, MyApp.Blog.Post
  end
end

# Loading relationships
MyApp.Accounts.User
|> Ash.Query.load(:posts)
|> Ash.read!()
```

### 6. Aggregates (Count, Sum, etc.)

```elixir
defmodule User do
  use Ash.Resource, domain: MyApp.Accounts

  aggregates do
    count :post_count, :posts
    sum :total_views, :posts, :view_count
  end
end

# Using aggregates
MyApp.Accounts.User
|> Ash.Query.load([:post_count, :total_views])
|> Ash.read!()
```

### 7. Calculations (Derived Values)

```elixir
defmodule User do
  use Ash.Resource, domain: MyApp.Accounts

  attributes do
    attribute :first_name, :string
    attribute :last_name, :string
  end

  calculations do
    calculate :full_name, :string, expr(first_name <> " " <> last_name)
  end
end
```

### 8. Custom Actions with Arguments

```elixir
actions do
  read :search do
    argument :query, :string, allow_nil?: false
    argument :min_views, :integer, default: 0

    filter expr(contains(title, ^arg(:query)) and views >= ^arg(:min_views))
  end
end

# Usage
MyApp.Blog.Post
|> Ash.Query.for_read(:search, %{query: "Elixir", min_views: 100})
|> Ash.read!()
```

### 9. Pagination

```elixir
# Offset pagination
actions do
  read :list do
    pagination offset?: true, default_limit: 20
  end
end

# Usage
MyApp.Blog.Post
|> Ash.Query.for_read(:list)
|> Ash.Query.page(limit: 10, offset: 20)
|> Ash.read!()

# Keyset pagination (more efficient)
actions do
  read :list do
    pagination keyset?: true, default_limit: 20
  end
end
```

### 10. Policies (Authorization)

```elixir
defmodule Post do
  use Ash.Resource,
    domain: MyApp.Blog,
    authorizers: [Ash.Policy.Authorizer]

  policies do
    # Anyone can read published posts
    policy action(:read) do
      authorize_if expr(published == true)
    end

    # Only author can update their posts
    policy action(:update) do
      authorize_if relates_to_actor_via(:author)
    end
  end
end

# Usage with actor
MyApp.Blog.Post
|> Ash.Query.for_read(:read, actor: current_user)
|> Ash.read!()
```

---

## 🗂️ Available Skills (19 Total)

### 🎯 Core Framework

**ash-core** - Foundation of everything
- Resources, actions, queries, changesets
- Calculations, aggregates, validations
- Declarative design philosophy
- **Use for**: Basic Ash questions, resource definition, action creation, understanding declarative patterns

**spark** - DSL Foundation
- DSL system underlying Ash
- Creating custom DSLs and extensions
- **Use for**: Advanced customization, understanding Ash internals

---

### 💾 Data Layer

**ash-postgres** - PostgreSQL Integration
- Database migrations, constraints, indexes
- Postgres-specific features
- **Use for**: Database operations, schema management, SQL questions

**ash-csv** - CSV Data Source
- Reading/writing CSV files as data sources
- **Use for**: CSV import/export, file-based data

---

### 🔐 Authentication & Authorization

**ash-authentication** - Core Auth
- Password auth, magic links, OAuth
- Token management, sessions
- **Use for**: Login systems, user auth, authentication strategies

**ash-authentication-phoenix** - Phoenix Auth UI
- LiveView components, forms
- Auth routes and controllers
- **Use for**: Phoenix auth integration, auth UI

**ash-policy-authorizer** - Authorization
- Policies, permissions, access control
- Field-level security
- **Use for**: Who can do what, role-based access, security rules

---

### 🌐 API Layers

**ash-graphql** - GraphQL APIs
- Schema generation, queries, mutations
- Absinthe integration, subscriptions
- **Use for**: Building GraphQL APIs

**ash-json-api** - JSON:API REST
- RESTful endpoints, JSON:API spec
- Filtering, sorting, pagination
- **Use for**: Building REST APIs

---

### 🏗️ Application Integrations

**ash-phoenix** - Phoenix Integration
- LiveView components, forms
- Phoenix helpers, contexts
- **Use for**: Using Ash in Phoenix apps

**ash-admin** - Admin UI
- Automatically generated admin panels
- Resource management interface
- **Use for**: Admin dashboards, CRUD UIs

---

### ⚙️ Extensions & Features

**ash-state-machine** - State Machines
- States, transitions, lifecycle management
- **Use for**: Order workflows, entity states, FSM patterns

**reactor** - Workflows & Orchestration
- Multi-step workflows, sagas
- Async workflows, compensation
- **Use for**: Complex business processes, multi-step operations

**ash-oban** - Background Jobs
- Async job processing with Oban
- Scheduled tasks, triggers
- **Use for**: Background jobs, scheduled work

**ash-archival** - Soft Deletes
- Soft delete, restore archived records
- **Use for**: Recoverable deletion, audit trails

**ash-paper-trail** - Audit Logs
- Version history, change tracking
- **Use for**: Audit trails, who changed what when

**ash-rate-limiter** - Rate Limiting
- API throttling, rate limits
- **Use for**: Rate limiting, request throttling

---

### 💰 Financial Extensions

**ash-money** - Money & Currency
- Money types, currency handling
- **Use for**: Financial calculations, pricing

**ash-double-entry** - Accounting
- Double-entry bookkeeping, ledgers
- **Use for**: Accounting systems, financial transactions

---

## 🧭 Routing Guide

### By Question Type

| Your Question | Use This Skill |
|--------------|----------------|
| "How do I create a resource?" | **ash-core** |
| "What is Ash's philosophy?" | **ash-core** |
| "How do I add authentication?" | **ash-authentication** |
| "How do I build a GraphQL API?" | **ash-graphql** |
| "How do I create a REST API?" | **ash-json-api** |
| "How do I use Ash in Phoenix?" | **ash-phoenix** |
| "How do I build a state machine?" | **ash-state-machine** |
| "How do I handle background jobs?" | **ash-oban** |
| "How do I create multi-step workflows?" | **reactor** |
| "How do I add authorization?" | **ash-policy-authorizer** |
| "How do I set up database migrations?" | **ash-postgres** |
| "How do I build an admin panel?" | **ash-admin** |
| "How do I handle money/prices?" | **ash-money** |
| "How do I build accounting features?" | **ash-double-entry** |
| "How do I add soft deletes?" | **ash-archival** |
| "How do I track changes?" | **ash-paper-trail** |

### By Feature Need

**Starting with Ash?** → **ash-core** (start here!)

**Building an app?**
- Web app → **ash-phoenix**
- API only → **ash-graphql** or **ash-json-api**
- Admin panel → **ash-admin**

**Adding features?**
- User login → **ash-authentication** + **ash-authentication-phoenix**
- Permissions → **ash-policy-authorizer**
- State management → **ash-state-machine**
- Background jobs → **ash-oban**
- Complex workflows → **reactor**
- Audit trail → **ash-paper-trail**
- Soft deletes → **ash-archival**

**Domain-specific?**
- E-commerce/pricing → **ash-money**
- Accounting → **ash-double-entry**
- Rate limiting → **ash-rate-limiter**

---

## 🎓 Learning Path

### Beginner (Week 1-2)
1. **ash-core**: Resources, actions, queries, changesets
2. **ash-postgres**: Database basics
3. **ash-phoenix**: Phoenix integration

### Intermediate (Week 3-4)
4. **ash-authentication**: Add auth
5. **ash-policy-authorizer**: Add authorization
6. **ash-graphql** or **ash-json-api**: Add API

### Advanced (Month 2+)
7. **ash-state-machine**: Complex state management
8. **reactor**: Multi-step workflows
9. **ash-oban**: Background jobs
10. Other extensions as needed

---

## 🔑 Key Concepts Across All Skills

**Resources** - The nouns of your application (User, Post, Order)
- Define attributes, actions, relationships
- Self-contained business logic units

**Actions** - What you can do with resources (register, publish, checkout)
- Not just CRUD - business-specific operations
- Can have arguments, validations, changes

**Domains** - Collections of related resources (Accounts, Blog, Shop)
- Organizational boundary for resources
- Entry point for code interfaces

**Extensions** - Add capabilities declaratively (Auth, GraphQL, StateMachine)
- Plug-and-play functionality
- No boilerplate code required

**Policies** - Who can do what (Authorization)
- Declarative access control
- Field-level and action-level security

**Calculations** - Derived values (full_name from first + last)
- Computed at query time
- Can use expressions or custom code

**Aggregates** - Computed from relationships (post_count)
- Statistics across related records
- Efficiently calculated at database level

---

## 📖 Reference Files in This Skill

This router skill includes reference documentation from two comprehensive Ash books:

### book-domain-modeling.md
**Domain Modeling with Ash Framework** by Shankar & Nittin Dhanasekaran
- Comprehensive guide to the "Tuesday" project management app
- Covers resources, attributes, actions, relationships
- Deep dive into policies, multitenancy, testing
- Practical examples from real-world application
- **Best for**: Understanding Ash through complete project examples

**Key Chapters:**
- Ch 2: Ash Domain & Resources - What they are and how to create them
- Ch 3: Attributes & Identities - Defining resource structure
- Ch 4: Ash.Query - Filtering, sorting, pagination
- Ch 5: Changeset - Creating and updating data
- Ch 6: Actions - CRUD operations and custom actions
- Ch 9: Relationships - belongs_to, has_many, many_to_many
- Ch 10: Aggregates - count, sum, avg, etc.
- Ch 11: Calculations - Derived values and expressions
- Ch 13: Policies - Authorization and access control

### book-pragmatic-ash.md
**Ash Framework: Create Declarative Elixir Web Apps** by Rebecca Le & Zach Daniel
- Build a music catalog app (Tunez) from scratch
- Phoenix LiveView integration
- Authentication with AshAuthentication
- GraphQL and JSON:API generation
- Real-time updates with PubSub
- **Best for**: Building complete Phoenix + Ash applications

**Key Chapters:**
- Ch 1: Building Our First Resource - Getting started
- Ch 2: Extending Resources - Relationships, validations
- Ch 3: Search UI - Custom actions, sorting, pagination
- Ch 4: Generating APIs - GraphQL and JSON:API
- Ch 5: Authentication - Password and magic link auth
- Ch 6: Authorization - Policies and permissions
- Ch 7: Testing - Resource and interface testing
- Ch 8: Nested Forms - Managing related data
- Ch 10: PubSub - Real-time notifications

---

## 💡 Working with This Skill

### For Beginners
**Start here if you're new to Ash:**

1. **Read the Philosophy section** in this file to understand the declarative approach
2. **Try the Quick Reference examples** - copy and paste them to see how they work
3. **Route to ash-core** for foundational concepts
4. **Use book-domain-modeling.md** Ch 2-6 for step-by-step learning
5. **Build a simple resource** with attributes and actions

**Common beginner questions:**
- "What's the difference between a resource and a domain?" → ash-core
- "How do I create my first resource?" → ash-core + book-domain-modeling.md Ch 2
- "How do I set up the database?" → ash-postgres

### For Intermediate Users
**You know basics, want to add features:**

1. **Use the Routing Guide** to find the right skill for your feature
2. **Check Quick Reference** for syntax reminders
3. **Refer to book-pragmatic-ash.md** for Phoenix integration patterns
4. **Route to specific skills** for authentication, APIs, etc.

**Common intermediate questions:**
- "How do I add authentication?" → ash-authentication
- "How do I build a GraphQL API?" → ash-graphql
- "How do I implement authorization?" → ash-policy-authorizer
- "How do I integrate with Phoenix LiveView?" → ash-phoenix

### For Advanced Users
**Optimizing and extending:**

1. **Use book-domain-modeling.md** Ch 13 (Policies), Ch 14 (Multitenancy)
2. **Check book-pragmatic-ash.md** Ch 10 for PubSub and atomics
3. **Route to specialized skills** for state machines, workflows, background jobs
4. **Explore spark** for custom extensions

**Common advanced questions:**
- "How do I implement multitenancy?" → ash-core + book-domain-modeling.md Ch 14
- "How do I build complex workflows?" → reactor
- "How do I optimize query performance?" → ash-postgres
- "How do I create custom policy checks?" → ash-policy-authorizer

---

## 🎨 Common Patterns

### Pattern 1: Resource-First Design
Always start by declaring your resource structure:

```elixir
defmodule MyApp.Accounts.User do
  use Ash.Resource, domain: MyApp.Accounts

  attributes do
    uuid_primary_key :id
    attribute :email, :string, allow_nil?: false
    attribute :name, :string
    timestamps()
  end

  actions do
    defaults [:read, :destroy]
    create :register
    update :change_email
  end
end
```

### Pattern 2: Action-Oriented
Think in terms of business actions, not generic CRUD:

```elixir
# ❌ Generic CRUD
actions do
  defaults [:create, :read, :update, :destroy]
end

# ✅ Business-specific actions
actions do
  create :register
  update :change_email
  update :verify_email
  update :reset_password
  update :suspend_account
  destroy :delete_account
end
```

### Pattern 3: Declare, Don't Build
Let extensions handle the heavy lifting:

```elixir
# Want authentication?
use AshAuthentication

# Want GraphQL?
use AshGraphql

# Want audit trail?
use AshPaperTrail
```

### Pattern 4: Code Interface for Clean APIs

```elixir
# Define on domain
defmodule MyApp.Accounts do
  use Ash.Domain

  resources do
    resource MyApp.Accounts.User do
      define :register, action: :register
      define :get_by_email, action: :by_email, args: [:email]
    end
  end
end

# Usage
MyApp.Accounts.register(%{email: "user@example.com", password: "secret"})
MyApp.Accounts.get_by_email("user@example.com")
```

---

## 🚦 When to Use Which Skill

### "How do I..." questions
- Start with **ash-core** for basic concepts
- Route to specialized skills for specific features

### "Why does Ash..." questions
- Use **ash-core** for philosophy and design decisions

### Error messages
- Route to relevant skill (e.g., auth error → **ash-authentication**)
- Fall back to **ash-core** for general errors

### "Best practices for..." questions
- Check specific skill first
- Then **ash-core** for general patterns

---

## 📐 Ash Ecosystem Architecture

```
┌─────────────────────────────────────────────────────┐
│                    YOUR APP                         │
└─────────────────────────────────────────────────────┘
                         │
        ┌────────────────┼────────────────┐
        │                │                │
   ┌────▼─────┐   ┌─────▼─────┐   ┌─────▼─────┐
   │ Phoenix  │   │  GraphQL   │   │ JSON:API  │
   │ LiveView │   │    API     │   │    API    │
   └────┬─────┘   └─────┬─────┘   └─────┬─────┘
        │               │               │
        └───────────────┼───────────────┘
                        │
              ┌─────────▼─────────┐
              │   ASH RESOURCES   │
              │  (Declarative)    │
              └─────────┬─────────┘
                        │
        ┌───────────────┼───────────────┐
        │               │               │
   ┌────▼─────┐   ┌────▼─────┐   ┌────▼─────┐
   │ Postgres │   │   Auth   │   │  State   │
   │   DB     │   │ Policies │   │ Machine  │
   └──────────┘   └──────────┘   └──────────┘
```

---

## 🗺️ Quick Start Paths

### For New Ash Users:
1. **Start with ash-core** - Understand declarative philosophy, resources, actions
2. **Add ash-phoenix** - Integrate with Phoenix (if building web app)
3. **Add ash-postgres** - Set up database
4. **Add ash-authentication** - Add user auth (if needed)
5. **Expand as needed** - Add other skills based on features

### For Specific Use Cases:

**Building a SaaS app:**
- ash-core → ash-postgres → ash-authentication → ash-policy-authorizer → ash-phoenix → ash-oban

**Building an API:**
- ash-core → ash-postgres → ash-graphql (or ash-json-api) → ash-authentication

**Building an e-commerce site:**
- ash-core → ash-postgres → ash-money → ash-state-machine (orders) → ash-phoenix

**Building an accounting system:**
- ash-core → ash-postgres → ash-double-entry → ash-money → ash-paper-trail

---

## 📚 Additional Resources

- **Official Docs**: [hexdocs.pm/ash](https://hexdocs.pm/ash)
- **Ash HQ**: [ash-hq.org](https://ash-hq.org)
- **Books**:
  - "Ash Framework: Create Declarative Elixir Web Apps" (Pragmatic Programmers) - Rebecca Le & Zach Daniel
  - "Domain Modeling with Ash Framework" - Shankar & Nittin Dhanasekaran
- **Community**: [ash-hq.org/community](https://ash-hq.org/community)
- **Newsletter**: Ash Weekly

---

## 🎯 Skill Usage Tips

1. **Start broad** - Ask **ash-core** first to understand concepts
2. **Get specific** - Use specialized skills for implementation details
3. **Cross-reference** - Many features work together (auth + policies, state machines + oban)
4. **Philosophy matters** - Understanding "why" (declarative design) helps with "how"
5. **Use the books** - Both reference books have complementary examples
6. **Experiment with Quick Reference** - All examples are runnable

---

## 📋 Complete Skill List

1. **ash-core** - Foundation
2. **ash-postgres** - Database
3. **ash-authentication** - Auth core
4. **ash-authentication-phoenix** - Auth UI
5. **ash-graphql** - GraphQL API
6. **ash-json-api** - REST API
7. **ash-state-machine** - State machines
8. **ash-oban** - Background jobs
9. **ash-phoenix** - Phoenix integration
10. **ash-archival** - Soft deletes
11. **ash-policy-authorizer** - Authorization
12. **ash-admin** - Admin UI
13. **ash-csv** - CSV data source
14. **ash-paper-trail** - Audit logs
15. **ash-rate-limiter** - Rate limiting
16. **ash-money** - Money types
17. **ash-double-entry** - Accounting
18. **spark** - DSL foundation
19. **reactor** - Workflows

**Total: 19 specialized skills covering the entire Ash ecosystem**

---

Ready to build declaratively? Start with **ash-core** to learn the foundation!
