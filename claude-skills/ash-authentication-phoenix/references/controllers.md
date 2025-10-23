# Ash-Authentication-Phoenix - Controllers

**Pages:** 3

---

## AshAuthentication.Phoenix.Controller behaviour (ash_authentication_phoenix v2.12.1)

**URL:** https://hexdocs.pm/ash_authentication_phoenix/AshAuthentication.Phoenix.Controller.html

**Contents:**
- AshAuthentication.Phoenix.Controller behaviour (ash_authentication_phoenix v2.12.1)
- Example
- Summary
- Types
- Callbacks
- Functions
- Types
- activity()
- t()
- token()

The authentication controller generator.

Since authentication often requires explicit HTTP requests to do things like set cookies or return Authorization headers, use this module to create an AuthController in your Phoenix application.

Handling the registration or authentication of a normal web-based user.

Handling registration or authentication of an API user.

Called when a request is made to delete a remember me cookie.

Called when authentication fails.

Called when a request is made to set a remember me cookie.

Called when a request to sign out is received.

Called when authentication (or registration, depending on the provider) has been successful.

Clears the session and revokes bearer and session tokens.

Called when a request is made to delete a remember me cookie.

Called when authentication fails.

Called when a request is made to set a remember me cookie.

Called when a request to sign out is received.

Called when authentication (or registration, depending on the provider) has been successful.

Clears the session and revokes bearer and session tokens.

This ensures that session tokens & bearer tokens are revoked on logout.

Hex Package Hex Preview Search HexDocs

Built using ExDoc (v0.38.4) for the Elixir programming language

**Examples:**

Example 1 (python):
```python
defmodule MyAppWeb.AuthController do
  use MyAppWeb, :controller
  use AshAuthentication.Phoenix.Controller

  def success(conn, _activity, user, _token) do
    conn
    |> store_in_session(user)
    |> assign(:current_user, user)
    |> redirect(to: Routes.page_path(conn, :index))
  end

  def failure(conn, _activity, _reason) do
    conn
    |> put_status(401)
    |> render("failure.html")
  end

  def sign_out(conn, _params) do
    conn
    |> clear_session(:my_otp_app)
    |> render("sign_out.html")
  end

  @remember_me_cookie_options [
    http_only: true, # prevents the cookie from bein
...
```

Example 2 (python):
```python
defmodule MyAppWeb.ApiAuthController do
  use MyAppWeb, :controller
  use AshAuthentication.Phoenix.Controller
  alias AshAuthentication.TokenRevocation

  def success(conn, _activity, _user, token) do
    conn
    |> put_status(200)
    |> json(%{
      authentication: %{
        status: :success,
        bearer: token}
    })
  end

  def failure(conn, _activity, _reason) do
    conn
    |> put_status(401)
    |> json(%{
      authentication: %{
        status: :failed
      }
    })
  end

  def sign_out(conn, _params) do
    conn
    |> revoke_bearer_tokens()
    |> json(%{
      status: :
...
```

---

## AshAuthentication.Phoenix.Plug (ash_authentication_phoenix v2.12.1)

**URL:** https://hexdocs.pm/ash_authentication_phoenix/AshAuthentication.Phoenix.Plug.html

**Contents:**
- AshAuthentication.Phoenix.Plug (ash_authentication_phoenix v2.12.1)
- Summary
- Functions
- Functions
- load_from_bearer(conn, opts)
- load_from_session(conn, opts)
- revoke_bearer_tokens(conn, opts)
- revoke_session_tokens(conn, opts)
- sign_in_with_remember_me(conn, opts)
- store_in_session(conn, actor)

Helper plugs mixed in to your router.

When you use AshAuthentication.Phoenix.Router this module is included, so that you can use these plugs in your pipelines.

Attempt to retrieve actors from the Authorization header(s).

Attempt to retrieve all actors from the connections' session.

Revoke all token(s) in the Authorization header(s).

Revoke all token(s) in the session.

Attempts to sign in the user with the remember me token if the user is not already signed in.

Store the actor in the connections' session.

Attempt to retrieve actors from the Authorization header(s).

A wrapper around AshAuthentication.Plug.Helpers.retrieve_from_bearer/2 with the otp_app as extracted from the endpoint.

