# Ash-Authentication - Getting Started

**Pages:** 8

---

## Audit Log Tutorial

**URL:** https://hexdocs.pm/ash_authentication/audit-log.html

**Contents:**
- Audit Log Tutorial
- Installation
  - With Igniter (recommended)
  - Manually
    - Create the audit log resource
    - Add the audit log add-on to your user resource
    - Generate and run migrations
    - Start the audit log batcher
- What gets logged?
- Viewing audit logs

The audit log add-on provides automatic logging of authentication events (sign in, registration, failures, etc.) to help you track security-relevant activities in your application.

Use mix ash_authentication.add_add_on audit_log to automatically set up audit logging:

You can customise the installation with options:

If you prefer to set up audit logging manually, continue with the steps below:

First, create a resource to store the audit logs. This resource uses the AshAuthentication.AuditLogResource extension which handles all the necessary setup:

The extension automatically creates all required attributes and actions. You don't need to define any manually unless you want to customise them.

Next, add the audit log add-on to your user resource's authentication configuration:

Generate migrations for the audit log table:

The audit log uses batched writes to reduce database load. Add the AshAuthentication.Supervisor to your application's supervision tree:

That's it! Authentication events will now be logged automatically.

The audit log automatically tracks:

You can read audit logs like any other Ash resource:

By default, sensitive arguments and attributes (marked with sensitive?: true) are filtered out of the audit logs. You can explicitly include specific fields:

If you want to exclude certain authentication strategies from being logged:

To exclude specific actions from being logged:

By default, audit logs are retained for 90 days. You can change this or disable automatic cleanup:

The audit log batches writes to reduce database load. You can customise this behaviour:

To disable batching entirely (writes happen immediately):

To comply with privacy regulations like GDPR, you can control how IP addresses are stored in audit logs:

Available IP privacy modes:

When using :truncate mode, the default masks are:

Example configurations:

The IP privacy transformation applies to all IP-related fields in the request metadata:

Each audit log entry contains:

Hex Package Hex Preview (current file) Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
mix ash_authentication.add_add_on audit_log
```

Example 2 (unknown):
```unknown
# Custom audit log resource name
mix ash_authentication.add_add_on audit_log --audit-log MyApp.Accounts.AuthAuditLog

# Include sensitive fields
mix ash_authentication.add_add_on audit_log --include-fields email,username

# Exclude specific strategies
mix ash_authentication.add_add_on audit_log --exclude-strategies magic_link,oauth

# Exclude specific actions
mix ash_authentication.add_add_on audit_log --exclude-actions sign_in_with_token
```

Example 3 (unknown):
```unknown
defmodule MyApp.Accounts.AuditLog do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshAuthentication.AuditLogResource],
    domain: MyApp.Accounts

  postgres do
    table "account_audit_logs"
    repo MyApp.Repo
  end
end
```

Example 4 (unknown):
```unknown
defmodule MyApp.Accounts.User do
  use Ash.Resource,
    extensions: [AshAuthentication],
    domain: MyApp.Accounts

  attributes do
    uuid_primary_key :id
    attribute :email, :ci_string, allow_nil?: false, public?: true, sensitive?: true
    attribute :hashed_password, :string, allow_nil?: false, sensitive?: true
  end

  authentication do
    tokens do
      enabled? true
      token_resource MyApp.Accounts.Token
    end

    add_ons do
      audit_log do
        audit_log_resource MyApp.Accounts.AuditLog
      end
    end

    strategies do
      password :password do
        identity_
