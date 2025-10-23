# Ash-Authentication-Phoenix - Getting Started

**Pages:** 1

---

## Getting Started Ash Authentication Phoenix

**URL:** https://hexdocs.pm/ash_authentication_phoenix/get-started.html

**Contents:**
- Getting Started Ash Authentication Phoenix
  - With Igniter
  - Manual
    - Router Setup
    - AuthController
    - Update formatter config
    - Override mix phx.routes alias (only for phoenix <= 1.7)
- Generated routes
  - Customizing the generated routes
- Styling

This will also install ash_authentication if you haven't run that installer.

If you'd like to see only the changes that ash_authentication_phoenix makes, you can run:

See the AshAuthentication getting started guide for information on how to add strategies and configure AshAuthentication if you have not already.

ash_authentication_phoenix includes several helper macros which can generate Phoenix routes for you. For that you need to add 6 lines in the router module or just replace the whole file with the following code:

lib/example_web/router.ex

While running mix phx.routes you probably saw the warning message that the ExampleWeb.AuthController.init/1 is undefined. Let's fix that by creating a new controller:

lib/example_web/controllers/auth_controller.ex

Note that failure will not necessarily ever be called. For example, Components.Password.SignInForm will handle failures internally as long as sign_in_tokens_enabled? is true (which is the default).

Add ash_authentication_phoenix to .formatter.exs for auto_formatting .formatter.exs

Override phx.routes alias in the mix.ex file to include ash_authentication_phoenix routes. mix.exs

Note that this is only for phoenix <= 1.7 as phoenix 1.8 removes the need for it.

Given the above configuration you should see the following in your routes:

If you're integrating AshAuthentication into an existing app, you probably already have existing HTML layouts you want to use, to wrap the provided sign in/forgot password/etc. forms.

Liveviews provided by AshAuthentication.Phoenix will use the same root layout configured in your router's :browser pipeline, but it includes its own layout file primarily for rendering flash messages.

If you would like to use your own layout file instead, you can specify this as an option to the route helpers, eg.

If you plan on using our default Tailwind-based components without overriding them you will need to modify your assets/tailwind.config.js to include the ash_authentication_phoenix dependency:

assets/tailwind.config.js

If you're using daisyUI, you can use the daisyUI-specific overrides instead of the default Tailwind ones. Replace AshAuthentication.Phoenix.Overrides.Default with AshAuthentication.Phoenix.Overrides.DaisyUI in your router:

To enable dark theme support for header images, make sure this is in your app.css:

This allows the dark:hidden and dark:block classes to work with daisyUI's theme system instead of just system dark mode.

It's configured by default in new

*[Content truncated]*

**Examples:**

Example 1 (unknown):
```unknown
mix igniter.install ash_authentication_phoenix
```

Example 2 (unknown):
```unknown
mix igniter.install ash_authentication
# and then run
mix igniter.install ash_authentication_phoenix
```

Example 3 (unknown):
```unknown
defmodule ExampleWeb.Router do
  use ExampleWeb, :router

 # add these lines -->
  use AshAuthentication.Phoenix.Router

  import AshAuthentication.Plug.Helpers

  # <-- add these lines

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {ExampleWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :load_from_session # <-------- Add this line
  end

  pipeline :api do
    plug :accepts, ["json"]

    # add these lines -->
    plug :load_from_bearer
    plug :set_actor, :user
...
```

Example 4 (python):
```python
defmodule ExampleWeb.AuthController do
  use ExampleWeb, :controller
  use AshAuthentication.Phoenix.Controller

  def success(conn, _activity, user, _token) do
    return_to = get_session(conn, :return_to) || ~p"/"

    conn
    |> delete_session(:return_to)
    |> store_in_session(user)
    # If your resource has a different name, update the assign name here (i.e :current_admin)
    |> assign(:current_user, user)
    |> redirect(to: return_to)
  end

  def failure(conn, _activity, _reason) do
    conn
    |> put_flash(:error, "Incorrect email or password")
    |> redirect(to: ~p"/sign-in")
 
...
```

---
