# Ash-Authentication - Strategies

**Pages:** 33

---

## AshAuthentication.Strategy.MagicLink

**URL:** https://hexdocs.pm/ash_authentication/dsl-ashauthentication-strategy-magiclink.html

**Contents:**
- AshAuthentication.Strategy.MagicLink
  - Example
- Tenancy
- Actions
  - Examples
- Usage with AshAuthenticationPhoenix
- Plugs
  - Examples:
  - authentication.strategies.magic_link
  - Options

Strategy for authentication using a magic link.

In order to use magic link authentication your resource needs to meet the following minimum requirements:

There are other options documented in the DSL.

Note that the tenant is provided to the sender in the opts key. Use this if you need to modify the url (i.e tenant.app.com) based on the tenant that requested the token.

By default the magic link strategy will automatically generate the request and sign-in actions for you, however you're free to define them yourself. If you do, then the action will be validated to ensure that all the needed configuration is present.

If you wish to work with the actions directly from your code you can do so via the AshAuthentication.Strategy protocol.

Requesting that a magic link token is sent for a user:

Signing in using a magic link token:

If you are using AshAuthenticationPhoenix, and have require_authentication? set to true, which you very much should, then you will need to add a magic_sign_in_route to your router. This is placed in the same location as auth_routes, and should be provided the user and the strategy name. For example:

The magic link strategy provides plug endpoints for both request and sign-in actions.

If you wish to work with the plugs directly, you can do so via the AshAuthentication.Strategy protocol.

Dispatching to plugs directly:

See the Magic Link Tutorial for more information.

Strategy for authenticating using local users with a magic link

Target: AshAuthentication.Strategy.MagicLink

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
  end

  authentication do
    strategies do
      magic_link do
        identity_field :email
        sender fn user_or_email, token, _opts ->
          # will be a user if the token relates to an existing user
          # will be an email if there is no matching user (such as during sign up)
          # opts will contain the `tenant` key, use this if you need to alter the link based
 
...
```

Example 2 (javascript):
```javascript
iex> strategy = Info.strategy!(Example.User, :magic_link)
...> user = build_user()
...> Strategy.action(strategy, :request, %{"username" => user.username})
:ok
```

Example 3 (javascript):
```javascript
...> {:ok, token} = MagicLink.request_token_for(strategy, user)
...> {:ok, signed_in_user} = Strategy.action(strategy, :sign_in, %{"token" => token})
...> signed_in_user.id == user
true
```

Example 4 (unknown):
```unknown
# Remove this if you do not want to use the magic link strategy
magic_sign_in_route(
  MyApp.Accounts.User,
  :sign_in,
  auth_routes_prefix: "/auth",
  overrides: [MyApp.AuthOverrides, AshAuthentication.Phoenix.Overrides.Default]
)
```

---

## AshAuthentication.Strategy.Password

**URL:** https://hexdocs.pm/ash_authentication/dsl-ashauthentication-strategy-password.html

**Contents:**
- AshAuthentication.Strategy.Password
  - Example:
- Actions
  - Examples:
- Plugs
  - Examples:
- Testing
  - authentication.strategies.password
  - Nested DSLs
  - Examples

Strategy for authenticating using local resources as the source of truth.

In order to use password authentication your resource needs to meet the following minimum requirements:

There are other options documented in the DSL.

By default the password strategy will automatically generate the register, sign-in, reset-request and reset actions for you, however you're free to define them yourself. If you do, then the action will be validated to ensure that all the needed configuration is present.

If you wish to work with the actions directly from your code you can do so via the AshAuthentication.Strategy protocol.

Interacting with the actions directly:

The password strategy provides plug endpoints for all four actions, although only sign-in and register will be reported by Strategy.routes/1 if the strategy is not configured as resettable.

If you wish to work with the plugs directly, you can do so via the AshAuthentication.Strategy protocol.

Dispatching to plugs directly:

See the Testing guide for tips on testing resources using this strategy.

Strategy for authenticating using local resources as the source of truth.

Configure password reset options for the resource

Target: AshAuthentication.Strategy.Password.Resettable

Target: AshAuthentication.Strategy.Password

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

Example 2 (javascript):
```javascript
iex> strategy = Info.strategy!(Example.User, :password)
...> {:ok, marty} = Strategy.action(strategy, :register, %{"username" => "marty", "password" => "outatime1985", "password_confirmation" => "outatime1985"})
...> marty.username |> to_string()
"marty"

...> {:ok, user} = Strategy.action(strategy, :sign_in, %{"username" => "marty", "password" => "outatime1985"})
...> user.username |> to_string()
"marty"
```

Example 3 (javascript):
```javascript
iex> strategy = Info.strategy!(Example.User, :password)
...> conn = conn(:post, "/user/password/register", %{"user" => %{"username" => "marty", "password" => "outatime1985", "password_confirmation" => "outatime1985"}})
...> conn = Strategy.plug(strategy, :register, conn)
...> {_conn, {:ok, marty}} = Plug.Helpers.get_authentication_result(conn)
...> marty.username |> to_string()
"marty"

...> conn = conn(:post, "/user/password/reset_request", %{"user" => %{"username" => "marty"}})
...> conn = Strategy.plug(strategy, :reset_request, conn)
...> {_conn, :ok} = Plug.Helpers.get_authentication_resul
...
```

Example 4 (unknown):
```unknown
password name \\ :password
```

---

## AshAuthentication.Strategy.Password (ash_authentication v4.12.0)

**URL:** https://hexdocs.pm/ash_authentication/AshAuthentication.Strategy.Password.html

**Contents:**
- AshAuthentication.Strategy.Password (ash_authentication v4.12.0)
  - Example:
- Actions
  - Examples:
- Plugs
  - Examples:
- Testing
- Summary
- Types
- Functions

Strategy for authenticating using local resources as the source of truth.

In order to use password authentication your resource needs to meet the following minimum requirements:

There are other options documented in the DSL.

By default the password strategy will automatically generate the register, sign-in, reset-request and reset actions for you, however you're free to define them yourself. If you do, then the action will be validated to ensure that all the needed configuration is present.

If you wish to work with the actions directly from your code you can do so via the AshAuthentication.Strategy protocol.

Interacting with the actions directly:

The password strategy provides plug endpoints for all four actions, although only sign-in and register will be reported by Strategy.routes/1 if the strategy is not configured as resettable.

If you wish to work with the plugs directly, you can do so via the AshAuthentication.Strategy protocol.

Dispatching to plugs directly:

See the Testing guide for tips on testing resources using this strategy.

Generate a reset token for a user.

Callback implementation for AshAuthentication.Strategy.Custom.transform/2.

Callback implementation for AshAuthentication.Strategy.Custom.verify/2.

Generate a reset token for a user.

Used by AshAuthentication.Strategy.Password.RequestPasswordResetPreparation.

Callback implementation for AshAuthentication.Strategy.Custom.transform/2.

Callback implementation for AshAuthentication.Strategy.Custom.verify/2.

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

Example 2 (javascript):
```javascript
iex> strategy = Info.strategy!(Example.User, :password)
...> {:ok, marty} = Strategy.action(strategy, :register, %{"username" => "marty", "password" => "outatime1985", "password_confirmation" => "outatime1985"})
...> marty.username |> to_string()
"marty"

