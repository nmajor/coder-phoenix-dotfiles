# Phoenix-Liveview - Components

**Pages:** 7

---

## Live navigation

**URL:** https://hexdocs.pm/phoenix_live_view/live-navigation.html

**Contents:**
- Live navigation
- handle_params/3
- Replace page address
- Multiple LiveViews in the same page

LiveView provides functionality to allow page navigation using the browser's pushState API. With live navigation, the page is updated without a full page reload.

You can trigger live navigation in two ways:

From the client - this is done by passing either patch={url} or navigate={url} to the Phoenix.Component.link/1 component.

From the server - this is done by Phoenix.LiveView.push_patch/2 or Phoenix.LiveView.push_navigate/2.

For example, instead of writing the following in a template:

The "patch" operations must be used when you want to navigate to the current LiveView, simply updating the URL and the current parameters, without mounting a new LiveView. When patch is used, the handle_params/3 callback is invoked and the minimal set of changes are sent to the client. See the next section for more information.

The "navigate" operations must be used when you want to dismount the current LiveView and mount a new one. You can only "navigate" between LiveViews in the same session. While redirecting, a phx-loading class is added to the LiveView, which can be used to indicate to the user a new page is being loaded.

If you attempt to patch to another LiveView or navigate across live sessions, a full page reload is triggered. This means your application continues to work, in case your application structure changes and that's not reflected in the navigation.

Here is a quick breakdown:

<.link href={...}> and redirect/2 are HTTP-based, work everywhere, and perform full page reloads

<.link navigate={...}> and push_navigate/2 work across LiveViews in the same session. They mount a new LiveView while keeping the current layout

<.link patch={...}> and push_patch/2 updates the current LiveView and sends only the minimal diff while also maintaining the scroll position

The handle_params/3 callback is invoked after mount/3 and before the initial render. It is also invoked every time <.link patch={...}> or push_patch/2 are used. It receives the request parameters as first argument, the url as second, and the socket as third.

For example, imagine you have a UserTable LiveView to show all users in the system and you define it in the router as:

Now to add live sorting, you could do:

When clicked, since we are navigating to the current LiveView, handle_params/3 will be invoked. Remember you should never trust the received params, so you must use the callback to validate the user input and change the state accordingly:

Note we returned {:noreply, socket}, where :nor

*[Content truncated]*

**Examples:**

Example 1 (unknown):
```unknown
<.link href={~p"/pages/#{@page + 1}"}>Next</.link>
```

Example 2 (unknown):
```unknown
<.link patch={~p"/pages/#{@page + 1}"}>Next</.link>
```

Example 3 (unknown):
```unknown
{:noreply, push_patch(socket, to: ~p"/pages/#{@page + 1}")}
```

Example 4 (unknown):
```unknown
live "/users", UserTable
```

---

## Phoenix.Component (Phoenix LiveView v1.1.16)

**URL:** https://hexdocs.pm/phoenix_live_view/Phoenix.Component.html

**Contents:**
- Phoenix.Component (Phoenix LiveView v1.1.16)
- Attributes
- Global attributes
  - Included globals
  - Custom global attribute prefixes
- Slots
  - The default slot
  - Named slots
  - Slot attributes
- Embedding external template files

Define reusable function components with HEEx templates.

A function component is any function that receives an assigns map as an argument and returns a rendered struct built with the ~H sigil:

This function uses the ~H sigil to return a rendered template. ~H stands for HEEx (HTML + EEx). HEEx is a template language for writing HTML mixed with Elixir interpolation. We can write Elixir code inside {...} for HTML-aware interpolation inside tag attributes and the body. We can also interpolate arbitrary HEEx blocks using <%= ... %> We use @name to access the key name defined inside assigns.

When invoked within a ~H sigil or HEEx template file:

The following HTML is rendered:

If the function component is defined locally, or its module is imported, then the caller can invoke the function directly without specifying the module:

