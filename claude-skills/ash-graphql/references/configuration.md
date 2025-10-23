# Ash-Graphql - Configuration

**Pages:** 1

---

## Relay

**URL:** https://hexdocs.pm/ash_graphql/relay.html

**Contents:**
- Relay
- Using Ash's built-in Relay support
- Relay Global IDs
  - Translating Relay Global IDs passed as arguments
- Using with Absinthe.Relay instead of Ash's relay type

Enabling Relay for a resource sets it up to follow the Relay specification.

The two changes that are made currently are:

Set relay? true on the resource:

Use the following option to generate Relay Global IDs (see here).

This allows refetching a node using the node query and passing its global ID.

When relay_ids?: true is passed, users of the API will have access only to the global IDs, so they will also need to use them when an ID is required as argument. You actions, though, internally use the normal IDs defined by the data layer.

To handle the translation between the two ID domains, you can use the relay_id_translations option. With this, you can define a list of arguments that will be translated from Relay global IDs to internal IDs.

For example, if you have a Post resource with an action to create a post associated with an author:

You can add this to the mutation connected to that action:

Use the following option when calling use AshGraphql

Hex Package Hex Preview (current file) Search HexDocs Download ePub version

Built using ExDoc (v0.38.2) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
graphql do
  relay? true

  ...
end
```

Example 2 (unknown):
```unknown
use AshGraphql, relay_ids?: true
```

Example 3 (unknown):
```unknown
create :create do
  argument :author_id, :uuid

  # Do stuff with author_id
end
```

Example 4 (unknown):
```unknown
mutations do
  create :create_post, :create do
    relay_id_translations [input: [author_id: :user]]
  end
end
```

---