...> {:ok, user} = Strategy.action(strategy, :sign_in, %{"username" => "marty", "password" => "outatime1985"})
...> user.username |> to_string()
"marty"
```

Example 3 (javascript):
```javascript
iex> strategy = Info.strategy!(Example.User, :password)
...> conn = conn(:post, "/user/password/register", %{"user" => %{"username" => "marty", "password" => "outatime1985", "password_confirmation" => "outatime1985"}})
...> conn = Strategy.plug(strategy, :register, conn)
...> {_conn, {:ok, marty}} = Plug.Helpers.get_authentication_result(conn)
...> marty.username |> to_string()
"marty"

...> conn = conn(:post, "/user/password/reset_request", %{"user" => %{"username" => "marty"}})
...> conn = Strategy.plug(strategy, :reset_request, conn)
...> {_conn, :ok} = Plug.Helpers.get_authentication_resul
...
```

---

## AshAuthentication.Strategy.Slack (ash_authentication v4.12.0)

**URL:** https://hexdocs.pm/ash_authentication/AshAuthentication.Strategy.Slack.html

**Contents:**
- AshAuthentication.Strategy.Slack (ash_authentication v4.12.0)
- More documentation:
- Summary
- Functions
- Functions
- transform(entity, dsl_state)
- verify(strategy, dsl_state)

Strategy for authenticating using Slack

This strategy builds on-top of AshAuthentication.Strategy.Oidc and assent.

In order to use Slack you need to provide the following minimum configuration:

Callback implementation for AshAuthentication.Strategy.Custom.transform/2.

Callback implementation for AshAuthentication.Strategy.Custom.verify/2.

Callback implementation for AshAuthentication.Strategy.Custom.transform/2.

Callback implementation for AshAuthentication.Strategy.Custom.verify/2.

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## AshAuthentication.Strategy.ApiKey (ash_authentication v4.12.0)

**URL:** https://hexdocs.pm/ash_authentication/AshAuthentication.Strategy.ApiKey.html

**Contents:**
- AshAuthentication.Strategy.ApiKey (ash_authentication v4.12.0)
- Security Considerations
- Summary
- Types
- Functions
- Types
- t()
- Functions
- transform(entity, dsl_state)
- verify(strategy, dsl_state)

Strategy for authenticating using an API key.

Responsibility for generating, securing, expiring and revoking lies on the implementor. If you are using API keys, you must ensure that your policies and application are set up to prevent misuse of these keys. For example:

To detect that a user is signed in with an API key, you can see if user.__metadata__[:using_api_key?] is set. If they are signed in, then user.__metadata__[:api_key] will be set to the API key that they used, allowing you to write policies that depend on the permissions granted by the API key.

Callback implementation for AshAuthentication.Strategy.Custom.transform/2.

Callback implementation for AshAuthentication.Strategy.Custom.verify/2.

Callback implementation for AshAuthentication.Strategy.Custom.transform/2.

Callback implementation for AshAuthentication.Strategy.Custom.verify/2.

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
policy AshAuthentication.Checks.UsingApiKey do
  authorize_if action([:a, :list, :of, :allowed, :action, :names])
end
```

---

## AshAuthentication.Strategy.ApiKey.Plug (ash_authentication v4.12.0)

**URL:** https://hexdocs.pm/ash_authentication/AshAuthentication.Strategy.ApiKey.Plug.html

**Contents:**
- AshAuthentication.Strategy.ApiKey.Plug (ash_authentication v4.12.0)
- Summary
- Types
- Functions
- Types
- auth_error()
- source_type()
- Functions
- call(conn, config)
- init(opts)

Plug for authenticating using API keys.

This plug validates API keys from either a query parameter or HTTP header.

Process the connection and attempt to authenticate using the API key.

Initialize the plug with options.

Handles errors that occur during the api key authentication process.

Process the connection and attempt to authenticate using the API key.

Initialize the plug with options.

Handles errors that occur during the api key authentication process.

This function determines the response format based on the Accept header of the incoming request. If the client accepts JSON responses, it returns a JSON-formatted error message. Otherwise, it returns a plain text error message.

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## Upgrading

**URL:** https://hexdocs.pm/ash_authentication/upgrading.html

**Contents:**
- Upgrading
- Upgrading to version 4.0.0
- Upgrading to version 3.6.0.
  - Upgrade steps:
  - Warning

Version 4.0.0 of AshAuthentication adds support for Ash 3.0 and in line with a number of changes in Ash there are some corresponding changes to Ash Authentication:

Token generation is enabled by default, meaning that you will have to explicitly set authentication.tokens.enabled? to false if you don't need them.

Sign in tokens are enabled by default in the password strategy. What this means is that instead of returning a regular user token on sign-in in the user's metadata, we generate a short-lived token which can be used to actually sign the user in. This is specifically to allow live-view based sign-in UIs to display an authentication error without requiring a page-load.

As of version 3.6.0 the TokenResource extension adds the subject attribute which allows us to more easily match tokens to specific users. This unlocks some new use-cases (eg sign out everywhere).

This means that you will need to generate new migrations and migrate your database.

If you already have tokens stored in your database then the migration will likely throw a migration error due to the new NOT NULL constraint on subject. If this happens then you can either delete all your tokens or explicitly add the subject attribute to your resource with allow_nil? set to true. eg:

