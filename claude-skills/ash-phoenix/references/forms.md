# Ash-Phoenix - Forms

**Pages:** 7

---

## AshPhoenix.FilterForm (ash_phoenix v2.3.17)

**URL:** https://hexdocs.pm/ash_phoenix/AshPhoenix.FilterForm.html

**Contents:**
- AshPhoenix.FilterForm (ash_phoenix v2.3.17)
- LiveView Example
- Summary
- Functions
- Functions
- add_group(form, opts \\ [])
- add_predicate(form, field, operator_or_function, value, opts \\ [])
- errors(form, opts \\ [])
- fields(resource)
- filter(query, form)

A module to help you create complex forms that generate Ash filters.

FilterForm's comprise 2 concepts, predicates and groups. Predicates are the simple boolean expressions you can use to build a query (name == "Joe"), and groups can be used to group predicates and more groups together. Groups can apply and or or operators to its nested components.

validate/1 is used to merge the submitted form params into the filter form, and one of the provided filter functions to apply the filter as a query, or generate an expression map, depending on your requirements:

You can build a form and handle adding and removing nested groups and predicates with the following:

Add a group to the filter. A group can contain predicates and other groups, allowing you to build quite complex nested filters.

Add a predicate to the filter.

Returns a flat list of all errors on all predicates in the filter, made safe for display in a form.

Returns the list of available fields, which may be attributes, calculations, or aggregates.

Converts the form into a filter, and filters the provided query or resource with that filter.

Same as filter/2 but raises on errors.

Create a new filter form.

Returns the minimal set of params (at the moment just strips ids) for use in a query string.

Returns the list of available predicates for the given resource, which may be functions or operators.

Returns a flat list of all errors on all predicates in the filter, without transforming.

Removes the group or predicate with the given id

Remove the group with the given id

Remove the predicate with the given id

Returns a filter expression that can be provided to Ash.Query.filter/2

Same as to_filter_expression/1 but raises on errors.

Returns a filter map that can be provided to Ash.Filter.parse

Update the predicate with the given id

Updates the filter with the provided input and validates it.

Add a group to the filter. A group can contain predicates and other groups, allowing you to build quite complex nested filters.

:to (String.t/0) - The nested group id to add the group to.

:operator - The operator that the group should have internally. Valid values are :and, :or The default value is :and.

:return_id? (boolean/0) - If set to true, the function returns {form, predicate_id} The default value is false.

Add a predicate to the filter.

:to (String.t/0) - The group id to add the predicate to. If not set, will be added to the top level group.

:return_id? (boolean/0) - If set to true, the func

*[Content truncated]*

**Examples:**

Example 1 (unknown):
```unknown
# Create a FilterForm
filter_form = AshPhoenix.FilterForm.new(MyApp.Payroll.Employee)
```

Example 2 (unknown):
```unknown
# Add a predicate to the root of the form (which is itself a group)
filter_form = AshPhoenix.FilterForm.add_predicate(filter_form, :some_field, :eq, "Some Value")

# Add a group and another predicate to that group
{filter_form, group_id} = AshPhoenix.FilterForm.add_group(filter_form, operator: :or, return_id?: true)
filter_form = AshPhoenix.FilterForm.add_predicate(filter_form, :another, :eq, "Other", to: group_id)
```

Example 3 (unknown):
```unknown
filter_form = AshPhoenix.FilterForm.validate(socket.assigns.filter_form, params)

# Generate a query and pass it to the Domain
query = AshPhoenix.FilterForm.filter!(MyApp.Payroll.Employee, filter_form)
filtered_employees = MyApp.Payroll.read!(query)

# Or use one of the other filter functions
AshPhoenix.FilterForm.to_filter_expression(filter_form)
AshPhoenix.FilterForm.to_filter_map(filter_form)
```

Example 4 (javascript):
```javascript
alias MyApp.Payroll.Employee

@impl true
def render(assigns) do
  ~H"""
  <.simple_form
    :let={filter_form}
    for={@filter_form}
    phx-change="filter_validate"
    phx-submit="filter_submit"
  >
    <.filter_form_component component={filter_form} />
    <:actions>
      <.button>Submit</.button>
    </:actions>
  </.simple_form>
  <.table id="employees" rows={@employees}>
    <:col :let={employee} label="Payroll ID"><%= employee.employee_id %></:col>
    <:col :let={employee} label="Name"><%= employee.name %></:col>
    <:col :let={employee} label="Position"><%= employee.position %></:c
...
```

