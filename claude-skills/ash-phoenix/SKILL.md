---
name: ash-phoenix
description: Forms and Phoenix web integration. Use for ANY form handling, form validation, error handling, LiveView integration, Phoenix contexts, and connecting Ash resources to Phoenix applications.
---

# Ash-Phoenix Skill

Comprehensive assistance with ash-phoenix development, generated from official documentation.

## When to Use This Skill

This skill should be triggered when:
- You are working with Ash resources and need to integrate them into a Phoenix LiveView application.
- You need to build dynamic, complex filtering forms for Ash resources in LiveView using `AshPhoenix.FilterForm`.
- You are implementing pagination or real-time updates for Ash queries in LiveView using `AshPhoenix.LiveView`.
- You are creating forms for Ash resource actions (create, update, destroy, read) in Phoenix, especially with nested or compound types, using `AshPhoenix.Form`.
- You are dealing with form validation, error handling, or managing relationships in Phoenix forms backed by Ash.
- You are looking for best practices or debugging assistance related to Ash and Phoenix integration.

## Key Concepts and Terminology

*   **`AshPhoenix.FilterForm`**: A module designed to create complex forms for generating Ash filters. It manages predicates (simple boolean expressions) and groups (logical groupings of predicates and other groups with `AND`/`OR` operators).
*   **`AshPhoenix.LiveView`**: Provides utilities to keep Ash query results up-to-date in a LiveView, handling pagination and real-time notifications.
*   **`AshPhoenix.Form`**: A module for fluidly using Ash resources with Phoenix forms. It simplifies the lifecycle of form creation, validation, and submission for Ash actions (create, update, destroy, read), including handling nested and compound data types.
*   **Predicates**: Simple boolean expressions used within `AshPhoenix.FilterForm` to build query conditions (e.g., `name == "Joe"`).
*   **Groups**: Logical containers within `AshPhoenix.FilterForm` that combine predicates and other groups using `AND` or `OR` operators.
*   **Liveness**: The ability for Ash queries in LiveView to automatically update results in response to changes in the underlying data, often via Ash Notifiers and PubSub.
*   **Code Interface (for Forms)**: An Ash feature that generates `form_to_` functions for resource actions, simplifying the creation of `AshPhoenix.Form` instances.
*   **Nested Forms**: Forms that manage relationships between resources, allowing creation, updating, or deletion of related data within a single parent form.
*   **Compound Types**: Data types like `Ash.Money` that require special handling in forms, often involving mapping errors to individual input fields.

## Quick Reference

### Common Patterns

**1. Initializing an `AshPhoenix.FilterForm`**
Create a new filter form for a given Ash resource.

```elixir
# Create a FilterForm for the Employee resource
filter_form = AshPhoenix.FilterForm.new(MyApp.Payroll.Employee)
```

**2. Building a Complex Filter with `AshPhoenix.FilterForm`**
Add predicates and nested groups to construct sophisticated query filters.

```elixir
# Add a predicate to the root of the form (which is itself a group)
filter_form = AshPhoenix.FilterForm.add_predicate(filter_form, :some_field, :eq, "Some Value")

# Add a group and another predicate to that group
{filter_form, group_id} = AshPhoenix.FilterForm.add_group(filter_form, operator: :or, return_id?: true)
filter_form = AshPhoenix.FilterForm.add_predicate(filter_form, :another, :eq, "Other", to: group_id)
```

**3. Validating and Applying an `AshPhoenix.FilterForm`**
Process submitted parameters, validate the filter form, and apply it to an Ash query.

```elixir
filter_form = AshPhoenix.FilterForm.validate(socket.assigns.filter_form, params)

# Generate a query and pass it to the Domain
query = AshPhoenix.FilterForm.filter!(MyApp.Payroll.Employee, filter_form)
filtered_employees = MyApp.Payroll.read!(query)

# Or use one of the other filter functions
AshPhoenix.FilterForm.to_filter_expression(filter_form)
AshPhoenix.FilterForm.to_filter_map(filter_form)
```

**4. Keeping LiveView Data Up-to-Date with `AshPhoenix.LiveView`**
Handle Ash notifications in a LiveView to automatically update query results.

```elixir
@impl true
def handle_info(%{topic: topic, payload: %Ash.Notifier.Notification{}}, socket) do
  # Updates queries assigned to :query1, :query2, :query3 based on the notification
  {:noreply, AshPhoenix.LiveView.handle_live(socket, topic, [:query1, :query2, :query3])}
end
```

