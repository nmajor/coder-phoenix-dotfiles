# Ash-Archival - Queries

**Pages:** 1

---

## Upserts & Identities

**URL:** https://hexdocs.pm/ash_archival/upserts-and-identities.html

**Contents:**
- Upserts & Identities
- With is_nil(archived_at)
- Without is_nil(archived_at)

Its important to consider identities when using AshArchival without a base_filter set up.

If you are using a base_filter, then all identities implicitly include that base_filter in their where (handled by the data layer).

Take the following identities, for example:

Using this identity allows multiple archived records with the same email, but only one non-archived record per email. It enables reuse of archived email addresses for new active records, maintaining data integrity by preventing duplicate active records while preserving archived data.

When you upsert a record using this identity, it will only consider active records.

This identity configuration enforces strict email uniqueness across all records. Once an email is used, it can't be used again, even after that record is archived.

When you upsert a record using this identity, it will consider all records.

Hex Package Hex Preview (current file) Search HexDocs Download ePub version

Built using ExDoc (v0.38.3) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
identities do
  identity :unique_email, [:email], where: expr(is_nil(archived_at))
  # and
  identity :unique_email, [:email]
end
```

---
