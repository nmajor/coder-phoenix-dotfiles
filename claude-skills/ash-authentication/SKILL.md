---
name: ash-authentication
description: User authentication strategies and identity management. Use for ANY auth work, login, signup, password reset, sessions, tokens, OAuth, magic links, user registration, identity verification, and authentication patterns.
---

# Ash-Authentication Skill

Comprehensive assistance with ash-authentication development, generated from official documentation.

## When to Use This Skill

This skill should be triggered when:
- Implementing authentication in Ash Framework applications
- Setting up password-based authentication with email/username login
- Integrating OAuth2 providers (GitHub, Google, Auth0, etc.)
- Implementing magic link (passwordless) authentication
- Setting up API key authentication for programmatic access
- Managing user tokens, sessions, and token revocation
- Implementing confirmation flows (email confirmation, password reset)
- Configuring audit logging for authentication events
- Working with user identities across multiple auth providers
- Creating authentication plugs for Phoenix or Plug applications
- Debugging authentication issues or strategies
- Questions about authentication security best practices in Ash

## Key Concepts

### Authentication Strategies
Ash Authentication provides multiple strategies for user authentication:
- **Password**: Traditional username/email + password authentication
- **Magic Link**: Passwordless authentication via email links
- **OAuth2**: Generic OAuth2 provider integration (GitHub, Google, Auth0, etc.)
- **OIDC**: OpenID Connect authentication

### User Identities
When users can authenticate via multiple providers, use the `identity_resource` to track which providers each user has connected. This allows a single user account to sign in via password, GitHub, Google, etc.

### Token Management
The `TokenResource` stores ephemeral authentication data like:
- Revoked tokens
- Pending confirmation changes
- Magic link tokens
- Token expiration tracking

### Add-ons
Additional features that complement authentication:
- **Confirmation**: Email/phone confirmation flows
- **Audit Log**: Track all authentication events for security
- **API Keys**: Generate and manage API keys for programmatic access

## Quick Reference

### Example 1: Basic Password Authentication Setup

```elixir
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
      end
    end
  end

  identities do
    identity :unique_email, [:email]
  end
end
```

**When to use**: Setting up basic email + password authentication for your Ash application.

### Example 2: Token Resource Configuration

```elixir
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

**When to use**: Required when token generation is enabled. Stores token metadata and handles automatic cleanup of expired tokens.

### Example 3: OAuth2 with GitHub

```elixir
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

**When to use**: Adding GitHub OAuth authentication. Similar patterns work for other OAuth providers.

### Example 4: OAuth2 Registration with Upsert

```elixir
defmodule MyApp.Accounts.User do
  actions do
    create :register_with_github do
      argument :user_info, :map, allow_nil?: false
      argument :oauth_tokens, :map, allow_nil?: false

      upsert? true
      upsert_identity :unique_email

      change AshAuthentication.GenerateTokenChange
      change AshAuthentication.Strategy.OAuth2.IdentityChange

      change fn changeset, _ctx ->
        user_info = Ash.Changeset.get_argument(changeset, :user_info)
        Ash.Changeset.change_attribute(changeset, :email, user_info["email"])
      end
    end
  end
end
```

**When to use**: Creating or updating users during OAuth authentication. Creates new users or signs in existing ones based on identity.

### Example 5: Magic Link Authentication

```elixir
defmodule MyApp.Accounts.User do
  authentication do
    strategies do
      magic_link do
        identity_field :email
        sender fn user_or_email, token, _opts ->
          MyApp.Emails.deliver_magic_link(user_or_email, token)
        end
      end
    end
  end
end
```

**When to use**: Implementing passwordless authentication where users receive login links via email.

### Example 6: Secret Management for OAuth

```elixir
defmodule MyApp.Secrets do
  use AshAuthentication.Secret

  def secret_for([:authentication, :strategies, :github, :client_id],
                 MyApp.Accounts.User, _opts, _meth) do
    Application.fetch_env(:my_app, :github_client_id)
  end

  def secret_for([:authentication, :strategies, :github, :client_secret],
                 MyApp.Accounts.User, _opts, _meth) do
    Application.fetch_env(:my_app, :github_client_secret)
  end
end
```

**When to use**: Securely managing OAuth2 secrets and configuration that varies by environment. Never hardcode secrets in your code.

### Example 7: Audit Log Configuration

```elixir
defmodule MyApp.Accounts.User do
  authentication do
    tokens do
      enabled? true
      token_resource MyApp.Accounts.Token
    end

    add_ons do
      audit_log do
        audit_log_resource MyApp.Accounts.AuditLog
        include_fields [:email, :username]
        exclude_strategies [:magic_link]
        ip_privacy_mode :truncate
      end
    end
  end
end
```

**When to use**: Adding comprehensive audit logging to track authentication events, with privacy controls for IP addresses.

### Example 8: Authentication Plug for Phoenix

```elixir
defmodule MyAppWeb.AuthPlug do
  use AshAuthentication.Plug, otp_app: :my_app

  def handle_success(conn, _activity, user, _token) do
    conn
    |> store_in_session(user)
    |> send_resp(200, "Welcome back #{user.name}")
  end

  def handle_failure(conn, _activity, _reason) do
    conn
    |> send_resp(401, "Authentication failed")
  end
end
```

