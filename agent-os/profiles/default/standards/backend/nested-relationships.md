## Ash nested relationship management standards

### Core Principles

- **Cascade Principle**: Each resource manages only its direct children - Ash automatically cascades nested creation through the relationship chain
- **Atomic Transactions**: All nested records are created/updated in a single database transaction - either all succeed or all roll back
- **Declarative Management**: Use `manage_relationship` in actions instead of manual relationship manipulation
- **Three Requirements**: Parent must define `argument`, parent must use `change manage_relationship`, child must have `attribute_writable? true` on `belongs_to`

### Resource Configuration

- **Foreign Keys Writable**: Always set `attribute_writable? true` on child's `belongs_to` relationship to allow parent to set foreign key
- **Accept All Fields**: Child create actions must `accept` all fields that will be passed from parent
- **Define Both Sides**: Always define both sides of relationships (parent has_one/has_many, child belongs_to)
- **Use Identities**: Define identities on resources where duplicate prevention is needed (`identity :unique_email, [:email]`)
- **No Child Policies**: Child resources should have NO policies - authorization inherits from root resource via `relates_to_actor_via`

### Action Configuration for Parents

- **Define Arguments**: Parent actions must define `argument :child, :map` (has_one) or `argument :children, {:array, :map}` (has_many) for nested data
- **Use manage_relationship**: Include `change manage_relationship(:child, type: :create)` in parent action to handle nested creation
- **Set Owner**: Root resource should use `change set_attribute(:user_id, arg(:actor_id))` to establish ownership
- **Match Argument Names**: Argument name must match relationship name unless using second parameter in manage_relationship

### Management Types (Built-in Shortcuts)

- **:create** - Only create new records, fail if already exists (use for immutable snapshots, audit logs, imports)
- **:append** - Add new relationships without removing existing (use for additive collections like tags, followers)
- **:append_and_remove** - Full control over which records are related, removing missing ones (use for replacing lists like tags)
- **:remove** - Only remove specified relationships (use for unlike, unfollow operations)
- **:direct_control** - Full CRUD control (create/update/destroy based on input) - requires `require_atomic? false` in action

### Behavior Options (Fine-Grained Control)

- **on_lookup** - Controls whether to query for existing records (`:ignore`, `:relate`, `{:relate, :action_name}`)
- **on_no_match** - What to do when record not found (`:ignore`, `:create`, `{:create, :action_name}`, `:error`)
- **on_match** - What to do with records in current relationship (`:ignore`, `:update`, `:unrelate`, `:destroy`, `:error`)
- **on_missing** - What to do with related records not in input (`:ignore`, `:unrelate`, `:destroy`, `{:destroy, :action_name}`, `:error`)
- **Default for All**: All `on_*` options default to `:ignore` - nothing happens unless you provide instructions

### Advanced Options

- **value_is_key** - Use when input is scalar values instead of maps (`:name` treats strings as name field, defaults to primary key)
- **order_is_key** - Writes position of each item in input list to specified field (use with `:direct_control` or `:create` only)
- **use_identities** - Specify which identities to use for matching records (defaults to `[:_primary_key]`)
- **identity_priority** - Order of identities to check when matching (e.g., `[:_primary_key, :unique_email, :unique_sku]`)
- **join_keys** - For many_to_many, specify extra fields to pass to join resource (e.g., `[:role, :created_by]`)
- **debug?** - Enable query logging during relationship management for troubleshooting (defaults to `false`)

### has_one Nested Pattern

- **Parent Definition**: `has_one :child, MyApp.Child` with `argument :child, :map` and `change manage_relationship(:child, type: :create)`
- **Child Definition**: `belongs_to :parent, MyApp.Parent, attribute_writable? true` with create action that accepts all fields
- **Multi-Level Cascading**: Middle resources need both `belongs_to :parent` and `has_one :grandchild` with own manage_relationship
- **Usage**: Pass nested map `%{parent_field: value, child: %{child_field: value, grandchild: %{...}}}`

### has_many Nested Pattern

- **Parent Definition**: `has_many :children, MyApp.Child` with `argument :children, {:array, :map}` and `change manage_relationship(:children, type: :create)`
- **Child Definition**: Same as has_one - `belongs_to :parent, attribute_writable? true` with accepting create action
- **Immutable Collections**: Use `type: :create` for collections that shouldn't be updated (order items, audit logs)
- **Mutable Collections**: Use `type: :direct_control` with `require_atomic? false` for full CRUD on collection items
- **Usage**: Pass array of maps `%{parent_field: value, children: [%{field: value}, %{field: value}]}`

