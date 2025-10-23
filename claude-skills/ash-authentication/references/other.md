# Ash-Authentication - Other

**Pages:** 17

---

## AshAuthentication.AddOn.Confirmation

**URL:** https://hexdocs.pm/ash_authentication/dsl-ashauthentication-addon-confirmation.html

**Contents:**
- AshAuthentication.AddOn.Confirmation
- Example
- Attributes
- Actions
  - Example
- Usage with AshAuthenticationPhoenix
- Plugs
  - Example
  - authentication.add_ons.confirmation
  - Arguments

Confirmation support.

Sometimes when creating a new user, or changing a sensitive attribute (such as their email address) you may want to wait for the user to confirm by way of sending them a confirmation token to prove that it was really them that took the action.

In order to add confirmation to your resource, it must been the following minimum requirements:

A confirmed_at attribute will be added to your resource if it's not already present (see confirmed_at_field in the DSL documentation).

By default confirmation will add an action which updates the confirmed_at attribute as well as retrieving previously stored changes and applying them to the resource.

If you wish to perform the confirm action directly from your code you can do so via the AshAuthentication.Strategy protocol.

If you are using AshAuthenticationPhoenix, and have require_interaction? set to true, which you very much should, then you will need to add a confirm_route to your router. This is placed in the same location as auth_routes, and should be provided the user and the strategy name. For example:

Confirmation provides a single endpoint for the :confirm phase. If you wish to interact with the plugs directly, you can do so via the AshAuthentication.Strategy protocol.

User confirmation flow

Target: AshAuthentication.AddOn.Confirmation

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
    add_ons do
      confirmation :confirm do
        monitor_fields [:email]
        sender MyApp.ConfirmationSender
      end
    end

    strategies do
      # ...
    end
  end

  identities do
    identity :email, [:email]
  end
end
```

Example 2 (javascript):
```javascript
iex> strategy = Info.strategy!(Example.User, :confirm)
...> {:ok, user} = Strategy.action(strategy, :confirm, %{"confirm" => confirmation_token()})
...> user.confirmed_at >= one_second_ago()
true
```

Example 3 (unknown):
```unknown
# Remove this if you do not want to use the confirmation strategy
confirm_route(
  MyApp.Accounts.User,
  :confirm_new_user,
  auth_routes_prefix: "/auth",
  overrides: [MyApp.AuthOverrides, AshAuthentication.Phoenix.Overrides.Default]
)
```

Example 4 (javascript):
```javascript
iex> strategy = Info.strategy!(Example.User, :confirm)
...> conn = conn(:get, "/user/confirm", %{"confirm" => confirmation_token()})
...> conn = Strategy.plug(strategy, :confirm, conn)
...> {_conn, {:ok, user}} = Plug.Helpers.get_authentication_result(conn)
...> user.confirmed_at >= one_second_ago()
true
```

---

## AshAuthentication.AddOn.AuditLog (ash_authentication v4.12.0)

**URL:** https://hexdocs.pm/ash_authentication/AshAuthentication.AddOn.AuditLog.html

**Contents:**
- AshAuthentication.AddOn.AuditLog (ash_authentication v4.12.0)
- Example
- Summary
- Types
- Functions
- Types
- t()
- Functions
- transform(entity, dsl)
- verify(strategy, dsl)

Audit logging support.

Provides audit-logging support for authentication strategies by adding changes and preparations to all their actions.

In order to use this add-on you must have at least one resource configured with the AshAuthentication.AuditLogResource extension added.

Callback implementation for AshAuthentication.Strategy.Custom.transform/2.

Callback implementation for AshAuthentication.Strategy.Custom.verify/2.

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

  authentication do
    add_ons do
      audit_log do
        audit_log_resource MyApp.Accounts.AuditLog
      end
    end
  end
end
```

---

## AshAuthentication.UserIdentity (ash_authentication v4.12.0)

**URL:** https://hexdocs.pm/ash_authentication/AshAuthentication.UserIdentity.html

**Contents:**
- AshAuthentication.UserIdentity (ash_authentication v4.12.0)
- Storage
- Usage
- Summary
- Functions
- Functions
- user_identity(body)

An Ash extension which generates the default user identities resource.

If you plan to support multiple different strategies at once (eg giving your users the choice of more than one authentication provider, or signing them into multiple services simultaneously) then you will want to create a resource with this extension enabled. It is used to keep track of the links between your local user records and their many remote identities.

