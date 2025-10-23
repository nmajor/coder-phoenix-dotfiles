# Ash-Authentication-Phoenix - Liveview

**Pages:** 23

---

## AshAuthentication.Phoenix.Components.OAuth2 (ash_authentication_phoenix v2.12.1)

**URL:** https://hexdocs.pm/ash_authentication_phoenix/AshAuthentication.Phoenix.Components.OAuth2.html

**Contents:**
- AshAuthentication.Phoenix.Components.OAuth2 (ash_authentication_phoenix v2.12.1)
- Component hierarchy
- Props
- Overrides
- Summary
- Types
- Functions
- Types
- props()
- Functions

Generates a sign-in button for OAuth2.

This is the top-most strategy-specific component, nested below AshAuthentication.Phoenix.Components.SignIn.

This component provides the following overrides:

See AshAuthentication.Phoenix.Overrides for more information.

Hex Package Hex Preview Search HexDocs

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## AshAuthentication.Phoenix.Components.MagicLink.Form (ash_authentication_phoenix v2.12.1)

**URL:** https://hexdocs.pm/ash_authentication_phoenix/AshAuthentication.Phoenix.Components.MagicLink.Form.html

**Contents:**
- AshAuthentication.Phoenix.Components.MagicLink.Form (ash_authentication_phoenix v2.12.1)
- Component heirarchy
- Props
- Overrides

Generates a default magic sign in form.

This is a child of AshAuthentication.Phoenix.Components.MagicLink.SignIn.

This component provides the following overrides:

See AshAuthentication.Phoenix.Overrides for more information.

Hex Package Hex Preview Search HexDocs

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## AshAuthentication.Phoenix.Components.Password.SignInForm (ash_authentication_phoenix v2.12.1)

**URL:** https://hexdocs.pm/ash_authentication_phoenix/AshAuthentication.Phoenix.Components.Password.SignInForm.html

**Contents:**
- AshAuthentication.Phoenix.Components.Password.SignInForm (ash_authentication_phoenix v2.12.1)
- Component hierarchy
- Props
- Overrides
- Summary
- Types
- Types
- props()

Generates a default sign in form.

This is a child of AshAuthentication.Phoenix.Components.Password.

This component provides the following overrides:

See AshAuthentication.Phoenix.Overrides for more information.

Hex Package Hex Preview Search HexDocs

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## AshAuthentication.Phoenix.Components.MagicLink.Input (ash_authentication_phoenix v2.12.1)

**URL:** https://hexdocs.pm/ash_authentication_phoenix/AshAuthentication.Phoenix.Components.MagicLink.Input.html

**Contents:**
- AshAuthentication.Phoenix.Components.MagicLink.Input (ash_authentication_phoenix v2.12.1)
- Component hierarchy
- Overrides
- Summary
- Functions
- Functions
- submit(assigns)
- Props

Function components for dealing with form input during magic link sign in.

These function components are consumed by AshAuthentication.Phoenix.Components.MagicLink.Form

This component provides the following overrides:

See AshAuthentication.Phoenix.Overrides for more information.

Generate an form submit button.

Generate an form submit button.

Hex Package Hex Preview Search HexDocs

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## AshAuthentication.Phoenix.Components.Password.RegisterForm (ash_authentication_phoenix v2.12.1)

**URL:** https://hexdocs.pm/ash_authentication_phoenix/AshAuthentication.Phoenix.Components.Password.RegisterForm.html

**Contents:**
- AshAuthentication.Phoenix.Components.Password.RegisterForm (ash_authentication_phoenix v2.12.1)
- Component hierarchy
- Props
- Overrides
- Summary
- Types
- Types
- props()

Generates a default registration form.

This is a child of AshAuthentication.Phoenix.Components.Password.

This component provides the following overrides:

See AshAuthentication.Phoenix.Overrides for more information.

Hex Package Hex Preview Search HexDocs

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## AshAuthentication.Phoenix.Components.SignIn (ash_authentication_phoenix v2.12.1)

**URL:** https://hexdocs.pm/ash_authentication_phoenix/AshAuthentication.Phoenix.Components.SignIn.html

**Contents:**
- AshAuthentication.Phoenix.Components.SignIn (ash_authentication_phoenix v2.12.1)
- Component hierarchy
- Overrides
- Props
- Summary
- Types
- Types
- props()

Renders sign in mark-up for an authenticated resource.

This means that it will render sign-in UI for all of the authentication strategies for a resource.

For each strategy configured on the resource a component name is inferred (e.g. AshAuthentication.Strategy.Password becomes AshAuthentication.Phoenix.Components.Password) and is rendered into the output.