For dynamic values, you can interpolate Elixir expressions into a function component:

Function components can also accept blocks of HEEx content (more on this later):

In this module we will learn how to build rich and composable components to use in our applications.

Phoenix.Component provides the attr/3 macro to declare what attributes the proceeding function component expects to receive when invoked:

By calling attr/3, it is now clear that greet/1 requires a string attribute called name present in its assigns map to properly render. Failing to do so will result in a compilation warning:

Attributes can provide default values that are automatically merged into the assigns map:

Now you can invoke the function component without providing a value for name:

Rendering the following HTML:

Accessing an attribute which is required and does not have a default value will fail. You must explicitly declare default: nil or assign a value programmatically with the assign_new/3 function.

Multiple attributes can be declared for the same function component:

Allowing the caller to pass multiple values:

Rendering the following HTML:

Multiple function components can be defined in the same module, with different attributes. In the following example, <Components.greet/> requires a name, but does not require a title, and <Components.heading> requires a title, but does not require a name.

With the attr/3 macro you have the core ingredients to create reusable function components. But what if you need your function components to support dynamic attributes, such as common HTML attributes to mix into a component's container?

Global attributes are a

*[Content truncated]*

**Examples:**

Example 1 (python):
```python
defmodule MyComponent do
  # In Phoenix apps, the line is typically: use MyAppWeb, :html
  use Phoenix.Component

  def greet(assigns) do
    ~H"""
    <p>Hello, {@name}!</p>
    """
  end
end
```

Example 2 (unknown):
```unknown
<MyComponent.greet name="Jane" />
```

Example 3 (unknown):
```unknown
<p>Hello, Jane!</p>
```

Example 4 (unknown):
```unknown
<.greet name="Jane" />
```

---

## Phoenix.LiveView.TagEngine behaviour (Phoenix LiveView v1.1.16)

**URL:** https://hexdocs.pm/phoenix_live_view/Phoenix.LiveView.TagEngine.html

**Contents:**
- Phoenix.LiveView.TagEngine behaviour (Phoenix LiveView v1.1.16)
- Summary
- Callbacks
- Functions
- Callbacks
- annotate_body(caller)
- annotate_caller(file, line)
- annotate_slot(name, tag_meta, close_tag_meta, caller)
- classify_type(name)
- handle_attributes(ast, meta)

An EEx engine that understands tags.

This cannot be directly used by Phoenix applications. Instead, it is the building block by engines such as Phoenix.LiveView.HTMLEngine.

It is typically invoked like this:

Where :tag_handler implements the behaviour defined by this module.

Callback invoked to add annotations around the whole body of a template.

Callback invoked to add caller annotations before a function component is invoked.

Callback invoked to add annotations around each slot of a template.

Classify the tag type from the given binary.

Implements processing of attributes.

Returns if the given tag name is void or not.

Renders a component defined by the given function.

Define a inner block, generally used by slots.

Callback invoked to add annotations around the whole body of a template.

Callback invoked to add caller annotations before a function component is invoked.

Callback invoked to add annotations around each slot of a template.

In case the slot is an implicit inner block, the tag meta points to the component.

Classify the tag type from the given binary.

This must return a tuple containing the type of the tag and the name of tag. For instance, for LiveView which uses HTML as default tag handler this would return {:tag, 'div'} in case the given binary is identified as HTML tag.

You can also return {:error, "reason"} so that the compiler will display this error.

Implements processing of attributes.

It returns a quoted expression or attributes. If attributes are returned, the second element is a list where each element in the list represents one attribute. If the list element is a two-element tuple, it is assumed the key is the name to be statically written in the template. The second element is the value which is also statically written to the template whenever possible (such as binaries or binaries inside a list).

Returns if the given tag name is void or not.

That's mainly useful for HTML tags and used internally by the compiler. You can just implement as def void?(_), do: false if you want to ignore this.

Renders a component defined by the given function.

