# Phoenix-Liveview - Js Interop

**Pages:** 3

---

## Phoenix.LiveView.ColocatedJS (Phoenix LiveView v1.1.16)

**URL:** https://hexdocs.pm/phoenix_live_view/Phoenix.LiveView.ColocatedJS.html

**Contents:**
- Phoenix.LiveView.ColocatedJS (Phoenix LiveView v1.1.16)
    - A note on dependencies and umbrella projects
- Internals
    - Tip
    - Warning!
  - Imports in colocated JS
- Options

A special HEEx :type that extracts any JavaScript code from a co-located <script> tag at compile time.

Note: To use ColocatedJS, you need to run Phoenix 1.8+.

Colocated JavaScript is a more generalized version of Phoenix.LiveView.ColocatedHook. In fact, colocated hooks are built on top of ColocatedJS.

You can use ColocatedJS to define any JavaScript code (Web Components, global event listeners, etc.) that do not necessarily need the functionalities of hooks, for example:

Then, in your app.js file, you could import it like this:

In this example, you don't actually need to have special code for the web component inside your app.js file, since you could also directly call customElements.define inside the colocated JavaScript. However, this example shows how you can access the exported values inside your bundle.

For each application that uses colocated JavaScript, a separate directory is created inside the phoenix-colocated folder. This allows to have clear separation between hooks and code of dependencies, but also applications inside umbrella projects.

While dependencies would typically still bundle their own hooks and colocated JavaScript into a separate file before publishing, simple hooks or code snippets that do not require access to third-party libraries can also be directly imported into your own bundle. If a library requires this, it should be stated in its documentation.

While compiling the template, colocated JavaScript is extracted into a special folder inside the Mix.Project.build_path(), called phoenix-colocated. This is customizable, as we'll see below, but it is important that it is a directory that is not tracked by version control, because the components are the source of truth for the code. Also, the directory is shared between applications (this also applies to applications in umbrella projects), so it should typically also be a shared directory not specific to a single application.

The colocated JS directory follows this structure:

Each application has its own folder. Inside, each module also gets its own folder, which allows us to track and clean up outdated code.

To use colocated JS from your app.js, your bundler needs to be configured to resolve the phoenix-colocated folder. For new Phoenix applications, this configuration is already included in the esbuild configuration inside config.exs:

The important part here is the NODE_PATH environment variable, which tells esbuild to also look for packages inside the deps folder, as w

*[Content truncated]*

**Examples:**

Example 1 (unknown):
```unknown
<script :type={Phoenix.LiveView.ColocatedJS} name="MyWebComponent">
  export default class MyWebComponent extends HTMLElement {
    connectedCallback() {
      this.innerHTML = "Hello, world!";
    }
  }
</script>
```

Example 2 (python):
```python
import colocated from "phoenix-colocated/my_app";
customElements.define("my-web-component", colocated.MyWebComponent);
```

Example 3 (unknown):
```unknown
_build/$MIX_ENV/phoenix-colocated/
_build/$MIX_ENV/phoenix-colocated/my_app/
_build/$MIX_ENV/phoenix-colocated/my_app/index.js
_build/$MIX_ENV/phoenix-colocated/my_app/MyAppWeb.DemoLive/line_HASH.js
_build/$MIX_ENV/phoenix-colocated/my_dependency/MyDependency.Module/line_HASH.js
...
```

Example 4 (javascript):
```javascript
config :esbuild,
  ...
  my_app: [
    args:
      ~w(js/app.js --bundle --target=es2022 --outdir=../priv/static/assets/js --external:/fonts/* --external:/images/* --alias:@=.),
    cd: Path.expand("../assets", __DIR__),
    env: %{
      "NODE_PATH" => [Path.expand("../deps", __DIR__), Mix.Project.build_path()]
    }
  ]
```

---

## JavaScript interoperability

**URL:** https://hexdocs.pm/phoenix_live_view/js-interop.html

**Contents:**
- JavaScript interoperability
- Debugging client events
- Simulating Latency
- Handling server-pushed events
- Client hooks via phx-hook
  - Colocated Hooks / Colocated JavaScript
  - Client-server communication
- JS commands

To enable LiveView client/server interaction, we instantiate a LiveSocket. For example:

All options are passed directly to the Phoenix.Socket constructor, except for the following LiveView specific options:

The liveSocket instance exposes the following methods:

To aid debugging on the client when troubleshooting issues, the enableDebug() and disableDebug() functions are exposed on the LiveSocket JavaScript instance. Calling enableDebug() turns on debug logging which includes LiveView life-cycle and payload events as they come and go from client to server. In practice, you can expose your instance on window for quick access in the browser's web console, for example:

The debug state uses the browser's built-in sessionStorage, so it will remain in effect for as long as your browser session lasts.

Proper handling of latency is critical for good UX. LiveView's CSS loading states allow the client to provide user feedback while awaiting a server response. In development, near zero latency on localhost does not allow latency to be easily represented or tested, so LiveView includes a latency simulator with the JavaScript client to ensure your application provides a pleasant experience. Like the enableDebug() function above, the LiveSocket instance includes enableLatencySim(milliseconds) and disableLatencySim() functions which apply throughout the current browser session. The enableLatencySim function accepts an integer in milliseconds for the one-way latency to and from the server. For example:

When the server uses Phoenix.LiveView.push_event/3, the event name will be dispatched in the browser with the phx: prefix. For example, imagine the following template where you want to highlight an existing element from the server to draw the user's attention:

Next, the server can issue a highlight using the standard push_event:

Finally, a window event listener can listen for the event and conditionally execute the highlight command if the element matches:

If you desire, you can also integrate this functionality with Phoenix' JS commands, executing JS commands for the given element whenever highlight is triggered. First, update the element to embed the JS command into a data attribute:

Now, in the event listener, use LiveSocket.execJS to trigger all JS commands in the new attribute:

To handle custom client-side JavaScript when an element is added, updated, or removed by the server, a hook object may be provided via phx-hook. phx-hook must point to an object with t

*[Content truncated]*

**Examples:**

Example 1 (python):
```python
import {Socket} from "phoenix"
import {LiveSocket} from "phoenix_live_view"

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
let liveSocket = new LiveSocket("/live", Socket, {params: {_csrf_token: csrfToken}})
liveSocket.connect()
```

Example 2 (javascript):
```javascript
// app.js
let liveSocket = new LiveSocket(...)
liveSocket.connect()
window.liveSocket = liveSocket

// in the browser's web console
>> liveSocket.enableDebug()
```

Example 3 (javascript):
```javascript
// app.js
let liveSocket = new LiveSocket(...)
liveSocket.connect()
window.liveSocket = liveSocket

// in the browser's web console
>> liveSocket.enableLatencySim(1000)
[Log] latency simulator enabled for the duration of this browser session.
      Call disableLatencySim() to disable
```

Example 4 (unknown):
```unknown
<div id={"item-#{item.id}"} class="item">
  {item.title}
</div>
```

---

## Phoenix.LiveView.JS (Phoenix LiveView v1.1.16)

**URL:** https://hexdocs.pm/phoenix_live_view/Phoenix.LiveView.JS.html

**Contents:**
- Phoenix.LiveView.JS (Phoenix LiveView v1.1.16)
- Client Utility Commands
- Enhanced push events
- DOM Selectors
- Custom JS events with JS.dispatch/1 and window.addEventListener
- Composing JS commands
- Summary
- Types
- Functions
- Types

Provides commands for executing JavaScript utility operations on the client.

JS commands support a variety of utility operations for common client-side needs, such as adding or removing CSS classes, setting or removing tag attributes, showing or hiding content, and transitioning in and out with animations. While these operations can be accomplished via client-side hooks, JS commands are DOM-patch aware, so operations applied by the JS APIs will stick to elements across patches from the server.

In addition to purely client-side utilities, the JS commands include a rich push API, for extending the default phx- binding pushes with options to customize targets, loading states, and additional payload values.

If you need to trigger these commands via JavaScript, see JavaScript interoperability.

The following utilities are included:

For example, the following modal component can be shown or hidden on the client without a trip to the server:

The push/1 command allows you to extend the built-in pushed event handling when a phx- event is pushed to the server. For example, you may wish to target a specific component, specify additional payload values to include with the event, apply loading states to external elements, etc. For example, given this basic phx-click event:

Imagine you need to target your current component, and apply a loading state to the parent container while the client awaits the server acknowledgement:

Push commands also compose with all other utilities. For example, to add a class when pushing:

Any phx-value-* attributes will also be included in the payload, their values will be overwritten by values given directly to push/1. Any phx-target attribute will also be used, and overwritten.

The client utility commands in this module all take an optional DOM selector using the :to option.

This can be a string for a regular DOM selector such as:

It is also possible to provide scopes to the DOM selector. The following scopes are available:

For example, if building a dropdown component, the button could use the :inner scope:

dispatch/1 can be used to dispatch custom JavaScript events to elements. For example, you can use JS.dispatch("click", to: "#foo"), to dispatch a click event to an element.

This also means you can augment your elements with custom events, by using JavaScript's window.addEventListener and invoking them with dispatch/1. For example, imagine you want to provide a copy-to-clipboard functionality in your application. You can a

*[Content truncated]*

**Examples:**

Example 1 (python):
```python
alias Phoenix.LiveView.JS

def hide_modal(js \\ %JS{}) do
  js
  |> JS.hide(transition: "fade-out", to: "#modal")
  |> JS.hide(transition: "fade-out-scale", to: "#modal-content")
end

def modal(assigns) do
  ~H"""
  <div id="modal" class="phx-modal" phx-remove={hide_modal()}>
    <div
      id="modal-content"
      class="phx-modal-content"
      phx-click-away={hide_modal()}
      phx-window-keydown={hide_modal()}
      phx-key="escape"
    >
      <button class="phx-modal-close" phx-click={hide_modal()}>✖</button>
      <p>{@text}</p>
    </div>
  </div>
  """
end
```

Example 2 (unknown):
```unknown
<button phx-click="inc">+</button>
```

Example 3 (unknown):
```unknown
alias Phoenix.LiveView.JS

~H"""
<button phx-click={JS.push("inc", loading: ".thermo", target: @myself)}>+</button>
"""
```

Example 4 (unknown):
```unknown
<button phx-click={
  JS.push("inc", loading: ".thermo", target: @myself)
  |> JS.add_class("warmer", to: ".thermo")
}>+</button>
```

---