This is the top-most authentication component.

This component provides the following overrides:

See AshAuthentication.Phoenix.Overrides for more information.

Hex Package Hex Preview Search HexDocs

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## AshAuthentication.Phoenix.Components.Password (ash_authentication_phoenix v2.12.1)

**URL:** https://hexdocs.pm/ash_authentication_phoenix/AshAuthentication.Phoenix.Components.Password.html

**Contents:**
- AshAuthentication.Phoenix.Components.Password (ash_authentication_phoenix v2.12.1)
- Component hierarchy
- Props
- Slots
- Overrides
- Summary
- Types
- Types
- props()

Generates sign in, registration and reset forms for a resource.

This is the top-most strategy-specific component, nested below AshAuthentication.Phoenix.Components.SignIn.

This component provides the following overrides:

See AshAuthentication.Phoenix.Overrides for more information.

Hex Package Hex Preview Search HexDocs

Built using ExDoc (v0.38.4) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
<.live_component
  module={AshAuthentication.Phoenix.Components.Password}
  strategy={AshAuthentication.Info.strategy!(Example.User, :password)}
  id="user-with-password"
  socket={@socket}
  overrides={[AshAuthentication.Phoenix.Overrides.Default]}>

  <:sign_in_extra :let={form}>
    <.input field={form[:capcha]} />
  </:sign_in_extra>

  <:register_extra :let={form}>
    <.input field={form[:name]} />
  </:register_extra>

  <:reset_extra :let={form}>
    <.input field={form[:capcha]} />
  </:reset_extra>
</.live_component>
```

---

## AshAuthentication.Phoenix.Components.Password.ResetForm (ash_authentication_phoenix v2.12.1)

**URL:** https://hexdocs.pm/ash_authentication_phoenix/AshAuthentication.Phoenix.Components.Password.ResetForm.html

**Contents:**
- AshAuthentication.Phoenix.Components.Password.ResetForm (ash_authentication_phoenix v2.12.1)
- Component hierarchy
- Props
- Overrides
- Summary
- Types
- Types
- props()

Generates a default password reset form.

This is a child of AshAuthentication.Phoenix.Components.Password.

This component provides the following overrides:

See AshAuthentication.Phoenix.Overrides for more information.

Hex Package Hex Preview Search HexDocs

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## AshAuthentication.Phoenix.Components.Confirm (ash_authentication_phoenix v2.12.1)

**URL:** https://hexdocs.pm/ash_authentication_phoenix/AshAuthentication.Phoenix.Components.Confirm.html

**Contents:**
- AshAuthentication.Phoenix.Components.Confirm (ash_authentication_phoenix v2.12.1)
- Component hierarchy
- Props
- Overrides
- Summary
- Types
- Types
- props()

Renders a confirmation button.

This component provides the following overrides:

See AshAuthentication.Phoenix.Overrides for more information.

Hex Package Hex Preview Search HexDocs

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## AshAuthentication.Phoenix.Components.Reset (ash_authentication_phoenix v2.12.1)

**URL:** https://hexdocs.pm/ash_authentication_phoenix/AshAuthentication.Phoenix.Components.Reset.html

**Contents:**
- AshAuthentication.Phoenix.Components.Reset (ash_authentication_phoenix v2.12.1)
- Component hierarchy
- Props
- Overrides
- Summary
- Types
- Types
- props()

Renders a password-reset form.

This component provides the following overrides:

See AshAuthentication.Phoenix.Overrides for more information.

Hex Package Hex Preview Search HexDocs

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## AshAuthentication.Phoenix.ResetLive (ash_authentication_phoenix v2.12.1)

**URL:** https://hexdocs.pm/ash_authentication_phoenix/AshAuthentication.Phoenix.ResetLive.html

**Contents:**
- AshAuthentication.Phoenix.ResetLive (ash_authentication_phoenix v2.12.1)
- Overrides

A generic, white-label password reset page.

This live-view can be rendered into your app using the AshAuthentication.Phoenix.Router.reset_route/1 macro in your router (or by using Phoenix.LiveView.Controller.live_render/3 directly in your markup).

This live-view looks for the token URL parameter, and if found passes it to AshAuthentication.Phoenix.Components.Reset.

This component provides the following overrides:

See AshAuthentication.Phoenix.Overrides for more information.

Hex Package Hex Preview Search HexDocs

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## Setting up your routes for LiveView

**URL:** https://hexdocs.pm/ash_authentication_phoenix/liveview.html

**Contents:**
- Setting up your routes for LiveView
- Authentication helper

A built in live session wrapper is provided that will set the user assigns for you. To use it, wrap your live routes like so:

There are two problems with the above, however.

To accomplish this, we use standard Phoenix on_mount hooks. Lets define a hook that gives us three potential behaviors, one for optionally having a user signed in, one for requiring a signed in user, and one for requiring that there is no signed in user.

And we can use this as follows:

If you want to allow access to a live_view based on users role or some other condition:

You can also match multiple roles:

Use it in a on_mount call in a LiveView:

You can also use this to prevent users from visiting the auto generated sign_in route:

Hex Package Hex Preview (current file) Search HexDocs

Built using ExDoc (v0.38.4) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
ash_authentication_live_session :session_name do
  live "/route", ProjectLive.Index, :index
end
```