Hex Package Hex Preview (current file) Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
attributes do
  attribute :subject, :string, allow_nil?: true
end
```

---

## AshAuthentication.Strategy.Google (ash_authentication v4.12.0)

**URL:** https://hexdocs.pm/ash_authentication/AshAuthentication.Strategy.Google.html

**Contents:**
- AshAuthentication.Strategy.Google (ash_authentication v4.12.0)
- More documentation:
- Summary
- Functions
- Functions
- transform(entity, dsl_state)
- verify(strategy, dsl_state)

Strategy for authenticating using Google

This strategy builds on-top of AshAuthentication.Strategy.OAuth2 and assent.

In order to use Google you need to provide the following minimum configuration:

Callback implementation for AshAuthentication.Strategy.Custom.transform/2.

Callback implementation for AshAuthentication.Strategy.Custom.verify/2.

Callback implementation for AshAuthentication.Strategy.Custom.transform/2.

Callback implementation for AshAuthentication.Strategy.Custom.verify/2.

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## AshAuthentication.Strategy.Apple (ash_authentication v4.12.0)

**URL:** https://hexdocs.pm/ash_authentication/AshAuthentication.Strategy.Apple.html

**Contents:**
- AshAuthentication.Strategy.Apple (ash_authentication v4.12.0)
- More documentation:
- Summary
- Functions
- Functions
- transform(entity, dsl_state)
- verify(strategy, dsl_state)

Strategy for authenticating using Apple Sign In

This strategy builds on-top of AshAuthentication.Strategy.Oidc and assent.

In order to use Apple Sign In you need to provide the following minimum configuration:

Callback implementation for AshAuthentication.Strategy.Custom.transform/2.

Callback implementation for AshAuthentication.Strategy.Custom.verify/2.

Callback implementation for AshAuthentication.Strategy.Custom.transform/2.

Callback implementation for AshAuthentication.Strategy.Custom.verify/2.

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## AshAuthentication.Strategy.Custom behaviour (ash_authentication v4.12.0)

**URL:** https://hexdocs.pm/ash_authentication/AshAuthentication.Strategy.Custom.html

**Contents:**
- AshAuthentication.Strategy.Custom behaviour (ash_authentication v4.12.0)
- Summary
- Types
- Callbacks
- Functions
- Types
- entity()
- strategy()
- Callbacks
- transform(strategy, t)

Define your own custom authentication strategy.

See the Custom Strategies guide for more information.

A Strategy DSL Entity.

This is the DSL target for your entity and the struct for which you will implement the AshAuthentication.Strategy protocol.

If your strategy needs to modify either the entity or the parent resource then you can implement this callback.

If your strategy needs to verify either the entity or the parent resource then you can implement this callback.

Sets default values for a DSL schema based on a set of defaults.

A Strategy DSL Entity.

See Spark.Dsl.Entity for more information.

This is the DSL target for your entity and the struct for which you will implement the AshAuthentication.Strategy protocol.

The only required field is resource which will contain the resource module that the strategy has been added to.

Optionally, you can include a strategy_module field if you're reusing another strategy's entity, and thus the __struct__ key can't be used to introspect the location of the transform/2 and verify/2 callbacks.

If your strategy needs to modify either the entity or the parent resource then you can implement this callback.

This callback can return one of three results:

If your strategy needs to verify either the entity or the parent resource then you can implement this callback.

This is called post-compilation in the @after_verify hook - see Module for more information.

This callback can return one of the following results:

Sets default values for a DSL schema based on a set of defaults.

If a given default is in the schema, it can be overriden, so we just set the default and mark it not required.

If not, then we add it to auto_set_fields, and the user cannot override it.

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## AshAuthentication.Strategy.Auth0

**URL:** https://hexdocs.pm/ash_authentication/dsl-ashauthentication-strategy-auth0.html

**Contents:**
- AshAuthentication.Strategy.Auth0
- More documentation:
  - authentication.strategies.auth0
        - More documentation:
        - Strategy defaults:
  - Arguments
  - Options
  - Introspection

Strategy for authenticating using Auth0.

This strategy builds on-top of AshAuthentication.Strategy.OAuth2 and assent.

In order to use Auth0 you need to provide the following minimum configuration:

Provides a pre-configured authentication strategy for Auth0.

This strategy is built using the :oauth2 strategy, and thus provides all the same configuration options should you need them.

The following defaults are applied:

Target: AshAuthentication.Strategy.OAuth2

Hex Package Hex Preview (current file) Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
auth0 name \\ :auth0
```

---

## AshAuthentication.Strategy.Password.RequestPasswordResetPreparation (ash_authentication v4.12.0)

**URL:** https://hexdocs.pm/ash_authentication/AshAuthentication.Strategy.Password.RequestPasswordResetPreparation.html

**Contents:**
- AshAuthentication.Strategy.Password.RequestPasswordResetPreparation (ash_authentication v4.12.0)
- Summary
- Functions
- Functions
- init(opts)
- supports(opts)

Prepare a query for a password reset request.

This preparation performs three jobs, one before the query executes and two after:

Always returns an empty result.

Callback implementation for Ash.Resource.Preparation.init/1.

Callback implementation for Ash.Resource.Preparation.supports/1.

Callback implementation for Ash.Resource.Preparation.init/1.

Callback implementation for Ash.Resource.Preparation.supports/1.

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## AshAuthentication.Strategy.Github (ash_authentication v4.12.0)

**URL:** https://hexdocs.pm/ash_authentication/AshAuthentication.Strategy.Github.html

**Contents:**
- AshAuthentication.Strategy.Github (ash_authentication v4.12.0)
- More documentation:
- Summary
- Functions
- Functions
- transform(entity, dsl_state)
- verify(strategy, dsl_state)

Strategy for authenticating using GitHub

This strategy builds on-top of AshAuthentication.Strategy.OAuth2 and assent.

In order to use GitHub you need to provide the following minimum configuration:

Callback implementation for AshAuthentication.Strategy.Custom.transform/2.

Callback implementation for AshAuthentication.Strategy.Custom.verify/2.

Callback implementation for AshAuthentication.Strategy.Custom.transform/2.

