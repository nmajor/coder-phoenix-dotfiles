## Ash Query Standards

### Call Domain Functions, Not Queries

**Use defined resource functions on domains.** Don't call `Ash.Query` or `Ash.read` directly in controllers/contexts.

```elixir
# ✅ Correct - domain code interface
Blog.list_published_posts(actor: user)
Blog.get_post!(id, load: [:comments])

# ❌ Wrong - manual queries
Post |> Ash.Query.for_read(:published) |> Ash.read!()
```

### Best Practices
**

**Name actions after business operations.** Use `filter`, `argument`, and `prepare` to encapsulate logic.

```elixir
read :published do
  filter expr(status == :published)
  prepare build(sort: [published_at: :desc])
end

read :by_author do
  argument :author_id, :uuid, allow_nil?: false
  filter expr(author_id == ^arg(:author_id))
  prepare build(load: [:comments, :tags])
end
```

### Filter Expressions

**Use `expr()` in filters.** Supports `==`, `!=`, `<`, `>`, `in`, relationships, and `exists()`.

```elixir
# Basic
filter expr(score > 100 and status == :active)

# Relationships
filter expr(author.role == :admin)

# Existence checks
filter expr(exists(comments, score > 50))
```

### User Input Safety

**Use `filter_input`/`sort_input` for untrusted input.** Restricts to public fields only.

```elixir
# In read action with dynamic filtering
prepare fn query, _context ->
  Ash.Query.filter_input(query, params["filter"])
end
```

### When to Use Ecto

**Use Ecto for analytics/reporting only.** Complex GROUP BY and aggregations that don't fit domain actions.

```elixir
from p in Post, group_by: p.category, select: {p.category, count(p.id)}
```
