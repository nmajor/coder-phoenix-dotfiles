# Ash-Paper-Trail - Other

**Pages:** 7

---

## AshPaperTrail.Domain

**URL:** https://hexdocs.pm/ash_paper_trail/dsl-ashpapertrail-domain.html

**Contents:**
- AshPaperTrail.Domain
- paper_trail
  - Options

Documentation for AshPaperTrail.Domain.

A section for configuring paper_trail behavior at the domain level.

Hex Package Hex Preview (current file) Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## AshPaperTrail.Domain (ash_paper_trail v0.5.7)

**URL:** https://hexdocs.pm/ash_paper_trail/AshPaperTrail.Domain.html

**Contents:**
- AshPaperTrail.Domain (ash_paper_trail v0.5.7)
- Summary
- Functions
- Functions
- paper_trail(body)

Documentation for AshPaperTrail.Domain.

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## 

**URL:** https://hexdocs.pm/ash_paper_trail/ash_paper_trail.epub

---

## AshPaperTrail (ash_paper_trail v0.5.7)

**URL:** https://hexdocs.pm/ash_paper_trail/AshPaperTrail.html

**Contents:**
- AshPaperTrail (ash_paper_trail v0.5.7)
- Summary
- Functions
- Functions
- allow_resource_versions(arg1, resource)

Documentation for AshPaperTrail.

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## AshPaperTrail.Resource (ash_paper_trail v0.5.7)

**URL:** https://hexdocs.pm/ash_paper_trail/AshPaperTrail.Resource.html

**Contents:**
- AshPaperTrail.Resource (ash_paper_trail v0.5.7)
- Summary
- Functions
- Functions
- paper_trail(body)

Documentation for AshPaperTrail.Resource.

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## AshPaperTrail.Resource

**URL:** https://hexdocs.pm/ash_paper_trail/dsl-ashpapertrail-resource.html

**Contents:**
- AshPaperTrail.Resource
- paper_trail
  - Nested DSLs
  - Options
  - paper_trail.belongs_to_actor
  - Examples
  - Arguments
  - Options
  - Introspection

Documentation for AshPaperTrail.Resource.

A section for configuring how versioning is derived for the resource.

Creates a belongs_to relationship for the actor resource. When creating a new version, if the actor on the action is set and matches the resource type, the version will be related to the actor. If your actors are polymorphic or varying types, declare a belongs_to_actor for each type.

A reference is also created with on_delete: :nilify and on_update: :update

If you need more complex relationships, set define_attribute? false and add the relationship via a mixin.

If your actor is not a resource, add a mixin and with a change for all creates that sets the actor's to one your attributes. The actor on the version changeset is set.

Target: AshPaperTrail.Resource.BelongsToActor

Hex Package Hex Preview (current file) Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
belongs_to_actor name, destination
```

Example 2 (unknown):
```unknown
belongs_to_actor :user, MyApp.Users.User, domain: MyApp.Users
```

---

## AshPaperTrail.Resource.BelongsToActor (ash_paper_trail v0.5.7)

**URL:** https://hexdocs.pm/ash_paper_trail/AshPaperTrail.Resource.BelongsToActor.html

**Contents:**
- AshPaperTrail.Resource.BelongsToActor (ash_paper_trail v0.5.7)
- Summary
- Types
- Types
- t()

Represents a belongs_to_actor relationship on a version resource

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

---
