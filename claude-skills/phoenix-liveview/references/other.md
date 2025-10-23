# Phoenix-Liveview - Other

**Pages:** 10

---

## Bindings

**URL:** https://hexdocs.pm/phoenix_live_view/bindings.html

**Contents:**
- Bindings
- Click Events
- Focus and Blur Events
- Key Events
- Rate limiting events with Debounce and Throttle
  - Debounce and Throttle special behavior
- JS commands
- DOM patching
- Lifecycle events
- LiveView events prefix

Phoenix supports DOM element bindings for client-server interaction. For example, to react to a click on a button, you would render the element:

Then on the server, all LiveView bindings are handled with the handle_event callback, for example:

If you need to trigger commands actions via JavaScript, see JavaScript interoperability.

The phx-click binding is used to send click events to the server. When any client event, such as a phx-click click is pushed, the value sent to the server will be chosen with the following priority:

The :value specified in Phoenix.LiveView.JS.push/3, such as:

Any number of optional phx-value- prefixed attributes, such as:

will send the following map of params to the server:

If the phx-value- prefix is used, the server payload will also contain a "value" if the element's value attribute exists.

The payload will also include any additional user defined metadata of the client event. For example, the following LiveSocket client option would send the coordinates and altKey information for all clicks:

The phx-click-away event is fired when a click event happens outside of the element. This is useful for hiding toggled containers like drop-downs.

Focus and blur events may be bound to DOM elements that emit such events, using the phx-blur, and phx-focus bindings, for example:

To detect when the page itself has received focus or blur, phx-window-focus and phx-window-blur may be specified. These window level events may also be necessary if the element in consideration (most often a div with no tabindex) cannot receive focus. Like other bindings, phx-value-* can be provided on the bound element, and those values will be sent as part of the payload. For example:

The onkeydown, and onkeyup events are supported via the phx-keydown, and phx-keyup bindings. Each binding supports a phx-key attribute, which triggers the event for the specific key press. If no phx-key is provided, the event is triggered for any key press. When pushed, the value sent to the server will contain the "key" that was pressed, plus any user-defined metadata. For example, pressing the Escape key looks like this:

To capture additional user-defined metadata, the metadata option for keydown events may be provided to the LiveSocket constructor. For example:

To determine which key has been pressed you should use key value. The available options can be found on MDN or via the Key Event Viewer.

Note: phx-keyup and phx-keydown are not supported on inputs. Instead us

*[Content truncated]*

**Examples:**

Example 1 (unknown):
```unknown
<button phx-click="inc_temperature">+</button>
```

Example 2 (python):
```python
def handle_event("inc_temperature", _value, socket) do
  {:ok, new_temp} = Thermostat.inc_temperature(socket.assigns.id)
  {:noreply, assign(socket, :temperature, new_temp)}
end
```

Example 3 (unknown):
```unknown
<div phx-click={JS.push("inc", value: %{myvar1: @val1})}>
```

Example 4 (unknown):
```unknown
<div phx-click="inc" phx-value-myvar1="val1" phx-value-myvar2="val2">
```

---

## Error and exception handling

**URL:** https://hexdocs.pm/phoenix_live_view/error-handling.html

**Contents:**
- Error and exception handling
- Expected scenarios
- Unexpected scenarios
  - Exceptions during HTTP mount
  - Exceptions during connected mount
  - Exceptions after connected mount

As with any other Elixir code, exceptions may happen during the LiveView life-cycle. This page describes how LiveView handles errors at different stages.

In this section, we will talk about error cases that you expect to happen within your application. For example, a user filling in a form with invalid data is expected. In a LiveView, we typically handle those cases by storing the form state in LiveView assigns and rendering any relevant error message back to the client.

We may also use flash messages for this. For example, imagine you have a page to manage all "Team members" in an organization. However, if there is only one member left in the organization, they should not be allowed to leave. You may want to handle this by using flash messages:

However, one may argue that, if the last member of an organization cannot leave it, it may be better to not even show the "Leave" button in the UI when the organization has only one member.

Given the button does not appear in the UI, triggering the "leave" action when the organization has only one member is an unexpected scenario. This means we can rewrite the code above to:

If leave does not return true, Elixir will raise a MatchError exception. Or you could provide a leave! function that raises a specific exception:

However, what will happen with a LiveView in case of exceptions? Let's talk about unexpected scenarios.

Elixir developers tend to write assertive code. This means that, if we expect leave to always return true, we can explicitly match on its result, as we did above:

If leave fails and returns false, an exception is raised. It is common for Elixir developers to use exceptions for unexpected scenarios in their Phoenix applications.

For example, if you are building an application where a user may belong to one or more organizations, when accessing the organization page, you may want to check that the user has access to it like this:

The code above builds a query that returns all organizations that belongs to the current user and then validates that the given org_id belongs to the user. If there is no such org_id or if the user has no access to it, Repo.get! will raise an Ecto.NoResultsError exception.

During a regular controller request, this exception will be converted to a 404 exception and rendered as a custom error page, as detailed here. LiveView will react to exceptions in three different ways, depending on where it is in its life-cycle.

When you first access a LiveView, a regular HTTP 

*[Content truncated]*

**Examples:**

Example 1 (unknown):
```unknown
if MyApp.Org.leave(socket.assigns.current_org, member) do
  {:noreply, socket}
else
  {:noreply, put_flash(socket, :error, "last member cannot leave organization")}
end
```

Example 2 (unknown):
```unknown
true = MyApp.Org.leave(socket.assigns.current_org, member)
{:noreply, socket}
```

Example 3 (unknown):
```unknown
MyApp.Org.leave!(socket.assigns.current_org, member)
{:noreply, socket}
```

Example 4 (unknown):
```unknown
true = MyApp.Org.leave(socket.assigns.current_org, member)
{:noreply, socket}
```

---

## phx- HTML attributes

**URL:** https://hexdocs.pm/phoenix_live_view/html-attrs.html

**Contents:**
- phx- HTML attributes
- Event Handlers
  - Click
  - Focus
  - Keyboard
  - Scroll
  - Example
    - lib/hello_web/live/hello_live.html.heex
- Form Event Handlers
  - On <form> elements

A summary of special HTML attributes used in Phoenix LiveView templates. Each attribute is linked to its documentation for more details.

Attribute values can be:

Use phx-value-* attributes to pass params to the server.

Use phx-debounce and phx-throttle to control the frequency of events.

Use the phx-key attribute to listen to specific keys.

Client hooks provide bidirectional communication between client and server using this.pushEvent and this.handleEvent to send and receive events.

Hex Package Hex Preview (current file) Search HexDocs Download ePub version

Built using ExDoc (v0.38.3) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
<button type="button" phx-click="click" phx-value-user={@current_user.id}>Click Me</button>
<button type="button" phx-click={JS.toggle(to: "#example")}>Toggle</button>
```

Example 2 (unknown):
```unknown
<form id="my-form" phx-change="validate" phx-submit="save">
  <input type="text" name="name" phx-debounce="500" phx-throttle="500" />
  <button type="submit" phx-disable-with="Saving...">Save</button>
</form>
```

Example 3 (unknown):
```unknown
<div id="status" class="hidden" phx-disconnected={JS.show()} phx-connected={JS.hide()}>
  Attempting to reconnect...
</div>
```

Example 4 (unknown):
```unknown
<div
  id="iframe-container"
  phx-mounted={JS.transition("animate-bounce", time: 2000)}
  phx-remove={JS.hide(transition: {"transition-all transform ease-in duration-200", "opacity-100", "opacity-0"})}
>
  <button type="button" phx-click={JS.exec("phx-remove", to: "#iframe-container")}>Hide</button>
  <iframe id="iframe" src="https://example.com" phx-update="ignore"></iframe>
