# Ash-Postgres - Constraints

**Pages:** 6

---

## References

**URL:** https://hexdocs.pm/ash_postgres/references.html

**Contents:**
- References
  - Actions are not used for this behavior
- On Delete
- On Update
- Nothing vs Restrict

To configure the behavior of generated foreign keys on a resource, we use the references section, within the postgres configuration block.

All supported DSL options can be found in a datalayer documentation.

No resource logic is applied with these operations! No authorization rules or validations take place, and no notifications are issued. This operation happens directly in the database.

This option describes what to do if the referenced row is deleted.

The option is called on_delete, instead of on_destroy, because it is hooking into the database level deletion, not a destroy action in your resource. See the warning above.

The possible values for the option are :nothing, :restrict, :delete, :nilify, {:nilify, columns}.

With :nothing or :restrict the deletion of the referenced row is prevented.

With :delete the row is deleted together with the referenced row.

With :nilify all columns of the foreign-key constraint are nilified.

With {:nilify, columns} a column list can specify which columns should be set to nil. If you intend to use this option to nilify a subset of the columns, note that it cannot be used together with the match: :full option otherwise a mix of nil and non-nil values would fail the constraint and prevent the deletion of the referenced row. In addition, keep into consideration that this option is only supported from Postgres v15.0 onwards.

This option describes what to do if the referenced row is updated.

The possible values for the option are :nothing, :restrict, :update, :nilify.

With :nothing or :restrict the update of the referenced row is prevented.

With :update the row is updated according to the referenced row.

With :nilify all columns of the foreign-key constraint are nilified.

The difference between :nothing and :restrict is subtle and, if you are unsure, choose :nothing (the default behavior). :restrict will immediately check the foreign-key constraint and prevent the update or deletion from happening, whereas :nothing allows the check to be deferred until later in the transaction. This allows for things like updating or deleting the destination row and then updating updating or deleting the reference (as long as you are in a transaction). The reason that :nothing still ultimately prevents the update or deletion is because postgres enforces foreign key referential integrity.

Hex Package Hex Preview (current file) Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
postgres do
  # other PostgreSQL config here

  references do
    reference :post, on_delete: :delete, on_update: :update, name: "comments_to_posts_fkey"
  end
end
```

Example 2 (unknown):
```unknown
references do
  reference :post, on_delete: :nothing
  # vs
  reference :post, on_delete: :restrict