...
```

---

## GitHub Tutorial

**URL:** https://hexdocs.pm/ash_authentication/github.html

**Contents:**
- GitHub Tutorial

This is a quick tutorial on how to configure your application to use GitHub for authentication.

First you need to configure an application in your GitHub developer settings:

Click the "New OAuth App" button.

Set your application name to something that identifies it. You will likely need separate applications for development and production environments, so keep that in mind.

Set "Homepage URL" appropriately for your application and environment.

In the "Authorization callback URL" section, add your callback URL. The callback URL is generated from the following information:

This means that the callback URL should look something like http://localhost:4000/auth/user/github/callback.

Do not set "Enable Device Flow" unless you know why you want this.

Click "Register application".

Click "Generate a new client secret".

Copy the "Client ID" and "Client secret" somewhere safe, we'll need them soon.

Click "Update application".

Next we can configure our resource (assuming you already have everything else set up):

Because all the configuration values should be kept secret (ie the client_secret) or are likely to be different for each environment we use the AshAuthentication.Secret behaviour to provide them. In this case we're delegating to the OTP application environment, however you may want to use a system environment variable or some other secret store (eg Vault).

The values for this configuration should be:

Lastly, we need to add a register action to your user resource. This is defined as an upsert so that it can register new users, or update information for returning users. The default name of the action is register_with_ followed by the strategy name. In our case that is register_with_github.

The register action takes two arguments, user_info and the oauth_tokens.

Ensure you set the hashed_password to allow_nil? if you are also using the password strategy.

And generate and run migrations in that case.

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
    strategies do
      github do
        client_id MyApp.Secrets
        redirect_uri MyApp.Secrets
        client_secret MyApp.Secrets
      end
    end
  end
end
```

Example 2 (python):
```python
defmodule MyApp.Secrets do
  use AshAuthentication.Secret

  def secret_for([:authentication, :strategies, :github, :client_id], MyApp.Accounts.User, _) do
    get_config(:client_id)
  end

  def secret_for([:authentication, :strategies, :github, :redirect_uri], MyApp.Accounts.User, _) do
    get_config(:redirect_uri)
  end

  def secret_for([:authentication, :strategies, :github, :client_secret], MyApp.Accounts.User, _) do
    get_config(:client_secret)
  end

  defp get_config(key) do
    :my_app
    |> Application.get_env(:github, [])
    |> Keyword.fetch(key)
  end
end
```

Example 3 (unknown):
```unknown
defmodule MyApp.Accounts.User do
  require Ash.Resource.Change.Builtins
  use Ash.Resource,
    extensions: [AshAuthentication],
    domain: MyApp.Accounts

  # ...

  actions do
    create :register_with_github do
      argument :user_info, :map, allow_nil?: false
      argument :oauth_tokens, :map, allow_nil?: false
      upsert? true
      upsert_identity :unique_email

      # Required if you have token generation enabled.
      change AshAuthentication.GenerateTokenChange

      # Required if you have the `identity_resource` configuration enabled.
      change AshAuthentication.Strategy.O
...
```

Example 4 (unknown):
```unknown
defmodule MyApp.Accounts.User do
  # ...
  attributes do
    # ...
    attribute :hashed_password, :string, allow_nil?: true, sensitive?: true
  end
  # ...
end
```

---

## Auth0 Tutorial

**URL:** https://hexdocs.pm/ash_authentication/auth0.html

**Contents:**
- Auth0 Tutorial

This is a quick tutorial on how to configure your application to use Auth0 for authentication.

First, you need to configure an application in the Auth0 dashboard using the following steps:

Click "Create Application".

Set your application name to something that identifies it. You will likely need separate applications for development and production environments, so keep that in mind.

Select "Regular Web Application" and click "Create".

Switch to the "Settings" tab.

Copy the "Domain", "Client ID" and "Client Secret" somewhere safe - we'll need them soon.

In the "Allowed Callback URLs" section, add your callback URL. The callback URL is generated from the following information:

This means that the callback URL should look something like http://localhost:4000/auth/user/auth0/callback.

Set "Allowed Web Origins" to your application's base URL.

Click "Save Changes".

Next we can configure our resource:

Because all the configuration values should be kept secret (ie the client_secret) or are likely to be different for each environment we use the AshAuthentication.Secret behaviour to provide them. In this case we're delegating to the OTP application environment, however you may want to use a system environment variable or some other secret store (eg Vault).

The values for this configuration should be:

Lastly, we need to add a register action to your user resource. This is defined as an upsert so that it can register new users, or update information for returning users. The default name of the action is register_with_ followed by the strategy name. In our case that is register_with_auth0.

The register action takes two arguments, user_info and the oauth_tokens.

If you are only setting up this strategy it's possible that you don't have the email field in your User resource, so you will need to add it:

And the generate & run the migrations with:

In your auth controller, make sure to add a redirect to https://[auth0_endpoint]/v2/logout when logging out. This notifies Auth0 that the user has logged out. Be sure to replace [auth0_endpoint] and [auth0_client_id] with your actual Auth0 values:

All good! Go to http://localhost:4000/sign-in to see it working.

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
    strategies do
      auth0 do
        client_id MyApp.Secrets
        redirect_uri MyApp.Secrets
        client_secret MyApp.Secrets
        base_url MyApp.Secrets
      end
    end
  end
end
```

Example 2 (python):
```python
defmodule MyApp.Secrets do
  use AshAuthentication.Secret

  def secret_for([:authentication, :strategies, :auth0, :client_id], MyApp.Accounts.User, _opts, _meth) do
    get_config(:client_id)
  end

  def secret_for([:authentication, :strategies, :auth0, :redirect_uri], MyApp.Accounts.User, _opts, _meth) do
    get_config(:redirect_uri)
  end

  def secret_for([:authentication, :strategies, :auth0, :client_secret], MyApp.Accounts.User, _opts, _meth) do
    get_config(:client_secret)
  end

  def secret_for([:authentication, :strategies, :auth0, :base_url], MyApp.Accounts.User, _opts, _meth) d
...
```

Example 3 (unknown):
```unknown
defmodule MyApp.Accounts.User do
  use Ash.Resource,
    extensions: [AshAuthentication],
    domain: MyApp.Accounts

  # ...

  actions do
    create :register_with_auth0 do
      argument :user_info, :map, allow_nil?: false
      argument :oauth_tokens, :map, allow_nil?: false
      upsert? true
      upsert_identity :unique_email

      # Required if you have token generation enabled.
      change AshAuthentication.GenerateTokenChange

      # Required if you have the `identity_resource` configuration enabled.
      change AshAuthentication.Strategy.OAuth2.IdentityChange

      change fn ch
...
```

Example 4 (unknown):
```unknown
defmodule MyApp.Accounts.User do

  # ...

  attributes do
    uuid_primary_key :id

    attribute :email, :ci_string do
      allow_nil? false
    end
  end

  identities do
    identity :unique_email, [:email]
  end

  # ...

end
```

---

## Get started with Ash Authentication

**URL:** https://hexdocs.pm/ash_authentication/get-started.html

**Contents:**
- Get started with Ash Authentication
  - Using Igniter (recommended)
    - Install the extension
      - Using Phoenix?
  - Manual
    - Add to your application's dependencies
    - Create authentication domain and resources
    - Setup Token Resource
    - Supervisor
      - Example

If you haven't already, read the getting started guide for Ash. This assumes that you already have resources set up, and only gives you the steps to add authentication to your resources and APIs.

Use the following. If you have not yet run the above command, this will prompt you to do so, so you can run both or only this one.

Bring in the ash_authentication dependency:

And add ash_authentication to your .formatter.exs:

Let's create an Accounts domain in our application which provides a User resource and a Token resource. This tutorial is assuming that you are using AshPostgres.

First, let's define our domain:

Be sure to add it to the ash_domains config in your config.exs

Next, let's define our Token resource. This resource is needed if token generation is enabled for any resources in your application. Most of the contents are auto-generated, so we just need to provide the data layer configuration and the API to use.

But before we do, we need to install a postgres extension.

AshAuthentication includes a supervisor which you should add to your application's supervisor tree. This is used to run any periodic jobs related to your authenticated resources (removing expired tokens, for example).

Lastly let's define our User resource. Note that we aren't defining any authentication strategies here. This setup is used for all strategies. Once you have done this, you can follow one of the strategy specific guides at the bottom of this page.

Proper management of secrets is outside the scope of this tutorial, but is absolutely crucial to the security of your application.

A mix task is provided to add strategies and add-ons to your application. For now, this only supports the password strategy, but more will be added in the future.

If you're using Phoenix, skip this section and go to Integrating Ash Authentication and Phoenix

In order for your users to be able to sign in, you will likely need to provide an HTTP endpoint to submit credentials or OAuth requests to. Ash Authentication provides AshAuthentication.Plug for this purposes. It provides a use macro which handles routing of requests to the correct providers, and defines callbacks for successful and unsuccessful outcomes.

Let's generate our plug:

Now that this is done, you can forward HTTP requests to it from your app's main router using forward "/auth", to: MyApp.AuthPlug or similar.

Your generated auth plug module will also contain load_from_session and load_from_bearer function plugs, which can b

*[Content truncated]*

**Examples:**

Example 1 (unknown):
```unknown
mix igniter.install ash_authentication --auth-strategy magic_link,password
```

Example 2 (unknown):
```unknown
mix igniter.install ash_authentication_phoenix --auth-strategy magic_link,password
```

Example 3 (unknown):
```unknown
# mix.exs