The user identities resource is used to store information returned by remote authentication strategies (such as those provided by OAuth2) and maps them to your user resource(s). This provides the following benefits:

User identities are expected to be relatively long-lived (although they're deleted on log out), so should probably be stored using a permanent data layer such as ash_postgres.

There is no need to define any attributes, etc. The extension will generate them all for you. As there is no other use-case for this resource it's unlikely that you will need to customise it.

If you intend to operate with multiple user resources, you will need to define multiple user identity resources.

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
defmodule MyApp.Accounts.UserIdentity do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshAuthentication.UserIdentity],
    domain: MyApp.Accounts

  user_identity do
    user_resource MyApp.Accounts.User
  end

  postgres do
    table "user_identities"
    repo MyApp.Repo
  end
end
```

---

## AshAuthentication.Errors.AuthenticationFailed exception (ash_authentication v4.12.0)

**URL:** https://hexdocs.pm/ash_authentication/AshAuthentication.Errors.AuthenticationFailed.html

**Contents:**
- AshAuthentication.Errors.AuthenticationFailed exception (ash_authentication v4.12.0)
- Summary
- Types
- Functions
- Types
- t()
- Functions
- exception(args)
- Keys

A generic, authentication failed error.

Create an Elixir.AshAuthentication.Errors.AuthenticationFailed without raising it.

Create an Elixir.AshAuthentication.Errors.AuthenticationFailed without raising it.

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## Testing

**URL:** https://hexdocs.pm/ash_authentication/testing.html

**Contents:**
- Testing
- When using the Password strategy
- Testing authenticated LiveViews

Tips and tricks to help test your apps.

AshAuthentication uses bcrypt_elixir for hashing passwords for secure storage, which by design has a high computational cost. To reduce the cost (make hashing faster), you can reduce the number of computation rounds it performs in tests:

In order to test authenticated LiveViews, you will need to seed a test user and log in it. While you may certainly use a helper that logs in through the UI each time, it's a little more efficient to call the sign-in code directly.

This can be done by adding a helper function in MyAppWeb.ConnCase found in test/support/conn_case.ex. In this example it's called register_and_log_in_user.

Now in your LiveView tests you can pass this function to setup:

If required, it can also be called directly inside a test block:

Hex Package Hex Preview (current file) Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
# in config/test.exs

# Do NOT set this value for production
config :bcrypt_elixir, log_rounds: 1
```

Example 2 (python):
```python
defmodule MyAppWeb.ConnCase do
  use ExUnit.CaseTemplate

  using do
    # ...
  end

  def register_and_log_in_user(%{conn: conn} = context) do
    email = "user@example.com"
    password = "password"
    {:ok, hashed_password} = AshAuthentication.BcryptProvider.hash(password)

    Ash.Seed.seed!(MyApp.Accounts.User, %{
      email: email,
      hashed_password: hashed_password
    })

    # Replace `:password` with the appropriate strategy for your application.
    strategy = AshAuthentication.Info.strategy!(MyApp.Accounts.User, :password)

    {:ok, user} =
      AshAuthentication.Strategy.
...
```

Example 3 (unknown):
```unknown
defmodule MyAppWeb.MyLiveTest do
  use MyAppWeb.ConnCase

  setup :register_and_log_in_user

  test "some test", %{conn: conn} do
    {:ok, lv, _html} = live(conn, ~p"/authenticated-route")

    # ...
  end
end
```

Example 4 (unknown):
```unknown
test "some test", context do
  %{conn: conn} = register_and_log_in_user(context)

  {:ok, lv, _html} = live(conn, ~p"/authenticated-route")

  # ...
end
```

---

## AshAuthentication.Supervisor (ash_authentication v4.12.0)

**URL:** https://hexdocs.pm/ash_authentication/AshAuthentication.Supervisor.html

**Contents:**
- AshAuthentication.Supervisor (ash_authentication v4.12.0)
- Example
- Summary
- Functions
- Functions
- child_spec(init_arg)

Starts and manages any processes required by AshAuthentication.

Add to your application supervisor:

Returns a specification to start this module under a supervisor.

Returns a specification to start this module under a supervisor.

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

**Examples:**

Example 1 (python):
```python
defmodule MyApp.Application do
  use Application

  def start(_type, _args) do
    children = [
      {AshAuthentication.Supervisor, otp_app: :my_app}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: MyApp.Supervisor)
  end
end
```