Callback implementation for AshAuthentication.Strategy.Custom.verify/2.

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## AshAuthentication.Strategy.Auth0 (ash_authentication v4.12.0)

**URL:** https://hexdocs.pm/ash_authentication/AshAuthentication.Strategy.Auth0.html

**Contents:**
- AshAuthentication.Strategy.Auth0 (ash_authentication v4.12.0)
- More documentation:
- Summary
- Functions
- Functions
- transform(entity, dsl_state)
- verify(strategy, dsl_state)

Strategy for authenticating using Auth0.

This strategy builds on-top of AshAuthentication.Strategy.OAuth2 and assent.

In order to use Auth0 you need to provide the following minimum configuration:

Callback implementation for AshAuthentication.Strategy.Custom.transform/2.

Callback implementation for AshAuthentication.Strategy.Custom.verify/2.

Callback implementation for AshAuthentication.Strategy.Custom.transform/2.

Callback implementation for AshAuthentication.Strategy.Custom.verify/2.

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## AshAuthentication.Strategy.ApiKey

**URL:** https://hexdocs.pm/ash_authentication/dsl-ashauthentication-strategy-apikey.html

**Contents:**
- AshAuthentication.Strategy.ApiKey
- Security Considerations
  - authentication.strategies.api_key
  - Options
  - Introspection

Strategy for authenticating using an API key.

Responsibility for generating, securing, expiring and revoking lies on the implementor. If you are using API keys, you must ensure that your policies and application are set up to prevent misuse of these keys. For example:

To detect that a user is signed in with an API key, you can see if user.__metadata__[:using_api_key?] is set. If they are signed in, then user.__metadata__[:api_key] will be set to the API key that they used, allowing you to write policies that depend on the permissions granted by the API key.

Strategy for authenticating using api keys

Target: AshAuthentication.Strategy.ApiKey

Hex Package Hex Preview (current file) Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
policy AshAuthentication.Checks.UsingApiKey do
  authorize_if action([:a, :list, :of, :allowed, :action, :names])
end
```

Example 2 (unknown):
```unknown
api_key name \\ :api_key
```

---

## AshAuthentication.Strategy.Password.Resettable (ash_authentication v4.12.0)

**URL:** https://hexdocs.pm/ash_authentication/AshAuthentication.Strategy.Password.Resettable.html

**Contents:**
- AshAuthentication.Strategy.Password.Resettable (ash_authentication v4.12.0)
- Summary
- Types
- Types
- t()

The entity used to store password reset information.

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## AshAuthentication.Strategy.MagicLink.RequestPreparation (ash_authentication v4.12.0)

**URL:** https://hexdocs.pm/ash_authentication/AshAuthentication.Strategy.MagicLink.RequestPreparation.html

**Contents:**
- AshAuthentication.Strategy.MagicLink.RequestPreparation (ash_authentication v4.12.0)
- Summary
- Functions
- Functions
- init(opts)
- supports(opts)

Prepare a query for a magic link request.

This preparation performs three jobs, one before the query executes and two after:

Always returns an empty result.

Callback implementation for Ash.Resource.Preparation.init/1.

Callback implementation for Ash.Resource.Preparation.supports/1.

Callback implementation for Ash.Resource.Preparation.init/1.

Callback implementation for Ash.Resource.Preparation.supports/1.

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## mix ash_authentication.add_strategy (ash_authentication v4.12.0)

**URL:** https://hexdocs.pm/ash_authentication/Mix.Tasks.AshAuthentication.AddStrategy.html

**Contents:**
- mix ash_authentication.add_strategy (ash_authentication v4.12.0)
- Example
- Global options
- Password options
- Summary
- Functions
- Functions
- igniter(igniter)

Adds the provided strategy or strategies to your user resource

This task will add the provided strategy or strategies to your user resource.

The following strategies are available. For all others, see the relevant documentation for setup

Callback implementation for Igniter.Mix.Task.igniter/1.

Callback implementation for Igniter.Mix.Task.igniter/1.

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
mix ash_authentication.add_strategy password
```

---

## Password Authentication

**URL:** https://hexdocs.pm/ash_authentication/password.html

**Contents:**
- Password Authentication
- With a mix task
- Add Bcrypt To your dependencies
- Add Attributes
- Add the password strategy

You can use mix ash_authentication.add_strategy password to install this strategy. The rest of the guide is in the case that you wish to proceed manually.

This step is not strictly necessary, but in the next major version of AshAuthentication, Bcrypt will be an optional dependency. This will make that upgrade slightly easier.

Add an email (or username) and hashed_password attribute to your user resource.

Ensure that the email (or username) is unique.

Configure it to use the :email or :username as the identity field.

Now we have enough in place to register and sign-in users using the AshAuthentication.Strategy protocol.

Hex Package Hex Preview (current file) Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
{:bcrypt_elixir, "~> 3.0"}
```

Example 2 (unknown):
```unknown
# lib/my_app/accounts/user.ex
attributes do
  ...
  attribute :email, :ci_string, allow_nil?: false, public?: true
  attribute :hashed_password, :string, allow_nil?: false, sensitive?: true
end
```

Example 3 (unknown):
```unknown
# lib/my_app/accounts/user.ex
identities do
  identity :unique_email, [:email]
  # or
  identity :unique_username, [:username]
end
```

Example 4 (unknown):
```unknown
# lib/my_app/accounts/user.ex
authentication do
  ...
  strategies do
    password :password do
      identity_field :email
      # or
      identity_field :username
    end
  end