defp deps()
  [
    # ...
    {:ash_authentication, "~> 4.0"}
  ]
end
```

Example 4 (unknown):
```unknown
# .formatter.exs
[
  import_deps: [..., :ash_authentication]
]
```

---

## Magic Links Tutorial

**URL:** https://hexdocs.pm/ash_authentication/magic-links.html

**Contents:**
- Magic Links Tutorial
- With a mix task
- Add the Magic Link Strategy to the User resource
  - Registration Enabled
  - Registration Disabled (default)
  - Require Interaction
- Create an email sender and email template

You can use mix ash_authentication.add_strategy magic_link to install this strategy. The rest of the guide is in the case that you wish to proceed manually.

When registration is enabled, signing in with magic is a create action that upserts the user by email. This allows a user who does not exist to request a magic link and sign up with one action.

When registration is disabled, signing in with magic link is a read action.

Some email clients, virus scanners, etc will retrieve a link automatically without user interaction, causing the magic link token to be consumed and thus fail when the user clicks the link. The mitigate this we now default to requiring that the user click a "sign in" button to ensure that retrieving the confirmation page does not actually consume the token. By default if a GET request is sent to the magic link endpoint a very simple form is served which submits to the same URL with the same token parameter as a POST. You probably don't want to serve this page to users in production. You can work around this by placing your own page at the same path before it in the router, or changing the email link to a different URL.

See also AshAuthentication.Phoenix.Router.magic_sign_in_route/3.

Inside /lib/example/accounts/user/senders/send_magic_link.ex

Inside /lib/example/accounts/emails.ex

Hex Package Hex Preview (current file) Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
# ...

strategies do
  # add these lines -->
  magic_link do
    identity_field :email
    registration_enabled? true
    require_interaction? true

    sender(Example.Accounts.User.Senders.SendMagicLink)
  end
  # <-- add these lines
end

# ...
```

Example 2 (python):
```python
defmodule Example.Accounts.User.Senders.SendMagicLink do
  @moduledoc """
  Sends a magic link
  """
  use AshAuthentication.Sender
  use ExampleWeb, :verified_routes

  @impl AshAuthentication.Sender
  def send(user_or_email, token, _) do
    # will be a user if the token relates to an existing user
    # will be an email if there is no matching user (such as during sign up)
    Example.Accounts.Emails.deliver_magic_link(
      user_or_email,
      url(~p"/auth/user/magic_link/?token=#{token}")
    )
  end
end
```

Example 3 (python):
```python
# ...

def deliver_magic_link(user, url) do
  if !url do
    raise "Cannot deliver reset instructions without a url"
  end

  email = case user do
    %{email: email} -> email
    email -> email
  end

  deliver(email, "Magic Link", """
  <html>
    <p>
      Hi #{email},
    </p>

    <p>
      <a href="#{url}">Click here</a> to login.
    </p>
  <html>
  """)
end

# ...
```

---

## Google Tutorial

**URL:** https://hexdocs.pm/ash_authentication/google.html

**Contents:**
- Google Tutorial

This is a quick tutorial on how to configure Google authentication.

First you'll need a registered application in Google Cloud, in order to get your OAuth 2.0 Client credentials.

Next we configure our resource to use google credentials:

Please check the guide on how to properly configure your Secrets. Then we need to define an action that will handle the oauth2 flow, for the google case it is :register_with_google it will handle both cases for our resource, user registration & login.