---

## AshPhoenix.FormData.Error protocol (ash_phoenix v2.3.17)

**URL:** https://hexdocs.pm/ash_phoenix/AshPhoenix.FormData.Error.html

**Contents:**
- AshPhoenix.FormData.Error protocol (ash_phoenix v2.3.17)
- Summary
- Types
- Functions
- Types
- t()
- Functions
- to_form_error(exception)

A protocol for allowing errors to be rendered into a form.

To implement, define a to_form_error/1 and return a single error or list of errors of the following shape:

{:field_name, message, replacements}

Replacements is a keyword list to allow for translations, by extracting out the constants like numbers from the message.

All the types that implement this protocol.

All the types that implement this protocol.

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.3) for the Elixir programming language

---

## Forms For Relationships Between Existing Records

**URL:** https://hexdocs.pm/ash_phoenix/forms-for-relationships-between-existing-records.html

**Contents:**
- Forms For Relationships Between Existing Records
- Defining the resources and relationships
- Declaring the create and update actions
- Adding the forms

Make sure you're familiar with the basics of AshPhoenix.Form and relationships before reading this guide.

When we talk about "relationships between existing records", we mean inputs on a form that manage the relationships between records that already exist.

For example, you might have a form for creating a "service" that can be performed at some "locations", but not others. When creating or updating a service, the user is only able to select from the existing locations.

First, we have a simple Location

Then we have a Service, which has a many_to_many association to Location, through ServiceLocation. We add a list aggregate for :location_ids for populating the form values.

ServiceLocation has default actions as well as the relationships declared to operate as the joining resource between a Service and one or more Locations.

First, we need to update our Service and declare custom create and update actions, which take a list of Location ids as an argument. We use type: :append_and_remove to cause a ServiceLocation to be added or removed for each Location as we add and remove them using our form. (See Ash.Changeset.manage_relationship/4 for more.)

Note: in this example, we are using integer_primary_key, so the argument's type is {:array, :integer}. If we were using uuid_primary_key, the type would be {:array, :uuid}.

Now we can create and update our Services.

Now, let's expose this to a user.

In our view, we create our form as normal. For update forms, we'll make sure to load our locations.

We use the :prepare_params option with our for_update form to set "location_ids" to an empty list if no value is provided. This allows the user to de-select all Locations to update a Service so that it's not available at any Location.

When rendering the form, we'll have to manually provide the options to our input. Using Phoenix generated core components, options is passed to Phoenix.HTML.Form.options_for_select/2, which expects a list of two-element tuples.

Assuming the available Locations are already assigned to @locations:

Now, when our form is submitted, we will receive a list of location ids.

That's all we need to do. We can pass these parameters to AshPhoenix.Form.submit/2 as normal and manage_relationship will create and destroy our ServiceLocation records as needed.

Hex Package Hex Preview (current file) Search HexDocs Download ePub version

Built using ExDoc (v0.38.3) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
defmodule MyApp.Operations.Location do
  use Ash.Resource,
    otp_app: :my_app,
    domain: MyApp.Operations,
    data_layer: AshPostgres.DataLayer

  ...

  attributes do
    integer_primary_key :id

    attribute :name, :string do
      allow_nil? false
    end
  end
end
```

Example 2 (unknown):
```unknown
defmodule MyApp.Operations.Service do
  use Ash.Resource,
    otp_app: :my_app,
    domain: MyApp.Operations,
    data_layer: AshPostgres.DataLayer

  ...

  relationships do
    has_many :location_relationships, MyApp.Operations.ServiceLocation do
      destination_attribute :service_id
    end

    many_to_many :locations, MyApp.Operations.Location do
      join_relationship :location_relationships
      source_attribute_on_join_resource :service_id
      destination_attribute_on_join_resource :location_id
    end
  end

  aggregates do
    list :location_ids, :locations, :id
  end
end
```

Example 3 (unknown):
```unknown
defmodule MyApp.Operations.ServiceLocation do
  use Ash.Resource,
    otp_app: :my_app,
    domain: MyApp.Operations,
    data_layer: AshPostgres.DataLayer

  ...

  actions do
    defaults [:create, :read, :update, :destroy]
    default_accept [:service_id, :location_id]
  end

  relationships do
    belongs_to :service, MyApp.Operations.Service do
      attribute_type :integer
      allow_nil? false
      primary_key? true
    end

    belongs_to :location, MyApp.Operations.Location do
      attribute_type :integer
      allow_nil? false
      primary_key? true
    end
  end