**When to use**: Creating HTTP endpoints for authentication in Phoenix or Plug applications.

### Example 9: Multi-Provider Authentication

```elixir
defmodule MyApp.Accounts.User do
  authentication do
    strategies do
      password :password do
        identity_field :email
      end

      github do
        client_id MyApp.Secrets
        client_secret MyApp.Secrets
      end

      oauth2 :google do
        client_id MyApp.Secrets
        client_secret MyApp.Secrets
      end
    end
  end
end
```

**When to use**: Allowing users to sign in with multiple providers (password + OAuth).

### Example 10: Audit Log Resource

```elixir
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

**When to use**: Creating a resource to store authentication audit logs automatically.

## Reference Files

This skill includes comprehensive documentation in the `references/` directory:

### configuration.md
**Contains**: DSL configuration options, authentication setup, strategy configuration, token settings, add-on configuration, HTTP adapter settings, and supervisor setup.

**Use for**: Understanding all available configuration options, setting up the authentication extension, configuring HTTP adapters for OAuth2, and managing the supervision tree.

**Key topics**: `authentication` block, `tokens` configuration, `strategies` setup, `add_ons` configuration, `AshAuthentication.Plug` setup.

### getting_started.md
**Contains**: Installation instructions (Igniter and manual), initial setup steps, creating authentication domains and resources, token resource setup, basic strategy configuration, and supervisor configuration.

**Use for**: First-time setup of ash-authentication, creating your authentication resources, understanding the basic architecture, and getting a working authentication system.

**Key topics**: Installing dependencies, creating User and Token resources, adding to supervision tree, using mix tasks for strategy setup.

### strategies.md
**Contains**: Detailed documentation for each authentication strategy (password, magic_link, OAuth2, OIDC, API keys), including configuration options, action definitions, callbacks, and security considerations.

**Use for**: Implementing specific authentication strategies, understanding strategy-specific options, learning about security best practices for each strategy type, and troubleshooting strategy-specific issues.

**Key topics**: Password hashing, magic link email sending, OAuth2 provider setup, OIDC configuration, API key generation and validation.

### providers.md
**Contains**: OAuth2 provider-specific guides and configuration examples (GitHub, Google, Auth0, Slack, etc.), including redirect URIs, scopes, provider-specific quirks, and step-by-step setup instructions.

**Use for**: Integrating specific OAuth2 providers, troubleshooting provider-specific issues, understanding provider requirements, and setting up OAuth applications in provider dashboards.

**Key topics**: GitHub OAuth setup, Auth0 configuration, Google OAuth, provider callback URLs, client ID/secret management.

### tokens.md
**Contains**: Token resource configuration, token lifecycle management, expunging expired tokens, token revocation, confirmation tokens, JWT settings, and the token supervisor.

**Use for**: Managing token storage, configuring automatic cleanup, implementing token revocation, understanding token security, and setting up confirmation flows.

**Key topics**: TokenResource extension, token expiration, automatic cleanup, JWT configuration, token revocation.

### other.md
**Contains**: Audit log add-on, API key generation, user identity management, confirmation flows, security considerations, advanced patterns, and troubleshooting.

**Use for**: Implementing advanced features like audit logging, managing multi-provider identities, setting up confirmation flows, securing your authentication system, and solving common problems.

**Key topics**: Audit logging, API keys, user identities, confirmation add-on, IP privacy, security best practices.

## Working with This Skill

### For Beginners
1. **Start with `getting_started.md`**: Follow the installation and setup guide
2. **Choose a strategy**: Start with password authentication (simplest) from `strategies.md`
3. **Set up tokens**: Follow the token resource guide in `tokens.md`
4. **Add to supervisor**: Ensure the AshAuthentication.Supervisor is in your application tree
5. **Use mix tasks**: Run `mix ash_authentication.add_strategy password` to get started quickly

**Common beginner tasks**:
- Setting up basic password authentication
- Creating the token resource
- Adding authentication routes in Phoenix
- Configuring the supervisor
- Understanding the authentication DSL

### For Intermediate Users
1. **Add OAuth2**: Check `providers.md` for your specific provider (GitHub, Google, Auth0)
2. **Implement magic links**: See `strategies.md` for passwordless authentication
3. **Add audit logging**: Use `other.md` for security monitoring
4. **Configure user identities**: Enable multi-provider login from `other.md`
5. **Use AshAuthentication.Plug**: Create custom authentication endpoints

**Common intermediate tasks**:
- Integrating OAuth2 providers
- Implementing magic link authentication
- Adding email confirmation flows
- Setting up audit logging for compliance
- Creating custom authentication plugs
- Managing secrets with `AshAuthentication.Secret`

### For Advanced Users
1. **API key authentication**: See `strategies.md` and `other.md` for programmatic access
2. **Custom strategies**: Extend the strategy system for custom auth flows
3. **Multi-tenancy**: Configure authentication with Ash's multi-tenancy features
4. **Security hardening**: Review security sections across all reference files
5. **Custom token handling**: Implement advanced token management

**Common advanced tasks**:
- Creating custom authentication strategies
- Implementing API key rotation and management
- Building complex authorization rules with policies
- Integrating with external identity providers
- Customizing HTTP adapters for OAuth2
- Implementing custom audit log queries

### Navigation Tips
- **Quick code examples**: Check the "Quick Reference" section above
- **Specific strategy help**: Go directly to `strategies.md` or `providers.md`
- **OAuth provider setup**: Use `providers.md` for step-by-step guides
- **Security questions**: Review security sections in `strategies.md` and `other.md`
- **Troubleshooting**: Check provider-specific docs in `providers.md` for OAuth issues
- **Configuration reference**: Use `configuration.md` for complete DSL options
- **First-time setup**: Use `getting_started.md` for installation

## Security Best Practices

1. **Never hardcode secrets**: Always use the `AshAuthentication.Secret` behaviour or environment variables
2. **Enable audit logging**: Track authentication events for security monitoring
3. **Use HTTPS**: Always use HTTPS in production for auth endpoints
4. **Implement rate limiting**: Protect against brute force attacks
5. **Store tokens securely**: Use the TokenResource for server-side token storage
6. **Enable confirmation**: Require email confirmation before account activation
7. **Rotate API keys**: Implement expiration and rotation for API keys
8. **Monitor failed attempts**: Set up alerts for suspicious authentication patterns
9. **Privacy compliance**: Use IP privacy modes (hash/truncate/exclude) for GDPR compliance
10. **Validate OAuth callbacks**: Always validate state parameters in OAuth flows

## Common Patterns

### Multi-Provider Authentication
Allow users to sign in with multiple providers (password + OAuth):

```elixir
authentication do
  strategies do
    password :password do
      identity_field :email
    end

    oauth2 :github do
      client_id MyApp.Secrets
      client_secret MyApp.Secrets
    end

    oauth2 :google do
      client_id MyApp.Secrets
      client_secret MyApp.Secrets
    end
  end