Ensure you set the hashed_password to allow_nil? if you are also using the password strategy.

And generate and run migrations in that case.

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
    ...
  end

  authentication do
    strategies do
      google do
        client_id MyApp.Secrets
        redirect_uri MyApp.Secrets
        client_secret MyApp.Secrets
      end
    end
  end
end
```

Example 2 (unknown):
```unknown
defmodule MyApp.Accounts.User do
  require Ash.Resource.Change.Builtins
  use Ash.Resource,
    extensions: [AshAuthentication],
    domain: MyApp.Accounts

  # ...
  actions do
    create :register_with_google do
      argument :user_info, :map, allow_nil?: false
      argument :oauth_tokens, :map, allow_nil?: false
      upsert? true
      upsert_identity :unique_email

      change AshAuthentication.GenerateTokenChange

      # Required if you have the `identity_resource` configuration enabled.
      change AshAuthentication.Strategy.OAuth2.IdentityChange

      change fn changeset, _ ->
  
...
```

Example 3 (unknown):
```unknown
defmodule MyApp.Accounts.User do
  # ...
  attributes do
    # ...
    attribute :hashed_password, :string, allow_nil?: true, sensitive?: true
  end
  # ...
end
```

Example 4 (unknown):
```unknown
mix ash.codegen make_hashed_password_nullable
mix ash.migrate
```

---

## Slack Tutorial

**URL:** https://hexdocs.pm/ash_authentication/slack.html

**Contents:**
- Slack Tutorial
- HTTPS Required

This is a quick tutorial on how to configure your application to use Slack for authentication.

First you need to configure an application in your Slack app settings:

Click the "Create New App" button.

Select "From scratch"

Set your application name to something that identifies it. You will likely need separate applications for development and production environments, so keep that in mind.

Select a "development workspace", which can be used for testing.

Browse to the "OAuth & Permissions" page.

In the "Redirect URLs" section add your callback URL. The callback URL is generated from the following information:

This means that the callback URL should look something like http://localhost:4000/auth/user/slack/callback.

Slack won't allow you to register an HTTP URL as the redirect URL, so you will likely have to add a URL for a service like ngrok

In the "Scopes" section, add your user token scopes. You must request openid, and may request email and profile as well.

In the "OAuth Tokens" section click "Install to :workspace:" where :workspace: is the one you selected as the development workspace.

Browse back to the "Basic Information".

Copy the "Client ID" and "Client secret" somewhere safe, we'll need them soon.

Next we can configure our resource (assuming you already have everything else set up):

Because all the configuration values should be kept secret (ie the client_secret) or are likely to be different for each environment we use the AshAuthentication.Secret behaviour to provide them. In this case we're delegating to the OTP application environment, however you may want to use a system environment variable or some other secret store (eg Vault).

The values for this configuration should be:

Lastly, we need to add a register action to your user resource. This is defined as an upsert so that it can register new users, or update information for returning users. The default name of the action is register_with_ followed by the strategy name. In our case that is register_with_slack.

The register action takes two arguments, user_info and the oauth_tokens.

Ensure you set the hashed_password to allow_nil? if you are also using the password strategy.

And generate and run migrations in that case.

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
    strategies do
      slack do
        client_id MyApp.Secrets
        redirect_uri MyApp.Secrets
        client_secret MyApp.Secrets
      end
    end
  end
end
```

Example 2 (python):
```python
defmodule MyApp.Secrets do
  use AshAuthentication.Secret

  def secret_for([:authentication, :strategies, :slack, :client_id], MyApp.Accounts.User, _) do
    get_config(:client_id)
  end

  def secret_for([:authentication, :strategies, :slack, :redirect_uri], MyApp.Accounts.User, _) do
    get_config(:redirect_uri)
  end

  def secret_for([:authentication, :strategies, :slack, :client_secret], MyApp.Accounts.User, _) do
    get_config(:client_secret)
  end

  defp get_config(key) do
    :my_app
    |> Application.get_env(:slack, [])
    |> Keyword.fetch(key)
  end
end
```