---

## Policies on Authenticated Resources

**URL:** https://hexdocs.pm/ash_authentication/policies-on-authentication-resources.html

**Contents:**
- Policies on Authenticated Resources

Typically, we want to lock down our User resource pretty heavily, which, in Ash, involves writing policies. However, AshAuthentication will be calling actions on your user/token resources. To make this more convenient, all actions run with AshAuthentication will set a special context. Additionally a check is provided that will check if that context has been set: AshAuthentication.Checks.AshAuthenticationInteraction. Using this you can write a simple bypass policy on your user/token resources like so:

Hex Package Hex Preview (current file) Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
policies do
  bypass always() do
    authorize_if AshAuthentication.Checks.AshAuthenticationInteraction
  end

  # or, pick your poison

  bypass AshAuthentication.Checks.AshAuthenticationInteraction do
    authorize_if always()
  end
end
```

---

## AshAuthentication.AuditLogResource (ash_authentication v4.12.0)

**URL:** https://hexdocs.pm/ash_authentication/AshAuthentication.AuditLogResource.html

**Contents:**
- AshAuthentication.AuditLogResource (ash_authentication v4.12.0)
- Storage
- Usage
- Batched writes
- Removing old records
- Summary
- Functions
- Functions
- audit_log(body)
- log_activity(strategy, params)

This is an Ash resource extension which generates the default audit log resource.

The audit log resource is used to store user interactions with the authentication system in order to derive extra security behaviour from this information.

The information stored in this resource is essentially time-series, and should be stored in a resilient data-layer such as postgres.

There is no need to define any attributes or actions (thought you can if you want). The extension will wire up everything that's needed for the audit log to function.

Whilst it is possible to have multiple audit log resources, there is no need to do so.

In order to reduce the write load on the database writes to the audit log (via the AuditLogResource.log_activity/2 function) will be buffered in a GenServer and written in batches.

Batching can be disabled entirely by setting audit_log.write_batching.enabled? to false. By default it write a batch every 100 records or every 10 seconds, whichever happens first. This can also be controlled by options in the audit_log.write_batching DSL.

When the log_lifetime DSL option is set to a positive integer then log entries will be automatically removed after that many days. To disable this behaviour, or to manage it manually set it to :infinity. Defaults to 90 days.

Log an authentication event into the audit logger.

Log an authentication event into the audit logger.

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
defmodule MyApp.Accounts.AuditLog do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshAuthentication.AuditLogResource],
    domain: MyApp.Accounts


  postgres do
    table "account_audit_log"
    repo MyApp.Repo
  end
end
```

---

## AshAuthentication.UserIdentity

**URL:** https://hexdocs.pm/ash_authentication/dsl-ashauthentication-useridentity.html

**Contents:**
- AshAuthentication.UserIdentity
- Storage
- Usage
- user_identity
  - Options

An Ash extension which generates the default user identities resource.

If you plan to support multiple different strategies at once (eg giving your users the choice of more than one authentication provider, or signing them into multiple services simultaneously) then you will want to create a resource with this extension enabled. It is used to keep track of the links between your local user records and their many remote identities.

The user identities resource is used to store information returned by remote authentication strategies (such as those provided by OAuth2) and maps them to your user resource(s). This provides the following benefits:

User identities are expected to be relatively long-lived (although they're deleted on log out), so should probably be stored using a permanent data layer such as ash_postgres.

There is no need to define any attributes, etc. The extension will generate them all for you. As there is no other use-case for this resource it's unlikely that you will need to customise it.

If you intend to operate with multiple user resources, you will need to define multiple user identity resources.

Configure identity options for this resource

Hex Package Hex Preview (current file) Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
defmodule MyApp.Accounts.UserIdentity do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshAuthentication.UserIdentity],
    domain: MyApp.Accounts

  user_identity do
    user_resource MyApp.Accounts.User
  end

  postgres do
    table "user_identities"
    repo MyApp.Repo
  end
