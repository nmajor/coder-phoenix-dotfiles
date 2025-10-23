# Ash-Authentication-Phoenix - Routes

**Pages:** 2

---

## AshAuthentication.Phoenix.Overrides (ash_authentication_phoenix v2.12.1)

**URL:** https://hexdocs.pm/ash_authentication_phoenix/AshAuthentication.Phoenix.Overrides.html

**Contents:**
- AshAuthentication.Phoenix.Overrides (ash_authentication_phoenix v2.12.1)
- Summary
- Functions
- Functions
- override(component, list)
- set(selector, value)

Behaviour for overriding component styles and attributes in your application.

The default implementation is AshAuthentication.Phoenix.Overrides.Default which uses TailwindCSS to generate a fairly generic looking user interface.

You can override this by adding your own override modules to the AshAuthentication.Phoenix.Router.sign_in_route/1 macro in your router:

and defining lib/my_app_web/auth_overrides.ex within which you can set any overrides.

The use macro defines overridable versions of all callbacks which return nil, so you only need to define the functions that you care about.

Each of the override modules specified in the config will be called in the order that they're specified, so you can still use the defaults if you just override some properties.

Define overrides for a specific component.

Override a setting within a component.

Define overrides for a specific component.

Override a setting within a component.

Hex Package Hex Preview Search HexDocs

Built using ExDoc (v0.38.4) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
sign_in_route overrides: [MyAppWeb.AuthOverrides, AshAuthentication.Phoenix.Overrides.Default]
```

Example 2 (unknown):
```unknown
defmodule MyAppWeb.AuthOverrides do
  use AshAuthentication.Phoenix.Overrides
  alias AshAuthentication.Phoenix.Components

  override Components.Banner do
    set :image_url, "/images/sign_in_logo.png"
  end
end
```

---

## mix ash_authentication.phoenix.routes (ash_authentication_phoenix v2.12.1)

**URL:** https://hexdocs.pm/ash_authentication_phoenix/Mix.Tasks.AshAuthentication.Phoenix.Routes.html

**Contents:**
- mix ash_authentication.phoenix.routes (ash_authentication_phoenix v2.12.1)
- Summary
- Functions
- Functions
- get_url_info(url, arg)

Prints all routes pertaining to AshAuthenticationPhoenix for the default or a given router.

This task can be called directly, accepting the same options as mix phx.routes, except for --info.

Alternatively, you can modify your aliases task to run them back to back it.

Hex Package Hex Preview Search HexDocs

Built using ExDoc (v0.38.4) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
aliases: ["phx.routes": ["do", "phx.routes,", "ash_authentication.phoenix.routes"]]
```

---
