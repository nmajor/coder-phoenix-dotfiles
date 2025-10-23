---
name: ash-admin
description: Admin UI panel for Ash resources. Use ONLY when explicitly building or working with Ash Admin interface, admin dashboards, auto-generated admin panels, or resource management UI. Do not use for general CRUD interfaces.
---

# Ash-Admin Skill

Comprehensive assistance with AshAdmin development - a super-admin UI dashboard for Ash Framework applications, built with Phoenix LiveView.

## When to Use This Skill

This skill should be triggered when:
- Setting up or configuring AshAdmin in a Phoenix application
- Creating admin interfaces for Ash resources
- Customizing resource display in the admin dashboard
- Configuring resource forms, fields, and validations in the admin UI
- Setting up authentication/authorization for admin access
- Customizing resource grouping and navigation
- Configuring field types, formats, and display options
- Working with relationships in the admin interface
- Debugging AshAdmin routing, CSP, or display issues
- Implementing custom field types or form behaviors

## Key Concepts

### Core Components

- **AshAdmin.Domain** - Extension to make a domain visible in the admin UI
- **AshAdmin.Resource** - Extension to customize how a resource appears in the admin
- **Admin Forms** - Configurable forms for creating/editing resources
- **Field Configuration** - Control field types, formats, and display behavior

### Important Terminology

- **Actor** - The authenticated user performing actions in the admin
- **Resource Group** - Organizational grouping for resources in the admin UI
- **Polymorphic Actions** - Actions for resources using Postgres polymorphism
- **Label Field** - The field displayed when resource appears in relationships

## Quick Reference

### Pattern 1: Basic AshAdmin Setup

```elixir
# Add to mix.exs
{:ash_admin, "~> 0.13.3"}

# In router
defmodule MyAppWeb.Router do
  use Phoenix.Router
  import AshAdmin.Router

  scope "/" do
    pipe_through [:browser]
    ash_admin "/admin"
  end
end

# In your Domain
use Ash.Domain,
  extensions: [AshAdmin.Domain]

admin do
  show? true
end
```

### Pattern 2: Resource Configuration

```elixir
# In your resource
use Ash.Resource,
  extensions: [AshAdmin.Resource]

admin do
  # Resource name in UI
  name "My Resource"

  # Fields shown in table view
  table_columns [:id, :name, :status, :inserted_at]

  # Field used as label in relationships
  label_field :name

  # Group in the resource dropdown
  resource_group :content
end
```

### Pattern 3: Custom Field Types in Forms

```elixir
admin do
  form do
    field :description, type: :long_text
    field :summary, type: :short_text
    field :content, type: :markdown
  end
end
```

### Pattern 4: File Upload Configuration

```elixir
admin do
  form do
    field :avatar,
      max_file_size: 5_000_000,  # 5MB in bytes
      accepted_extensions: [".jpg", ".jpeg", ".png"]

    field :document,
      accepted_extensions: ["application/pdf", "image/*"]
  end
end
```

### Pattern 5: Configuring Available Actions

```elixir
admin do
  # Limit which actions appear in admin
  read_actions [:read, :read_all]
  create_actions [:create]
  update_actions [:update, :quick_update]
  destroy_actions [:archive]  # Only show archive, not hard delete
  generic_actions [:custom_action]
end
```

### Pattern 6: Format Fields for Display

```elixir
admin do
  # Format dates and times
  format_fields [
    inserted_at: {Timex, :format!, ["{0D}-{0M}-{YYYY} {h12}:{m} {AM}"]},
    price: {MyApp.Helpers, :format_currency, []},
    status: {String, :upcase, []}
  ]

  # Show sensitive fields (normally hidden)
  show_sensitive_fields [:email, :phone]
end
```

### Pattern 7: Relationship Display Configuration

```elixir
admin do
  # Fields shown when this resource appears in relationships
  relationship_display_fields [:name, :email, :status]

  # Max items before switching to typeahead
  relationship_select_max_items 25
end
```

### Pattern 8: Domain Configuration

```elixir
use Ash.Domain,
  extensions: [AshAdmin.Domain]

admin do
  show? true
  name "My Application"
  default_resource_page :primary_read

  # Custom labels for resource groups
  resource_group_labels [
    content: "Content Management",
    users: "User Administration",
    settings: "Configuration"
  ]
end
```

### Pattern 9: Actor Configuration

```elixir
admin do
  # Mark resource as usable as actor
  actor? true

  # Load associations when fetching actor
  actor_load [:organization, :permissions]
end
```

### Pattern 10: Securing AshAdmin Routes