end
```

---

## AshAuthentication.Strategy.OAuth2

**URL:** https://hexdocs.pm/ash_authentication/dsl-ashauthentication-strategy-oauth2.html

**Contents:**
- AshAuthentication.Strategy.OAuth2
  - Example:
- Secrets and runtime configuration
  - Warning
  - Examples:
- User identities
- Actions
  - Sign-in
  - Registration
  - Examples:

Strategy for authenticating using any OAuth 2.0 server as the source of truth.

This authentication strategy provides registration and sign-in for users using a remote OAuth 2.0 server as the source of truth. You will be required to provide either a "register" or a "sign-in" action depending on your configuration, which the strategy will attempt to validate for common misconfigurations.

This strategy wraps the excellent assent package, which provides OAuth 2.0 capabilities.

In order to use OAuth 2.0 authentication on your resource, it needs to meet the following minimum criteria:

In order to use OAuth 2.0 you need to provide a varying number of secrets and other configuration which may change based on runtime environment. The AshAuthentication.Secret behaviour is provided to accommodate this. This allows you to provide configuration either directly on the resource (ie as a string), as an anonymous function, or as a module.

We strongly urge you not to share actual secrets in your code or repository.

Providing configuration as an anonymous function:

Providing configuration as a module:

Because your users can be signed in via multiple providers at once, you can specify an identity_resource in the DSL configuration which points to a seperate Ash resource which has the AshAuthentication.UserIdentity extension present. This resource will be used to store details of the providers in use by each user and a relationship will be added to the user resource.

Setting the identity_resource will cause extra validations to be applied to your resource so that changes are tracked correctly on sign-in or registration.

When using an OAuth 2.0 provider you need to declare either a "register" or "sign-in" action. The reason for this is that it's not possible for us to know ahead of time how you want to manage the link between your user resources and the "user info" provided by the OAuth server.

Both actions receive the following two arguments:

The actions themselves can be interacted with directly via the AshAuthentication.Strategy protocol, but you are more likely to interact with them via the web/plugs.

The sign-in action is called when a successful OAuth2 callback is received. You should use it to constrain the query to the correct user based on the arguments provided.

This action is only needed when the registration_enabled? DSL settings is set to false.

The register action is a little more complicated than the sign-in action, because we cannot tell the differ

*[Content truncated]*

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
  end

  authentication do
    strategies do
      oauth2 :example do
        client_id "OAuth Client ID"
        redirect_uri "https://my.app/"
        client_secret "My Super Secret Secret"
        site "https://auth.example.com/"
      end
    end
  end
end
```

Example 2 (unknown):
```unknown
oauth2 do
  client_secret fn _path, resource ->
    Application.fetch_env(:my_app, resource, :oauth2_client_secret)
  end
end
```

Example 3 (python):
```python
defmodule MyApp.Secrets do
  use AshAuthentication.Secret

  def secret_for([:authentication, :strategies, :example, :client_secret], MyApp.User, _opts), do: Application.fetch_env(:my_app, :oauth2_client_secret)
end

# and in your strategies:

oauth2 :example do
  client_secret MyApp.Secrets
end
```

Example 4 (unknown):
```unknown
defmodule MyApp.Accounts.User do
  attributes do
    uuid_primary_key :id
    attribute :email, :ci_string, allow_nil?: false
  end

  actions do
    read :sign_in_with_example do
      argument :user_info, :map, allow_nil?: false
      argument :oauth_tokens, :map, allow_nil?: false
      prepare AshAuthentication.Strategy.OAuth2.SignInPreparation

      filter expr(email == get_path(^arg(:user_info), [:email]))
    end
  end

  authentication do
    strategies do
      oauth2 :example do
        registration_enabled? false
      end
    end
  end
end
```

---

## AshAuthentication.Strategy.Github

**URL:** https://hexdocs.pm/ash_authentication/dsl-ashauthentication-strategy-github.html

**Contents:**
- AshAuthentication.Strategy.Github
- More documentation:
  - authentication.strategies.github
        - More documentation:
        - Strategy defaults:
  - Arguments
  - Options
  - Introspection

Strategy for authenticating using GitHub

This strategy builds on-top of AshAuthentication.Strategy.OAuth2 and assent.

In order to use GitHub you need to provide the following minimum configuration:

Provides a pre-configured authentication strategy for GitHub.

This strategy is built using the :oauth2 strategy, and thus provides all the same configuration options should you need them.

The following defaults are applied:

Target: AshAuthentication.Strategy.OAuth2

Hex Package Hex Preview (current file) Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
github name \\ :github
```

---

## AshAuthentication.Strategy.Oidc

**URL:** https://hexdocs.pm/ash_authentication/dsl-ashauthentication-strategy-oidc.html

**Contents:**
- AshAuthentication.Strategy.Oidc
- Nonce
- More documentation:
  - authentication.strategies.oidc
        - More documentation:
  - Arguments
  - Options
  - Introspection

Strategy for authentication using an OpenID Connect compatible server as the source of truth.

This strategy builds on-top of AshAuthentication.Strategy.OAuth2 and assent.

In order to use OIDC you need to provide the following minimum configuration:

nonce can be set in the provider config. The nonce will be returned in the session_params along with state. You can use this to store the value in the current session e.g. a httpOnly session cookie.

A random value generator can look like this:

AshAuthentication will dynamically generate one for the session if nonce is set to true.

Provides an OpenID Connect authentication strategy.

This strategy is built using the :oauth2 strategy, and thus provides all the same configuration options should you need them.

Target: AshAuthentication.Strategy.OAuth2

Hex Package Hex Preview (current file) Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
16
|> :crypto.strong_rand_bytes()
|> Base.encode64(padding: false)
```

Example 2 (unknown):
```unknown
oidc name \\ :oidc
```

---

## AshAuthentication.Strategy protocol (ash_authentication v4.12.0)

**URL:** https://hexdocs.pm/ash_authentication/AshAuthentication.Strategy.html

**Contents:**
- AshAuthentication.Strategy protocol (ash_authentication v4.12.0)
- Summary
- Types
- Functions
- Types
- action()
- http_method()
- path()
- phase()
- route()

The protocol used for interacting with authentication strategies.

Any new Authentication strategy must implement this protocol.

The name of an individual action supported by the strategy.

A path to match in web requests

The "phase" of the request.

All the types that implement this protocol.

Perform an named action.

Return a list of actions supported by the strategy.

Return the HTTP method for a phase.

The "short name" of the strategy, used for genererating routes, etc.

Return a list of phases supported by the strategy.

Handle requests routed to the strategy.

Used to build the routing table to route web requests to request phases for each strategy.

Indicates that the strategy creates or consumes tokens.

The name of an individual action supported by the strategy.

This maybe not be the action name on the underlying resource, which may be generated, but the name that the strategy itself calls the action.

A path to match in web requests

The "phase" of the request.

Usually :request or :callback but can be any atom.

Eg: {"/user/password/sign_in", :sign_in}

All the types that implement this protocol.

Perform an named action.

