# Ash-Authentication - Configuration

**Pages:** 3

---

## AshAuthentication

**URL:** https://hexdocs.pm/ash_authentication/dsl-ashauthentication.html

**Contents:**
- AshAuthentication
- Usage
- Authentication Strategies
  - HTTP client settings
- Add-ons
- Supervisor
- authentication
  - Nested DSLs
  - Options
  - authentication.tokens

AshAuthentication provides a turn-key authentication solution for folks using Ash.

This package assumes that you have Ash installed and configured. See the Ash documentation for details.

Once installed you can easily add support for authentication by configuring the AshAuthentication extension on your resource:

If you plan on providing authentication via the web, then you will need to define a plug using AshAuthentication.Plug which builds a Plug.Router that routes incoming authentication requests to the correct provider and provides callbacks for you to manipulate the conn after success or failure.

If you're using AshAuthentication with Phoenix, then check out ash_authentication_phoenix which provides route helpers, a controller abstraction and LiveView components for easy set up.

Currently supported strategies:

Most of the authentication strategies based on OAuth2 wrap the assent package.

If you needs to customize the behavior of the http client used by assent, define a custom http_adapter in the application settings:

config :ash_authentication, :http_adapter, {Assent.HTTPAdapter.Finch, supervisor: MyApp.CustomFinch}

See assent's documentation for more details on the supported http clients and their configuration.

Add-ons are like strategies, except that they don't actually provide authentication - they just provide features adjacent to authentication. Current add-ons:

Some add-ons or strategies may require processes to be started which manage their state over the lifetime of the application (eg periodically deleting expired token revocations). Because of this you should add {AshAuthentication.Supervisor, otp_app: :my_app} to your application's supervision tree. See the Elixir docs for more information.

Configure authentication for this resource

Configure JWT settings for this resource

Configure authentication strategies on this resource

Additional add-ons related to, but not providing authentication

A DSL section for extensions to add authentication providers

Hex Package Hex Preview (current file) Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
defmodule MyApp.Accounts.User do
  use Ash.Resource,
    extensions: [AshAuthentication],
    domain: MyApp.Accounts

  attributes do
    uuid_primary_key :id
    attribute :email, :ci_string, allow_nil?: false
    attribute :hashed_password, :string, allow_nil?: false, sensitive?: true
  end

  authentication do
    strategies do
      password :password do
        identity_field :email
        hashed_password_field :hashed_password
      end
    end
  end

  identities do
    identity :unique_email, [:email]
  end
end
```

---

## AshAuthentication.Plug behaviour (ash_authentication v4.12.0)

**URL:** https://hexdocs.pm/ash_authentication/AshAuthentication.Plug.html

**Contents:**
- AshAuthentication.Plug behaviour (ash_authentication v4.12.0)
  - Using in Phoenix
  - Using in a Plug application
- Summary
- Types
- Callbacks
- Types
- activity()
- token()
- Callbacks

Generate an authentication plug.

Use in your app by creating a new module called AuthPlug or similar:

In your Phoenix router you can add it:

In order to load any authenticated users for either web or API users you can add the following to your router:

Note that you will need to include a bunch of other plugs in the pipeline to do useful things like session and query param fetching.

When there is any failure during authentication this callback is called.

When authentication has been succesful, this callback will be called with the conn, the successful activity, the authenticated resource and a token.

When there is any failure during authentication this callback is called.

Note that this includes not just authentication failures but potentially route-not-found errors also.

The default implementation simply returns a 401 status with the message "Access denied". You almost definitely want to override this.

When authentication has been succesful, this callback will be called with the conn, the successful activity, the authenticated resource and a token.

This allows you to choose what action to take as appropriate for your application.

The default implementation calls store_in_session/2 and returns a simple "Access granted" message to the user. You almost definitely want to override this behaviour.

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

**Examples:**

Example 1 (python):
```python
defmodule MyAppWeb.AuthPlug do
  use AshAuthentication.Plug, otp_app: :my_app

  def handle_success(conn, _activity, user, _token) do
    conn
    |> store_in_session(user)
    |> send_resp(200, "Welcome back #{user.name}")
  end

  def handle_failure(conn, _activity, reason) do
    conn
    |> send_resp(401, "Better luck next time")
  end