Example 2 (python):
```python
# lib/my_app_web/live_user_auth.ex
defmodule MyAppWeb.LiveUserAuth do
  @moduledoc """
  Helpers for authenticating users in LiveViews.
  """

  import Phoenix.Component
  use MyAppWeb, :verified_routes

  def on_mount(:live_user_optional, _params, _session, socket) do
    if socket.assigns[:current_user] do
      {:cont, socket}
    else
      {:cont, assign(socket, :current_user, nil)}
    end
  end

  def on_mount(:live_user_required, _params, _session, socket) do
    if socket.assigns[:current_user] do
      {:cont, socket}
    else
      {:halt, Phoenix.LiveView.redirect(socket, to: ~p"/s
...
```

Example 3 (unknown):
```unknown
# lib/my_app_web/router.ex
  # ...
  scope "/", MyAppWeb do
    # ...
    ash_authentication_live_session :authentication_required,
      on_mount: {MyAppWeb.LiveUserAuth, :live_user_required} do
      live "/protected_route", ProjectLive.Index, :index
    end

    ash_authentication_live_session :authentication_optional,
      on_mount: {MyAppWeb.LiveUserAuth, :live_user_optional} do
      live "/", ProjectLive.Index, :index
    end
  end
  # ...
```

Example 4 (python):
```python
def on_mount({:required_role, role}, _params, _session, socket) do
  if socket.assigns[:current_user] && socket.assigns[:current_user].role == role do
    {:cont, socket}
  else
    {:halt, Phoenix.LiveView.redirect(socket, to: ~p"/")}
  end
end
```

---

## AshAuthentication.Phoenix.Components.Confirm.Form (ash_authentication_phoenix v2.12.1)

**URL:** https://hexdocs.pm/ash_authentication_phoenix/AshAuthentication.Phoenix.Components.Confirm.Form.html

**Contents:**
- AshAuthentication.Phoenix.Components.Confirm.Form (ash_authentication_phoenix v2.12.1)
- Component hierarchy
- Props
- Overrides
- Summary
- Types
- Types
- props()

Generates a default confirmation form.

This is a child of AshAuthentication.Phoenix.Components.Confirm.

This component provides the following overrides:

See AshAuthentication.Phoenix.Overrides for more information.

Hex Package Hex Preview Search HexDocs

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## AshAuthentication.Phoenix.Components.Banner (ash_authentication_phoenix v2.12.1)

**URL:** https://hexdocs.pm/ash_authentication_phoenix/AshAuthentication.Phoenix.Components.Banner.html

**Contents:**
- AshAuthentication.Phoenix.Components.Banner (ash_authentication_phoenix v2.12.1)
- Props
- Overrides
- Summary
- Types
- Types
- props()

Renders a very simple banner at the top of the sign-in component.

Can show either an image or some text, depending on the provided overrides.

This component provides the following overrides:

See AshAuthentication.Phoenix.Overrides for more information.

Hex Package Hex Preview Search HexDocs

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## AshAuthentication.Phoenix.Components.MagicLink (ash_authentication_phoenix v2.12.1)

**URL:** https://hexdocs.pm/ash_authentication_phoenix/AshAuthentication.Phoenix.Components.MagicLink.html

**Contents:**
- AshAuthentication.Phoenix.Components.MagicLink (ash_authentication_phoenix v2.12.1)
- Component hierarchy
- Props
- Overrides
- Summary
- Types
- Types
- props()

Generates a sign-in for for a resource using the "Magic link" strategy.

This is the top-most strategy-specific component, nested below AshAuthentication.Phoenix.Components.SignIn.

This component provides the following overrides:

See AshAuthentication.Phoenix.Overrides for more information.

Hex Package Hex Preview Search HexDocs

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## AshAuthentication.Phoenix.Components.Apple (ash_authentication_phoenix v2.12.1)

**URL:** https://hexdocs.pm/ash_authentication_phoenix/AshAuthentication.Phoenix.Components.Apple.html

