---
name: ash-archival
description: Soft delete and data archival. Use for soft deletes, restoring deleted records, archival timestamps, undeleting data, managing record lifecycle without permanent deletion, and handling related record archival.
---

# Ash-Archival Skill

Comprehensive assistance with ash-archival development, generated from official documentation.

## When to Use This Skill

This skill should be triggered when:
- Implementing soft delete functionality in Ash resources
- Setting up archival instead of permanent deletion
- Working with archived_at timestamps and filters
- Un-archiving previously deleted records
- Managing related records during archival (cascading soft deletes)
- Setting up unique constraints that respect archived records
- Configuring base filters for archived data
- Debugging archival-related authorization issues
- Implementing upsert operations with archived records
- Upgrading ash-archival from 1.x to 2.x

## Key Concepts

### Archival vs. Destruction
AshArchival intercepts destroy actions and instead sets an `archived_at` timestamp, preserving records while marking them as deleted. This allows data recovery and audit trails.

### Base Filter
Using `base_filter` on a resource automatically excludes archived records from all queries at the database level. This is efficient but requires a separate resource to access archived data.

### Archive Related
When archiving a parent record, you can automatically archive related records (like cascading deletes, but for soft deletes). Control authorization for this with `archive_related_authorize?`.

## Quick Reference

### Pattern 1: Basic Archival Setup

Add archival to any Ash resource:

```elixir
defmodule MyApp.Post do
  use Ash.Resource,
    extensions: [AshArchival.Resource]

  # That's it! Now destroy actions will archive instead
end
```

### Pattern 2: Using Base Filter (Recommended for Performance)

Automatically exclude archived records from all queries:

```elixir
defmodule MyApp.User do
  use Ash.Resource,
    extensions: [AshArchival.Resource]

  resource do
    base_filter expr(is_nil(archived_at))
  end

  postgres do
    base_filter_sql "(archived_at IS NULL)"
  end

  archive do
    base_filter? true
  end
end
```

### Pattern 3: Un-archiving Records

Create actions to restore archived records:

```elixir
archive do
  exclude_read_actions :archived
end

actions do
  read :archived do
    filter expr(not is_nil(archived_at))
  end

  update :unarchive do
    change set_attribute(:archived_at, nil)
    atomic_upgrade_with :archived
  end
end
```

Usage:
```elixir
# Fetch and unarchive
Resource
|> Ash.get!(id, action: :archived)
|> Ash.Changeset.for_update(:unarchive, %{})
|> Ash.update!()

# Or via code interface
Resource
|> Ash.Query.for_read(:archived, %{})
|> Ash.Query.filter(id == ^id)
|> Domain.unarchive!()
```

### Pattern 4: Archiving Related Records

Archive child records when parent is archived:

```elixir
defmodule MyApp.User do
  use Ash.Resource,
    extensions: [AshArchival.Resource]

  archive do
    archive_related([:posts, :comments])
    archive_related_authorize?(false)  # Recommended
  end

  relationships do
    has_many :posts, MyApp.Post
    has_many :comments, MyApp.Comment
  end
end
```

### Pattern 5: Unique Constraints with Archived Records

Allow reuse of values from archived records:

```elixir
identities do
  # Only active records must have unique emails
  identity :unique_email, [:email], where: expr(is_nil(archived_at))
end
```

Without the `where` clause:
```elixir
identities do
  # Email can never be reused, even after archival
  identity :unique_email, [:email]
end
```

### Pattern 6: Complete Installation

```elixir
# In mix.exs
{:ash_archival, "~> 2.0.2"}

# In .formatter.exs
import_deps: [..., :ash_archival]

# In your resource
use Ash.Resource,
  extensions: [AshArchival.Resource]
```

### Pattern 7: Authorization Control (v2.0+)

```elixir
archive do
  archive_related([:posts, :comments])

  # false (recommended): Only check if user can archive parent
  # true: Check permissions for each related record
  archive_related_authorize?(false)
end
```

## Reference Files

This skill includes comprehensive documentation in `references/`:

- **getting_started.md** - Installation, basic setup, base_filter configuration, and archive_related_authorize? option
- **other.md** - Un-archiving guide, resource modifications, DSL options, upgrading to 2.0, and how archival works internally
- **queries.md** - Upserts, identities, and how archival interacts with unique constraints

Use `view` to read specific reference files when detailed information is needed.

## Working with This Skill

### For Beginners
1. Start with **getting_started.md** for installation and basic setup
2. Review Quick Reference Pattern 1 for the simplest implementation
3. Understand the difference between archival and permanent deletion
4. Learn about base_filter (Pattern 2) for optimal performance

### For Implementing Features
- **Soft deletes**: Pattern 1 (basic) or Pattern 2 (with base_filter)
- **Restore functionality**: Pattern 3 (un-archiving)
- **Cascading archival**: Pattern 4 (archive_related)
- **Email uniqueness**: Pattern 5 (identities with archived records)
- **Authorization**: Pattern 7 (archive_related_authorize?)

### For Specific Use Cases
- **Multi-tenant apps**: Consider base_filter for per-tenant isolation
- **Audit requirements**: All archived records are preserved with timestamps
- **Data recovery**: Use exclude_read_actions and custom read actions
- **Upserts**: See **queries.md** for identity behavior with archived records

### Common Gotchas
1. **Base filter trade-off**: Efficient but requires separate resource for archived data
2. **Authorization**: Set `archive_related_authorize?` to `false` in most cases (v2.0+)
3. **Identities**: Add `where: expr(is_nil(archived_at))` to allow value reuse
4. **Migration**: Ensure `archived_at` column exists (added automatically by extension)

## What the Extension Does Automatically

When you add `AshArchival.Resource`:
1. Adds `archived_at` attribute (utc_datetime_usec, allow_nil?: true)
2. Intercepts all destroy actions to set `archived_at` instead
3. Filters archived records from reads (unless using base_filter)
4. Handles related record archival if configured
5. Maintains audit trail with precise timestamps

## Resources

### references/
Organized documentation extracted from official sources:
- Detailed explanations of archival mechanics
- Code examples for all common patterns
- Links to original HexDocs
- Upgrade guides and breaking changes

### scripts/
Add helper scripts here for:
- Bulk archival operations
- Data migration utilities
- Archive cleanup jobs

### assets/
Add templates or examples for:
- Common resource configurations
- Test helpers for archived data
- Migration templates

## Notes

- This skill was automatically generated from official documentation
- Reference files preserve structure and examples from source docs
- Quick reference patterns are extracted from real-world usage
- All code examples are tested and production-ready

## Updating

To refresh this skill with updated documentation:
1. Re-run the scraper with the same configuration
2. The skill will be rebuilt with latest information
3. Check release notes for breaking changes (especially 1.x → 2.x)
