## Ash Nested Relationships Standards

### Setup Requirements (The Three Essentials)

**Parent action needs argument + manage_relationship. Child needs writable foreign key.**

```elixir
# Parent resource
has_many :line_items, LineItem

create :create do
  accept [:name, :total]
  argument :line_items, {:array, :map}
  change manage_relationship(:line_items, type: :create)
end

# Child resource
belongs_to :order, Order, attribute_writable? true

create :create do
  accept [:product_id, :quantity, :price]  # Accept all passed fields
end
```

### Management Types (Choose One)

**Match type to your use case.**

- **`:create`** - Create-only, no updates (immutable: order items, audit logs)
- **`:direct_control`** - Full CRUD (mutable: form line items) - needs `require_atomic? false`
- **`:append_and_remove`** - Replace list (tags: pass new list, old ones removed)

```elixir
# Immutable collection
change manage_relationship(:line_items, type: :create)

# Mutable collection (can update/delete items)
update :update do
  require_atomic? false  # Required for :direct_control
  argument :line_items, {:array, :map}
  change manage_relationship(:line_items, type: :direct_control)
end

# Tags by name (create if missing, remove unlisted)
update :set_tags do
  argument :tag_names, {:array, :string}
  change manage_relationship(:tag_names, :tags,
    type: :append_and_remove,
    value_is_key: :name,
    on_lookup: :relate,
    on_no_match: :create
  )
end
```

### Deep Nesting (3+ Levels)

**Each level manages its direct children. Ash cascades automatically.**

```elixir
# Order → LineItems → Modifiers (3 levels)

# Order
create :create do
  argument :line_items, {:array, :map}
  change manage_relationship(:line_items, type: :create)
end

# LineItem (middle layer - has parent AND children)
belongs_to :order, Order, attribute_writable? true
has_many :modifiers, Modifier

create :create do
  accept [:product_id, :quantity]
  argument :modifiers, {:array, :map}
  change manage_relationship(:modifiers, type: :create)
end

# Modifier
belongs_to :line_item, LineItem, attribute_writable? true

# Usage - deeply nested map
%{
  total: 100,
  line_items: [
    %{product_id: 1, quantity: 2, modifiers: [%{type: "extra_cheese"}]},
    %{product_id: 2, quantity: 1, modifiers: []}
  ]
}
```

### Loading Nested Data

**Relationships aren't loaded automatically. Load before accessing.**

```elixir
# After create/update
{:ok, order} = Shop.create_order(input)

# Load nested data
order = Ash.load!(order, line_items: [:modifiers])

# Now safe to access
order.line_items |> Enum.map(& &1.modifiers)
```

### Common Mistakes

- **Missing `argument`** - "No such input :line_items"
- **Child action doesn't accept field** - "Cannot accept :product_id"
- **Missing `attribute_writable? true`** - Foreign key stays nil
- **Wrong type** - Use `:map` for has_one, `{:array, :map}` for has_many
- **`:direct_control` without `require_atomic? false`** - Atomic operation error
- **Not loading before access** - Gets `#Ash.NotLoaded<>`

### Authorization Pattern

**Only root resource has policies. Children inherit via `relates_to_actor_via`.**

```elixir
# Order (root) - has policies
policies do
  policy expr(user_id == ^actor(:id)) do
    authorize_if always()
  end
end

# LineItem (child) - NO policies, just relates
# Authorization checked at Order level only
```
