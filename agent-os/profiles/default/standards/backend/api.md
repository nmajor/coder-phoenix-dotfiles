## API standards

### Declarative Ash API Generation

- **Never Write Controllers for Domain Logic**: APIs are generated from resource definitions via AshJsonApi or AshGraphql extensions
- **Resources Define Endpoints**: Add `extensions: [AshJsonApi]` or `extensions: [AshGraphql]` to resources to expose them via API
- **Actions Define Operations**: API endpoints/mutations are derived from resource actions, not manually coded routes
- **Policies Enforce Authorization**: Access control happens at the policy layer, not in controller code