Different strategies are likely to implement a number of different actions depending on their configuration. Calling them via this function will ensure that the context is correctly set, etc.

See actions/1 for a list of actions provided by the strategy.

Any options passed to the action will be passed to the underlying Ash.Domain function.

Return a list of actions supported by the strategy.

Return the HTTP method for a phase.

The "short name" of the strategy, used for genererating routes, etc.

This is most likely the same value that you use for the entity's name argument.

Return a list of phases supported by the strategy.

Handle requests routed to the strategy.

Each phase will be an atom (ie the second element in the route tuple).

See phases/1 for a list of phases supported by the strategy.

Used to build the routing table to route web requests to request phases for each strategy.

Indicates that the strategy creates or consumes tokens.

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
iex> strategy = Info.strategy!(Example.User, :password)
...> actions(strategy)
[:sign_in_with_token, :register, :sign_in, :reset_request, :reset]
```

Example 2 (unknown):
```unknown
iex> strategy = Info.strategy!(Example.User, :oauth2)
...> method_for_phase(strategy, :request)
:get
```

Example 3 (unknown):
```unknown
iex> strategy = Info.strategy!(Example.User, :password)
...> phases(strategy)
[:sign_in_with_token, :register, :sign_in, :reset_request, :reset]
```

Example 4 (unknown):
```unknown
iex> strategy = Info.strategy!(Example.User, :password)
...> routes(strategy)
[
  {"/user/password/sign_in_with_token", :sign_in_with_token},
  {"/user/password/register", :register},
  {"/user/password/sign_in", :sign_in},
  {"/user/password/reset_request", :reset_request},
  {"/user/password/reset", :reset}
]
```

---

## AshAuthentication.Strategy.OAuth2 (ash_authentication v4.12.0)

**URL:** https://hexdocs.pm/ash_authentication/AshAuthentication.Strategy.OAuth2.html

**Contents:**
- AshAuthentication.Strategy.OAuth2 (ash_authentication v4.12.0)
  - Example:
- Secrets and runtime configuration
  - Warning
  - Examples:
- User identities
- Actions
  - Sign-in
  - Registration
  - Examples:

Strategy for authenticating using any OAuth 2.0 server as the source of truth.

This authentication strategy provides registration and sign-in for users using a remote OAuth 2.0 server as the source of truth. You will be required to provide either a "register" or a "sign-in" action depending on your configuration, which the strategy will attempt to validate for common misconfigurations.

This strategy wraps the excellent assent package, which provides OAuth 2.0 capabilities.

In order to use OAuth 2.0 authentication on your resource, it needs to meet the following minimum criteria:

In order to use OAuth 2.0 you need to provide a varying number of secrets and other configuration which may change based on runtime environment. The AshAuthentication.Secret behaviour is provided to accommodate this. This allows you to provide configuration either directly on the resource (ie as a string), as an anonymous function, or as a module.

We strongly urge you not to share actual secrets in your code or repository.

Providing configuration as an anonymous function:

Providing configuration as a module:

Because your users can be signed in via multiple providers at once, you can specify an identity_resource in the DSL configuration which points to a seperate Ash resource which has the AshAuthentication.UserIdentity extension present. This resource will be used to store details of the providers in use by each user and a relationship will be added to the user resource.

Setting the identity_resource will cause extra validations to be applied to your resource so that changes are tracked correctly on sign-in or registration.

When using an OAuth 2.0 provider you need to declare either a "register" or "sign-in" action. The reason for this is that it's not possible for us to know ahead of time how you want to manage the link between your user resources and the "user info" provided by the OAuth server.

Both actions receive the following two arguments:

The actions themselves can be interacted with directly via the AshAuthentication.Strategy protocol, but you are more likely to interact with them via the web/plugs.

The sign-in action is called when a successful OAuth2 callback is received. You should use it to constrain the query to the correct user based on the arguments provided.

This action is only needed when the registration_enabled? DSL settings is set to false.

The register action is a little more complicated than the sign-in action, because we cannot tell the differ

*[Content truncated]*

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
  end

  authentication do
    strategies do
      oauth2 :example do
        client_id "OAuth Client ID"
        redirect_uri "https://my.app/"
        client_secret "My Super Secret Secret"
        site "https://auth.example.com/"
      end
    end
  end
end
```

Example 2 (unknown):
```unknown
oauth2 do
  client_secret fn _path, resource ->
    Application.fetch_env(:my_app, resource, :oauth2_client_secret)
  end
end
```

Example 3 (python):
```python
defmodule MyApp.Secrets do
  use AshAuthentication.Secret

  def secret_for([:authentication, :strategies, :example, :client_secret], MyApp.User, _opts), do: Application.fetch_env(:my_app, :oauth2_client_secret)
end

# and in your strategies:

oauth2 :example do
  client_secret MyApp.Secrets
end
```

Example 4 (unknown):
```unknown
defmodule MyApp.Accounts.User do
  attributes do
    uuid_primary_key :id
    attribute :email, :ci_string, allow_nil?: false
  end

  actions do
    read :sign_in_with_example do
      argument :user_info, :map, allow_nil?: false
      argument :oauth_tokens, :map, allow_nil?: false
      prepare AshAuthentication.Strategy.OAuth2.SignInPreparation

      filter expr(email == get_path(^arg(:user_info), [:email]))
    end
  end

  authentication do
    strategies do
      oauth2 :example do
        registration_enabled? false
      end
    end
  end
end
```

---

## Defining Custom Authentication Strategies

**URL:** https://hexdocs.pm/ash_authentication/custom-strategy.html

**Contents:**
- Defining Custom Authentication Strategies
    - Add-on vs Strategy?
- DSL setup
- Implementing the AshAuthentication.Strategy protocol
    - Warning
- Bonus round - transformers and verifiers
  - Transformers
  - Verifiers
- Summary

AshAuthentication allows you to bring your own authentication strategy without having to change the Ash Authentication codebase.

There is functionally no difference between "add ons" and "strategies" other than where they appear in the DSL. We invented "add ons" because it felt weird calling "confirmation" an authentication strategy.

There are several moving parts which must all work together so hold on to your hat!

We're going to define an extremely dumb strategy which lets anyone with a name that starts with "Marty" sign in with just their name. Of course you would never do this in real life, but this isn't real life - it's documentation!