**Contents:**
- AshAuthentication.Phoenix.Components.Apple (ash_authentication_phoenix v2.12.1)
- Component hierarchy
- Props
- Overrides
- Summary
- Types
- Functions
- Types
- props()
- Functions

Generates a sign-in button for Apple.

This is the top-most strategy-specific component, nested below AshAuthentication.Phoenix.Components.SignIn.

This component provides the following overrides:

See AshAuthentication.Phoenix.Overrides for more information.

Hex Package Hex Preview Search HexDocs

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## Overriding Ash Authentication Phoenix's default UI

**URL:** https://hexdocs.pm/ash_authentication_phoenix/ui-overrides.html

**Contents:**
- Overriding Ash Authentication Phoenix's default UI
- Defining Overrides
- Internationalisation
- Telling AshAuthentication about your overrides
- Reference
- Sign In
  - AshAuthentication.Phoenix.SignInLive
  - AshAuthentication.Phoenix.Components.SignIn
- Password Sign-in
  - AshAuthentication.Phoenix.Components.Password

Ash Authentication Phoenix provides a default UI implementation to get you started, however we wanted there to be a middle road between "you gets what you gets" and "¯\(ツ)/¯ make your own". Thus AAP's system of UI overrides were born.

Each of our LiveView components has a number of hooks where you can override either the CSS styles, text or images.

In addition you have the option to provide a gettext/2 compatible function through which all output text will be run.

You override these components by defining an "overrides module", which you will then provide in your router when setting up your routes.

For example, if we wanted to change the default banner used on the sign-in page:

You only need to define the overrides you want to change. Unspecified overrides will use their default value.

When overriding UI elements, remember to account for dark mode support. Some properties have dark mode variants (prefixed with dark_) that should be set alongside their light mode counterparts. For instance, if you override image_url, you should typically also set dark_image_url to ensure your UI looks good in both light and dark modes.

Plug in your Gettext backend and have all display text translated automagically, see next section for an example.

The package includes Gettext templates for the untranslated messages and a growing number of translations. You might want to

For other i18n libraries you have the option to provide a gettext-like handler function, see AshAuthentication.Phoenix.Router.sign_in_route/1 for details.

To do this, you modify your sign_in_route calls to contain the overrides option. Be sure to put the AshAuthentication.Phoenix.Overrides.Default override last, as it contains the default values for all components!

The same way you may add a gettext_backend option to specify your Gettext backend and domain.

The below documentation is autogenerated from the components that support overrides. All available overrides are listed here. If you are looking to override something not in this list, please open an issue, or even better a PR!

Looking at the source of the components can be enlightening to see exactly how an override is used. If you click on the name of component you are interested in, and then look in the top right (if you are on hexdocs), you will see a </> button that will take you to the source for that component. In that code, look for calls to override_for/3 to see specifically how each override is used.

A generic, white-label sign-in 

*[Content truncated]*

**Examples:**

Example 1 (unknown):
```unknown
defmodule MyAppWeb.AuthOverrides do
  use AshAuthentication.Phoenix.Overrides

  # Override a property per component
  override AshAuthentication.Phoenix.Components.Banner do
    # include any number of properties you want to override
    set :image_url, "/images/rickroll.gif"
    set :dark_image_url, "/images/rickroll-dark.gif"
  end
end
```

Example 2 (unknown):
```unknown
cp -rv deps/ash_authentication_phoenix/i18n/gettext/* priv/gettext
```

Example 3 (unknown):
```unknown
defmodule MyAppWeb.Router do
  use MyAppWeb, :router
  use AshAuthentication.Phoenix.Router

  # ...

  scope "/", MyAppWeb do
    sign_in_route overrides: [MyAppWeb.AuthOverrides, AshAuthentication.Phoenix.Overrides.Default],
                  gettext_backend: {MyAppWeb.Gettext, "auth"}
  end
end
```

---

## AshAuthentication.Phoenix.Components.Confirm.Input (ash_authentication_phoenix v2.12.1)

**URL:** https://hexdocs.pm/ash_authentication_phoenix/AshAuthentication.Phoenix.Components.Confirm.Input.html

**Contents:**
- AshAuthentication.Phoenix.Components.Confirm.Input (ash_authentication_phoenix v2.12.1)
- Component hierarchy
- Overrides
- Summary
- Functions
- Functions
- submit(assigns)
- Props

Function components for dealing with form input during password authentication.

These function components are consumed by AshAuthentication.Phoenix.Components.Password.SignInForm, AshAuthentication.Phoenix.Components.Password.RegisterForm and AshAuthentication.Phoenix.Components.ResetForm.

This component provides the following overrides:

See AshAuthentication.Phoenix.Overrides for more information.