</div>
```

---

## Security considerations

**URL:** https://hexdocs.pm/phoenix_live_view/security-model.html

**Contents:**
- Security considerations
- Authentication vs authorization
- live_session
- Mounting considerations
- Events considerations
- Disconnecting all instances of a live user
- Summing up

LiveView begins its life-cycle as a regular HTTP request. Then a stateful connection is established. Both the HTTP request and the stateful connection receive the client data via parameters and session.

This means that any session validation must happen both in the HTTP request (plug pipeline) and the stateful connection (LiveView mount).

When speaking about security, there are two terms commonly used: authentication and authorization. Authentication is about identifying a user. Authorization is about telling if a user has access to a certain resource or feature in the system.

In a regular web application, once a user is authenticated, for example by entering their email and password, or by using a third-party service such as Google, Twitter, or Facebook, a token identifying the user is stored in the session, which is a cookie (a key-value pair) stored in the user's browser.

Every time there is a request, we read the value from the session, and, if valid, we fetch the user stored in the session from the database. The session is automatically validated by Phoenix and tools like mix phx.gen.auth can generate the building blocks of an authentication system for you.

Once the user is authenticated, they may perform many actions on the page, and some of those actions require specific permissions. This is called authorization and the specific rules often change per application.

In a regular web application, we perform authentication and authorization checks on every request. Given LiveViews start as a regular HTTP request, they share the authentication logic with regular requests through plugs. The request starts in your endpoint, which then invokes the router. Plugs are used to ensure the user is authenticated and stores the relevant information in the session.

Once the user is authenticated, we typically validate the sessions on the mount callback. Authorization rules generally happen on mount (for instance, is the user allowed to see this page?) and also on handle_event (is the user allowed to delete this item?).

The primary mechanism for grouping LiveViews is via the Phoenix.LiveView.Router.live_session/2. LiveView will then ensure that navigation events within the same live_session skip the regular HTTP requests without going through the plug pipeline. Events across live sessions will go through the router.

For example, imagine you need to authenticate two distinct types of users. Your regular users login via email and password, and you have an admi

*[Content truncated]*

**Examples:**

Example 1 (unknown):
```unknown
scope "/" do
  pipe_through [:authenticate_user]
  get ...

  live_session :default do
    live ...
  end
end

scope "/admin" do
  pipe_through [:http_auth_admin]
  get ...

  live_session :admin do
    live ...
  end
end
```

Example 2 (unknown):
```unknown
scope "/" do
  pipe_through [:authenticate_user]

  live_session :default, on_mount: MyAppWeb.UserLiveAuth do
    live ...
  end
end

scope "/admin" do
  pipe_through [:authenticate_admin]

  live_session :admin, on_mount: MyAppWeb.AdminLiveAuth do
    live ...
  end
end
```

Example 3 (unknown):
```unknown
plug :ensure_user_authenticated
plug :ensure_user_confirmed
```

Example 4 (javascript):
```javascript
def mount(_params, %{"user_id" => user_id} = _session, socket) do
  socket = assign(socket, current_user: Accounts.get_user!(user_id))

  socket =
    if socket.assigns.current_user.confirmed_at do
      socket
    else
      redirect(socket, to: "/login")
    end

  {:ok, socket}