### many_to_many Pattern

- **Join Resource Required**: Create separate resource with `belongs_to` to both sides, both with `primary_key? true` and `attribute_writable? true`
- **Join Actions Needed**: Join resource must have `:create` (and `:destroy` for removal) actions defined
- **Relationship Definition**: Use `many_to_many :tags, MyApp.Tag, through: MyApp.JoinResource, source_attribute_on_join_resource: :source_id, destination_attribute_on_join_resource: :dest_id`
- **By ID Pattern**: `argument :tags, {:array, :uuid}` with `type: :append_and_remove, on_lookup: :relate`
- **By Name Pattern**: `argument :tag_names, {:array, :string}` with `value_is_key: :name, on_lookup: :relate, on_no_match: :create`
- **Extra Join Fields**: Use `join_keys: [:role, :tagged_at]` to pass additional attributes to join table

### Loading Nested Data

- **Not Loaded by Default**: After create/update, nested relationships are not loaded automatically
- **Explicit Loading Required**: Use `Ash.Query.load(resource, :relationship)` or `Ash.load!(record, :relationship)` to load
- **Nested Loading**: Load multi-level with `Ash.load!(record, child: [:grandchild])` or `load: [author: [:profile, :posts]]`
- **Load Calculations**: Include calculations and aggregates in load lists alongside relationships
- **Before Accessing**: Always load relationships before accessing nested data to avoid `#Ash.NotLoaded<>` errors

### Common Pitfalls to Avoid

- **Missing Argument**: Forgetting `argument :child, :map` in parent action causes "No such input" errors
- **Fields Not Accepted**: Child action not accepting all passed fields causes "Cannot accept :field_name" errors
- **Missing attribute_writable?**: Forgetting `attribute_writable? true` on belongs_to causes foreign key nil errors
- **Wrong Management Type**: Using `:append` instead of `:append_and_remove`, `:create` instead of `:direct_control`, etc.
- **Manual manage_relationship Calls**: Calling `Ash.Changeset.manage_relationship/4` directly instead of passing data as argument
- **Missing require_atomic?**: Using `:direct_control` without `require_atomic? false` in action causes atomic operation errors
- **Wrong Argument Type**: Using `:map` for has_many (should be `{:array, :map}`) or `{:array, :map}` for has_one (should be `:map`)
- **Missing Join Actions**: Join resource in many_to_many without `:create` action causes "No create action available" errors
- **No Identity Defined**: Using `on_lookup: :relate` without defining identity on target resource causes lookups to fail
- **Not Loading Relationships**: Attempting to access nested data without loading first causes `#Ash.NotLoaded<>` errors

### Testing Requirements

- **Test Direct Creation**: Verify child can be created with parent_id directly before adding nested support
- **Test Nested Creation**: Verify parent creates child via manage_relationship with correct foreign keys
- **Test Deep Nesting**: Verify 3+ level hierarchies cascade correctly through all levels
- **Test Validation Errors**: Verify validation errors in nested resources propagate to root changeset
- **Test Transaction Rollback**: Verify that all records roll back if any nested creation fails
- **Test Duplicate Detection**: Verify identities prevent duplicate nested records when expected
- **Test Authorization**: Verify policies enforce at root level and cascade to nested resources
- **Test has_many CRUD**: Verify `:direct_control` can create, update, and destroy collection items
- **Test many_to_many Lookup**: Verify `value_is_key` with `on_lookup: :relate` creates or relates correctly
- **Test Relationship Loading**: Verify nested relationships load correctly after creation

### Best Practices

- **Start Simple**: Begin with direct creation, then add single-level nesting, then deep nesting incrementally
- **Choose Appropriate Types**: Match management type to use case (immutable snapshots use `:create`, mutable use `:direct_control`, tags use `:append_and_remove`)
- **Define Clear Ownership**: Root resource owns policies and sets user_id, children have no policies and inherit authorization
- **Document Complex Structures**: Add comments documenting expected input shape for complex nested hierarchies
- **Use debug? for Troubleshooting**: Enable `debug?: true` in manage_relationship during development to log all queries
- **Test Rollback Behavior**: Always verify that failed nested creation rolls back all records atomically
- **Load Before Accessing**: Make it a habit to load nested relationships immediately after create/update before accessing data
- **Validate Input Shape**: Use argument constraints to validate nested data structure (`:min_length`, `:max_length` for arrays)
