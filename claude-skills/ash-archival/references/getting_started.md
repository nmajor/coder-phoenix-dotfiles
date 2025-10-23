# Ash-Archival - Getting Started

**Pages:** 1

---

## Get Started with AshArchival

**URL:** https://hexdocs.pm/ash_archival/get-started-with-ash-archival.html

**Contents:**
- Get Started with AshArchival
- Installation
- Adding to a resource
- Base Filter
  - Benefits of base_filter
- archive_related_authorize?
- More

First, add the dependency to your mix.exs file

and add :ash_archival to your .formatter.exs

To add archival to a resource, add the extension to the resource:

And thats it! Now, when you destroy a record, it will be archived instead, using an archived_at attribute.

See How Does Ash Archival Work? for what modifications are made to a resource, and read on for info on the tradeoffs of leveraging Ash.Resource.Dsl.resource.base_filter.

Using a Ash.Resource.Dsl.resource.base_filter for your archived_at field has a lot of benefits if you are using ash_postgres, but comes with one major drawback, which is that it is not possible to exclude certain read actions from archival. If you wish to use a base filter, you will need to create a separate resource to read from the archived items. We may introduce a way to bypass the base filter at some point in the future.

To add a base_filter and base_filter_sql to your resource:

Add base_filter? true to the archive configuration of your resource to tell it that it doesn't need to add an equivalent action filter itself.

If you want these benefits, add the appropriate base_filter.

The archive_related_authorize? option controls whether authorization checks are enforced when archiving related records during a destroy operation.

Default behavior (archive_related_authorize?: true):

Recommended behavior (archive_related_authorize?: false):

You typically want to set archive_related_authorize? to false because when you archive a parent record, you usually want ALL related records to be archived together, regardless of individual permissions. You typically just want to authorize the actor to archive the record in question, not all descendents.

See the Unarchiving guide For more.

Hex Package Hex Preview (current file) Search HexDocs Download ePub version

Built using ExDoc (v0.38.3) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
{:ash_archival, "~> 2.0.2"}
```

Example 2 (unknown):
```unknown
import_deps: [..., :ash_archival]
```

Example 3 (unknown):
```unknown
use Ash.Resource,
  extensions: [..., AshArchival.Resource]
```

Example 4 (unknown):
```unknown
resource do
  base_filter expr(is_nil(archived_at))
end

postgres do
  ...
  base_filter_sql "(archived_at IS NULL)"
end
```

---