end
```

---

## Deployments and recovery

**URL:** https://hexdocs.pm/phoenix_live_view/deployments.html

**Contents:**
- Deployments and recovery

One of the questions that arise from LiveView stateful model is what considerations are necessary when deploying a new version of LiveView (or when recovering from an error).

First off, whenever LiveView disconnects, it will automatically attempt to reconnect to the server using exponential back-off. This means it will try immediately, then wait 2s and try again, then 5s and so on. If you are deploying, this typically means the next reconnection will immediately succeed and your load balancer will automatically redirect to the new servers.

However, your LiveView may still have state that will be lost in this transition. How to deal with it? The good news is that there are a series of practices you can follow that will not only help with deployments but it will improve your application in general.

Keep state in the query parameters when appropriate. For example, if your application has tabs and the user clicked a tab, instead of using phx-click and Phoenix.LiveView.handle_event/3 to manage it, you should implement it using <.link patch={...}> passing the tab name as parameter. You will then receive the new tab name Phoenix.LiveView.handle_params/3 which will set the relevant assign to choose which tab to display. You can even define specific URLs for each tab in your application router. By doing this, you will reduce the amount of server state, make tab navigation shareable via links, improving search engine indexing, and more.

Consider storing other relevant state in the database. For example, if you are building a chat app and you want to store which messages have been read, you can store so in the database. Once the page is loaded, you retrieve the index of the last read message. This makes the application more robust, allow data to be synchronized across devices, etc.

If your application uses forms (which is most likely the case), keep in mind that Phoenix performs automatic form recovery: in case of disconnections, Phoenix will collect the form data and resubmit it on reconnection. This mechanism works out of the box for most forms but you may want to customize it or test it for your most complex forms. See the relevant section in the "Form bindings" document to learn more.

The idea is that: if you follow the practices above, most of your state is already handled within your app and therefore deployments should not bring additional concerns. Not only that, it will bring overall benefits to your app such as indexing, link sharing, device sharing, 

*[Content truncated]*

---

## Telemetry

**URL:** https://hexdocs.pm/phoenix_live_view/telemetry.html

**Contents:**
- Telemetry

LiveView currently exposes the following telemetry events:

[:phoenix, :live_view, :mount, :start] - Dispatched by a Phoenix.LiveView immediately before mount/3 is invoked.

[:phoenix, :live_view, :mount, :stop] - Dispatched by a Phoenix.LiveView when the mount/3 callback completes successfully.

[:phoenix, :live_view, :mount, :exception] - Dispatched by a Phoenix.LiveView when an exception is raised in the mount/3 callback.

Measurement: %{duration: native_time}

[:phoenix, :live_view, :handle_params, :start] - Dispatched by a Phoenix.LiveView immediately before handle_params/3 is invoked.

[:phoenix, :live_view, :handle_params, :stop] - Dispatched by a Phoenix.LiveView when the handle_params/3 callback completes successfully.

[:phoenix, :live_view, :handle_params, :exception] - Dispatched by a Phoenix.LiveView when an exception is raised in the handle_params/3 callback.

[:phoenix, :live_view, :handle_event, :start] - Dispatched by a Phoenix.LiveView immediately before handle_event/3 is invoked.

[:phoenix, :live_view, :handle_event, :stop] - Dispatched by a Phoenix.LiveView when the handle_event/3 callback completes successfully.

[:phoenix, :live_view, :handle_event, :exception] - Dispatched by a Phoenix.LiveView when an exception is raised in the handle_event/3 callback.

[:phoenix, :live_view, :render, :start] - Dispatched by a Phoenix.LiveView immediately before render/1 is invoked.

[:phoenix, :live_view, :render, :stop] - Dispatched by a Phoenix.LiveView when the render/1 callback completes successfully.

[:phoenix, :live_view, :render, :exception] - Dispatched by a Phoenix.LiveView when an exception is raised in the render/1 callback.

[:phoenix, :live_component, :update, :start] - Dispatched by a Phoenix.LiveComponent immediately before update/2 or a update_many/1 is invoked.

In the case ofupdate/2 it might dispatch one event for multiple calls.

[:phoenix, :live_component, :update, :stop] - Dispatched by a Phoenix.LiveComponent when the update/2 or a update_many/1 callback completes successfully.

In the case ofupdate/2 it might dispatch one event for multiple calls. The sockets metadata contain the updated sockets.

[:phoenix, :live_component, :update, :exception] - Dispatched by a Phoenix.LiveComponent when an exception is raised in the update/2 or a update_many/1 callback.

In the case ofupdate/2 it might dispatch one event for multiple calls.

[:phoenix, :live_component, :handle_event, :start] - Dispatched by a Phoenix.LiveComponent immed

*[Content truncated]*

**Examples:**

Example 1 (unknown):
```unknown
%{system_time: System.monotonic_time}
```

Example 2 (unknown):
```unknown
%{
  socket: Phoenix.LiveView.Socket.t,
  params: unsigned_params | :not_mounted_at_router,
  session: map,
  uri: String.t() | nil
}
```

Example 3 (unknown):
```unknown
%{duration: native_time}
```

Example 4 (unknown):
```unknown
%{
  socket: Phoenix.LiveView.Socket.t,
  params: unsigned_params | :not_mounted_at_router,
  session: map,
  uri: String.t() | nil
}
```

---

## Live layouts

**URL:** https://hexdocs.pm/phoenix_live_view/live-layouts.html

**Contents:**
- Live layouts
- Root layout
- Updating document title

Your LiveView applications can be made of two layouts:

the root layout - this layout typically contains the <html> definition alongside the head and body tags. Any content defined in the root layout will remain the same, even as you live navigate across LiveViews. The root layout is typically declared on the router with put_root_layout and defined as "root.html.heex" in your layouts folder. It calls {@inner_content} to inject the content rendered by the layout

the app layout - this is the dynamic layout part of your application, it often includes the menu, sidebar, flash messages, and more. From Phoenix v1.8, this layout is explicitly rendered in your templates by calling the <Layouts.app /> component. In Phoenix v1.7 and earlier, the layout was typically configured as part of the lib/my_app_web.ex file, such as use Phoenix.LiveView, layout: ...

Overall, those layouts are found in components/layouts and are embedded within MyAppWeb.Layouts.

The "root" layout is rendered only on the initial request and therefore it has access to the @conn assign. The root layout is typically defined in your router:

The root layout can also be set via the :root_layout option in your router via Phoenix.LiveView.Router.live_session/2.

Because the root layout from the Plug pipeline is rendered outside of LiveView, the contents cannot be dynamically changed. The one exception is the <title> of the HTML document. Phoenix LiveView special cases the @page_title assign to allow dynamically updating the title of the page, which is useful when using live navigation, or annotating the browser tab with a notification. For example, to update the user's notification count in the browser's title bar, first set the page_title assign on mount:

Then access @page_title in the root layout:

You can also use the Phoenix.Component.live_title/1 component to support adding automatic prefix and suffix to the page title when rendered and on subsequent updates:

Although the root layout is not updated by LiveView, by simply assigning to page_title, LiveView knows you want the title to be updated:

Note: If you find yourself needing to dynamically patch other parts of the base layout, such as injecting new scripts or styles into the <head> during live navigation, then a regular, non-live, page navigation should be used instead. Assigning the @page_title updates the document.title directly, and therefore cannot be used to update any other part of the base layout.

Hex Package Hex Preview (current

*[Content truncated]*

**Examples:**

Example 1 (unknown):
```unknown
plug :put_root_layout, html: {MyAppWeb.Layouts, :root}
```

Example 2 (python):
```python
def mount(_params, _session, socket) do
  socket = assign(socket, page_title: "Latest Posts")
  {:ok, socket}
