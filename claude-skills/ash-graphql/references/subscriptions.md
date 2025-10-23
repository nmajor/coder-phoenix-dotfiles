# Ash-Graphql - Subscriptions

**Pages:** 5

---

## AshGraphql.Subscription.Endpoint (ash_graphql v1.8.3)

**URL:** https://hexdocs.pm/ash_graphql/AshGraphql.Subscription.Endpoint.html

**Contents:**
- AshGraphql.Subscription.Endpoint (ash_graphql v1.8.3)

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.2) for the Elixir programming language

---

## AshGraphql.Domain.Info (ash_graphql v1.8.3)

**URL:** https://hexdocs.pm/ash_graphql/AshGraphql.Domain.Info.html

**Contents:**
- AshGraphql.Domain.Info (ash_graphql v1.8.3)
- Summary
- Functions
- Functions
- authorize?(domain)
- error_handler(domain)
- mutations(resource)
- queries(resource)
- root_level_errors?(domain)
- show_raised_errors?(domain)

Introspection helpers for AshGraphql.Domain

Whether or not to run authorization on this domain

An error handler for errors produced by the domain

The mutations exposed by the domain

The queries exposed by the domain

Whether or not to surface errors to the root of the response

Whether or not to render raised errors in the GraphQL response

The pubsub module configured for subscriptions in this domain

The tracer to use for the given schema

Whether or not to run authorization on this domain

An error handler for errors produced by the domain

The mutations exposed by the domain

The queries exposed by the domain

Whether or not to surface errors to the root of the response

Whether or not to render raised errors in the GraphQL response

The pubsub module configured for subscriptions in this domain

The tracer to use for the given schema

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.2) for the Elixir programming language

---

## AshGraphql.Resource.Subscription (ash_graphql v1.8.3)

**URL:** https://hexdocs.pm/ash_graphql/AshGraphql.Resource.Subscription.html

**Contents:**
- AshGraphql.Resource.Subscription (ash_graphql v1.8.3)
- Summary
- Functions
- Functions
- schema()

Represents a configured query on a resource

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.2) for the Elixir programming language

---

## AshGraphql.Subscription (ash_graphql v1.8.3)

**URL:** https://hexdocs.pm/ash_graphql/AshGraphql.Subscription.html

**Contents:**
- AshGraphql.Subscription (ash_graphql v1.8.3)
- Summary
- Functions
- Functions
- query_for_subscription(query, domain, resolution, type_override \\ nil, nested \\ [])

Helpers for working with absinthe subscriptions

Produce a query that will load the correct data for a subscription.

Produce a query that will load the correct data for a subscription.

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.2) for the Elixir programming language

---

## AshGraphql.Subscription.Batcher (ash_graphql v1.8.3)

**URL:** https://hexdocs.pm/ash_graphql/AshGraphql.Subscription.Batcher.html

**Contents:**
- AshGraphql.Subscription.Batcher (ash_graphql v1.8.3)
- Summary
- Functions
- Functions
- child_spec(init_arg)
- drain()
- handle_continue(arg, state)
- init(config)
- publish(topic, notification, pubsub, key_strategy, doc)
- start_link(opts \\ [])

If started as a GenServer, this module will batch notifications and send them in bulk. Otherwise, it will send them immediately.

Returns a specification to start this module under a supervisor.

Callback implementation for GenServer.handle_continue/2.

Returns a specification to start this module under a supervisor.

Callback implementation for GenServer.handle_continue/2.

async_limit (default 100): if there are more than async_limit notifications, we will start to backpressure

send_immediately_threshold (default 50): if there are less then send_immediately_threshold notifications, we will send them immediately

subscription_batch_interval (default 1000): the interval in milliseconds the batcher waits for new notifications before sending them

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.2) for the Elixir programming language

---
