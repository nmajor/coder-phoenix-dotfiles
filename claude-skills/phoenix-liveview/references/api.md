# Phoenix-Liveview - Api

**Pages:** 9

---

## Phoenix.LiveView.AsyncResult (Phoenix LiveView v1.1.16)

**URL:** https://hexdocs.pm/phoenix_live_view/Phoenix.LiveView.AsyncResult.html

**Contents:**
- Phoenix.LiveView.AsyncResult (Phoenix LiveView v1.1.16)
- Fields
- Summary
- Functions
- Functions
- failed(result, reason)
- Examples
- loading()
- Examples
- loading(result)

Provides a data structure for tracking the state of an async assign.

See the Async Operations section of the Phoenix.LiveView docs for more information.

Updates the failed state.

Creates an async result in loading state.

Updates the loading state.

Updates the loading state of an existing async_result.

Creates a successful result.

Updates the successful result.

Updates the failed state.

When failed, the loading state will be reset to nil. If the result was previously ok?, both result and failed will be set.

Creates an async result in loading state.

Updates the loading state.

When loading, the failed state will be reset to nil.

Updates the loading state of an existing async_result.

When loading, the failed state will be reset to nil. If the result was previously ok?, both result and loading will be set.

Creates a successful result.

The :ok? field will also be set to true to indicate this result has completed successfully at least once, regardless of future state changes.

Updates the successful result.

The :ok? field will also be set to true to indicate this result has completed successfully at least once, regardless of future state changes.

When ok'd, the loading and failed state will be reset to nil.

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.3) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
iex> result = AsyncResult.loading()
iex> result = AsyncResult.failed(result, {:exit, :boom})
iex> result.failed
{:exit, :boom}
iex> result.loading
nil
```

Example 2 (unknown):
```unknown
iex> result = AsyncResult.loading()
iex> result.loading
true
iex> result.ok?
false
```

Example 3 (unknown):
```unknown
iex> result = AsyncResult.loading(%{my: :loading_state})
iex> result.loading
%{my: :loading_state}
iex> result = AsyncResult.loading(result)
iex> result.loading
true
```

Example 4 (unknown):
```unknown
iex> result = AsyncResult.loading()
iex> result = AsyncResult.loading(result, %{my: :other_state})
iex> result.loading
%{my: :other_state}
```

---

## Phoenix.LiveView.Socket (Phoenix LiveView v1.1.16)

**URL:** https://hexdocs.pm/phoenix_live_view/Phoenix.LiveView.Socket.html

**Contents:**
- Phoenix.LiveView.Socket (Phoenix LiveView v1.1.16)
- Summary
- Types
- Types
- assigns()
- assigns_not_in_socket()
- t()

The LiveView socket for Phoenix Endpoints.

This is typically mounted directly in your endpoint.

To share an underlying transport connection between regular Phoenix channels and LiveView processes, use Phoenix.LiveView.Socket from your own MyAppWeb.UserSocket module.

Next, declare your channel definitions and optional connect/3, and id/1 callbacks to handle your channel specific needs, then mount your own socket in your endpoint:

If you require session options to be set at runtime, you can use an MFA tuple. The function it designates must return a keyword list.

The data in a LiveView as stored in the socket.

Struct returned when assigns is not in the socket.

The data in a LiveView as stored in the socket.

Struct returned when assigns is not in the socket.

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.3) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
socket "/live", Phoenix.LiveView.Socket,
  websocket: [connect_info: [session: @session_options]]
```

Example 2 (unknown):
```unknown
socket "/live", MyAppWeb.UserSocket,
  websocket: [connect_info: [session: @session_options]]
```

Example 3 (python):
```python
socket "/live", MyAppWeb.UserSocket,
  websocket: [connect_info: [session: {__MODULE__, :runtime_opts, []}]]

# ...

def runtime_opts() do
  Keyword.put(@session_options, :domain, host())
end
```

---

## Phoenix.LiveView.Comprehension (Phoenix LiveView v1.1.16)

**URL:** https://hexdocs.pm/phoenix_live_view/Phoenix.LiveView.Comprehension.html

**Contents:**
- Phoenix.LiveView.Comprehension (Phoenix LiveView v1.1.16)
- Summary
- Types
- Types
- key()
- keyed_render_fun()
- t()

The struct returned by for-comprehensions in .heex templates.

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.3) for the Elixir programming language

---

## Phoenix.LiveView.Rendered (Phoenix LiveView v1.1.16)

**URL:** https://hexdocs.pm/phoenix_live_view/Phoenix.LiveView.Rendered.html

