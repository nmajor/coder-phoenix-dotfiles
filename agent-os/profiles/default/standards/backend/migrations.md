## Migration standards

**NEVER use `mix ecto.migrate` directly in Ash projects.** Always follow the Ash migration workflow:

1. Make changes to your Ash resource modules (attributes, relationships, etc.)
2. Run `mix ash.codegen <descriptive_name>` to generate migrations
   - Use lower_snake_case for the migration name
   - Example: `mix ash.codegen add_user_roles`
3. Review generated migrations in `priv/repo/migrations/`
4. Run `mix ash.migrate` to apply migrations

### Development Workflow (Recommended)

For iterative development, use the `--dev` flag to avoid naming migrations prematurely:

1. Make resource changes
2. Run `mix ash.codegen --dev` to generate temporary dev migrations
3. Run `mix ash.migrate` to apply migrations
4. Continue iterating with more changes and `mix ash.codegen --dev`
5. When feature is complete, run `mix ash.codegen <descriptive_name>`
   - This rolls back and squashes dev migrations into a final named migration
6. Review and run `mix ash.migrate`

### Custom Database Changes

For database changes that can't be expressed in resource definitions, use `custom_statements`:

```elixir
postgres do
  custom_statements do
    statement "CREATE EXTENSION IF NOT EXISTS \"uuid-ossp\""

    statement """
    CREATE INDEX users_search_idx
    ON users USING gin(search_vector)
    """
  end
end
```