end
```

Example 3 (unknown):
```unknown
<title>{@page_title}</title>
```

Example 4 (unknown):
```unknown
<Phoenix.Component.live_title default="Welcome" prefix="MyApp – ">
  {assigns[:page_title]}
</Phoenix.Component.live_title>
```

---

## Syncing changes and optimistic UIs

**URL:** https://hexdocs.pm/phoenix_live_view/syncing-changes.html

**Contents:**
- Syncing changes and optimistic UIs
- The problem in a nutshell
- Optimistic UIs via loading classes
  - Tailwind integration
- Optimistic UIs via JS commands
- Optimistic UIs via JS hooks
- Live navigation
  - Navigation classes
  - Navigation events

When using LiveView, whenever you change the state in your LiveView process, changes are automatically sent and applied in the client.

However, in many occasions, the client may have its own state: inputs, buttons, focused UI elements, and more. In order to avoid server updates from destroying state on the client, LiveView provides several features and out-of-the-box conveniences.

Let's start by discussing which problems may arise from client-server integration, which may apply to any web application, and explore how LiveView solves it automatically. If you want to focus on the more practical aspects, you can jump to later sections or watch the video below:

Imagine your web application has a form. The form has a single email input and a button. We have to validate that the email is unique in our database and render a tiny “✗” or “✓“ accordingly close to the input. Because we are using server-side rendering, we are debouncing/throttling form changes to the server. And, to avoid double-submissions, we want to disable the button as soon as it is clicked.

Here is what could happen. The user has typed “hello@example.” and debounce kicks in, causing the client to send an event to the server. Here is how the client looks like at this moment:

While the server is processing this information, the user finishes typing the email and presses submit. The client sends the submit event to the server, then proceeds to disable the button, and change its value to “SUBMITTING”:

Immediately after pressing submit, the client receives an update from the server, but this is an update from the debounce event! If the client were to simply render this server update, the client would effectively roll back the form to the previous state shown below, which would be a disaster:

This is a simple example of how client and server state can evolve and differ for periods of times, due to the latency (distance) between them, in any web application, not only LiveView.

LiveView solves this in two ways:

The JavaScript client is always the source of truth for current input values

LiveView tracks how many events are currently in flight in a given input/button/form. The changes to the form are applied behind the scenes as they arrive, but LiveView only shows them once all in-flight events have been resolved

In other words, for the most common cases, LiveView will automatically sync client and server state for you. This is a huge benefit of LiveView, as many other stacks would require dev

*[Content truncated]*

**Examples:**

Example 1 (unknown):
```unknown
[ hello@example.    ]

    ------------
       SUBMIT
    ------------