end
```

Example 2 (unknown):
```unknown
scope "/auth" do
  pipe_through :browser
  forward "/", MyAppWeb.AuthPlug
end
```

Example 3 (unknown):
```unknown
import MyAppWeb.AuthPlug

pipeline :session_users do
  plug :load_from_session
end

pipeline :bearer_users do
  plug :load_from_bearer
end

scope "/", MyAppWeb do
  pipe_through [:browser, :session_users]

  live "/", PageLive, :home
end

scope "/api", MyAppWeb do
  pipe_through [:api, :bearer_users]

  get "/" ApiController, :index
end
```

Example 4 (unknown):
```unknown
use Plug.Router

forward "/auth", to: MyAppWeb.AuthPlug
```

---

## AshAuthentication (ash_authentication v4.12.0)

**URL:** https://hexdocs.pm/ash_authentication/AshAuthentication.html

**Contents:**
- AshAuthentication (ash_authentication v4.12.0)
- Usage
- Authentication Strategies
  - HTTP client settings
- Add-ons
- Supervisor
- Summary
- Types
- Functions
- Types

AshAuthentication provides a turn-key authentication solution for folks using Ash.

This package assumes that you have Ash installed and configured. See the Ash documentation for details.

Once installed you can easily add support for authentication by configuring the AshAuthentication extension on your resource:

If you plan on providing authentication via the web, then you will need to define a plug using AshAuthentication.Plug which builds a Plug.Router that routes incoming authentication requests to the correct provider and provides callbacks for you to manipulate the conn after success or failure.

If you're using AshAuthentication with Phoenix, then check out ash_authentication_phoenix which provides route helpers, a controller abstraction and LiveView components for easy set up.

Currently supported strategies:

Most of the authentication strategies based on OAuth2 wrap the assent package.

If you needs to customize the behavior of the http client used by assent, define a custom http_adapter in the application settings:

config :ash_authentication, :http_adapter, {Assent.HTTPAdapter.Finch, supervisor: MyApp.CustomFinch}

See assent's documentation for more details on the supported http clients and their configuration.

Add-ons are like strategies, except that they don't actually provide authentication - they just provide features adjacent to authentication. Current add-ons:

Some add-ons or strategies may require processes to be started which manage their state over the lifetime of the application (eg periodically deleting expired token revocations). Because of this you should add {AshAuthentication.Supervisor, otp_app: :my_app} to your application's supervision tree. See the Elixir docs for more information.

Find all resources which support authentication for a given OTP application.

Given a subject string, attempt to retrieve a user record.

Return a subject string for user.

Find all resources which support authentication for a given OTP application.

Returns a list of resource modules.

Given a subject string, attempt to retrieve a user record.

Any options passed will be passed to the underlying Domain.read/2 callback.

Return a subject string for user.

This is done by concatenating the resource's subject name with the resource's primary key field(s) to generate a uri-like string.

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
defmodule MyApp.Accounts.User do
  use Ash.Resource,
    extensions: [AshAuthentication],
    domain: MyApp.Accounts

  attributes do
    uuid_primary_key :id
    attribute :email, :ci_string, allow_nil?: false
    attribute :hashed_password, :string, allow_nil?: false, sensitive?: true
  end

  authentication do
    strategies do
      password :password do
        identity_field :email
        hashed_password_field :hashed_password
      end
    end
  end

  identities do
    identity :unique_email, [:email]
  end
end
```

Example 2 (unknown):
```unknown
iex> %{id: user_id} = build_user()
...> {:ok, %{id: ^user_id}} = subject_to_user("user?id=#{user_id}", Example.User)
```

Example 3 (unknown):
```unknown
iex> build_user(id: "ce7969f9-afa5-474c-bc52-ac23a103cef6") |> user_to_subject()
"user?id=ce7969f9-afa5-474c-bc52-ac23a103cef6"
```

---
