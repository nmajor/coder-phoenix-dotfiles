# Ash-Archival - Other

**Pages:** 6

---

## Un-archiving

**URL:** https://hexdocs.pm/ash_archival/unarchiving.html

**Contents:**
- Un-archiving

If you want to unarchive a resource that uses a base filter, you will need to define a separate resource that uses the same storage and has no base filter. The rest of this guide applies for folks who aren't using a base_filter.

Un-archiving can be accomplished by creating a read action that is skipped, using exclude_read_actions. Then, you can create an update action that sets that attribute to nil. For example:

You could then do something like this:

More idiomatically, you would define a code interface on the domain, and call that:

Hex Package Hex Preview (current file) Search HexDocs Download ePub version

Built using ExDoc (v0.38.3) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
archive do
  ...
  exclude_read_actions :archived
end

actions do
  read :archived do
    filter expr(not is_nil(archived_at))
  end

  update :unarchive do
    change set_attribute(:archived_at, nil)
    # if an individual record is used to unarchive
    # it must use the `archived` read action for its atomic upgrade
    atomic_upgrade_with :archived
  end
end
```

Example 2 (unknown):
```unknown
Resource
|> Ash.get!(id, action: :archived)
|> Ash.Changeset.for_update(:unarchive, %{})
|> Ash.update!()
```

Example 3 (unknown):
```unknown
# to unarchive by `id`
Resource
|> Ash.Query.for_read(:archived, %{})
|> Ash.Query.filter(id == ^id)
|> Domain.unarchive!()
```

---

## AshArchival.Resource

**URL:** https://hexdocs.pm/ash_archival/dsl-asharchival-resource.html

**Contents:**
- AshArchival.Resource
- archive
  - Options

Configures a resource to be archived instead of destroyed for all destroy actions.

For more information, see the getting started guide

A section for configuring how archival is configured for a resource.

Hex Package Hex Preview (current file) Search HexDocs Download ePub version

Built using ExDoc (v0.38.3) for the Elixir programming language

---

## How does Archival Work?

**URL:** https://hexdocs.pm/ash_archival/how-does-ash-archival-work.html

**Contents:**
- How does Archival Work?
- Resource Modifications

We make modifications to the resource to enable soft deletes. Here's a breakdown of what the extension does:

Hex Package Hex Preview (current file) Search HexDocs Download ePub version

Built using ExDoc (v0.38.3) for the Elixir programming language

---

## 

**URL:** https://hexdocs.pm/ash_archival/ash_archival.epub

---

## Upgrading to 2.0

**URL:** https://hexdocs.pm/ash_archival/upgrading-to-2-0.html

**Contents:**
- Upgrading to 2.0
- New archive_related_authorize? Option
- Breaking Change
- Recommended Action
- When to Keep Default (true)

This guide covers the key changes when upgrading to AshArchival 2.0.

Version 2.0 introduces the archive_related_authorize? configuration option that controls whether authorization checks are enforced when archiving related records.

This is a breaking change because in some cases when reading records during the archival process, we previously used authorize?: false, but now we respect the archive_related_authorize? setting.

For most applications, you should set archive_related_authorize?: false:

The reason you want it to be false is because you typically want to just authorize access to archive the parent record, and if that is allowed, then all related records will be archived without additional authorization checks.

Only keep the default true if you need fine-grained authorization control where some related records should only be archived if the actor has explicit permission to destroy them.

Hex Package Hex Preview (current file) Search HexDocs Download ePub version

Built using ExDoc (v0.38.3) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
defmodule MyApp.User do
  use Ash.Resource,
    extensions: [AshArchival.Resource]

  archive do
    archive_related([:posts, :comments])
    archive_related_authorize?(false)  # Recommended setting
  end
end
```

Example 2 (unknown):
```unknown
archive do
  archive_related([:posts, :comments])
  archive_related_authorize?(false)
end
```

---

## Home

**URL:** https://hexdocs.pm/ash_archival/readme.html

**Contents:**
- Home
- AshArchival
- Tutorials
- Topics
- Reference

AshArchival is an Ash extension that provides a push-button solution for soft deleting records, instead of destroying them.

Hex Package Hex Preview (current file) Search HexDocs Download ePub version

Built using ExDoc (v0.38.3) for the Elixir programming language

---