**5. Creating an `AshPhoenix.Form` for a Resource Action**
Initialize a form for a create action on an Ash resource, leveraging generated `form_to_` functions.

```elixir
# In your LiveView's mount function:
def mount(_params, _session, socket) do
  # Assuming MyApp.Accounts.User has an action 'register_with_password'
  # and AshPhoenix extension is used in the domain.
  form = MyApp.Accounts.form_to_register_with_password() |> AshPhoenix.Form.to_form()
  {:ok, assign(socket, form: form)}
end
```

**6. Handling `AshPhoenix.Form` Validation and Submission in LiveView**
Process form changes for validation and submit the form to perform the Ash action.

```elixir
# In your LiveView's handle_event for validation:
def handle_event("validate", %{"form" => params}, socket) do
  form = AshPhoenix.Form.validate(socket.assigns.form, params)
  {:noreply, assign(socket, :form, form)}
end

# In your LiveView's handle_event for submission:
def handle_event("submit", %{"form" => params}, socket) do
  case AshPhoenix.Form.submit(socket.assigns.form, params: params) do
    {:ok, _user} ->
      socket = socket |> put_flash(:success, "User registered successfully") |> push_navigate(to: ~p"/")
      {:noreply, socket}
    {:error, form} ->
      socket = socket |> put_flash(:error, "Something went wrong") |> assign(:form, form)
      {:noreply, socket}
  end
end
```

**7. Defining Resource Actions with Relationship Management for Forms**
Configure an Ash resource action to manage related data (e.g., `many_to_many`) when the form is submitted.

```elixir
# In lib/my_app/operations/service.ex
create :create do
  accept [:name]
  primary? true
  argument :location_ids, {:array, :integer}, allow_nil?: true

  # This change manages the many_to_many relationship with :locations
  change Ash.Changeset.manage_relationship(:location_ids, :locations, type: :append_and_remove)
end

update :update do
  accept [:name]
  primary? true
  argument :location_ids, {:array, :integer}, allow_nil?: true
  require_atomic? false

  # This change manages the many_to_many relationship with :locations
  change Ash.Changeset.manage_relationship(:location_ids, :locations, type: :append_and_remove)
end
```

## Reference Files

This skill includes comprehensive documentation in `references/`:

-   **forms.md**: Detailed documentation on `AshPhoenix.Form`, covering its lifecycle, usage with code interfaces, handling related/embedded data, and compound types.
-   **liveview.md**: Documentation for `AshPhoenix.LiveView`, focusing on keeping query results live, pagination, and handling Ash notifications.
-   **filter_form.md**: Specific documentation for `AshPhoenix.FilterForm`, explaining predicates, groups, and how to build complex filters.
-   **forms-for-relationships-between-existing-records.md**: A guide on managing relationships between existing records using `AshPhoenix.Form`, particularly for `many_to_many` associations.

Use `view` to read specific reference files when detailed information is needed.

## Working with This Skill

### For Beginners
Start by understanding the core concepts of Ash (resources, actions, changesets, queries) before diving into `ash-phoenix`. Focus on `AshPhoenix.Form` for basic CRUD operations and `AshPhoenix.LiveView` for displaying data. The examples in the "Quick Reference" provide a good starting point.

### For Specific Features
-   **Dynamic Filtering**: Refer to `filter_form.md` and the `AshPhoenix.FilterForm` examples.
-   **Live Data & Pagination**: Consult `liveview.md` and the `AshPhoenix.LiveView` examples.
-   **Complex Forms (Nested/Compound)**: Explore `forms.md` and `forms-for-relationships-between-existing-records.md` for advanced form scenarios.
-   **Error Handling**: Look into `AshPhoenix.FormData.Error` documentation for customizing error rendering.

### For Code Examples
The "Quick Reference" section above contains common patterns extracted directly from the official docs. Pay attention to the Elixir language tags for easy copy-pasting and experimentation.

## Resources

### references/
Organized documentation extracted from official sources. These files contain:
-   Detailed explanations
-   Code examples with language annotations
-   Links to original documentation
-   Table of contents for quick navigation

### scripts/
Add helper scripts here for common automation tasks.

### assets/
Add templates, boilerplate, or example projects here.

## Notes

-   This skill was automatically generated from official documentation
-   Reference files preserve the structure and examples from source docs
-   Code examples include language detection for better syntax highlighting
-   Quick reference patterns are extracted from common usage examples in the docs

## Updating

To refresh this skill with updated documentation:
1.  Re-run the scraper with the same configuration
2.  The skill will be rebuilt with the latest information