Example 3 (unknown):
```unknown
defmodule MyApp.Accounts.User do
  require Ash.Resource.Change.Builtins
  use Ash.Resource,
    extensions: [AshAuthentication],
    domain: MyApp.Accounts

  # ...

  actions do
    create :register_with_slack do
      argument :user_info, :map, allow_nil?: false
      argument :oauth_tokens, :map, allow_nil?: false
      upsert? true
      upsert_identity :unique_email

      # Required if you have token generation enabled.
      change AshAuthentication.GenerateTokenChange

      # Required if you have the `identity_resource` configuration enabled.
      change AshAuthentication.Strategy.OA
...
```

Example 4 (unknown):
```unknown
defmodule MyApp.Accounts.User do
  # ...
  attributes do
    # ...
    attribute :hashed_password, :string, allow_nil?: true, sensitive?: true
  end
  # ...
end
```

---

## Confirmation Tutorial

**URL:** https://hexdocs.pm/ash_authentication/confirmation.html

**Contents:**
- Confirmation Tutorial
- Important security notes
  - How to handle this?
    - Automatic Handling
    - auto_confirming and clearing the password on upsert
    - Opt-out
- Tutorial
- Confirming newly registered users
- Blocking unconfirmed users from logging in
    - Must add error handling

This add-on allows you to confirm changes to a user record by generating and sending them a confirmation token which they must submit before allowing the change to take place.

In this tutorial we'll assume that you have a User resource which uses email as it's user identifier. We'll show you how to confirm a new user on sign-up and also require them to confirm if they wish to change their email address.

If you are using multiple strategies that use emails, where one of the strategy has an upsert registration (like social sign-up, magic link registration), then you must use the confirmation add-on to prevent account hijacking, as described below.

The confirmation add-on prevents this by default by not allowing an upsert action to set confirmed_at, if there is a matching record that has confirmed_at that is currently nil. This allows you to show a message to the user like "You signed up with a different method. Please sign in with the method you used to sign up."

An alternative is to clear the user's password on upsert. To do this, you would want to ensure the following things are true:

Why do you have to ensure that no actions can be taken without a confirmed account?

This does technically remove any access that the attacker may have had from the account, but we don't suggest taking this approach unless you are absolutely sure that you know what you are doing. For example, lets say you have an app that shows where the user is in the world, or where their friends are in the world. Lets say you also allow configuring a phone number to receive text notifications when they are near one of their friends. An attacker could sign up with a password, and configure their phone number. Then, their target signs up with Oauth or magic link, adds some friends, but doesn't notice that a phone number is configured.

Now the attacker is getting text messages about where the user and/or their friends are.

You can set prevent_hijacking? false on either the confirmation add-on, or your strategy to disable the automatic handling described above, and not follow the steps recommended in the section section above. This is not recommended.

Here's the user resource we'll be starting with:

First we start by adding the confirmation add-on to your existing authentication DSL:

Next we will have to generate and run migrations to add confirmed_at column to user resource

To make this work we need to create a new module MyApp.Accounts.User.Senders.SendNewUserConfirmationEmail:

W

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
    attribute :email, :ci_string, allow_nil?: false, public?: true, sensitive?: true
    attribute :hashed_password, :string, allow_nil?: false, public?: false, sensitive?: true
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
defmodule MyApp.Accounts.User do
  # ...

  authentication do
    # ...

    add_ons do
      confirmation :confirm_new_user do
        monitor_fields [:email]
        confirm_on_create? true
        confirm_on_update? false
        require_interaction? true
        sender MyApp.Accounts.User.Senders.SendNewUserConfirmationEmail
      end
    end
  end
end
```

Example 3 (unknown):
```unknown
mix ash.codegen account_confirmation
```

Example 4 (python):
```python
defmodule MyApp.Accounts.User.Senders.SendNewUserConfirmationEmail do
  @moduledoc """
  Sends an email confirmation email
  """
  use AshAuthentication.Sender
  use MyAppWeb, :verified_routes

  @impl AshAuthentication.Sender
  def send(user, token, _opts) do
    MyApp.Accounts.Emails.deliver_email_confirmation_instructions(
      user,
      url(~p"/confirm_new_user/#{token}")
    )
  end
end
```

---
