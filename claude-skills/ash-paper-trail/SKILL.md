---
name: ash-paper-trail
description: Audit trails and change tracking. Use for audit logs, version history, tracking changes, compliance tracking, rollback capabilities, versioning, and recording who changed what and when.
---

# Ash-Paper-Trail Skill

Comprehensive assistance with AshPaperTrail development for version tracking and audit logging in Ash Framework applications.

## When to Use This Skill

Trigger this skill when you need to:
- **Add version history** to Ash resources (track all changes over time)
- **Implement audit logs** showing who changed what and when
- **Track data changes** for compliance or debugging
- **Enable rollback functionality** by storing previous versions
- **Monitor resource modifications** in production systems
- **Create change notifications** based on version history
- **Debug data issues** by examining historical changes
- **Implement undo/redo features** using version snapshots

## Key Concepts

### Version Resources
AshPaperTrail automatically generates a `Version` resource for each tracked resource. For example, if you have `MyApp.Post`, it creates `MyApp.Post.Version` with:
- `has_many :paper_trail_versions` on the original resource
- `belongs_to :version_source` on the version resource

### Change Tracking Modes
- **:snapshot** - Stores complete state of all attributes (default)
- **:changes_only** - Stores only changed attributes (space-efficient)
- **:full_diff** - Stores before/after values for each attribute (detailed)

### Actor Tracking
Link versions to the users who made changes using `belongs_to_actor`. Supports polymorphic actors (users, systems, etc.).

## Quick Reference

### 1. Basic Setup - Enable Versioning on a Resource

```elixir
# Add to your resource
use Ash.Resource,
  domain: MyDomain,
  extensions: [AshPaperTrail.Resource]

paper_trail do
  primary_key_type :uuid_v7  # or :uuid
  change_tracking_mode :changes_only
  store_action_name? true
  ignore_attributes [:inserted_at, :updated_at]
end
```

### 2. Configure Domain to Include Version Resources

```elixir
# Add to your domain
use Ash.Domain,
  extensions: [AshPaperTrail.Domain]

paper_trail do
  include_versions? true  # Auto-include all version resources
end
```

### 3. Track Who Made Changes (Actor Tracking)

```elixir
paper_trail do
  # Track changes by users
  belongs_to_actor :user, MyApp.Accounts.User, domain: MyApp.Accounts

  # Support multiple actor types (polymorphic)
  belongs_to_actor :admin, MyApp.Accounts.Admin, domain: MyApp.Accounts
  belongs_to_actor :system, MyApp.Systems.Service, domain: MyApp.Systems
end
```

### 4. Change Tracking Modes Comparison

```elixir
# SNAPSHOT MODE (default) - Store everything
paper_trail do
  change_tracking_mode :snapshot
end
# Result: { subject: "new subject", body: "unchanged body", author: { name: "bob" }}

# CHANGES ONLY - Store only what changed (space-efficient)
paper_trail do
  change_tracking_mode :changes_only
end
# Result: { subject: "new subject" }

# FULL DIFF - Store before/after values
paper_trail do
  change_tracking_mode :full_diff
end
# Result: { subject: { from: "old", to: "new" }, body: { unchanged: "body" }}
```

### 5. Handling Destroy Actions with AshPostgres

```elixir
# Option 1: Don't version destroys
paper_trail do
  create_version_on_destroy? false
end

# Option 2: Use soft deletes (recommended)
# Use AshArchival or similar for soft deletion

# Option 3: Configure cascade deletion
defmodule MyApp.MyResource.PaperTrailMixin do
  def mixin do
    quote do
      postgres do
        references do
          reference :version_source, on_delete: :delete
        end
      end
    end
  end
end

paper_trail do
  mixin {MyApp.MyResource.PaperTrailMixin, :mixin, []}
end
```

### 6. Store Specific Attributes as Version Columns

```elixir
# Store frequently queried attributes as columns instead of JSON
paper_trail do
  attributes_as_attributes [:organization_id, :author_id, :status]
end

# Version records will have these as actual columns:
# %PostVersion{
#   organization_id: 123,
#   author_id: 456,
#   status: "published",
#   changes: %{...}  # Other attributes in JSON
# }
```

### 7. Expose Versions via GraphQL

```elixir
paper_trail do
  # Add GraphQL extension to version resource
  mixin {MyApp.Post.PaperTrailMixin, :graphql, [:post_version]}
  relationship_opts public?: true
  version_extensions extensions: [AshGraphql.Resource]
end

# Mixin module
defmodule MyApp.Post.PaperTrailMixin do
  def graphql(type) do
    quote do
      graphql do
        type unquote(type)

        queries do
          list :list_versions, action: :read
        end
      end
    end
  end
end
```

### 8. Conditional Version Tracking

```elixir
# Global setting - only track when something actually changed
paper_trail do
  only_when_changed? true
end

# Per-action control - skip versioning for specific actions
# In your resource action:
update :silent_update do
  change set_context(%{skip_version_when_unchanged?: true})
end
```

### 9. Ignore Specific Attributes or Actions

```elixir
paper_trail do
  # Don't track these attributes
  ignore_attributes [:inserted_at, :updated_at, :view_count]

  # Don't create versions for these actions
  ignore_actions [:increment_counter, :touch]

  # Or specify which actions SHOULD create versions
  on_actions [:create, :update, :publish]
end
```