```elixir
# In router with authentication
scope "/" do
  pipe_through [:browser, :require_authenticated_user, :admin_only]
  ash_admin "/admin"
end

# Define admin_only plug
def admin_only(conn, _opts) do
  if conn.assigns.current_user.role == :admin do
    conn
  else
    conn
    |> put_flash(:error, "Access denied")
    |> redirect(to: "/")
    |> halt()
  end
end

# Set actor for policies
scope "/" do
  pipe_through [:browser, :require_authenticated_user]

  ash_admin "/admin",
    on_mount: [{MyAppWeb.LiveUserAuth, :live_user_required}]
end
```

### Pattern 11: Content Security Policy Configuration

```elixir
# If you have CSP headers
plug :put_secure_browser_headers, %{
  "content-security-policy" =>
    "default-src 'self' 'nonce-#{AshAdmin.Plug.default_csp_nonce()}'"
}

# Or use custom nonce
scope "/" do
  pipe_through [:browser]
  ash_admin "/admin", csp_nonce_assign_key: :csp_nonce
end
```

## Reference Files

This skill includes comprehensive documentation in `references/`:

### other.md
Contains essential setup and configuration documentation:
- Installation and setup (with Igniter or manual)
- Router configuration
- Security setup and CSP configuration
- Domain and resource extension basics
- Actor configuration for authentication
- Troubleshooting common issues

### resources.md
Detailed resource customization documentation:
- AshAdmin.Resource DSL options
- Field configuration and types
- Form customization
- Table display options
- Action filtering
- Relationship display
- Polymorphic resource handling
- Format fields and calculations

Use `view` to read specific reference files when detailed information is needed.

## Working with This Skill

### For Beginners

Start with these steps:
1. Review Pattern 1 for basic setup
2. Read the "Getting Started" section in `references/other.md`
3. Add AshAdmin.Resource extension to your resources (Pattern 2)
4. Secure your admin routes (Pattern 10)

### For Customizing Forms

When building custom admin forms:
1. Use Pattern 3 for field type customization
2. Check Pattern 4 for file uploads
3. Reference Pattern 6 for field formatting
4. Review `references/resources.md` for detailed field options

### For Production Setup

Important considerations:
1. Always secure admin routes (Pattern 10)
2. Configure Content Security Policy (Pattern 11)
3. Set appropriate actor configuration (Pattern 9)
4. Limit exposed actions (Pattern 5)

### Common Tasks

**Customize resource display:**
- Table columns: Pattern 2 (`table_columns`)
- Field formatting: Pattern 6 (`format_fields`)
- Relationship display: Pattern 7

**Configure forms:**
- Field types: Pattern 3 (`form.field type:`)
- File uploads: Pattern 4
- Available actions: Pattern 5

**Organize resources:**
- Resource groups: Pattern 2 (`resource_group`)
- Group labels: Pattern 8 (`resource_group_labels`)

## Troubleshooting

### Common Issues

**Admin UI not loading:**
- Check that `show? true` is set in domain admin config
- Verify router configuration includes `import AshAdmin.Router`
- Ensure resources are registered with their domains

**Styles/JS not working:**
- Review CSP configuration (Pattern 11)
- Check browser console for CSP violations
- Add AshAdmin nonces to CSP allowlist

**UndefinedFunctionError for PageLive:**
- Ensure router is in the web namespace (e.g., `MyAppWeb.Router`)
- Verify Phoenix LiveView is properly configured

**Authentication issues:**
- Verify actor configuration (Pattern 9)
- Check that policies allow the current actor
- Review router pipeline for authentication plugs

## Advanced Features

### Polymorphic Resources

For resources using Postgres polymorphism:

```elixir
admin do
  polymorphic_tables ["table_1", "table_2"]
  polymorphic_actions [:create, :update]
end
```

### Custom Calculations Display

```elixir
admin do
  # Show specific calculations
  show_calculations [:total_value, :completion_percentage]
end
```

### Multi-attribute Formatting

```elixir
admin do
  format_fields [
    # Complex formatting
    full_name: {MyApp.Formatters, :format_name, [:first_name, :last_name]},

    # Conditional formatting
    status_display: {MyApp.Formatters, :status_with_icon, []}
  ]
end
```

## Resources

### references/
Organized documentation extracted from official AshAdmin sources:
- Detailed API documentation
- Complete DSL options reference
- Configuration examples
- Security best practices

### Official Resources
- [AshAdmin Hex Documentation](https://hexdocs.pm/ash_admin)
- [Ash Framework Guide](https://hexdocs.pm/ash)
- [Phoenix LiveView](https://hexdocs.pm/phoenix_live_view)

## Notes

- AshAdmin is built on Phoenix LiveView - requires LiveView setup
- All resources in a domain are automatically included unless filtered
- Field formatting applies to read-only fields of date/time types
- Actor configuration enables policy-based authorization
- Resource groups help organize large applications

## Updating

To refresh this skill with updated documentation:
1. Re-run the documentation scraper
2. Review new DSL options in the reference files
3. Update patterns with new features
