---
name: ash-authentication-phoenix
description: Phoenix-specific authentication UI and routes. Use when integrating authentication with Phoenix controllers, LiveView auth components, auth routes, session management, sign-in pages, or authentication user interfaces.
---

# Ash-Authentication-Phoenix Skill

Phoenix integration for Ash Authentication - providing routes, controllers, LiveView components, plugs, and UI helpers for building authentication flows in Phoenix applications.

## When to Use This Skill

This skill should be triggered when:
- Setting up authentication routes in a Phoenix router
- Creating authentication controllers (sign in, sign out, success/failure handling)
- Implementing session management in Phoenix applications
- Adding authentication plugs to Phoenix pipelines
- Using LiveView for authentication UI (sign in, password reset, magic links)
- Integrating AshAuthentication with Phoenix applications
- Working with bearer tokens and session tokens in Phoenix
- Customizing authentication layouts and styling
- Debugging Phoenix authentication flows
- Implementing remember me functionality

## Key Concepts

### Router Integration
`AshAuthentication.Phoenix.Router` provides macros to automatically generate authentication routes for your Ash resources. It includes route helpers for sign in, sign out, password reset, and strategy-specific endpoints.

### Controller Callbacks
Authentication controllers implement callbacks for handling success and failure scenarios. The `success/4` callback receives the connection, activity, user, and token, while `failure/3` handles authentication failures.

### Session vs Bearer Tokens
- **Session tokens**: Stored in Phoenix sessions, used for web applications
- **Bearer tokens**: Sent in Authorization headers, used for API authentication
- Both can be loaded, stored, and revoked using provided plugs

### Plugs
Helper plugs for loading users from sessions or bearer tokens, revoking tokens, and managing authentication state throughout the request lifecycle.

## Quick Reference

### 1. Basic Router Setup

```elixir
defmodule MyAppWeb.Router do
  use MyAppWeb, :router
  use AshAuthentication.Phoenix.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {MyAppWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :load_from_session  # Load authenticated user from session
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug :load_from_bearer  # Load authenticated user from bearer token
  end

  scope "/", MyAppWeb do
    pipe_through :browser

    sign_in_route auth_routes_prefix: "/auth"
    sign_out_route AuthController
    auth_routes AuthController, MyApp.Accounts.User
    reset_route auth_routes_prefix: "/auth"
  end
end
```

### 2. Simple Authentication Controller

```elixir
defmodule MyAppWeb.AuthController do
  use MyAppWeb, :controller
  use AshAuthentication.Phoenix.Controller

  def success(conn, _activity, user, _token) do
    return_to = get_session(conn, :return_to) || ~p"/"

    conn
    |> delete_session(:return_to)
    |> store_in_session(user)
    |> assign(:current_user, user)
    |> redirect(to: return_to)
  end

  def failure(conn, _activity, _reason) do
    conn
    |> put_flash(:error, "Incorrect email or password")
    |> redirect(to: ~p"/sign-in")
  end

  def sign_out(conn, _params) do
    conn
    |> clear_session()
    |> redirect(to: ~p"/")
  end
end
```

### 3. API Authentication Controller

```elixir
defmodule MyAppWeb.ApiAuthController do
  use MyAppWeb, :controller
  use AshAuthentication.Phoenix.Controller

  def success(conn, _activity, _user, token) do
    conn
    |> put_status(200)
    |> json(%{
      authentication: %{
        status: :success,
        bearer: token
      }
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
    |> json(%{status: :signed_out})
  end
end
```

### 4. Remember Me Cookie Implementation

```elixir
defmodule MyAppWeb.AuthController do
  use MyAppWeb, :controller
  use AshAuthentication.Phoenix.Controller

  @remember_me_cookie_options [
    http_only: true,  # Prevents cookie access from JavaScript
    max_age: 60 * 60 * 24 * 30,  # 30 days
    same_site: "Lax",  # CSRF protection
    secure: true  # HTTPS only
  ]

  def success(conn, _activity, user, token) do
    conn
    |> store_in_session(user)
    |> assign(:current_user, user)
    |> redirect(to: Routes.page_path(conn, :index))
  end

  def set_remember_me_cookie(conn, params) do
    conn
    |> put_resp_cookie(
      "remember_me_token",
      params["token"],
      @remember_me_cookie_options
    )
    |> send_resp(200, "")
  end

  def delete_remember_me_cookie(conn, _params) do
    conn
    |> delete_resp_cookie("remember_me_token")
    |> send_resp(200, "")
  end
end
```

### 5. Loading Users with Plugs

```elixir
# Load from session (in your router)
pipeline :browser do
  plug :accepts, ["html"]
  plug :fetch_session
  plug :load_from_session  # Loads user from session
end

# Load from bearer token
pipeline :api do
  plug :accepts, ["json"]
  plug :load_from_bearer  # Loads user from Authorization header
end

# Sign in with remember me token
pipeline :maybe_authenticated do
  plug :sign_in_with_remember_me  # Tries to authenticate with remember me cookie
end
```

### 6. Token Revocation

```elixir
# Revoke all session tokens
conn
|> revoke_session_tokens()
|> clear_session()

# Revoke all bearer tokens
conn
|> revoke_bearer_tokens()

# Complete sign out (revokes all tokens)
def sign_out(conn, _params) do
  conn
  |> revoke_bearer_tokens()
  |> revoke_session_tokens()
  |> clear_session()
  |> redirect(to: ~p"/")
end
```

### 7. Custom Route Paths and Scopes

```elixir
# Custom authentication path
scope "/", MyAppWeb do
  auth_routes_for(MyApp.Accounts.User,
    to: AuthController,
    path: "/authentication",  # Custom path instead of /auth
    scope_opts: [host: "auth.example.com"]  # Optional scope options
  )
end
```

