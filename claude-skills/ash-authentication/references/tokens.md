# Ash-Authentication - Tokens

**Pages:** 6

---

## AshAuthentication.Plug.Helpers (ash_authentication v4.12.0)

**URL:** https://hexdocs.pm/ash_authentication/AshAuthentication.Plug.Helpers.html

**Contents:**
- AshAuthentication.Plug.Helpers (ash_authentication v4.12.0)
- Summary
- Functions
- Functions
- assign_new_resources(socket, session, assign_new, opts)
- get_authentication_result(conn)
- load_subjects(subjects, otp_app, opts \\ [])
- retrieve_from_bearer(conn, otp_app, opts \\ [])
- retrieve_from_session(conn, otp_app, opts \\ [])
- revoke_bearer_tokens(conn, otp_app, opts \\ [])

Authentication helpers for use in your router, etc.

Assigns all subjects from their equivalent sessions, if they are not already assigned.

Given a list of subjects, turn as many as possible into users.

Validate authorization header(s).

Attempt to retrieve all users from the connections' session.

Revoke all authorization header(s).

Revoke all tokens in the session.

Set a subject as the request actor.

Attempts to sign in all authenticated resources for the specificed otp_app using the RememberMe strategy if not already signed in. You can limited it to specific strategies using the strategy opt.

Store result in private.

Store the user in the connections' session.

Assigns all subjects from their equivalent sessions, if they are not already assigned.

This is meant to used via AshAuthenticationPhoenix for nested liveviews. See AshAuthenticationPhoenix.LiveSession.assign_new_resources/3 for more.

Given a list of subjects, turn as many as possible into users.

Opts are forwarded to AshAuthentication.subject_to_user/2

Validate authorization header(s).

Assumes that your clients are sending a bearer-style authorization header with your request. If a valid bearer token is present then the subject is loaded into the assigns under their subject name (with the prefix current_).

If the authentication token is required to be present in the database, it is loaded into the assigns using current_#{subject_name}_token_record

If there is no user present for a resource then the assign is set to nil.

Attempt to retrieve all users from the connections' session.

Iterates through all configured authentication resources for otp_app and retrieves any users stored in the session, loads them and stores them in the assigns under their subject name (with the prefix current_).

If there is no user present for a resource then the assign is set to nil.

Revoke all authorization header(s).

Any bearer-style authorization headers will have their tokens revoked.

Revoke all tokens in the session.

Set a subject as the request actor.

Presumes that you have already loaded your user resource(s) into the connection's assigns.

Uses Ash.PlugHelpers to streamline integration with AshGraphql and AshJsonApi.

Setting the actor for a AshGraphql API using Plug.Router.

Attempts to sign in all authenticated resources for the specificed otp_app using the RememberMe strategy if not already signed in. You can limited it to specific strategies using the strategy opt.

Opts are forwarded to

*[Content truncated]*

**Examples:**

Example 1 (unknown):
```unknown
defmodule MyApp.ApiRouter do
  use Plug.Router
  import MyApp.AuthPlug

  plug :match

  plug :retrieve_from_bearer
  plug :set_actor, :user

  plug :dispatch

  forward "/gql",
    to: Absinthe.Plug,
    init_opts: [schema: MyApp.Schema]
end
```

---

## AshAuthentication.TokenResource

**URL:** https://hexdocs.pm/ash_authentication/dsl-ashauthentication-tokenresource.html

**Contents:**
- AshAuthentication.TokenResource
- Storage
- Usage
- Removing expired records
- token
  - Nested DSLs
  - Options
  - token.revocation
  - Options
  - token.confirmation

This is an Ash resource extension which generates the default token resource.

The token resource is used to store information about tokens that should not be shared with the end user. It does not actually contain any tokens.

The information stored in this resource is essentially ephemeral - all tokens have an expiry date, so it doesn't make sense to keep them after that time has passed. However, if you have any tokens with very long expiry times then we suggest you store this resource in a resilient data-layer such as Postgres.

There is no need to define any attributes or actions (although you can if you want). The extension will wire up everything that's needed for the token system to function.

Whilst it is possible to have multiple token resources, there is no need to do so.

Once a token has expired there's no point in keeping the information it refers to, so expired tokens can be automatically removed by adding the AshAuthentication.Supervisor to your application supervision tree. This will start the AshAuthentication.TokenResource.Expunger GenServer which periodically scans and removes any expired records.

Configuration options for this token resource

Configuration options for token revocation

Configuration options for confirmation tokens

Hex Package Hex Preview (current file) Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
defmodule MyApp.Accounts.Token do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshAuthentication.TokenResource],
    domain: MyApp.Accounts

  postgres do
    table "tokens"
    repo MyApp.Repo
  end