end
```

---

## AshAuthentication.Checks.AshAuthenticationInteraction (ash_authentication v4.12.0)

**URL:** https://hexdocs.pm/ash_authentication/AshAuthentication.Checks.AshAuthenticationInteraction.html

**Contents:**
- AshAuthentication.Checks.AshAuthenticationInteraction (ash_authentication v4.12.0)
- Summary
- Functions
- Functions
- eager_evaluate?()
- prefer_expanded_description?()
- requires_original_data?(_, _)
- strict_check(actor, context, opts)
- type()

This check is true if the context private.ash_authentication? is set to true.

This context will only ever be set in code that is called internally by ash_authentication, allowing you to create a bypass in your policies on your user/user_token resources.

Callback implementation for Ash.Policy.Check.eager_evaluate?/0.

Callback implementation for Ash.Policy.Check.prefer_expanded_description?/0.

Callback implementation for Ash.Policy.Check.requires_original_data?/2.

Callback implementation for Ash.Policy.Check.strict_check/3.

Callback implementation for Ash.Policy.Check.type/0.

Callback implementation for Ash.Policy.Check.eager_evaluate?/0.

Callback implementation for Ash.Policy.Check.prefer_expanded_description?/0.

Callback implementation for Ash.Policy.Check.requires_original_data?/2.

Callback implementation for Ash.Policy.Check.strict_check/3.

Callback implementation for Ash.Policy.Check.type/0.

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
policies do
  bypass AshAuthenticationInteraction do
    authorize_if always()
  end
end
```

---

## AshAuthentication.Info (ash_authentication v4.12.0)

**URL:** https://hexdocs.pm/ash_authentication/AshAuthentication.Info.html

**Contents:**
- AshAuthentication.Info (ash_authentication v4.12.0)
- Summary
- Types
- Functions
- Types
- dsl_or_resource()
- Functions
- authentication_add_ons(dsl_or_extended)
- authentication_domain(dsl_or_extended)
- authentication_domain!(dsl_or_extended)

Generated configuration functions based on a resource's DSL configuration.

authentication.add_ons DSL entities

The name of the Ash domain to use to access this resource when doing anything authentication related.

The name of the Ash domain to use to access this resource when doing anything authentication related.

The name of the read action used to retrieve records. If the action doesn't exist, one will be generated for you.

The name of the read action used to retrieve records. If the action doesn't exist, one will be generated for you.

authentication DSL options

authentication.providers DSL entities

A list of fields that we will ensure are selected whenever a sender will be invoked. Defaults to [:email] if there is an :email attribute on the resource, and [] otherwise.

A list of fields that we will ensure are selected whenever a sender will be invoked. Defaults to [:email] if there is an :email attribute on the resource, and [] otherwise.

How to uniquely identify a session. Only necessary if require_token_presence_for_authentication? is not set to true. Should always be :jti, if set.

How to uniquely identify a session. Only necessary if require_token_presence_for_authentication? is not set to true. Should always be :jti, if set.

authentication.strategies DSL entities

The subject name is used anywhere that a short version of your resource name is needed. Must be unique system-wide and will be inferred from the resource name by default (ie MyApp.Accounts.User -> user).

The subject name is used anywhere that a short version of your resource name is needed. Must be unique system-wide and will be inferred from the resource name by default (ie MyApp.Accounts.User -> user).

Should JWTs be generated by this resource?

authentication.tokens DSL options

Require a locally-stored token for authentication. See the tokens guide for more.

The algorithm to use for token signing. Available signing algorithms are; EdDSA, Ed448ph, Ed448, Ed25519ph, Ed25519, PS512, PS384, PS256, ES512, ES384, ES256, RS512, RS384, RS256, HS512, HS384 and HS256.

The algorithm to use for token signing. Available signing algorithms are; EdDSA, Ed448ph, Ed448, Ed25519ph, Ed25519, PS512, PS384, PS256, ES512, ES384, ES256, RS512, RS384, RS256, HS512, HS384 and HS256.

The secret used to sign tokens. Takes either a module which implements the AshAuthentication.Secret behaviour, a 2 arity anonymous function or a string.

The secret used to sign tokens. Takes either a module which im

*[Content truncated]*

**Examples:**

Example 1 (unknown):
```unknown
change {AshAuthentication.Strategy.Password.HashPasswordChange, strategy_name: :banana_custard}
```

Example 2 (unknown):
```unknown
prepare set_context(%{strategy_name: :banana_custard})
prepare AshAuthentication.Strategy.Password.SignInPreparation
```

---

## AshAuthentication.Secret behaviour (ash_authentication v4.12.0)

**URL:** https://hexdocs.pm/ash_authentication/AshAuthentication.Secret.html

**Contents:**
- AshAuthentication.Secret behaviour (ash_authentication v4.12.0)
- Example
- Secret name
- Summary
- Callbacks
- Callbacks
- secret_for(secret_name, t, keyword)
- secret_for(secret_name, t, keyword, context)