```

Example 2 (unknown):
```unknown
[ hello@example.com ]

    ------------
     SUBMITTING
    ------------
```

Example 3 (unknown):
```unknown
[ hello@example.    ] ✓

    ------------
       SUBMIT
    ------------
```

Example 4 (unknown):
```unknown
<button phx-click="clicked" phx-window-keydown="key">...</button>
```

---

## Assigns and HEEx templates

**URL:** https://hexdocs.pm/phoenix_live_view/assigns-eex.html

**Contents:**
- Assigns and HEEx templates
- Change tracking
- Common pitfalls
  - Variables
  - The assigns variable
  - Comprehensions
  - Summary

All of the data in a LiveView is stored in the socket, which is a server side struct called Phoenix.LiveView.Socket. Your own data is stored under the assigns key of said struct. The server data is never shared with the client beyond what your template renders.

Phoenix template language is called HEEx (HTML+EEx). EEx is Embedded Elixir, an Elixir string template engine. Those templates are either files with the .heex extension or they are created directly in source files via the ~H sigil. You can learn more about the HEEx syntax by checking the docs for the ~H sigil.

The Phoenix.Component.assign/2 and Phoenix.Component.assign/3 functions help store those values. Those values can be accessed in the LiveView as socket.assigns.name but they are accessed inside HEEx templates as @name.

In this section, we are going to cover how LiveView minimizes the payload over the wire by understanding the interplay between assigns and templates.

When you first render a .heex template, it will send all of the static and dynamic parts of the template to the client. Imagine the following template:

It has two static parts, <h1> and </h1> and one dynamic part made of expand_title(@title). Further rendering of this template won't resend the static parts and it will only resend the dynamic part if it changes.

The tracking of changes is done via assigns. If the @title assign changes, then LiveView will execute the dynamic parts of the template, expand_title(@title), and send the new content. If @title is the same, nothing is executed and nothing is sent.

Change tracking also works when accessing map/struct fields. Take this template:

If the @user.name changes but @user.id doesn't, then LiveView will re-render only @user.name and it will not execute or resend @user.id at all.

The change tracking also works when rendering other templates as long as they are also .heex templates:

Or when using function components:

The assign tracking feature also implies that you MUST avoid performing direct operations in the template. For example, if you perform a database query in your template:

Then Phoenix will never re-render the section above, even if the number of users in the database changes. Instead, you need to store the users as assigns in your LiveView before it renders the template:

Generally speaking, data loading should never happen inside the template, regardless if you are using LiveView or not. The difference is that LiveView enforces this best practice.

There are som

*[Content truncated]*

**Examples:**

Example 1 (unknown):
```unknown
<h1>{expand_title(@title)}</h1>
```

Example 2 (unknown):
```unknown
<div id={"user_#{@user.id}"}>
  {@user.name}
