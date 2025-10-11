## Ash API standards (AshJsonApi & AshGraphql)

### Declarative API Generation

- **Never Write Controllers for Domain Logic**: APIs are generated from resource definitions via AshJsonApi or AshGraphql extensions
- **Resources Define Endpoints**: Add `extensions: [AshJsonApi]` or `extensions: [AshGraphql]` to resources to expose them via API
- **Actions Define Operations**: API endpoints/mutations are derived from resource actions, not manually coded routes
- **Policies Enforce Authorization**: Access control happens at the policy layer, not in controller code

### AshJsonApi Standards

- **Configure in Domain**: Add AshJsonApi configuration to domain module, not individual routers
- **Base Route per Resource**: Define `base_route` in resource's `json_api` block (e.g., `base_route "/posts"`)
- **Expose Actions Explicitly**: Use `routes` block to explicitly expose actions as endpoints (e.g., `get :read`, `post :create`, `patch :update`)
- **Include Relationships**: Configure `includes` to allow clients to request related resources in single requests
- **JSON:API Spec Compliance**: Follow JSON:API specification for request/response format (enforced automatically by AshJsonApi)

### AshGraphql Standards

- **Configure in Domain**: Add AshGraphql configuration to domain module with schema definition
- **Type Definitions**: Resource attributes automatically become GraphQL types - no manual type definitions needed
- **Queries and Mutations**: Expose read actions as queries, create/update/destroy actions as mutations via `queries` and `mutations` blocks
- **Relationships as Fields**: Related resources become nested fields automatically - Ash handles N+1 prevention via dataloader
- **Custom Queries**: Define generic actions for complex queries that don't fit standard patterns

### Code Interfaces (Primary API)

- **Define in Domain Module**: Use `define` macro in domain's `resources` block to create function-based API
- **Name Functions After Operations**: Match function names to business operations (`:place_order`, `:publish_post`, `:approve_request`)
- **This is Your Public API**: Phoenix controllers and LiveViews should call code interface functions, not build changesets directly
- **Pass Actor Always**: Include `actor: current_user` in all code interface calls for proper authorization

### Common Patterns

- **Filtering**: Expose read action arguments for filtering instead of building query parameter logic
- **Pagination**: AshJsonApi and AshGraphql handle pagination automatically - configure limits and offsets in read actions
- **Sorting**: Define `prepare sort(...)` in read actions to control default and allowed sort orders
- **Field Selection**: Clients can request specific fields via JSON:API sparse fieldsets or GraphQL field selection
- **Error Responses**: Framework returns standardized error responses - customize with error handlers if needed
- **Authentication**: Use AshAuthentication with token resources, not custom JWT/session logic