A module to implement retrieving of secrets.

Allows you to implement secrets access via your method or choice at runtime.

The context parameter is either a map with the conn key containing the Plug.Conn if the secret is being retrieved in a plug, or the context of the ash action it is called in

You can also implement it directly as a function:

Because you may wish to reuse this module for a number of different providers and resources, the first argument passed to the callback is the "secret name", it contains the "path" to the option being set. The path is made up of a list containing the DSL path to the secret.

Secret retrieval callback.

Secret retrieval callback.

This function will be called with the "secret name", see the module documentation for more info.

The context paramter is either a map with the conn key containing the Plug.Conn if the secret is being retrieved in a plug, or the context of the ash action it is called in

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

**Examples:**

Example 1 (python):
```python
defmodule MyApp.GetSecret do
  use AshAuthentication.Secret

  def secret_for([:authentication, :strategies, :oauth2, :client_id], MyApp.User, _opts, _context), do: Application.fetch_env(:my_app, :oauth_client_id)
end

defmodule MyApp.Accounts.User do
  use Ash.Resource,
    extensions: [AshAuthentication],
    domain: MyApp.Accounts

  authentication do
    strategies do
      oauth2 do
        client_id MyApp.GetSecret
        client_secret MyApp.GetSecret
      end
    end
  end
end
```

Example 2 (unknown):
```unknown
defmodule MyApp.User do
   use Ash.Resource,
    extensions: [AshAuthentication],
    domain: MyApp.Accounts

  authentication do
    strategies do
      oauth2 do
        client_id fn _secret, _resource ->
          Application.fetch_env(:my_app, :oauth_client_id)
        end
      end
    end
  end
end
```

---

## API Keys

**URL:** https://hexdocs.pm/ash_authentication/api-keys.html

**Contents:**
- API Keys
- A note on API Keys
- Installation
  - With Igniter (recommended)
  - Manually
    - Create an API key resource
    - Add the strategy to your user
    - Relate users to valid api keys
    - Add the sign_in_with_api_key action
    - Use the plug in your router/plug pipeline

API keys are generated using AshAuthentication.Strategy.ApiKey.GenerateApiKey. See the module docs for more information. The API key is generated using a random byte string and a prefix. The prefix is used to generate a key that is compliant with secret scanning. You can use this to set up an endpoint that will automatically revoke leaked tokens, which is an extremely powerful and useful security feature. We only store a hash of the api key. The plaintext api key is only available in api_key.__metadata__.plaintext_api_key immediately after creation.

See the guide on Github for more information.

Api key expiration/validity is otherwise up to you. The configured api_key_relationship should include those rules in the filter. For example:

Use mix ash_authentication.add_strategy api_key to install this strategy, and modify the generated resource to suit your needs.

Add the action to your user resource

See AshAuthentication.Strategy.ApiKey.Plug for all available options.

In Phoenix, for example, you might add this plug to your :api pipeline.

Hex Package Hex Preview (current file) Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
has_many :valid_api_keys, MyApp.Accounts.ApiKey do
  filter expr(valid)
end
```

Example 2 (unknown):
```unknown
defmodule MyApp.Accounts.ApiKey do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer,
    authorizers: [Ash.Policy.Authorizer]

  actions do
    defaults [:read, :destroy]

    create :create do
      primary? true
      accept [:user_id, :expires_at]
      change {AshAuthentication.Strategy.ApiKey.GenerateApiKey, prefix: :myapp, hash: :api_key_hash}
    end
  end

  attributes do
    uuid_primary_key :id
    attribute :api_key_hash, :binary do
      allow_nil? false
      sensitive? true
    end

    # In this example, all api keys have an expiration
    # Feel free to rework this how
...
```

Example 3 (unknown):
```unknown
authentication do
  ...
  strategies do
    api_key do
      api_key_relationship :valid_api_keys
    end
  end
end
```

Example 4 (unknown):
```unknown
relationships do
  has_many :valid_api_keys, MyApp.Accounts.ApiKey do
    filter expr(valid)
  end