Let's start by defining a module for our strategy to live in. Let's call it OnlyMartiesAtTheParty:

Sadly, this isn't enough to make the magic happen. We need to define our DSL entity by adding it to the use statement:

If you haven't you should take a look at the docs for Spark.Dsl.Entity, but here's a brief overview of what each field we've set does:

By default the entity is added to the authentication / strategy DSL, however if you want it in the authentication / add_ons DSL instead you can also pass style: :add_on in the use statement.

Next up, we need to define our struct. The struct should have at least the fields named in the entity schema. Additionally, Ash Authentication requires that it have a resource field which will be set to the module of the resource it's attached to during compilation.

Now it would be theoretically possible to add this custom strategies to your app by adding it to the extensions section of your resource:

The Strategy protocol is used to introspect the strategy so that it can seamlessly fit in with the rest of Ash Authentication. Here are the key concepts:

Given this information, let's implement the strategy. It's quite long, so I'm going to break it up into smaller chunks.

The name/1 function is used to uniquely identify the strategy. It must be an atom and should be the same as the path fragment used in the generated routes.

Since our strategy only supports sign-in we only need a single :sign_in phase and action.

Next we generate the routes for the strategy. Routes should contain the subject name of the resource being authenticated in case the implementer is authenticating multiple different resources - eg User and Admin.

When generating routes or forms for this phase, what HTTP method should we use?

Next up, we write our plug. We take the "name field" from the input param

*[Content truncated]*

**Examples:**

Example 1 (unknown):
```unknown
defmodule OnlyMartiesAtTheParty do
  use AshAuthentication.Strategy.Custom
end
```

Example 2 (unknown):
```unknown
defmodule OnlyMartiesAtTheParty do
  @entity %Spark.Dsl.Entity{
    name: :only_marty,
    describe: "Strategy which only allows folks whose name starts with \"Marty\" to sign in.",
    examples: [
      """
      only_marty do
        case_sensitive? true
        name_field :name
      end
      """
    ],
    target: __MODULE__,
    args: [{:optional, :name, :marty}],
    schema: [
      name: [
        type: :atom,
        doc: """
        The strategy name.
        """,
        required: true
      ],
      case_sensitive?: [
        type: :boolean,
        doc: """
        Ignore letter c
...
```

Example 3 (unknown):
```unknown
defmodule OnlyMartiesAtTheParty do
  defstruct name: :marty,
            case_sensitive?: false,
            name_field: nil,
            resource: nil,
            __spark_metadata__: nil

  # ...

  use AshAuthentication.Strategy.Custom, entity: @entity

  # other code elided ...
end
```

Example 4 (unknown):
```unknown
defmodule MyApp.Accounts.User do
  use Ash.Resource,
    extensions: [AshAuthentication, OnlyMartiesAtTheParty],
    domain: MyApp.Accounts

  authentication do
    strategies do
      only_marty do
        name_field :name
      end
    end
  end

  attributes do
    uuid_primary_key
    attribute :name, :string, allow_nil?: false
  end
end
```

---

## AshAuthentication.Strategy.ApiKey.GenerateApiKey (ash_authentication v4.12.0)

**URL:** https://hexdocs.pm/ash_authentication/AshAuthentication.Strategy.ApiKey.GenerateApiKey.html

**Contents:**
- AshAuthentication.Strategy.ApiKey.GenerateApiKey (ash_authentication v4.12.0)
- Options

Generates a random API key for a user.

The API key is generated using a random byte string and a prefix. The prefix is used to generate a key that is compliant with secret scanning. You can use this to set up an endpoint that will automatically revoke leaked tokens, which is an extremely powerful and useful security feature.

See the guide on Github for more information.

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## AshAuthentication.Strategy.MagicLink (ash_authentication v4.12.0)

**URL:** https://hexdocs.pm/ash_authentication/AshAuthentication.Strategy.MagicLink.html

**Contents:**
- AshAuthentication.Strategy.MagicLink (ash_authentication v4.12.0)
  - Example
- Tenancy
- Actions
  - Examples
- Usage with AshAuthenticationPhoenix
- Plugs
  - Examples:
- Summary
- Types

Strategy for authentication using a magic link.

In order to use magic link authentication your resource needs to meet the following minimum requirements:

There are other options documented in the DSL.

Note that the tenant is provided to the sender in the opts key. Use this if you need to modify the url (i.e tenant.app.com) based on the tenant that requested the token.

By default the magic link strategy will automatically generate the request and sign-in actions for you, however you're free to define them yourself. If you do, then the action will be validated to ensure that all the needed configuration is present.

If you wish to work with the actions directly from your code you can do so via the AshAuthentication.Strategy protocol.

Requesting that a magic link token is sent for a user:

Signing in using a magic link token:

If you are using AshAuthenticationPhoenix, and have require_authentication? set to true, which you very much should, then you will need to add a magic_sign_in_route to your router. This is placed in the same location as auth_routes, and should be provided the user and the strategy name. For example:

The magic link strategy provides plug endpoints for both request and sign-in actions.

If you wish to work with the plugs directly, you can do so via the AshAuthentication.Strategy protocol.

Dispatching to plugs directly:

See the Magic Link Tutorial for more information.

Generate a magic link token for a user.

Generate a magic link token for an identity field.

Callback implementation for AshAuthentication.Strategy.Custom.transform/2.

Callback implementation for AshAuthentication.Strategy.Custom.verify/2.

Generate a magic link token for a user.

Used by AshAuthentication.Strategy.MagicLink.RequestPreparation.

Generate a magic link token for an identity field.

Used by AshAuthentication.Strategy.MagicLink.RequestPreparation.

Callback implementation for AshAuthentication.Strategy.Custom.transform/2.

Callback implementation for AshAuthentication.Strategy.Custom.verify/2.

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
  end

  authentication do
    strategies do
      magic_link do
        identity_field :email
        sender fn user_or_email, token, _opts ->
          # will be a user if the token relates to an existing user
          # will be an email if there is no matching user (such as during sign up)
          # opts will contain the `tenant` key, use this if you need to alter the link based
 
