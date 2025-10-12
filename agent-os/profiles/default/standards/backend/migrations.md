## Migration standards

**NEVER, UNDER ANY CIRCUMSTANCES, CREATE OR MODIFY DATABASE MIGRATIONS MANUALLY**

This project uses Ash Framework with AshPostgres. **ALL** database schema changes MUST follow the Ash migration workflow:

## ✅ CORRECT Way to Change Schema:

1. Modify Ash resource definitions in `lib/kingpin/*/resources/`
2. Run: `mix ash.codegen <descriptive_name>`
3. Review the generated migration in `priv/repo/migrations/`
4. Apply with: `mix ash.migrate`

## ❌ FORBIDDEN Actions:

- **DO NOT** run `mix ecto.gen.migration` - This bypasses Ash's resource snapshots
- **DO NOT** run `mix ecto.migrate` directly - Always use `mix ash.migrate`
- **DO NOT** manually create files in `priv/repo/migrations/`
- **DO NOT** manually edit existing Ash-generated migrations
- **DO NOT** use `Ecto.Migration.create table(...)` directly in migrations

## 📝 Exceptions (Rare):

Only these migration types may be created manually:

- System extensions (e.g., `CREATE EXTENSION postgis`)
- Non-Ash tables (e.g., Oban job tables)
- Multi-repo or multitenancy edge cases

**If you violate this rule, you will corrupt the migration state and cause database inconsistencies that require dropping and recreating the database.**