end
```

### API + Web Authentication
Support both browser-based and API authentication:

```elixir
authentication do
  strategies do
    password :password do
      identity_field :email
    end

    api_key do
      api_key_relationship :valid_api_keys
    end
  end
end
```

### Passwordless with Fallback
Offer magic link as primary method with password as fallback:

```elixir
authentication do
  strategies do
    magic_link do
      identity_field :email
      sender MyApp.Emails
    end

    password :password do
      identity_field :email
    end
  end
end
```

### Authentication with Audit Logging
Complete setup with password auth and audit logging:

```elixir
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
      identity_field :email
    end
  end
end
```

## Installation & Setup

### Using Igniter (Recommended)

```bash
# Install ash_authentication
mix igniter.install ash_authentication

# Add a password strategy
mix ash_authentication.add_strategy password

# Add audit logging
mix ash_authentication.add_add_on audit_log
```

### Manual Installation

1. Add to `mix.exs`:
```elixir
{:ash_authentication, "~> 4.0"}
```

2. Add to `.formatter.exs`:
```elixir
[
  import_deps: [:ash_authentication]
]
```

3. Create Token resource and User resource (see getting_started.md)

4. Add supervisor to your application:
```elixir
{AshAuthentication.Supervisor, otp_app: :my_app}
```

## Troubleshooting

### Common Issues

**"No such strategy" errors**: Ensure your strategy is properly configured in the `authentication.strategies` block.

**Token not found**: Make sure the TokenResource is configured and the supervisor is running.

**OAuth callback fails**: Verify your redirect_uri matches exactly what's configured in your OAuth provider.

**Magic link emails not sending**: Implement the `sender` function to actually deliver the email.

**Hashed password errors with OAuth**: Set `allow_nil?: true` on the `hashed_password` attribute when using multiple strategies.

**Secrets not loading**: Check that your `AshAuthentication.Secret` module is properly implementing the callback for your configuration path.

For more detailed troubleshooting, consult the strategy-specific documentation in `strategies.md` and `providers.md`.

## Resources

### Documentation Files
All comprehensive documentation is in the `references/` directory. Use the `Read` tool to view specific files when you need detailed information.

### Official Links
- [Hex Package](https://hex.pm/packages/ash_authentication)
- [GitHub Repository](https://github.com/team-alembic/ash_authentication)
- [Ash Framework](https://ash-hq.org)

### Related Packages
- **ash_authentication_phoenix**: Phoenix integration with LiveView components
- **assent**: Underlying OAuth2 library used for OAuth strategies
- **AshPhoenix**: Phoenix integration for Ash Framework

## Notes

- This skill was automatically generated from official ash-authentication documentation
- Code examples use Elixir syntax with the Ash Framework DSL
- All strategies support Ash's multi-tenancy features
- The token resource uses automatic cleanup via the AshAuthentication.Supervisor
- OAuth2 strategies wrap the assent package for protocol handling
- API keys use secret scanning compliant prefixes for leaked token detection
- Audit logs are retained for 90 days by default
- IP privacy modes comply with GDPR requirements