### 10. Advanced Options for Auditing

```elixir
paper_trail do
  # Store which action was called
  store_action_name? true

  # Store action inputs (arguments and attributes)
  store_action_inputs? true

  # Add resource identifier for multi-resource tracking
  store_resource_identifier? true
  resource_identifier :blog_post

  # Handle sensitive attributes
  sensitive_attributes :redact  # or :display, :ignore
end
```

## Reference Files

This skill includes comprehensive documentation in `references/`:

### references/tracking.md
Core versioning functionality:
- **Getting Started** - Installation and basic setup
- **Change Tracking Modes** - Snapshot, changes_only, and full_diff comparison
- **Actor Tracking** - Recording who made changes
- **Destroy Actions** - Handling deletion with versioning
- **Attributes Configuration** - Storing attributes as columns vs JSON

**Use this file for:**
- Initial setup and configuration
- Understanding tracking modes
- Implementing actor relationships
- Handling edge cases (destroys, multitenancy)

### references/other.md
Advanced configuration and API reference:
- **Domain Configuration** - AshPaperTrail.Domain DSL options
- **Resource Options** - Complete paper_trail block options
- **belongs_to_actor** - Actor relationship configuration
- **Version Extensions** - Adding GraphQL, custom mixins

**Use this file for:**
- Advanced configuration options
- Customizing version resources
- API integrations (GraphQL, JSON)
- Fine-tuning performance and storage

## Working with This Skill

### For Beginners

**Start here:**
1. Read `references/tracking.md` for foundational concepts
2. Use Quick Reference example #1 (Basic Setup)
3. Use example #2 (Domain Configuration)
4. Test with a single resource before adding to all resources

**Common first-time questions:**
- "How do I add versioning?" → See example #1
- "How do I track who made changes?" → See example #3
- "What tracking mode should I use?" → See example #4

### For Intermediate Users

**Key tasks:**
- Customize change tracking → See examples #4, #6, #9
- Add GraphQL API → See example #7
- Handle destroy actions → See example #5
- Conditional versioning → See example #8

**Refer to:** `references/tracking.md` for implementation patterns

### For Advanced Users

**Complex scenarios:**
- Custom version resource mixins → `references/other.md`
- Multitenancy with versioning → `references/tracking.md`
- Performance optimization → Use `attributes_as_attributes` (example #6)
- Polymorphic actors → See example #3

**Deep dive:** Read the full DSL reference in `references/other.md`

## Common Patterns

### Pattern: Basic Post Versioning

```elixir
defmodule MyApp.Blog.Post do
  use Ash.Resource,
    domain: MyApp.Blog,
    extensions: [AshPaperTrail.Resource]

  paper_trail do
    change_tracking_mode :changes_only
    belongs_to_actor :user, MyApp.Accounts.User, domain: MyApp.Accounts
    ignore_attributes [:view_count, :inserted_at, :updated_at]
  end

  attributes do
    uuid_primary_key :id
    attribute :title, :string
    attribute :content, :string
    attribute :view_count, :integer
  end
end
```

### Pattern: Audit Log with Action Details

```elixir
paper_trail do
  change_tracking_mode :full_diff
  store_action_name? true
  store_action_inputs? true
  belongs_to_actor :user, MyApp.Accounts.User, domain: MyApp.Accounts

  # Keep frequently queried fields as columns
  attributes_as_attributes [:organization_id]
end
```

### Pattern: Multi-Tenant Versioning

```elixir
# Resource with multitenancy
multitenancy do
  strategy :attribute
  attribute :organization_id
end

paper_trail do
  # Organization ID automatically added to versions
  attributes_as_attributes [:organization_id]
  belongs_to_actor :user, MyApp.Accounts.User, domain: MyApp.Accounts
end
```

## Resources

### Official Documentation
- Hex Package: https://hexdocs.pm/ash_paper_trail
- Getting Started: See `references/tracking.md`
- DSL Reference: See `references/other.md`

### Related Ash Extensions
- **AshArchival** - Soft deletion (works great with paper_trail)
- **AshGraphql** - GraphQL API generation
- **AshPostgres** - PostgreSQL data layer

## Troubleshooting

### "Can't destroy records with versioning"
**Solution:** Use example #5 (Handling Destroy Actions)
- Either disable versioning on destroy
- Or use soft deletion (AshArchival)

### "Version table not found"
**Solution:** Add version resources to domain (example #2)
```elixir
paper_trail do
  include_versions? true
end
```

### "Actor not being recorded"
**Solution:** Ensure actor is passed when performing actions
```elixir
MyResource
|> Ash.Changeset.for_create(:create, params)
|> Ash.create!(actor: current_user)
```

### "Too much storage used"
**Solution:** Switch to `:changes_only` mode (example #4)
```elixir
paper_trail do
  change_tracking_mode :changes_only
  ignore_attributes [:updated_at, :view_count]
end
```

## Notes

- Version resources are automatically generated - you don't define them manually
- Primary keys are always ignored in change tracking
- Foreign key references use `on_delete: :nilify` for actors by default
- Use `attributes_as_attributes` for fields you'll query frequently
- Consider storage costs when choosing tracking modes

## Updating

To learn about new features:
1. Check the official hex docs: https://hexdocs.pm/ash_paper_trail
2. Review the changelog on Hex or GitHub
3. Update reference files using the documentation scraper if needed