This function is rarely invoked directly by users. Instead, it is used by ~H and other engine implementations to render Phoenix.Components. For example, the following:

Define a inner block, generally used by slots.

This macro is mostly used by custom HTML engines that provide a slot implementation and rarely called directly. The name must be the assign name the slot/block 

*[Content truncated]*

**Examples:**

Example 1 (unknown):
```unknown
EEx.compile_string(source,
  engine: Phoenix.LiveView.TagEngine,
  line: 1,
  file: path,
  caller: __CALLER__,
  source: source,
  tag_handler: FooBarEngine
)
```

Example 2 (unknown):
```unknown
<MyApp.Weather.city name="Kraków" />
```

Example 3 (unknown):
```unknown
<%= component(
      &MyApp.Weather.city/1,
      [name: "Kraków"],
      {__ENV__.module, __ENV__.function, __ENV__.file, __ENV__.line}
    ) %>
```

---

## Phoenix.LiveViewTest (Phoenix LiveView v1.1.16)

**URL:** https://hexdocs.pm/phoenix_live_view/Phoenix.LiveViewTest.html

**Contents:**
- Phoenix.LiveViewTest (Phoenix LiveView v1.1.16)
- Testing function components
- Testing LiveViews and LiveComponents
  - Testing LiveViews
  - Testing Events
  - Testing regular messages
  - Testing LiveComponents
- Summary
- Functions
- Functions

Conveniences for testing function components as well as LiveViews and LiveComponents.

There are two mechanisms for testing function components. Imagine the following component:

You can test it by using render_component/3, passing the function reference to the component as first argument:

However, for complex components, often the simplest way to test them is by using the ~H sigil itself:

The difference is that we use rendered_to_string/1 to convert the rendered template to a string for testing.

In LiveComponents and LiveView tests, we interact with views via process communication in substitution of a browser. Like a browser, our test process receives messages about the rendered updates from the view which can be asserted against to test the life-cycle and behavior of LiveViews and their children.

The life-cycle of a LiveView as outlined in the Phoenix.LiveView docs details how a view starts as a stateless HTML render in a disconnected socket state. Once the browser receives the HTML, it connects to the server and a new LiveView process is started, remounted in a connected socket state, and the view continues statefully. The LiveView test functions support testing both disconnected and connected mounts separately, for example:

Here, we start by using the familiar Phoenix.ConnTest function, get/2 to test the regular HTTP GET request which invokes mount with a disconnected socket. Next, live/1 is called with our sent connection to mount the view in a connected state, which starts our stateful LiveView process.

In general, it's often more convenient to test the mounting of a view in a single step, provided you don't need the result of the stateless HTTP render. This is done with a single call to live/2, which performs the get step for us:

The browser can send a variety of events to a LiveView via phx- bindings, which are sent to the handle_event/3 callback. To test events sent by the browser and assert on the rendered side effect of the event, use the render_* functions:

render_click/1 - sends a phx-click event and value, returning the rendered result of the handle_event/3 callback.

render_focus/2 - sends a phx-focus event and value, returning the rendered result of the handle_event/3 callback.

render_blur/1 - sends a phx-blur event and value, returning the rendered result of the handle_event/3 callback.

render_submit/1 - sends a form phx-submit event and value, returning the rendered result of the handle_event/3 callback.

render_change/1 - sends

*[Content truncated]*

**Examples:**

Example 1 (unknown):
```unknown
def greet(assigns) do
  ~H"""
  <div>Hello, {@name}!</div>
  """
end
```

Example 2 (unknown):
```unknown
import Phoenix.LiveViewTest

test "greets" do
  assert render_component(&MyComponents.greet/1, name: "Mary") ==
           "<div>Hello, Mary!</div>"
end
```

Example 3 (unknown):
```unknown
import Phoenix.Component
import Phoenix.LiveViewTest

test "greets" do
  assigns = %{}
  assert rendered_to_string(~H"""
         <MyComponents.greet name="Mary" />
         """) ==
           "<div>Hello, Mary!</div>"
end
```