end
```

---

## Tokens

**URL:** https://hexdocs.pm/ash_authentication/tokens.html

**Contents:**
- Tokens
- Token Lifetime
- Requiring Token Storage
- Sign in Tokens

Since refresh tokens are not yet included in ash_authentication, you should set the token lifetime to a reasonably long time to ensure a good user experience. Alternatively, refresh tokens can be implemented on your own.

Using AshAuthentication.Dsl.authentication.tokens.require_token_presence_for_authentication? inverts the token validation behaviour from requiring that tokens are not revoked to requiring any token presented by a client to be present in the token resource to be considered valid.

Requires store_all_tokens? to be true.

store_all_tokens? instructs AshAuthentication to keep track of all tokens issued to any user. This is optional behaviour with ash_authentication in order to preserve as much performance as possible.

Enabled with AshAuthentication.Strategy.Password.authentication.strategies.password.sign_in_tokens_enabled?

Sign in tokens can be generated on request by setting the :token_type context to :sign_in when calling the sign in action. You might do this when you need to generate a short lived token to be exchanged for a real token using the validate_sign_in_token route. This is used, for example, by ash_authentication_phoenix (since 1.7) to support signing in a liveview, and then redirecting with a valid token to a controller action, allowing the liveview to show invalid username/password errors.

Hex Package Hex Preview (current file) Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## AshAuthentication.AddOn.LogOutEverywhere

**URL:** https://hexdocs.pm/ash_authentication/dsl-ashauthentication-addon-logouteverywhere.html

**Contents:**
- AshAuthentication.AddOn.LogOutEverywhere
- Example
- Actions
  - Example
  - authentication.add_ons.log_out_everywhere
  - Arguments
  - Options
  - Introspection

Log out everywhere support.

Sometimes it's necessary to be able to invalidate all of a user's sessions with a single action. This add-on provides this functionality.

In order to use this feature the following features must be enabled:

By default the add-on will add a log_out_everywhere action which reverts all the existing non-expired tokens for the user in question.

Log out everywhere add-on

Target: AshAuthentication.AddOn.LogOutEverywhere

Hex Package Hex Preview (current file) Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
defmodule MyApp.Accounts.User do
  use Ash.Resource,
    extensions: [AshAuthentication],
    domain: MyApp.Accounts

  authentication do
    tokens do
      enabled? true
      store_all_tokens? true
      require_token_presence_for_authentication? true
    end

    add_ons do
      log_out_everywhere do
        apply_on_password_change? true
      end
    end
```

Example 2 (javascript):
```javascript
iex> strategy = Info.strategy!(Example.User, :log_out_everywhere)
...> {:ok, user} = Strategy.action(strategy, :log_out_everywhere, %{"user_id" => user_id()})
...> user.id == user_id()
true
```

Example 3 (unknown):
```unknown
log_out_everywhere name \\ :log_out_everywhere
```

---

## AshAuthentication.AddOn.LogOutEverywhere (ash_authentication v4.12.0)

**URL:** https://hexdocs.pm/ash_authentication/AshAuthentication.AddOn.LogOutEverywhere.html

**Contents:**
- AshAuthentication.AddOn.LogOutEverywhere (ash_authentication v4.12.0)
- Example
- Actions
  - Example
- Summary
- Types
- Functions
- Types
- t()
- Functions

Log out everywhere support.

Sometimes it's necessary to be able to invalidate all of a user's sessions with a single action. This add-on provides this functionality.

In order to use this feature the following features must be enabled:

By default the add-on will add a log_out_everywhere action which reverts all the existing non-expired tokens for the user in question.

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
    tokens do
      enabled? true
      store_all_tokens? true
      require_token_presence_for_authentication? true
    end

    add_ons do
      log_out_everywhere do
        apply_on_password_change? true
      end
    end
```

Example 2 (javascript):
```javascript
iex> strategy = Info.strategy!(Example.User, :log_out_everywhere)
...> {:ok, user} = Strategy.action(strategy, :log_out_everywhere, %{"user_id" => user_id()})
...> user.id == user_id()
true
```

---

## AshAuthentication.TokenResource.Expunger (ash_authentication v4.12.0)

**URL:** https://hexdocs.pm/ash_authentication/AshAuthentication.TokenResource.Expunger.html

**Contents:**
- AshAuthentication.TokenResource.Expunger (ash_authentication v4.12.0)
- Summary
- Functions
- Functions
- child_spec(init_arg)

A GenServer which periodically removes expired token revocations.

Scans all token revocation resources based on their configured expunge interval and removes any expired records.

This GenServer is started by the AshAuthentication.Supervisor which should be added to your app's supervision tree.

Returns a specification to start this module under a supervisor.

Returns a specification to start this module under a supervisor.

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
defmodule MyApp.Accounts.Token do
  use Ash.Resource,
    extensions: [AshAuthentication.TokenResource],
    domain: MyApp.Accounts

  token do
    expunge_interval 12
  end
end
```

---