### 8. Using Generated LiveView Routes

```elixir
# Sign-in page (white-label LiveView)
sign_in_route auth_routes_prefix: "/auth"

# Password reset request page
reset_route auth_routes_prefix: "/auth"

# Magic link sign-in page
# (generated automatically if magic link strategy is configured)

# Confirmation page
# (generated automatically if confirmation strategy is configured)
```

### 9. Custom Layout for Auth Pages

```elixir
# Use your own layout instead of the default
sign_in_route(
  auth_routes_prefix: "/auth",
  layout: {MyAppWeb.Layouts, :auth}  # Custom layout
)

reset_route(
  auth_routes_prefix: "/auth",
  layout: {MyAppWeb.Layouts, :auth}
)
```

### 10. Tailwind Configuration for Default Components

```javascript
// assets/tailwind.config.js
module.exports = {
  content: [
    "./js/**/*.js",
    "../lib/*_web.ex",
    "../lib/*_web/**/*.*ex",
    "../deps/ash_authentication_phoenix/**/*.ex"  // Add this line
  ],
  // ... rest of config
}
```

## Reference Files

This skill includes comprehensive documentation in `references/`:

- **getting_started.md** - Complete setup guide with Igniter or manual installation, router configuration, controller setup, styling with Tailwind/DaisyUI, and generated routes overview
- **controllers.md** - Authentication controller behavior, callback functions (success/failure/sign_out), handling web vs API authentication, remember me cookie management, and token revocation
- **routes.md** - Route generation macros, auth_routes_for configuration, custom paths and scopes, LiveView route helpers (sign_in, reset, magic link), and route customization options
- **liveview.md** - LiveView components and forms for authentication flows
- **ui.md** - UI components and styling for authentication pages
- **other.md** - Additional utilities and helpers

Use these reference files when you need detailed information about specific features.

## Working with This Skill

### For Beginners
1. Start with **getting_started.md** to set up your Phoenix router and authentication controller
2. Follow the installation steps (Igniter recommended) to get routes and plugs configured
3. Use the basic router and controller examples in the Quick Reference section above
4. Test with the generated white-label LiveView pages before customizing

### For Intermediate Users
1. Review **controllers.md** for handling different authentication scenarios (web vs API)
2. Check **routes.md** for customizing route paths and adding authentication to specific scopes
3. Explore remember me functionality and token management
4. Customize layouts and styling for authentication pages

### For Advanced Users
1. Implement custom authentication strategies with strategy-specific controllers
2. Use **liveview.md** and **ui.md** for building custom authentication UI
3. Handle multi-tenancy and complex authorization scenarios
4. Integrate with external authentication providers
5. Customize token lifecycle and revocation policies

### Common Tasks

**Setting up authentication routes:**
→ See getting_started.md, section "Router Setup"

**Handling successful login:**
→ See controllers.md, `success/4` callback examples

**API authentication with bearer tokens:**
→ See Quick Reference example #3 above

**Remember me functionality:**
→ See controllers.md and Quick Reference example #4

**Custom authentication layouts:**
→ See getting_started.md, section "Customizing the generated routes"

**Token revocation on sign out:**
→ See controllers.md and Quick Reference example #6

## Resources

### Generated Routes
After adding authentication routes, run `mix phx.routes` to see all generated endpoints. Look for routes like:
- `/auth/user/password/sign_in` - Password sign in
- `/auth/user/password/register` - Registration
- `/auth/user/password/reset_request` - Password reset request
- `/auth/user/password/reset` - Password reset with token

### Common Patterns

**Complete sign-out with token cleanup:**
```elixir
def sign_out(conn, _params) do
  conn
  |> revoke_bearer_tokens()
  |> revoke_session_tokens()
  |> clear_session()
  |> redirect(to: ~p"/")
end
```

**Protected routes with authentication:**
```elixir
pipeline :authenticated do
  plug :load_from_session
  plug :require_authenticated_user  # Custom plug
end

scope "/app", MyAppWeb do
  pipe_through [:browser, :authenticated]
  # Protected routes here
end
```

**API with bearer token authentication:**
```elixir
pipeline :api do
  plug :accepts, ["json"]
  plug :load_from_bearer
end
```

### Styling Options

**Tailwind (default):**
Add ash_authentication_phoenix to your Tailwind content paths (see Quick Reference #10)

**DaisyUI:**
Use `AshAuthentication.Phoenix.Overrides.DaisyUI` in your router configuration

**Custom styles:**
Override layouts using the `layout:` option on route helpers

## Notes

- Routes are generated automatically based on configured authentication strategies
- The `auth_routes_prefix` must be consistent across all route helpers
- Session tokens are automatically managed when using `store_in_session/2`
- Bearer tokens must be manually included in Authorization headers for API requests
- Token revocation ensures proper cleanup on sign out
- LiveView pages are provided for common flows but can be customized with your own layouts

## Troubleshooting

**Routes not found:**
- Ensure `use AshAuthentication.Phoenix.Router` is added to your router
- Check that `auth_routes_prefix` matches across all route helpers
- Run `mix phx.routes` to verify generated routes

**Styles not applying:**
- Verify Tailwind content includes ash_authentication_phoenix dependency
- For DaisyUI, ensure you're using the DaisyUI overrides module
- Check that CSS is being properly compiled and loaded

**Authentication not persisting:**
- Ensure `:load_from_session` plug is in your :browser pipeline
- Verify `store_in_session/2` is called in your success callback
- Check session configuration in your endpoint

**Token issues:**
- For APIs, ensure bearer tokens are in Authorization header: `Bearer <token>`
- Session tokens are automatically managed - don't manually set them
- Use `revoke_bearer_tokens/1` and `revoke_session_tokens/1` for proper cleanup