end
```

Example 4 (unknown):
```unknown
# in lib/my_app/operations/service.ex
create :create do
  accept [:name]
  primary? true
  argument :location_ids, {:array, :integer}, allow_nil?: true

  change manage_relationship(:location_ids, :locations, type: :append_and_remove)
end

update :update do
  accept [:name]
  primary? true
  argument :location_ids, {:array, :integer}, allow_nil?: true
  require_atomic? false

  change manage_relationship(:location_ids, :locations, type: :append_and_remove)
end
```

---

## AshPhoenix.Form (ash_phoenix v2.3.17)

**URL:** https://hexdocs.pm/ash_phoenix/AshPhoenix.Form.html

**Contents:**
- AshPhoenix.Form (ash_phoenix v2.3.17)
  - Life cycle
  - Forms in the code interface
- Working with related or embedded data
- Working with compound types
  - Handling errors for composite inputs
- Summary
- Types
- Functions
- Types

A module to allow you to fluidly use resources with Phoenix forms.

The general workflow is, with either LiveView or Phoenix forms:

The following keys exist on the form to show where in the lifecycle you are:

Throughout this documentation you will see forms created with AshPhoenix.Form.for_create/3 and other functions like it. This is perfectly fine to do, however there is a way to use AshPhoenix.Form in a way that adds clarity to its usage and makes it easier to find usage of each action. Code interfaces allow us to do this for standard action calls, i.e:

Adding the AshPhoenix extension to our domains and resources, like so:

will cause another function to be generated for each definition, beginning with form_to_.

By default, the args option in define is ignored when building forms. If you want to have positional arguments, configure that in the forms section which is added by the AshPhoenix section. For example:

With this extension, the standard setup for forms looks something like this:

See the nested forms guide

Compound types, such as Ash.Money, will need some extra work to make it work.

For instance, when working with the Transfer type in AshDoubleEntry.Transfer, it will have the Ash.Money type for amount. When rendering the forms, you should do as follows:

When working with composite inputs like the example above, you may need to map errors from the composite field to the individual input fields. The post_process_errors option can help with this:

The above will allow the fields to be used by the AshPhoenix.Form when creating or updating a Transfer. You can follow the same style with other compound types.

Adds an error to the source underlying the form.

Adds a new form at the provided path.

A utility to get the list of arguments the action underlying the form accepts

A utility to get the list of attributes the action underlying the form accepts

Clears a given input's value on a form.

Returns the errors on the form, sanitized for displaying to the end user.

Creates a form corresponding to any given action on a resource.

Creates a form corresponding to a create action on a resource.

Creates a form corresponding to a destroy action on a record.

Creates a form corresponding to a read action on a resource.

Creates a form corresponding to an update action on a record.

Gets the form at the specified path

Returns true if a given form path exists in the form

Returns the hidden fields for a form as a keyword list

Toggles the form to be

*[Content truncated]*

**Examples:**

Example 1 (unknown):
```unknown
resources do
  resource MyApp.Accounts.User do
    define :register_with_password, args: [:email, :password]
    define :update_user, action: :update, args: [:email, :password]
  end
end
```

Example 2 (unknown):
```unknown
use Ash.Domain,
  extensions: [AshPhoenix]
```

Example 3 (unknown):
```unknown
forms do
  form :update_user, args: [:email]
end
```

Example 4 (javascript):
```javascript
def render(assigns) do
  ~H"""
  <.form for={@form} phx-change="validate" phx-submit="submit">
    <.input field={@form[:email]} />
    <.input field={@form[:password]} />
    <.button type="submit" />
  </.form>
  """
end

def mount(_params, _session, socket) do
  # Here we call our new generated function to create the form
  {:ok, assign(socket, form: MyApp.Accounts.form_to_register_with_password() |> to_form())}
end

def handle_event("validate", %{"form" => params}, socket) do
  form = AshPhoenix.Form.validate(socket.assigns.form, params)
  {:noreply, assign(socket, :form, form)}
end