**Contents:**
- Phoenix.LiveView.Rendered (Phoenix LiveView v1.1.16)
- Summary
- Types
- Types
- dyn()
- t()

The struct returned by .heex templates.

See a description about its fields and use cases in Phoenix.LiveView.Engine docs.

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.3) for the Elixir programming language

---

## Phoenix.LiveView.Engine (Phoenix LiveView v1.1.16)

**URL:** https://hexdocs.pm/phoenix_live_view/Phoenix.LiveView.Engine.html

**Contents:**
- Phoenix.LiveView.Engine (Phoenix LiveView v1.1.16)
- Phoenix.LiveView.Rendered
- Tracking changes
- Nesting and fingerprinting
- Comprehensions
- Components

An EEx template engine that tracks changes.

This is often used by Phoenix.LiveView.TagEngine which also adds HTML validation. In the documentation below, we will explain how it works internally. For user-facing documentation, see Phoenix.LiveView.

Whenever you render a live template, it returns a Phoenix.LiveView.Rendered structure. This structure has three fields: :static, :dynamic and :fingerprint.

The :static field is a list of literal strings. This allows the Elixir compiler to optimize this list and avoid allocating its strings on every render.

The :dynamic field contains a function that takes a boolean argument (see "Tracking changes" below), and returns a list of dynamic content. Each element in the list is either one of:

When you render a live template, you can convert the rendered structure to iodata by alternating the static and dynamic fields, always starting with a static entry followed by a dynamic entry. The last entry will always be static too. So the following structure:

Results in the following content to be sent over the wire as iodata:

This is also what calling Phoenix.HTML.Safe.to_iodata/1 with a Phoenix.LiveView.Rendered structure returns.

Of course, the benefit of live templates is exactly that you do not need to send both static and dynamic segments every time. So let's talk about tracking changes.

By default, a live template does not track changes. Change tracking can be enabled by including a changed map in the assigns with the key __changed__ and passing true to the dynamic parts. The map should contain the name of any changed field as key and the boolean true as value. If a field is not listed in __changed__, then it is always considered unchanged.

If a field is unchanged and live believes a dynamic expression no longer needs to be computed, its value in the dynamic list will be nil. This information can be leveraged to avoid sending data to the client.

Phoenix.LiveView also tracks changes across live templates. Therefore, if your view has this:

Phoenix will be able to track what is static and dynamic across templates, as well as what changed. A rendered nested live template will appear in the dynamic list as another Phoenix.LiveView.Rendered structure, which must be handled recursively.

However, because the rendering of live templates can be dynamic in itself, it is important to distinguish which live template was rendered. For example, imagine this code:

To solve this, all Phoenix.LiveView.Rendered structs also co

*[Content truncated]*

**Examples:**

Example 1 (unknown):
```unknown
%Phoenix.LiveView.Rendered{
  static: ["foo", "bar", "baz"],
  dynamic: fn track_changes? -> ["left", "right"] end
}
```

Example 2 (unknown):
```unknown
["foo", "left", "bar", "right", "baz"]
```

Example 3 (unknown):
```unknown
{render("form.html", assigns)}
```

Example 4 (unknown):
```unknown
<%= if something?, do: render("one.html", assigns), else: render("other.html", assigns) %>
```

---

## Phoenix.LiveView.ColocatedHook (Phoenix LiveView v1.1.16)

**URL:** https://hexdocs.pm/phoenix_live_view/Phoenix.LiveView.ColocatedHook.html

**Contents:**
- Phoenix.LiveView.ColocatedHook (Phoenix LiveView v1.1.16)
- Introduction
    - Compilation order
- Options
- Runtime hooks

A special HEEx :type that extracts hooks from a co-located <script> tag at compile time.

Note: To use ColocatedHook, you need to run Phoenix 1.8+.

Colocated hooks are defined as with :type={Phoenix.LiveView.ColocatedHook}:

You can read more about the internals of colocated hooks in the documentation for colocated JS. A brief summary: at compile time, the hook's code is extracted into a special folder, typically in your _build directory. Each hook is also imported into a special manifest file. The manifest file provides a named export which allows it to be imported by any JavaScript bundler that supports ES modules:

Colocated hooks are only written when the corresponding component is compiled. Therefore, whenever you need to access a colocated hook, you need to ensure mix compile runs first. This automatically happens in development.

If you have a custom mix alias, instead of

to ensure that all colocated hooks are extracted before esbuild or any other bundler runs.

Colocated hooks are configured through the attributes of the <script> tag. The supported attributes are:

name - The name of the hook. This is required and must start with a dot, for example: name=".myhook". The same name must be used when referring to this hook in the phx-hook attribute of another HTML element.

