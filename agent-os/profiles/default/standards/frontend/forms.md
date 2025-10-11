## AshPhoenix Form Standards

### The Golden Rule: Always Use Domain Forms

**NEVER create forms directly in LiveViews. ALWAYS define in domain `forms` block.**

```elixir
# ✅ In domain
defmodule MyApp.Blog do
  use Ash.Domain

  forms do
    form :create_post
    form :update_post
  end

  resources do
    resource MyApp.Blog.Post do
      define :create_post, action: :create
      define :update_post, action: :update
    end
  end
end

# ✅ In LiveView - use domain function
form = Blog.form_to_create_post(actor: current_user) |> to_form()

# ❌ NEVER do this - bypasses domain abstraction
form = AshPhoenix.Form.for_create(Post, :create, domain: Blog) |> to_form()
```

### Share LiveView Between New/Edit

**Use same LiveView file with different actions for new/edit operations.**

```elixir
# lib/my_app_web/live/posts_live/form.ex
defmodule MyAppWeb.PostsLive.Form do
  use MyAppWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  # New action
  defp apply_action(socket, :new, _params) do
    form =
      Blog.form_to_create_post(
        actor: socket.assigns.current_user,
        transform_params: &merge_form_state/3
      )
      |> to_form()

    assign(socket, :form, form)
  end

  # Edit action
  defp apply_action(socket, :edit, %{"id" => id}) do
    post = Blog.get_post!(id, actor: socket.assigns.current_user)

    form =
      Blog.form_to_update_post(
        post,
        actor: socket.assigns.current_user,
        transform_params: &merge_form_state/3
      )
      |> to_form()

    assign(socket, :form, form)
  end

  # Preserve form state during validation
  defp merge_form_state(form, params, _ctx) do
    Map.merge(form.params || %{}, params || %{})
  end
end
```

### Router Pattern

```elixir
# In router
live "/posts/new", PostsLive.Form, :new
live "/posts/:id/edit", PostsLive.Form, :edit
```

### Form Validation Pattern

```elixir
def handle_event("validate", %{"post" => params}, socket) do
  form =
    socket.assigns.form.source
    |> Form.validate(params, errors: socket.assigns.show_errors)
    |> to_form()

  {:noreply, assign(socket, form: form)}
end
```

### Form Submission Pattern

```elixir
def handle_event("save", %{"post" => params}, socket) do
  case Form.submit(socket.assigns.form.source, params: params) do
    {:ok, post} ->
      {:noreply,
        socket
        |> put_flash(:info, "Post saved successfully")
        |> push_navigate(to: ~p"/posts/#{post}")}

    {:error, form} ->
      {:noreply,
        socket
        |> assign(form: to_form(form))
        |> assign(show_errors: true)}
  end
end
```

### Critical Rules

**1. transform_params is required for stateful forms:**
```elixir
# ✅ Preserves form state during validation
form =
  Blog.form_to_create_post(
    actor: current_user,
    transform_params: fn form, params, _ctx ->
      Map.merge(form.params || %{}, params || %{})
    end
  )

# ❌ Without transform_params, form loses state on validation
form = Blog.form_to_create_post(actor: current_user)
```

**2. Always pass actor from socket.assigns:**
```elixir
# ✅ Correct - passes authorization
form = Blog.form_to_create_post(actor: socket.assigns.current_user)

# ❌ Wrong - bypasses authorization
form = Blog.form_to_create_post()
```

**3. Use form.source for validate/submit:**
```elixir
# ✅ Correct - validates the AshPhoenix.Form struct
Form.validate(socket.assigns.form.source, params)

# ❌ Wrong - validates the Phoenix.HTML.Form struct
Form.validate(socket.assigns.form, params)
```

**4. Show errors only after first submit attempt:**
```elixir
# In mount/handle_params
assign(socket, show_errors: false)

# In validate event
Form.validate(form.source, params, errors: socket.assigns.show_errors)

# In submit event (on error)
assign(socket, show_errors: true)
```

### Nested Forms Pattern

```elixir
# Domain automatically detects from manage_relationship
defmodule MyApp.Shop do
  forms do
    form :create_order  # Auto-detects line_items from manage_relationship
  end
end

# In LiveView - nested forms work automatically
%{
  "order" => %{
    "total" => "100",
    "line_items" => [
      %{"product_id" => "1", "quantity" => "2"},
      %{"product_id" => "2", "quantity" => "1"}
    ]
  }
}
```

### Template Pattern

```elixir
<.simple_form for={@form} phx-change="validate" phx-submit="save">
  <.input field={@form[:title]} label="Title" />
  <.input field={@form[:body]} type="textarea" label="Body" />

  <:actions>
    <.button>Save Post</.button>
  </:actions>
</.simple_form>
```

### What NOT to Do

- **Never call `AshPhoenix.Form.for_create/update` directly** - Use domain `form_to_*` functions
- **Never create forms without transform_params** - Form state gets lost
- **Never skip actor** - Bypasses authorization
- **Never validate `@form` instead of `@form.source`** - Wrong struct type
- **Never show errors before first submit** - Bad UX
- **Never create separate LiveViews for new/edit** - Use same file with actions

### Common Mistakes

**Validating wrong struct:**
```elixir
# ❌ Wrong - @form is Phoenix.HTML.Form
Form.validate(@form, params)

# ✅ Correct - @form.source is AshPhoenix.Form
Form.validate(@form.source, params)
```

**Not preserving form state:**
```elixir
# ❌ Wrong - loses unsaved changes on validation
form = Blog.form_to_create_post(actor: user)

# ✅ Correct - merges current state with new params
form = Blog.form_to_create_post(
  actor: user,
  transform_params: fn form, params, _ctx ->
    Map.merge(form.params || %{}, params || %{})
  end
)
```

**Showing errors immediately:**
```elixir
# ❌ Wrong - shows errors before user tries to submit
Form.validate(form, params, errors: true)

# ✅ Correct - only show after submit attempt
Form.validate(form, params, errors: socket.assigns.show_errors)
```