def h
...
```

---

## Union Forms

**URL:** https://hexdocs.pm/ash_phoenix/union-forms.html

**Contents:**
- Union Forms
- Determining the type for a union form
- Changing the type of a union form
- Non-embedded types
- Example

When building a form for a union, you use inputs_for as normal, but a few things are done for you under the hood.

Lets take this example union:

We track the type of the value in a hidden param called _union_type. You can use this to show a different form depending on the type of thing.

If you want to let the user change the union type, you would use AshPhoenix.Form.remove_form/3 and AshPhoenix.Form.add_form/3. See the example below for the template, and here is an example event handler

If one of your union values is a non embedded type, like :integer, it will still be a nested form, but you would access the single value with <.input field={nested_form[:value]} .../>

We might have a form like this:

Hex Package Hex Preview (current file) Search HexDocs Download ePub version

Built using ExDoc (v0.38.3) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
defmodule NormalContent do
  use Ash.Resource, data_layer: :embedded

  attributes do
    attribute :body, :string, allow_nil?: false, public?: true
  end

  actions do
    defaults [:read, create: [:body], update: [:body]]
  end
end

defmodule SpecialContent do
  use Ash.Resource, data_layer: :embedded

  attributes do
    attribute :text, :string, allow_nil?: false, public?: true
  end

  actions do
    defaults [:read, create: [:text], update: [:text]]
  end
end

defmodule Content do
  use Ash.Type.NewType,
    subtype_of: :union,
    constraints: [
      types: [
        normal: [
        
...
```

Example 2 (javascript):
```javascript
def handle_event("type-changed", %{"_target" => path} = params, socket) do
  new_type = get_in(params, path)
  # The last part of the path in this case is the field name
  path = :lists.droplast(path)

  form =
    socket.assigns.form
    |> AshPhoenix.Form.remove_form(path)
    |> AshPhoenix.Form.add_form(path, params: %{"_union_type" => new_type})

  {:noreply, assign(socket, :form, form)}
end
```

Example 3 (unknown):
```unknown
<.inputs_for :let={fc} field={@form[:content]}>
  <!-- Dropdown for setting the union type -->
  <.input
    field={fc[:_union_type]}
    phx-change="type-changed"
    type="select"
    options={[Normal: "normal", Special: "special"]}
  />

  <!-- switch on the union type to display a form -->
  <%= case fc.params["_union_type"] do %>
    <% "normal" -> %>
      <.input  type="text" field={fc[:body]} />
    <% "special" -> %>
      <.input type="text" field={fc[:text]} />
  <% end %>
</.inputs_for>
```

---

## AshPhoenix.Form.Auto (ash_phoenix v2.3.17)

**URL:** https://hexdocs.pm/ash_phoenix/AshPhoenix.Form.Auto.html

**Contents:**
- AshPhoenix.Form.Auto (ash_phoenix v2.3.17)
- Options
- Special Considerations
  - on_lookup: :relate_and_update
  - Many to Many Relationships
- Summary
- Functions
- Functions
- auto(resource, action, opts \\ [])
- embedded(resource, action, auto_opts)

A tool to automatically generate available nested forms based on a resource and action.

To use this, specify forms: [auto?: true] when creating the form.

Keep in mind, you can always specify these manually when creating a form by simply specifying the forms option.

There are two things that this builds forms for:

For more on relationships see the documentation for Ash.Changeset.manage_relationship/4.

When building forms, you can switch on the action type and/or resource of the form, in order to have different fields depending on the form. For example, if you have a simple relationship called :comments with on_match: :update and on_no_match: :create, there are two types of forms that can be in inputs_for(form, :comments).

In which case you may have something like this:

This also applies to adding forms of different types manually. For instance, if you had a "search" field to allow them to search for a record (e.g in a liveview), and you had an on_lookup read action, you could render a search form for that read action, and once they've selected a record, you could render the fields to update that record (in the case of on_lookup: :relate_and_update configurations).

:relationship_fetcher (term/0) - A two argument function that receives the parent data, the relationship to fetch. The default simply fetches the relationship value, and if it isn't loaded, it uses [] or nil.

:sparse_lists? (boolean/0) - Sets all list type forms to sparse?: true by default. Has no effect on forms derived for embedded resources. The default value is false.

:include_non_map_types? (boolean/0) - Creates form for non map or array of map type inputs The default value is false.

