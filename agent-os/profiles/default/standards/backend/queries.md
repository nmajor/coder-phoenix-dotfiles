## Ash query standards

### Declarative Querying with Ash.Query

- **Never Write Raw Ecto Queries**: ALL data access MUST go through Ash actions and queries, not direct `Repo.all()` or `Repo.get()`
- **Never Build Custom Query Functions**: Don't write functions that construct Ecto queries - define read actions with filters and arguments instead
- **Use Ash.Query for Read Operations**: Build queries with `Ash.Query` functions (`:filter`, `:sort`, `:load`, `:limit`, `:offset`), then execute with `Ash.read/2`
- **Read Actions Define Query Patterns**: Each query pattern should be a named read action, not a function that builds a query

### Read Actions

- **Named Query Patterns**: Define read actions for common query patterns (`:by_author`, `:published`, `:recent`, `:search`)
- **Arguments for Inputs**: Use `argument` in read actions for dynamic filtering (`:status`, `:author_id`, `:search_term`)
- **Filter Expressions**: Use `filter expr(...)` to define declarative filters that compile to SQL
- **Prepare Hooks**: Use `prepare` callbacks for query modifications (sorting, limiting, eager loading)
- **Get Actions**: Define `:get_by` read actions for single-record retrieval by specific fields

### Filtering

- **Expression Filters**: Use Ash expression syntax in filters (`expr(status == :published and author_id == ^arg(:author_id))`)
- **Automatic SQL Generation**: Ash compiles filter expressions to optimized SQL - no manual query building
- **Relationship Filters**: Filter on related resources using relationship paths (`expr(author.role == :admin)`)
- **Existence Filters**: Use `exists/2` to filter based on related record existence
- **Dynamic Filters**: Accept filter arguments in read actions instead of creating multiple query functions

### Loading Related Data

- **Declarative Loading**: Use `Ash.Query.load/2` to specify related resources to load (prevents N+1)
- **Nested Loading**: Load nested relationships with list syntax (`load: [author: [:profile, :posts]]`)
- **Load Calculations**: Include calculations and aggregates in load lists alongside relationships
- **Automatic Optimization**: Ash uses dataloader pattern to batch relationship queries efficiently
- **Never Manual Preloading**: Don't use `Repo.preload` - use Ash's load mechanism

### Sorting & Pagination

- **Default Sort**: Define `prepare sort(...)` in read actions for consistent default ordering
- **Dynamic Sorting**: Accept sort arguments in read actions for client-controlled ordering
- **Offset Pagination**: Use `limit` and `offset` options in `Ash.Query` or read action defaults
- **Keyset Pagination**: Use `page` option with keyset pagination for better performance on large datasets
- **Count Queries**: Use `Ash.count/2` for total count queries, or enable `count: true` option in read actions

### Performance

- **Index Usage**: Define indexes in resource's `postgres` block - Ash generates appropriate database indexes
- **Select Specific Fields**: Use `select` option to load only needed attributes, or define read actions with limited selected fields
- **Aggregates at Database**: Use Ash aggregates instead of loading records and counting in memory
- **Calculations in Database**: Prefer expression-based calculations that push computation to database
- **Query Timeouts**: Configure timeouts in read actions or via `timeout` option to prevent runaway queries

### Security

- **SQL Injection Impossible**: Ash expressions compile safely - user input cannot inject SQL
- **Policies Always Apply**: Authorization policies enforce automatically on all read actions - no bypass possible
- **Tenant Isolation**: Use multitenancy configuration for automatic tenant filtering on all queries
- **Field-Level Authorization**: Use policy conditions to restrict which fields users can read
