# Phoenix-Liveview - Getting Started

**Pages:** 1

---

## Welcome

**URL:** https://hexdocs.pm/phoenix_live_view/welcome.html

**Contents:**
- Welcome
- What is a LiveView?
- Example
- Parameters and session
- Bindings
- Navigation
- Generators
- Compartmentalize state, markup, and events in LiveView
  - Function components to organize markup and event handling
  - Live components to encapsulate additional state

Welcome to Phoenix LiveView documentation. Phoenix LiveView enables rich, real-time user experiences with server-rendered HTML. A general overview of LiveView and its benefits is available in our README.

LiveViews are processes that receive events, update their state, and render updates to a page as diffs.

The LiveView programming model is declarative: instead of saying "once event X happens, change Y on the page", events in LiveView are regular messages which may cause changes to the state. Once the state changes, the LiveView will re-render the relevant parts of its HTML template and push it to the browser, which updates the page in the most efficient manner.

LiveView state is nothing more than functional and immutable Elixir data structures. The events are either internal application messages (usually emitted by Phoenix.PubSub) or sent by the client/browser.

Every LiveView is first rendered statically as part of a regular HTTP request, which provides quick times for "First Meaningful Paint", in addition to helping search and indexing engines. A persistent connection is then established between the client and server. This allows LiveView applications to react faster to user events as there is less work to be done and less data to be sent compared to stateless requests that have to authenticate, decode, load, and encode data on every request.

LiveView is included by default in Phoenix applications. Therefore, to use LiveView, you must have already installed Phoenix and created your first application. If you haven't done so, check Phoenix' installation guide to get started.

The behaviour of a LiveView is outlined by a module which implements a series of functions as callbacks. Let's see an example. Write the file below to lib/my_app_web/live/thermostat_live.ex. Remember to replace the directory my_app_web and the module MyAppWeb with your app's name:

The module above defines three functions (they are callbacks required by LiveView). The first one is render/1, which receives the socket assigns and is responsible for returning the content to be rendered on the page. We use the ~H sigil to define a HEEx template, which stands for HTML+EEx. They are an extension of Elixir's builtin EEx templates, with support for HTML validation, syntax-based components, smart change tracking, and more. You can learn more about the template syntax in Phoenix.Component.sigil_H/2 (note Phoenix.Component is automatically imported when you use Phoenix.LiveView).

The data u

*[Content truncated]*

**Examples:**

Example 1 (python):
```python
defmodule MyAppWeb.ThermostatLive do
  use MyAppWeb, :live_view

  def render(assigns) do
    ~H"""
    Current temperature: {@temperature}°F
    <button phx-click="inc_temperature">+</button>
    """
  end

  def mount(_params, _session, socket) do
    temperature = 70 # Let's assume a fixed temperature for now
    {:ok, assign(socket, :temperature, temperature)}
  end

  def handle_event("inc_temperature", _params, socket) do
    {:noreply, update(socket, :temperature, &(&1 + 1))}
  end
end
```

Example 2 (unknown):
```unknown
defmodule MyAppWeb.Router do
  use MyAppWeb, :router

  pipeline :browser do
    ...
  end

  scope "/", MyAppWeb do
    pipe_through :browser
    ...

    live "/thermostat", ThermostatLive
  end
end
```

Example 3 (python):
```python
import {Socket} from "phoenix"
import {LiveSocket} from "phoenix_live_view"

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
let liveSocket = new LiveSocket("/live", Socket, {params: {_csrf_token: csrfToken}})
liveSocket.connect()
```

Example 4 (javascript):
```javascript
def mount(%{"house" => house}, _session, socket) do
  temperature = Thermostat.get_house_reading(house)
  {:ok, assign(socket, :temperature, temperature)}
end
```

---