For on_lookup: :relate_and_update configurations, the "read" form for that relationship will use the appropriate read action. However, you may also want to include the relevant fields for the update that would subsequently occur. To that end, a special nested form called :_update is created, that uses an empty instance of that resource as the base of its changeset. This may require some manual manipulation of that data before rendering the relevant form because it assumes all the default values. To solve for this, if you are using liveview, you could actually look up the record using the input from the read action, and then use AshPhoenix.Form.update_form/3 to set that looked up record as the data of the _update form.

In the case that a manage_change option points to a join relationship, that form is 

*[Content truncated]*

**Examples:**

Example 1 (unknown):
```unknown
<%= for comment_form <- inputs_for(f, :comments) do %>
  <%= hidden_inputs_for(comment_form) %>
  <%= if comment_form.source.type == :create do %>
    <%= text_input comment_form, :text %>
    <%= text_input comment_form, :on_create_field %>
  <% else %>
    <%= text_input comment_form, :text %>
    <%= text_input comment_form, :on_update_field %>
  <% end %>

  <button phx-click="remove_form" phx-value-path="<%= comment_form.name %>">Remove Comment</button>
  <button phx-click="add_form" phx-value-path="<%= comment_form.name %>">Add Comment</button>
<% end %>
```

---

## Nested Forms

**URL:** https://hexdocs.pm/ash_phoenix/nested-forms.html

**Contents:**
- Nested Forms
- Defining the structure
  - Inferring from the action
  - Manually defining nested forms
- Updating existing data
  - Not using tailwind?
- Adding nested forms
  - The _add_* checkbox
  - But the checkbox is hidden, what gives?
  - AshPhoenix.Form.add_form

Make sure you're familiar with the basics of AshPhoenix.Form before reading this guide.

When we talk about "nested" or "related" forms, we mean sets of form inputs that are for resource actions for related or embedded resources.

For example, you might have a form for creating a "business" that can also include multiple "locations". In some cases, you may have buttons to add or remove from a list of nested forms, you may be able to drag and drop to reorder forms, etc. In other cases, the form may just be for one related thing, think a form for updating a "user" that also contains inputs for its associated "profile".

AshPhoenix.Form automatically infers what "nested forms" are available, based on introspecting actions which use change manage_relationship. For example, in the following action:

With this action, you could submit an input like so:

AshPhoenix.Form will look at the action, allowing you to use Phoenix's <.inputs_for component for locations. Here is what it might look like in practice:

To turn this automatic behavior off, you can specify forms: [auto?: false] when creating the form.

You can manually specify nested form configurations using the forms option.

You should prefer to use the automatic form definition wherever possible, but this exists as an escape hatch to customize configuration.

You should be sure to load any relationships that are necessary for your manage_relationships when you want to update the nested items. For example, if the form above was for an update action, you may want to allow updating the existing locations all in a single form. AshPhoenix.Form will show a form for each existing location, but only if the locations are loaded on the business already. For example:

If you're not using tailwind, you'll need to replace class="hidden" in the examples below with something else. In standard HTML, you'd do <input .... hidden />. As long as the checkbox is hidden, you're good!

There are two ways to add nested forms.

This checkbox, when checked, will add a parameter like form[_add_locations]=end. When AshPhoenix.Form is handling nested forms, it will see that and append an empty form at the end. Valid values are "start", "end" and an index, i.e "3", in which case the new form will be inserted at that index.

If you're anything like me, the label + checkbox combo above may confuse you at first sight. When you have a checkbox inside of a label, clicking on the label counts as clicking the checkbox itself!

In some cases, y

*[Content truncated]*

**Examples:**

Example 1 (unknown):
```unknown
# on a `MyApp.Operations.Business` resource
create :create do
  accept [:name]

  argument :locations, {:array, :map}

  change manage_relationship(:locations, type: :create)
end
```

Example 2 (unknown):
```unknown
%{name: "Wally World", locations: [%{name: "HQ", address: "1 hq street"}]}
```

Example 3 (unknown):
```unknown
<.simple_form for={@form} phx-change="validate" phx-submit="submit">
  <.input field={@form[:email]} />

  <.inputs_for :let={location} field={@form[:locations]}>
    <.input field={location[:name]} />
  </.inputs_for>
</.form>
```

Example 4 (unknown):
```unknown
AshPhoenix.Form.for_create(
  MyApp.Operations.Business, 
  :create, 
  forms: [
    locations: [
      type: :list,
      resource: MyApp.Operations.Location,
      create_action: :create
    ]
  ]
)
```

---