...
```

Example 2 (javascript):
```javascript
iex> strategy = Info.strategy!(Example.User, :magic_link)
...> user = build_user()
...> Strategy.action(strategy, :request, %{"username" => user.username})
:ok
```

Example 3 (javascript):
```javascript
...> {:ok, token} = MagicLink.request_token_for(strategy, user)
...> {:ok, signed_in_user} = Strategy.action(strategy, :sign_in, %{"token" => token})
...> signed_in_user.id == user
true
```

Example 4 (unknown):
```unknown
# Remove this if you do not want to use the magic link strategy
magic_sign_in_route(
  MyApp.Accounts.User,
  :sign_in,
  auth_routes_prefix: "/auth",
  overrides: [MyApp.AuthOverrides, AshAuthentication.Phoenix.Overrides.Default]
)
```

---

## AshAuthentication.Strategy.Custom.Helpers (ash_authentication v4.12.0)

**URL:** https://hexdocs.pm/ash_authentication/AshAuthentication.Strategy.Custom.Helpers.html

**Contents:**
- AshAuthentication.Strategy.Custom.Helpers (ash_authentication v4.12.0)
- Summary
- Functions
- Functions
- put_add_on(dsl_state, strategy)
- put_strategy(dsl_state, strategy)
- register_strategy_actions(action, dsl_state, strategy)

Helpers for use within custom strategies.

Update the add-on in the DSL state by name.

Update the strategy in the DSL state by name.

If there's any chance that an implementor may try and use actions genrated by your strategy programatically then you should register your actions with Ash Authentication so that it can find the appropriate strategy when needed.

Update the add-on in the DSL state by name.

This helper should only be used within transformers.

Update the strategy in the DSL state by name.

This helper should only be used within transformers.

If there's any chance that an implementor may try and use actions genrated by your strategy programatically then you should register your actions with Ash Authentication so that it can find the appropriate strategy when needed.

The strategy can be retrieved again by calling AshAuthentication.Info.strategy_for_action/2.

This helper should only be used within transformers.

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## AshAuthentication.Strategy.Google

**URL:** https://hexdocs.pm/ash_authentication/dsl-ashauthentication-strategy-google.html

**Contents:**
- AshAuthentication.Strategy.Google
- More documentation:
  - authentication.strategies.google
    - More documentation:
        - Strategy defaults:
  - Arguments
  - Options
  - Introspection

Strategy for authenticating using Google

This strategy builds on-top of AshAuthentication.Strategy.OAuth2 and assent.

In order to use Google you need to provide the following minimum configuration:

Provides a pre-configured authentication strategy for Google.

This strategy is built using the :oauth2 strategy, and thus provides all the same configuration options should you need them.

The following defaults are applied:

Target: AshAuthentication.Strategy.OAuth2

Hex Package Hex Preview (current file) Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
google name \\ :google
```

---

## AshAuthentication.Strategy.Oidc (ash_authentication v4.12.0)

**URL:** https://hexdocs.pm/ash_authentication/AshAuthentication.Strategy.Oidc.html

**Contents:**
- AshAuthentication.Strategy.Oidc (ash_authentication v4.12.0)
- Nonce
- More documentation:
- Summary
- Functions
- Functions
- transform(entity, dsl_state)
- verify(strategy, dsl_state)

Strategy for authentication using an OpenID Connect compatible server as the source of truth.

This strategy builds on-top of AshAuthentication.Strategy.OAuth2 and assent.

In order to use OIDC you need to provide the following minimum configuration:

nonce can be set in the provider config. The nonce will be returned in the session_params along with state. You can use this to store the value in the current session e.g. a httpOnly session cookie.

A random value generator can look like this:

AshAuthentication will dynamically generate one for the session if nonce is set to true.

Callback implementation for AshAuthentication.Strategy.Custom.transform/2.

Callback implementation for AshAuthentication.Strategy.Custom.verify/2.

Callback implementation for AshAuthentication.Strategy.Custom.transform/2.

Callback implementation for AshAuthentication.Strategy.Custom.verify/2.

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
16
|> :crypto.strong_rand_bytes()
|> Base.encode64(padding: false)
```

---

## AshAuthentication.Strategy.Apple

**URL:** https://hexdocs.pm/ash_authentication/dsl-ashauthentication-strategy-apple.html

**Contents:**
- AshAuthentication.Strategy.Apple
- More documentation:
  - authentication.strategies.apple
    - More documentation:
        - Strategy defaults:
  - Arguments
  - Options
  - Introspection

Strategy for authenticating using Apple Sign In

This strategy builds on-top of AshAuthentication.Strategy.Oidc and assent.

In order to use Apple Sign In you need to provide the following minimum configuration:

Provides a pre-configured authentication strategy for Apple Sign In.

This strategy is built using the :oidc strategy, and thus provides all the same configuration options should you need them.

The following defaults are applied:

Target: AshAuthentication.Strategy.OAuth2

Hex Package Hex Preview (current file) Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
apple name \\ :apple
```

---

## AshAuthentication.Strategy.Slack

**URL:** https://hexdocs.pm/ash_authentication/dsl-ashauthentication-strategy-slack.html

**Contents:**
- AshAuthentication.Strategy.Slack
- More documentation:
  - authentication.strategies.slack
        - More documentation:
        - Strategy defaults:
  - Arguments
  - Options
  - Introspection

Strategy for authenticating using Slack

This strategy builds on-top of AshAuthentication.Strategy.Oidc and assent.

In order to use Slack you need to provide the following minimum configuration:

Provides a pre-configured authentication strategy for Slack.

This strategy is built using the :oauth2 strategy, and thus provides all the same configuration options should you need them.

The following defaults are applied:

Target: AshAuthentication.Strategy.OAuth2

Hex Package Hex Preview (current file) Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
slack name \\ :slack
```

---

## AshAuthentication.Strategy.Oidc.NonceGenerator (ash_authentication v4.12.0)

**URL:** https://hexdocs.pm/ash_authentication/AshAuthentication.Strategy.Oidc.NonceGenerator.html

**Contents:**
- AshAuthentication.Strategy.Oidc.NonceGenerator (ash_authentication v4.12.0)

An implmentation of AshAuthentication.Secret that generates nonces for OpenID Connect strategies.

Defaults to 16 bytes of random data. You can change this by setting the byte_size option in your DSL:

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
oidc do
  nonce {AshAuthentication.NonceGenerator, byte_size: 32}
  # ...
end
```

---