end
```

---

## AshPostgres (ash_postgres v2.6.23)

**URL:** https://hexdocs.pm/ash_postgres/AshPostgres.html

**Contents:**
- AshPostgres (ash_postgres v2.6.23)
- Summary
- Functions
- Functions
- base_filter_sql(resource)
- check_constraints(resource)
- custom_indexes(resource)
- custom_statements(resource)
- exclusion_constraint_names(resource)
- foreign_key_names(resource)

The AshPostgres extension gives you tools to map a resource to a postgres database table.

For more, check out the getting started guide

See AshPostgres.DataLayer.Info.base_filter_sql/1.

See AshPostgres.DataLayer.Info.check_constraints/1.

See AshPostgres.DataLayer.Info.custom_indexes/1.

See AshPostgres.DataLayer.Info.custom_statements/1.

See AshPostgres.DataLayer.Info.exclusion_constraint_names/1.

See AshPostgres.DataLayer.Info.foreign_key_names/1.

See AshPostgres.DataLayer.Info.identity_index_names/1.

See AshPostgres.DataLayer.Info.manage_tenant_create?/1.

See AshPostgres.DataLayer.Info.manage_tenant_template/1.

See AshPostgres.DataLayer.Info.manage_tenant_update?/1.

See AshPostgres.DataLayer.Info.migrate?/1.

See AshPostgres.DataLayer.Info.migration_types/1.

See AshPostgres.DataLayer.Info.polymorphic?/1.

See AshPostgres.DataLayer.Info.polymorphic_name/1.

See AshPostgres.DataLayer.Info.polymorphic_on_delete/1.

See AshPostgres.DataLayer.Info.polymorphic_on_update/1.

See AshPostgres.DataLayer.Info.references/1.

See AshPostgres.DataLayer.Info.repo/1.

See AshPostgres.DataLayer.Info.schema/1.

See AshPostgres.DataLayer.Info.skip_unique_indexes/1.

See AshPostgres.DataLayer.Info.table/1.

See AshPostgres.DataLayer.Info.unique_index_names/1.

See AshPostgres.DataLayer.Info.base_filter_sql/1.

See AshPostgres.DataLayer.Info.check_constraints/1.

See AshPostgres.DataLayer.Info.custom_indexes/1.

See AshPostgres.DataLayer.Info.custom_statements/1.

See AshPostgres.DataLayer.Info.exclusion_constraint_names/1.

See AshPostgres.DataLayer.Info.foreign_key_names/1.

See AshPostgres.DataLayer.Info.identity_index_names/1.

See AshPostgres.DataLayer.Info.manage_tenant_create?/1.

See AshPostgres.DataLayer.Info.manage_tenant_template/1.

See AshPostgres.DataLayer.Info.manage_tenant_update?/1.

See AshPostgres.DataLayer.Info.migrate?/1.

See AshPostgres.DataLayer.Info.migration_types/1.

See AshPostgres.DataLayer.Info.polymorphic?/1.

See AshPostgres.DataLayer.Info.polymorphic_name/1.

See AshPostgres.DataLayer.Info.polymorphic_on_delete/1.

See AshPostgres.DataLayer.Info.polymorphic_on_update/1.

See AshPostgres.DataLayer.Info.references/1.

See AshPostgres.DataLayer.Info.repo/1.

See AshPostgres.DataLayer.Info.schema/1.

See AshPostgres.DataLayer.Info.skip_unique_indexes/1.

See AshPostgres.DataLayer.Info.table/1.

See AshPostgres.DataLayer.Info.unique_index_names/1.

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4

*[Content truncated]*

---

## AshPostgres.Reference (ash_postgres v2.6.23)

**URL:** https://hexdocs.pm/ash_postgres/AshPostgres.Reference.html

**Contents:**
- AshPostgres.Reference (ash_postgres v2.6.23)
- Summary
- Functions
- Functions
- schema()

Represents the configuration of a reference (i.e foreign key).

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## AshPostgres.DataLayer

**URL:** https://hexdocs.pm/ash_postgres/dsl-ashpostgres-datalayer.html

**Contents:**
- AshPostgres.DataLayer
- postgres
  - Nested DSLs
  - Examples
  - Options
  - postgres.custom_indexes
  - Nested DSLs
  - Examples
  - postgres.custom_indexes.index
  - Examples

A postgres data layer that leverages Ecto's postgres capabilities.

Postgres data layer configuration

A section for configuring indexes to be created by the migration generator.

In general, prefer to use identities for simple unique constraints. This is a tool to allow for declaring more complex indexes.

Add an index to be managed by the migration generator.

Target: AshPostgres.CustomIndex

A section for configuring custom statements to be added to migrations.

Changing custom statements may require manual intervention, because Ash can't determine what order they should run in (i.e if they depend on table structure that you've added, or vice versa). As such, any down statements we run for custom statements happen first, and any up statements happen last.

Additionally, when changing a custom statement, we must make some assumptions, i.e that we should migrate the old structure down using the previously configured down and recreate it.

This may not be desired, and so what you may end up doing is simply modifying the old migration and deleting whatever was generated by the migration generator. As always: read your migrations after generating them!

Add a custom statement for migrations.

Target: AshPostgres.Statement

Configuration for the behavior of a resource that manages a tenant

A section for configuring the references (foreign keys) in resource migrations.

This section is only relevant if you are using the migration generator with this resource. Otherwise, it has no effect.

Configures the reference for a relationship in resource migrations.

Keep in mind that multiple relationships can theoretically involve the same destination and foreign keys. In those cases, you only need to configure the reference behavior for one of them. Any conflicts will result in an error, across this resource and any other resources that share a table with this one. For this reason, instead of adding a reference configuration for :nothing, its best to just leave the configuration out, as that is the default behavior if no relationship anywhere has configured the behavior of that reference.

Target: AshPostgres.Reference

A section for configuring the check constraints for a given table.

This can be used to automatically create those check constraints, or just to provide message when they are raised

Add a check constraint to be validated.

If a check constraint exists on the table but not in this section, and it produces an error, a runtime error will be raised.

Pro

*[Content truncated]*

**Examples:**

Example 1 (unknown):
```unknown
postgres do
  repo MyApp.Repo
  table "organizations"