end
```

---

## 

**URL:** https://hexdocs.pm/ash_authentication/ash_authentication.epub

---

## AshAuthentication.Errors.UnconfirmedUser exception (ash_authentication v4.12.0)

**URL:** https://hexdocs.pm/ash_authentication/AshAuthentication.Errors.UnconfirmedUser.html

**Contents:**
- AshAuthentication.Errors.UnconfirmedUser exception (ash_authentication v4.12.0)
- Summary
- Functions
- Functions
- exception(args)
- Keys

The user is unconfirmed and so the operation cannot be executed.

Create an Elixir.AshAuthentication.Errors.UnconfirmedUser without raising it.

Create an Elixir.AshAuthentication.Errors.UnconfirmedUser without raising it.

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## README

**URL:** https://hexdocs.pm/ash_authentication/readme.html

**Contents:**
- README
- Ash Authentication
- About the Documentation
- Tutorials
- Topics
- Tutorials
- Reference
- Related packages

Welcome! Here you will find everything you need to know to get started with and use Ash Authentication. This documentation is best viewed on hexdocs.

Tutorials walk you through a series of steps to accomplish a goal. These are learning-oriented, and are a great place for beginners to start.

Topics provide a high level overview of a specific concept or feature. These are understanding-oriented, and are perfect for discovering design patterns, features, and tools related to a given topic.

Reference documentation is produced automatically from our source code. It comes in the form of module documentation and DSL documentation. This documentation is information-oriented. Use the sidebar and the search bar to find relevant reference information.

Ash Authentication Phoenix | Integrates Ash Authentication into your Phoenix application

Proudly written and maintained by the team at Alembic for the Ash community.

Hex Package Hex Preview (current file) Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## AshAuthentication.AddOn.Confirmation (ash_authentication v4.12.0)

**URL:** https://hexdocs.pm/ash_authentication/AshAuthentication.AddOn.Confirmation.html

**Contents:**
- AshAuthentication.AddOn.Confirmation (ash_authentication v4.12.0)
- Example
- Attributes
- Actions
  - Example
- Usage with AshAuthenticationPhoenix
- Plugs
  - Example
- Summary
- Types

Confirmation support.

Sometimes when creating a new user, or changing a sensitive attribute (such as their email address) you may want to wait for the user to confirm by way of sending them a confirmation token to prove that it was really them that took the action.

In order to add confirmation to your resource, it must been the following minimum requirements:

A confirmed_at attribute will be added to your resource if it's not already present (see confirmed_at_field in the DSL documentation).

By default confirmation will add an action which updates the confirmed_at attribute as well as retrieving previously stored changes and applying them to the resource.

If you wish to perform the confirm action directly from your code you can do so via the AshAuthentication.Strategy protocol.

If you are using AshAuthenticationPhoenix, and have require_interaction? set to true, which you very much should, then you will need to add a confirm_route to your router. This is placed in the same location as auth_routes, and should be provided the user and the strategy name. For example:

Confirmation provides a single endpoint for the :confirm phase. If you wish to interact with the plugs directly, you can do so via the AshAuthentication.Strategy protocol.

Generate a confirmation token for a changeset.

Callback implementation for AshAuthentication.Strategy.Custom.transform/2.

Callback implementation for AshAuthentication.Strategy.Custom.verify/2.

Generate a confirmation token for a changeset.

This will generate a token with the "act" claim set to the confirmation action for the strategy, and the "chg" claim will contain any changes.

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
    add_ons do
      confirmation :confirm do
        monitor_fields [:email]
        sender MyApp.ConfirmationSender
      end
    end

    strategies do
      # ...
    end
  end

  identities do
    identity :email, [:email]
  end
end
```

Example 2 (javascript):
```javascript
iex> strategy = Info.strategy!(Example.User, :confirm)
...> {:ok, user} = Strategy.action(strategy, :confirm, %{"confirm" => confirmation_token()})
...> user.confirmed_at >= one_second_ago()
true
```

Example 3 (unknown):
```unknown
# Remove this if you do not want to use the confirmation strategy
confirm_route(
  MyApp.Accounts.User,
  :confirm_new_user,
  auth_routes_prefix: "/auth",
  overrides: [MyApp.AuthOverrides, AshAuthentication.Phoenix.Overrides.Default]
)
```

Example 4 (javascript):
```javascript
iex> strategy = Info.strategy!(Example.User, :confirm)
...> conn = conn(:get, "/user/confirm", %{"confirm" => confirmation_token()})
...> conn = Strategy.plug(strategy, :confirm, conn)
...> {_conn, {:ok, user}} = Plug.Helpers.get_authentication_result(conn)
...> user.confirmed_at >= one_second_ago()
true
```

---
