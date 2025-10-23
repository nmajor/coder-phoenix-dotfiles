# Ash-Phoenix - Liveview

**Pages:** 2

---

## AshPhoenix.LiveView (ash_phoenix v2.3.17)

**URL:** https://hexdocs.pm/ash_phoenix/AshPhoenix.LiveView.html

**Contents:**
- AshPhoenix.LiveView (ash_phoenix v2.3.17)
- Summary
- Types
- Functions
- Types
- assign()
- assigns()
- callback()
- callback_result()
- liveness_options()

Utilities for keeping Ash query results up to date in a LiveView.

Shorthand to add results of a page onto a socket along with the page.

Incorporates an Ash.Notifier.Notification into the query results, based on the liveness configuration.

Runs the callback, and stores the information required to keep it live in the socket assigns.

Returns true if there's a next page.

Generates a page request for doing pagination based on the passed in parameters.

Converts Ash.Page.Offset to query link params

Converts an Ash.Page.Keyset or Ash.Page.Offset struct into page parameters in keyword format.

Generates page request options for pagination based on the passed in parameters and options.

Returns true if there's a previous page.

Shorthand to add results of a page onto a socket along with the page.

:results_key (atom/0) - The default value is :results.

:page_key (atom/0) - The default value is :page.

:stream_opts (keyword/0) - The default value is [reset: true].

Incorporates an Ash.Notifier.Notification into the query results, based on the liveness configuration.

You will want to match on receiving a notification from Ash, and the easiest way to do that is to match on the payload like so:

Feel free to intercept notifications and do your own logic to respond to events. Ultimately, all that matters is that you also call handle_live/3 if you want it to update your query results.

The assign or list of assigns passed as the third argument must be the same names passed into keep_live. If you only want some queries to update based on some events, you can define multiple matches on events, and only call handle_live/3 with the assigns that should be updated for that notification.

Runs the callback, and stores the information required to keep it live in the socket assigns.

The data will be assigned to the provided key, e.g keep_live(socket, :me, ...) would assign the results to :me (accessed as @me in the template).

Additionally, you'll need to define a handle_info/2 callback for your liveview to receive any notifications, and pass that notification into handle_live/3. See handle_live/3 for more.

The logic for handling events to keep data live is currently very limited. It will simply rerun the query every time. To this end, you should feel free to intercept individual events and handle them yourself for more optimized liveness.

To make paginated views convenient, as well as making it possible to keep those views live, Ash does not simply rerun the query when

*[Content truncated]*

**Examples:**

Example 1 (javascript):
```javascript
AshPhoenix.LiveView.assign_page_and_stream_result(%Phoenix.LiveView.Socket{}, %Ash.Page.Offset{results: [1,2,3]})
# => %Phoenix.LiveView.Socket{assigns: %{streams: %{results: [1,2,3]}, page: %Ash.Page.Offset{results: nil}}}
```

Example 2 (python):
```python
@impl true
def handle_info(%{topic: topic, payload: %Ash.Notifier.Notification{}}, socket) do
  {:noreply, handle_live(socket, topic, [:query1, :query2, :query3])}
end
```

Example 3 (python):
```python
def handle_info({:refetch, assign, opts}, socket) do
  {:noreply, handle_live(socket, :refetch, assign, opts)}
end
```

Example 4 (unknown):
```unknown
iex> AshPhoenix.LiveView.next_page?(%Ash.Page.Offset{offset: 10, limit: 10, more?: true})
true

iex> AshPhoenix.LiveView.next_page?(%{offset: 0, limit: 10, more?: false})
false
```

---

## AshPhoenix.LiveView.SubdomainHook (ash_phoenix v2.3.17)

**URL:** https://hexdocs.pm/ash_phoenix/AshPhoenix.LiveView.SubdomainHook.html

**Contents:**
- AshPhoenix.LiveView.SubdomainHook (ash_phoenix v2.3.17)
- Summary
- Functions
- Functions
- on_mount(opts, params, session, socket)

This is a basic hook that loads the current tenant assign from a given value set on subdomain.

:assign (atom/0) - The key to use when assigning the current tenant The default value is :current_tenant.

:handle_subdomain - An mfa to call with the socket and a subdomain value. Can be used to do something like fetch the current user given the tenant.

To use the hook, you can do one of the following:

This will assign the tenant's subdomain value to :current_tenant key by default.

If you want to specify the assign key

You can also provide handle_subdomain module, function, arguments tuple that will be run after the tenant is assigned.

This can be any module, function, and list of arguments as it uses Elixir's apply/3.

The socket and tenant will be the first two arguments.

The function return must match Phoenix LiveView's on_mount/1

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.3) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
Must return either `{:cont, socket}`, `{:cont, socket, opts} or `{:halt, socket}`.
```

Example 2 (unknown):
```unknown
live_session :foo, on_mount: [
AshPhoenix.LiveView.SubdomainHook,
]
```

Example 3 (unknown):
```unknown
live_session :foo, on_mount: [
{AshPhoenix.LiveView.SubdomainHook, [assign: :different_assign_key}]
]
```

Example 4 (unknown):
```unknown
live_session :foo, on_mount: [
{AshPhoenix.LiveView.SubdomainHook, [handle_subdomain: {FooApp.SubdomainHandler, :handle_subdomain, [:bar]}]
]
```

---