end
```

Example 2 (unknown):
```unknown
custom_indexes do
  index [:column1, :column2], unique: true, where: "thing = TRUE"
end
```

Example 3 (unknown):
```unknown
index fields
```

Example 4 (unknown):
```unknown
index ["column", "column2"], unique: true, where: "thing = TRUE"
```

---

## AshPostgres.DataLayer.Info (ash_postgres v2.6.23)

**URL:** https://hexdocs.pm/ash_postgres/AshPostgres.DataLayer.Info.html

**Contents:**
- AshPostgres.DataLayer.Info (ash_postgres v2.6.23)
- Summary
- Functions
- Functions
- base_filter_sql(resource)
- calculation_to_sql(resource, calc)
- calculations_to_sql(resource)
- check_constraints(resource)
- custom_indexes(resource)
- custom_statements(resource)

Introspection functions for

A stringified version of the base_filter, to be used in a where clause when generating unique indexes

A keyword list of calculations to their sql representation

The configured check_constraints for a resource

The configured custom_indexes for a resource

The configured custom_statements for a resource

The configured exclusion_constraint_names

The configured foreign_key_names

A list of keys to always include in upserts.

The configured identity_index_names

Returns the literal SQL for the where clause given a resource and an identity name.

A keyword list of identity names to the literal SQL string representation of the where clause portion of identity's partial unique index.

Whether or not to create a tenant for a given resource

The template for a managed tenant

Whether or not to update a tenant for a given resource

Whether or not the resource should be included when generating migrations

A keyword list of customized migration defaults

A list of attributes to be ignored when generating migrations

A keyword list of customized migration types

Gets the resource's repo's postgres version

Checks a version requirement against the resource's repo's postgres version

The configured polymorphic? for a resource

The configured polymorphic_reference_name for a resource

The configured polymorphic_reference_on_delete for a resource

The configured polymorphic_reference_on_update for a resource

The configured reference for a given relationship of a resource

The configured references for a resource

The configured repo for a resource

The configured schema for a resource

Identities not to include in the migrations

Skip generating unique indexes when generating migrations

A keyword list of customized storage types

The configured table for a resource

The configured unique_index_names

A stringified version of the base_filter, to be used in a where clause when generating unique indexes

A keyword list of calculations to their sql representation

The configured check_constraints for a resource

The configured custom_indexes for a resource

The configured custom_statements for a resource

The configured exclusion_constraint_names

The configured foreign_key_names

A list of keys to always include in upserts.

The configured identity_index_names

Returns the literal SQL for the where clause given a resource and an identity name.

See identity_wheres_to_sql/1 for more details.

A keyword list of identity names to the literal S

*[Content truncated]*

**Examples:**

Example 1 (unknown):
```unknown
identities do
  identity :active, [:status] do
    where expr(status == "active")
  end
end
```

Example 2 (unknown):
```unknown
postgres do
  ...

  identity_wheres_to_sql active: "status = 'active'"
end
```

---

## AshPostgres.CheckConstraint (ash_postgres v2.6.23)

**URL:** https://hexdocs.pm/ash_postgres/AshPostgres.CheckConstraint.html

**Contents:**
- AshPostgres.CheckConstraint (ash_postgres v2.6.23)
- Summary
- Functions
- Functions
- schema()

Represents a configured check constraint on the table backing a resource

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

---