Attempt to retrieve all actors from the connections' session.

A wrapper around AshAuthentication.Plug.Helpers.retrieve_from_session/2 with the otp_app as extracted from the endpoint.

Revoke all token(s) in the Authorization header(s).

A wrapper around AshAuthentication.Plug.Helpers.revoke_bearer_tokens/2 with the otp_app as extracted from the endpoint.

Revoke all token(s) in the session.

A wrapper around AshAuthentication.Plug.Helpers.revoke_session_tokens/2 with the otp_app as extracted from the endpoint.

Attempts to sign in the user with the remember me token if the user is not already signed in.

A wrapper around AshAuthentication.Plug.Helpers.sign_in_with_remember_me/2 with the otp_app as extracted from the endpoint.

Store the actor in the connections' session.

Hex Package Hex Preview Search HexDocs

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## AshAuthentication.Phoenix.Router (ash_authentication_phoenix v2.12.1)

**URL:** https://hexdocs.pm/ash_authentication_phoenix/AshAuthentication.Phoenix.Router.html

**Contents:**
- AshAuthentication.Phoenix.Router (ash_authentication_phoenix v2.12.1)
- Usage
- Summary
- Types
- Functions
- Types
- auth_route_options()
- path_option()
- scope_opts_option()
- to_option()

Phoenix route generation for AshAuthentication.

Using this module imports the macros in this module and the plug functions from AshAuthentication.Phoenix.Plug.

Adding authentication to your live-view router is very simple:

Options that can be passed to auth_routes_for.

A sub-path if required. Defaults to /auth.

Any options which should be passed to the generated scope.

The controller which will handle success and failure.

Generates the routes needed for the various strategies for a given AshAuthentication resource.

Generates the routes needed for the various strategies for a given AshAuthentication resource.

Generates a generic, white-label confirmation page using LiveView and the components in AshAuthentication.Phoenix.Components.

Generates a genric, white-label magic link sign in page using LiveView and the components in AshAuthentication.Phoenix.Components.

Generates a generic, white-label password reset page using LiveView and the components in AshAuthentication.Phoenix.Components. This is the page that allows a user to actually change his password, after requesting a reset token via the sign-in (/reset) route.

Generates a generic, white-label sign-in page using LiveView and the components in AshAuthentication.Phoenix.Components.

Generates a sign-out route which points to the sign_out action in your auth controller.

Options that can be passed to auth_routes_for.

A sub-path if required. Defaults to /auth.

Any options which should be passed to the generated scope.

The controller which will handle success and failure.

Generates the routes needed for the various strategies for a given AshAuthentication resource.

This matches all routes at the provided path, which defaults to /auth. This means that if you have any other routes that begin with /auth, you will need to make sure this appears after them.

If you are using route helpers anywhere in your application, typically looks like Routes.auth_path/3 or Helpers.auth_path/3 you will need to update them to use verified routes. To see what routes are available to you, use mix ash_authentication.phoenix.routes.

If you are using any of the components provided by AshAuthenticationPhoenix, you will need to supply them with the auth_routes_prefix assign, set to the path you provide here (set to /auth by default).

You also will need to set auth_routes_prefix on the reset_route, i.e reset_route(auth_routes_prefix: "/auth")

Generates the routes needed for the various strategies for a given AshAut

*[Content truncated]*

**Examples:**

Example 1 (unknown):
```unknown
defmodule MyAppWeb.Router do
  use MyAppWeb, :router
  use AshAuthentication.Phoenix.Router

  pipeline :browser do
    # ...
    plug(:load_from_session)
  end

  pipeline :api do
    # ...
    plug(:load_from_bearer)
  end

  scope "/", MyAppWeb do
    pipe_through :browser
    sign_in_route auth_routes_prefix: "/auth"
    sign_out_route AuthController
    auth_routes AuthController, MyApp.Accounts.User
    reset_route auth_routes_prefix: "/auth"
  end
```

Example 2 (unknown):
```unknown
scope "/", DevWeb do
  auth_routes_for(MyApp.Accounts.User,
    to: AuthController,
    path: "/authentication",
    scope_opts: [host: "auth.example.com"]
  )
end
```

---