runtime - If present, the hook is not extracted, but instead registered at runtime. You should only use this option if you know that you need it. It comes with some limitations:

Runtime hooks are a special kind of colocated hook that are not removed from the DOM when rendering the component. Instead, the hook's code is executed directly in the browser with no bundler involved.

One example where this can be useful is when you are creating a custom page for a library like Phoenix.LiveDashboard. The live dashboard already bundles its hooks, therefore there is no way to add new hooks to the bundle when the live dashboard is used inside your application.

Because of this, runtime hooks must also use a slightly different syntax. While in normal colocated hooks you'd write an export default statement, runtime hooks must evaluate to the hook itself:

This is because the hook's code is wrapped by LiveView into something like this:

Still, even for runtime hooks, the hook's name needs to start with a dot and is automatically prefixed with the module name to avoid conflicts with other hooks.

When using runtime hooks, it is important to think about any limitations that content security pol

*[Content truncated]*

**Examples:**

Example 1 (javascript):
```javascript
defmodule MyAppWeb.DemoLive do
  use MyAppWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <input type="text" name="user[phone_number]" id="user-phone-number" phx-hook=".PhoneNumber" />
    <script :type={Phoenix.LiveView.ColocatedHook} name=".PhoneNumber">
      export default {
        mounted() {
          this.el.addEventListener("input", e => {
            let match = this.el.value.replace(/\D/g, "").match(/^(\d{3})(\d{3})(\d{4})$/)
            if(match) {
              this.el.value = `${match[1]}-${match[2]}-${mat
...
```

Example 2 (python):
```python
import {hooks} from "phoenix-colocated/my_app"

console.log(hooks);
/*
{
  "MyAppWeb.DemoLive.PhoneNumber": {...},
  ...
}
*/
```

Example 3 (unknown):
```unknown
release: ["assets.deploy", "release"]
```

Example 4 (unknown):
```unknown
release: ["compile", "assets.deploy", "release"]
```

---

## Phoenix.LiveView.HTMLEngine (Phoenix LiveView v1.1.16)

**URL:** https://hexdocs.pm/phoenix_live_view/Phoenix.LiveView.HTMLEngine.html

**Contents:**
- Phoenix.LiveView.HTMLEngine (Phoenix LiveView v1.1.16)

The HTMLEngine that powers .heex templates and the ~H sigil.

It works by adding a HTML parsing and validation layer on top of Phoenix.LiveView.TagEngine.

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.3) for the Elixir programming language

---

## Phoenix.LiveView behaviour (Phoenix LiveView v1.1.16)

**URL:** https://hexdocs.pm/phoenix_live_view/Phoenix.LiveView.html

**Contents:**
- Phoenix.LiveView behaviour (Phoenix LiveView v1.1.16)
- Life-cycle
- Template collocation
- Async Operations
  - Async assigns
  - Warning
  - Arbitrary async operations
- Endpoint configuration
- Summary
- Types

A LiveView is a process that receives events, updates its state, and renders updates to a page as diffs.

To get started, see the Welcome guide. This module provides advanced documentation and features about using LiveView.

A LiveView begins as a regular HTTP request and HTML response, and then upgrades to a stateful view on client connect, guaranteeing a regular HTML page even if JavaScript is disabled. Any time a stateful view changes or updates its socket assigns, it is automatically re-rendered and the updates are pushed to the client.

Socket assigns are stateful values kept on the server side in Phoenix.LiveView.Socket. This is different from the common stateless HTTP pattern of sending the connection state to the client in the form of a token or cookie and rebuilding the state on the server to service every request.

You begin by rendering a LiveView typically from your router. When LiveView is first rendered, the mount/3 callback is invoked with the current params, the current session and the LiveView socket. As in a regular request, params contains public data that can be modified by the user. The session always contains private data set by the application itself. The mount/3 callback wires up socket assigns necessary for rendering the view. After mounting, handle_params/3 is invoked so uri and query params are handled. Finally, render/1 is invoked and the HTML is sent as a regular HTML response to the client.

After rendering the static page, LiveView connects from the client to the server where stateful views are spawned to push rendered updates to the browser, and receive client events via phx- bindings. Just like the first rendering, mount/3, is invoked with params, session, and socket state. However in the connected client case, a LiveView process is spawned on the server, runs handle_params/3 again and then pushes the result of render/1 to the client and continues on for the duration of the connection. If at any point during the stateful life-cycle a crash is encountered, or the client connection drops, the client gracefully reconnects to the server, calling mount/3 and handle_params/3 again.

LiveView also allows attaching hooks to specific life-cycle stages with attach_hook/4.

There are two possible ways of rendering content in a LiveView. The first one is by explicitly defining a render function, which receives assigns and returns a HEEx template defined with the ~H sigil.

For larger templates, you can place them in a file in the same 

*[Content truncated]*

**Examples:**

Example 1 (python):
```python
defmodule MyAppWeb.DemoLive do
  # In a typical Phoenix app, the following line would usually be `use MyAppWeb, :live_view`
  use Phoenix.LiveView

  def render(assigns) do
    ~H"""
    Hello world!
    """
  end
end
```

Example 2 (javascript):
```javascript
def mount(%{"slug" => slug}, _, socket) do
  {:ok,
   socket
   |> assign(:foo, "bar")
   |> assign_async(:org, fn -> {:ok, %{org: fetch_org!(slug)}} end)
   |> assign_async([:profile, :rank], fn -> {:ok, %{profile: ..., rank: ...}} end)}
end
```

Example 3 (unknown):
```unknown
assign_async(:org, fn -> {:ok, %{org: fetch_org(socket.assigns.slug)}} end)
```

Example 4 (unknown):
```unknown
slug = socket.assigns.slug
assign_async(:org, fn -> {:ok, %{org: fetch_org(slug)}} end)
```

---

## Phoenix.LiveView.Router (Phoenix LiveView v1.1.16)

**URL:** https://hexdocs.pm/phoenix_live_view/Phoenix.LiveView.Router.html

**Contents:**
- Phoenix.LiveView.Router (Phoenix LiveView v1.1.16)
- Summary
- Functions
- Functions
- fetch_live_flash(conn, opts \\ [])
- Examples
- live(path, live_view, action \\ nil, opts \\ [])
    - HTTP requests
- Actions and live navigation
- Options

Provides LiveView routing for Phoenix routers.

Fetches the LiveView and merges with the controller flash.

Defines a LiveView route.

Defines a live session for live redirects within a group of live routes.

Fetches the LiveView and merges with the controller flash.

Replaces the default :fetch_flash plug used by Phoenix.Router.

Defines a LiveView route.

A LiveView can be routed to by using the live macro with a path and the name of the LiveView:

To navigate to this route within your app, you can use Phoenix.VerifiedRoutes:

The HTTP request method that a route defined by the live/4 macro responds to is GET.

It is common for a LiveView to have multiple states and multiple URLs. For example, you can have a single LiveView that lists all articles on your web app. For each article there is an "Edit" button which, when pressed, opens up a modal on the same page to edit the article. It is a best practice to use live navigation in those cases, so when you click edit, the URL changes to "/articles/1/edit", even though you are still within the same LiveView. Similarly, you may also want to show a "New" button, which opens up the modal to create new entries, and you want this to be reflected in the URL as "/articles/new".

In order to make it easier to recognize the current "action" your LiveView is on, you can pass the action option when defining LiveViews too:

The current action will always be available inside the LiveView as the @live_action assign, that can be used to render a LiveComponent:

Or can be used to show or hide parts of the template:

Note that @live_action will be nil if no action is given on the route definition.

:container - an optional tuple for the HTML tag and DOM attributes to be used for the LiveView container. For example: {:li, style: "color: blue;"}. See Phoenix.Component.live_render/3 for more information and examples.

:as - optionally configures the named helper. Defaults to :live when using a LiveView without actions or defaults to the LiveView name when using actions.

:metadata - a map to optional feed metadata used on telemetry events and route info, for example: %{route_name: :foo, access: :user}. This data can be retrieved by calling Phoenix.Router.route_info/4 with the uri from the handle_params callback. This can be used to customize a LiveView which may be invoked from different routes.

:private - an optional map of private data to put in the plug connection, for example: %{route_name: :foo, access: :user}. The data wi

*[Content truncated]*

**Examples:**

Example 1 (unknown):
```unknown
defmodule MyAppWeb.Router do
  use LiveGenWeb, :router
  import Phoenix.LiveView.Router

  pipeline :browser do
    ...
    plug :fetch_live_flash
  end
  ...
end
```

Example 2 (unknown):
```unknown
live "/thermostat", ThermostatLive
```

Example 3 (unknown):
```unknown
push_navigate(socket, to: ~p"/thermostat")
push_patch(socket, to: ~p"/thermostat?page=#{page}")
```

Example 4 (unknown):
```unknown
live "/articles", ArticleLive.Index, :index
live "/articles/new", ArticleLive.Index, :new
live "/articles/:id/edit", ArticleLive.Index, :edit
```

---