</div>
```

Example 3 (unknown):
```unknown
{render("child_template.html", assigns)}
```

Example 4 (unknown):
```unknown
<.show_name name={@user.name} />
```

---

## Gettext for internationalization

**URL:** https://hexdocs.pm/phoenix_live_view/gettext.html

**Contents:**
- Gettext for internationalization
- Locale from parameters
- Locale from session
- Locale from database

For internationalization with gettext, you must call Gettext.put_locale/2 on the LiveView mount callback to instruct the LiveView which locale should be used for rendering the page.

However, one question that has to be answered is how to retrieve the locale in the first place. There are many approaches to solve this problem:

We will briefly cover these approaches to provide some direction.

You can say all URLs have a locale parameter. In your router:

Accessing a page without a locale should automatically redirect to a URL with locale (the best locale could be fetched from HTTP headers, which is outside of the scope of this guide).

Then, assuming all URLs have a locale, you can set the Gettext locale accordingly:

You can also use the on_mount hook to automatically restore the locale for every LiveView in your application:

Then, add this hook to def live_view under MyAppWeb, to run it on all LiveViews by default:

Note that, because the Gettext locale is not stored in the assigns, if you want to change the locale, you must use <.link navigate={...} />, instead of simply patching the page.

You may also store the locale in the Plug session. For example, in a controller you might do:

and then restore the locale from session within your LiveView mount:

You can also encapsulate this in a hook, as done in the previous section.

However, if the locale is stored in the session, you can only change it by using regular controller requests. Therefore you should always use <.link to={...} /> to point to a controller that change the session accordingly, reloading any LiveView.

You may also allow users to store their locale configuration in the database. Then, on mount/3, you can retrieve the user id from the session and load the locale:

In practice, you may end-up mixing more than one approach listed here. For example, reading from the database is great once the user is logged in but, before that happens, you may need to store the locale in the session or in the URL.

Similarly, you can keep the locale in the URL, but change the URL accordingly to the user preferred locale once they sign in. Hopefully this guide gives some suggestions on how to move forward and explore the best approach for your application.

Hex Package Hex Preview (current file) Search HexDocs Download ePub version

Built using ExDoc (v0.38.3) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
scope "/:locale" do
  live ...
  get ...
end
```

Example 2 (javascript):
```javascript
def mount(%{"locale" => locale}, _session, socket) do
  Gettext.put_locale(MyApp.Gettext, locale)
  {:ok, socket}
end
```

Example 3 (javascript):
```javascript
defmodule MyAppWeb.RestoreLocale do
  def on_mount(:default, %{"locale" => locale}, _session, socket) do
    Gettext.put_locale(MyApp.Gettext, locale)
    {:cont, socket}
  end

  # catch-all case
  def on_mount(:default, _params, _session, socket), do: {:cont, socket}
end
```

Example 4 (unknown):
```unknown
def live_view do
  quote do
    use Phoenix.LiveView

    on_mount MyAppWeb.RestoreLocale
    unquote(view_helpers())
  end
end
```

---