Example 4 (unknown):
```unknown
import Plug.Conn
import Phoenix.ConnTest
import Phoenix.LiveViewTest
@endpoint MyEndpoint

test "disconnected and connected mount", %{conn: conn} do
  conn = get(conn, "/my-path")
  assert html_response(conn, 200) =~ "<h1>My Disconnected View</h1>"

  {:ok, view, html} = live(conn)
end

test "redirected mount", %{conn: conn} do
  assert {:error, {:redirect, %{to: "/somewhere"}}} = live(conn, "my-path")
end
```

---

## Phoenix.LiveComponent behaviour (Phoenix LiveView v1.1.16)

**URL:** https://hexdocs.pm/phoenix_live_view/Phoenix.LiveComponent.html

**Contents:**
- Phoenix.LiveComponent behaviour (Phoenix LiveView v1.1.16)
    - Functional components or live components?
- Life-cycle
  - Mount and update
  - Events
  - Update many
  - Summary
- Managing state
  - LiveView as the source of truth
  - LiveComponent as the source of truth

LiveComponents are a mechanism to compartmentalize state, markup, and events for sharing across LiveViews.

LiveComponents are defined by using Phoenix.LiveComponent and are used by calling Phoenix.Component.live_component/1 in a parent LiveView. They run inside the LiveView process but have their own state and life-cycle. For this reason, they are also often called "stateful components". This is a contrast to Phoenix.Component, also known as "function components", which are stateless and do not have a life-cycle.

The simplest LiveComponent only needs to define a render/1 function:

A LiveComponent is rendered with:

You must always pass the module and id attributes. The id will be available as an assign and it must be used to uniquely identify the component. All other attributes will be available as assigns inside the LiveComponent.

Generally speaking, prefer function components over live components as they are a simpler abstraction with a smaller surface area. The use case for live components only arises when there is a need to encapsulate both event handling and additional state.

Avoid using LiveComponents merely for code organization purposes.

Live components are identified by the component module and their ID. We often tie the component ID to some application based ID:

When live_component/1 is called, mount/1 is called once, when the component is first added to the page. mount/1 receives a socket as its argument. Note that this is not the same socket struct from the parent LiveView. It doesn't contain the parent LiveView's assigns, and updating it won't affect the parent LiveView's socket.

Then update/2 is invoked with all of the assigns passed to live_component/1. The assigns received as the first argument to update/2 will only include those assigns given to live_component/1, and not any pre-existing assigns in socket.assigns such as those assigned by mount/1.

If update/2 is not defined then all assigns given to live_component/1 will simply be merged into socket.assigns.

Both mount/1 and update/2 must return a tuple whose first element is :ok and whose second element is the updated socket.

After the component is updated, render/1 is called with all assigns. On first render, we get:

On further rendering:

Two live components with the same module and ID are treated as the same component, regardless of where they are in the page. Therefore, if you change the location of where a component is rendered within its parent LiveView, it won't be remo

*[Content truncated]*

**Examples:**

Example 1 (python):
```python
defmodule HeroComponent do
  # In Phoenix apps, the line is typically: use MyAppWeb, :live_component
  use Phoenix.LiveComponent

  def render(assigns) do
    ~H"""
    <div class="hero">{@content}</div>
    """
  end
end
```

Example 2 (unknown):
```unknown
<.live_component module={HeroComponent} id="hero" content={@content} />
```

Example 3 (unknown):
```unknown
<.live_component module={UserComponent} id={@user.id} user={@user} />
```

Example 4 (unknown):
```unknown
mount(socket) -> update(assigns, socket) -> render(assigns)
```

---

## Form bindings

**URL:** https://hexdocs.pm/phoenix_live_view/form-bindings.html

**Contents:**
- Form bindings
- Form events
  - The CoreComponents module
    - Note
- Error feedback
- Number inputs
- Password inputs
- Nested inputs
- File inputs
- Submitting the form action over HTTP

