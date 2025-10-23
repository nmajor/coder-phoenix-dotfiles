# Ash-Admin - Other

**Pages:** 6

---

## 

**URL:** https://hexdocs.pm/ash_admin/ash_admin.epub

---

## AshAdmin.Domain

**URL:** https://hexdocs.pm/ash_admin/dsl-ashadmin-domain.html

**Contents:**
- AshAdmin.Domain
- admin
  - Options

A domain extension to alter the behavior of a domain in the admin UI.

Configure the admin dashboard for a given domain.

Hex Package Hex Preview (current file) Search HexDocs Download ePub version

Built using ExDoc (v0.38.3) for the Elixir programming language

---

## Getting Started with AshAdmin

**URL:** https://hexdocs.pm/ash_admin/getting-started-with-ash-admin.html

**Contents:**
- Getting Started with AshAdmin
- Demo
- Installation
- Setup
  - With Igniter (Recommended)
  - Manual
    - Warning
- Security
  - Content Security Policy
- Troubleshooting

https://www.youtube.com/watch?v=aFMLz3cpQ8c

Add the ash_admin dependency to your mix.exs file:

Modify your router to add AshAdmin at whatever path you'd like to serve it at.

Add the AshAdmin.Domain extension to each domain you want to show in the AshAdmin dashboard, and configure it to show. See DSL: AshAdmin.Domain for more configuration options.

All resources in each Domain will automatically be included in AshAdmin. To configure a resource, use the AshAdmin.Resource extension, and then use the DSL: AshAdmin.Resource configuration options. Specifically, if your app has an actor you will want to configure that.

There is no builtin security for your AshAdmin (except your app's normal policies). In most cases you will want to secure your AshAdmin routes in some way to prevent them from being publicly accessible.

Start your project (usually by running mix phx.server in a terminal) and visit /admin in your browser (or the path you configured ash_admin with in your router).

You can limit access to ash_admin when using AshAuthentication like so:

Then, we'll need to define :admin_only in our [example_web/live_user_auth.ex]:

Of course, the user role attribute will need to be added to our User resource in [example/accounts/user.ex]

Define our roles in a new file, [example/accounts/user/role.ex]. You can use whatever names you'd like:

If you don't want to use Ash.Type.Enum, you could update the User's attribute as such:

The following steps are optional: if you want users who use the dashboard to act “as themselves” (and thus follow any policy rules with themselves as the actor), you’ll also want to specify an actor plug:

and then configure it like so

If your app specifies a content security policy header, eg. via

in your router, then the stylesheets and JavaScript used to power AshAdmin will be blocked by your browser.

To avoid this, you can add the default AshAdmin nonces to the default-src allowlist, ie.

Alternatively you can supply your own nonces to the ash_admin route, by setting a :csp_nonce_assign_key in the options list, ie.

This will allow AshAdmin-generated inline CSS and JS blocks to execute normally.

If your admin UI is not responding as expected, check your browser's developer console for content-security-policy violations (see above).

If you are seeing the following error (UndefinedFunctionError) function YourAppWeb.AshAdmin.PageLive.__live__/0 is undefined (module YourAppWeb.AshAdmin.PageLive is not available) it likely means that

*[Content truncated]*

**Examples:**

Example 1 (unknown):
```unknown
{:ash_admin, "~> 0.13.3"}
```

Example 2 (unknown):
```unknown
mix igniter.install ash_admin
```

Example 3 (unknown):
```unknown
defmodule MyAppWeb.Router do
  use Phoenix.Router

  import AshAdmin.Router

  # AshAdmin requires a Phoenix LiveView `:browser` pipeline
  # If you DO NOT have a `:browser` pipeline already, then AshAdmin has a `:browser` pipeline
  # Most applications will not need this:
  admin_browser_pipeline :browser

  # NOTE: `scope/2` here does not have a second argument.
  # If it looks like `scope "/", MyAppWeb`, create a *new* scope, don't copy the contents into your scope
  scope "/" do
    # Pipe it through your browser pipeline
    pipe_through [:browser]

    ash_admin "/admin"
  end
end
```

Example 4 (unknown):
```unknown
# In your Domain(s)
use Ash.Domain,
  extensions: [AshAdmin.Domain]

admin do
  show? true
end
```

---

## README

**URL:** https://hexdocs.pm/ash_admin/readme.html

**Contents:**
- README
- AshAdmin
- Tutorials
- Reference

Welcome! This is a super-admin UI dashboard for Ash Framework applications, built with Phoenix LiveView.

Hex Package Hex Preview (current file) Search HexDocs Download ePub version

Built using ExDoc (v0.38.3) for the Elixir programming language

---

## AshAdmin.Domain (ash_admin v0.13.19)

**URL:** https://hexdocs.pm/ash_admin/AshAdmin.Domain.html

**Contents:**
- AshAdmin.Domain (ash_admin v0.13.19)
- Summary
- Functions
- Functions
- admin(body)
- default_resource_page(domain)
- name(domain)
- resource_group_labels(domain)
- show?(domain)
- show_resources(domain)

A domain extension to alter the behavior of a domain in the admin UI.

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.3) for the Elixir programming language

---

## Contributing to AshAdmin

**URL:** https://hexdocs.pm/ash_admin/contributing-to-ash-admin.html

**Contents:**
- Contributing to AshAdmin

AshAdmin includes a development app, located in the dev folder, so you don't need to have an external Phoenix app to plug AshAdmin into.

You'll need to have PostgreSQL set up locally. Then you can run:

Then, you can start the app server with: mix dev

If you make changes to the dev resources, you can generate migrations with mix generate_migrations

If you make changes to any of the assets (CSS or JavaScript), including updating dependencies that include assets such as Phoenix LiveView, you will need to recompile the assets with mix assets.deploy.

For general Ash contribution details, check out our contribution guide.

Hex Package Hex Preview (current file) Search HexDocs Download ePub version

Built using ExDoc (v0.38.3) for the Elixir programming language

---