Generate an form submit button.

Generate an form submit button.

Hex Package Hex Preview Search HexDocs

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## AshAuthentication.Phoenix.Components.MagicLink.SignIn (ash_authentication_phoenix v2.12.1)

**URL:** https://hexdocs.pm/ash_authentication_phoenix/AshAuthentication.Phoenix.Components.MagicLink.SignIn.html

**Contents:**
- AshAuthentication.Phoenix.Components.MagicLink.SignIn (ash_authentication_phoenix v2.12.1)
- Component heirarchy
- Props
- Overrides

Renders a magic sign in button.

This component provides the following overrides:

See AshAuthentication.Phoenix.Overrides for more information.

Hex Package Hex Preview Search HexDocs

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## AshAuthentication.Phoenix.Components.Reset.Form (ash_authentication_phoenix v2.12.1)

**URL:** https://hexdocs.pm/ash_authentication_phoenix/AshAuthentication.Phoenix.Components.Reset.Form.html

**Contents:**
- AshAuthentication.Phoenix.Components.Reset.Form (ash_authentication_phoenix v2.12.1)
- Component hierarchy
- Props
- Overrides
- Summary
- Types
- Types
- props()

Generates a default password reset form.

This is a child of AshAuthentication.Phoenix.Components.Reset.

This component provides the following overrides:

See AshAuthentication.Phoenix.Overrides for more information.

Hex Package Hex Preview Search HexDocs

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## AshAuthentication.Phoenix.Components.HorizontalRule (ash_authentication_phoenix v2.12.1)

**URL:** https://hexdocs.pm/ash_authentication_phoenix/AshAuthentication.Phoenix.Components.HorizontalRule.html

**Contents:**
- AshAuthentication.Phoenix.Components.HorizontalRule (ash_authentication_phoenix v2.12.1)
- Overrides
- Props
- Summary
- Types
- Types
- props()

A horizontal rule with text.

This component is pretty tailwind-specific, but I (@jimsynz) really wanted a certain look. If you think I'm wrong then please let me know.

This component provides the following overrides:

See AshAuthentication.Phoenix.Overrides for more information.

Hex Package Hex Preview Search HexDocs

Built using ExDoc (v0.38.4) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
* `overrides` - A list of override modules.
```

---

## AshAuthentication.Phoenix.SignInLive (ash_authentication_phoenix v2.12.1)

**URL:** https://hexdocs.pm/ash_authentication_phoenix/AshAuthentication.Phoenix.SignInLive.html

**Contents:**
- AshAuthentication.Phoenix.SignInLive (ash_authentication_phoenix v2.12.1)
- Overrides

A generic, white-label sign-in page.

This live-view can be rendered into your app using the AshAuthentication.Phoenix.Router.sign_in_route/1 macro in your router (or by using Phoenix.LiveView.Controller.live_render/3 directly in your markup).

This live-view finds all Ash resources with an authentication configuration (via AshAuthentication.authenticated_resources/1) and renders the appropriate UI for their providers using AshAuthentication.Phoenix.Components.SignIn.

This component provides the following overrides:

See AshAuthentication.Phoenix.Overrides for more information.

Hex Package Hex Preview Search HexDocs

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## AshAuthentication.Phoenix.Components.Password.Input (ash_authentication_phoenix v2.12.1)

**URL:** https://hexdocs.pm/ash_authentication_phoenix/AshAuthentication.Phoenix.Components.Password.Input.html

**Contents:**
- AshAuthentication.Phoenix.Components.Password.Input (ash_authentication_phoenix v2.12.1)
- Component hierarchy
- Overrides
- Summary
- Functions
- Functions
- error(assigns)
- Props
- identity_field(assigns)
- Props

Function components for dealing with form input during password authentication.

These function components are consumed by AshAuthentication.Phoenix.Components.Password.SignInForm, AshAuthentication.Phoenix.Components.Password.RegisterForm and AshAuthentication.Phoenix.Components.ResetForm.

This component provides the following overrides:

See AshAuthentication.Phoenix.Overrides for more information.

Generate a list of errors for a field (if there are any).

Generate a form field for the configured identity field.

Generate a form field for the configured password confirmation entry field.

Generate a form field for the configured password entry field.

Generate a form field for the remember me field.

Generate an form submit button.

Generate a list of errors for a field (if there are any).

Generate a form field for the configured identity field.

Generate a form field for the configured password confirmation entry field.

Generate a form field for the configured password entry field.

Generate a form field for the remember me field.

Generate an form submit button.

Hex Package Hex Preview Search HexDocs

Built using ExDoc (v0.38.4) for the Elixir programming language

---