To handle form changes and submissions, use the phx-change and phx-submit events. In general, it is preferred to handle input changes at the form level, where all form fields are passed to the LiveView's callback given any single input change. For example, to handle real-time form validation and saving, your form would use both phx-change and phx-submit bindings. Let's get started with an example:

.form is the function component defined in Phoenix.Component.form/1, we recommend reading its documentation for more details on how it works and all supported options. .form expects a @form assign, which can be created from a changeset or user parameters via Phoenix.Component.to_form/1.

input/1 is a function component for rendering inputs, most often defined in your own application, often encapsulating labelling, error handling, and more. Here is a simple version to get started with:

If your application was generated with Phoenix v1.7, then mix phx.new automatically imports many ready-to-use function components, such as .input component with built-in features and styles.

With the form rendered, your LiveView picks up the events in handle_event callbacks, to validate and attempt to save the parameter accordingly:

The validate callback simply updates the changeset based on all form input values, then convert the changeset to a form and assign it to the socket. If the form changes, such as generating new errors, render/1 is invoked and the form is re-rendered.

Likewise for phx-submit bindings, the same callback is invoked and persistence is attempted. On success, a :noreply tuple is returned and the socket is annotated for redirect with Phoenix.LiveView.redirect/2 to the new user page, otherwise the socket assigns are updated with the errored changeset to be re-rendered for the client.

You may wish for an individual input to use its own change event or to target a different component. This can be accomplished by annotating the input itself with phx-change, for example:

Then your LiveView or LiveComponent would handle the event:

For proper error feedback on form updates, LiveView sends special parameters on form events starting with _unused_ to indicate that the input for the specific field has not been interacted with yet.

When creating a form from these parameters through Phoenix.Component.to_form/2 or Phoenix.Component.form/1, Phoenix.Component.used_input?/1 can be used to filter error messages.

For example, your MyAppWeb.CoreComponents may use this fun

*[Content truncated]*

**Examples:**

Example 1 (unknown):
```unknown
<.form for={@form} id="my-form" phx-change="validate" phx-submit="save">
  <.input type="text" field={@form[:username]} />
  <.input type="email" field={@form[:email]} />
  <button>Save</button>
</.form>
```

Example 2 (python):
```python
attr :field, Phoenix.HTML.FormField
attr :rest, :global, include: ~w(type)
def input(assigns) do
  ~H"""
  <input id={@field.id} name={@field.name} value={@field.value} {@rest} />
  """
end
```

Example 3 (javascript):
```javascript
def render(assigns) ...

def mount(_params, _session, socket) do
  {:ok, assign(socket, form: to_form(Accounts.change_user(%User{})))}
end

def handle_event("validate", %{"user" => params}, socket) do
  form =
    %User{}
    |> Accounts.change_user(params)
    |> to_form(action: :validate)

  {:noreply, assign(socket, form: form)}
end

def handle_event("save", %{"user" => user_params}, socket) do
  case Accounts.create_user(user_params) do
    {:ok, user} ->
      {:noreply,
       socket
       |> put_flash(:info, "user created")
       |> redirect(to: ~p"/users/#{user}")}

    {:error, %Ect
...
```

Example 4 (unknown):
```unknown
<.form for={@form} id="my-form" phx-change="validate" phx-submit="save">
  ...
  <.input field={@form[:email]} phx-change="email_changed" phx-target={@myself} />
</.form>
```

---

## Phoenix.LiveView.Component (Phoenix LiveView v1.1.16)

**URL:** https://hexdocs.pm/phoenix_live_view/Phoenix.LiveView.Component.html

**Contents:**
- Phoenix.LiveView.Component (Phoenix LiveView v1.1.16)
- Summary
- Types
- Types
- t()

The struct returned by components in .heex templates.

This component is never meant to be output directly into the template. It should always be handled by the diffing algorithm.

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.3) for the Elixir programming language

---
