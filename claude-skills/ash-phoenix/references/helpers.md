# Ash-Phoenix - Helpers

**Pages:** 7

---

## Get Started with Ash and Phoenix

**URL:** https://hexdocs.pm/ash_phoenix/getting-started-with-ash-and-phoenix.html

**Contents:**
- Get Started with Ash and Phoenix
- Setup
- Connecting your Resource to a Phoenix LiveView
  - mix ash_phoenix.gen.live
- Where to Next?
  - Examples
  - Continue Learning
  - Ash Authentication & Ash Authentication Phoenix
  - Add an API (or two)

This is a small guide to get you started with Ash & Phoenix. See the AshPhoenix home page for more information on what is available.

To begin, you should go through the Ash getting started guide. You should choose the step to create a new application with Phoenix pre-installed, as Phoenix cannot easily be added to your project later.

Once you've done that, you'll have some Ash resources with which to follow the next steps.

In general, working with Ash and Phoenix is fairly "standard" with the exception that you will be calling into your Ash resources & domains instead of context functions. For that reason, we suggest reading their documentation as well, since nothing really changes about controllers, liveviews etc.

We can run mix ash_phoenix.gen.live to generate a liveview! Run the following command to generate a starting point for your own liveview. Remember that it is just a starting point, not a finished product.

Now, start the web server by running mix phx.server. Then, visit the tickets route that you added in your browser to see what we have just created.

There's a few places you can go to learn more about how to use ash:

See the power Ash can bring to your web app or API. Get authentication working in minutes.

Check out the AshJsonApi and AshGraphql extensions to effortlessly build APIs around your resources.

Hex Package Hex Preview (current file) Search HexDocs Download ePub version

Built using ExDoc (v0.38.3) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
mix ash_phoenix.gen.live --domain Helpdesk.Support --resource Helpdesk.Support.Ticket
```

---

## Home

**URL:** https://hexdocs.pm/ash_phoenix/readme.html

**Contents:**
- Home
- AshPhoenix
- Installation
- Whats in the box?
- Tutorials
- Topics

Welcome! This is the package for integrating Phoenix Framework and Ash Framework. It provides tools for integrating with Phoenix forms (AshPhoenix.Form), Phoenix LiveViews (AshPhoenix.LiveView) and more.

Add ash_phoenix to your list of dependencies in mix.exs:

Hex Package Hex Preview (current file) Search HexDocs Download ePub version

Built using ExDoc (v0.38.3) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
{:ash_phoenix, "~> 2.3.17"}
```

---

## 

**URL:** https://hexdocs.pm/ash_phoenix/ash_phoenix.epub

---

## AshPhoenix (ash_phoenix v2.3.17)

**URL:** https://hexdocs.pm/ash_phoenix/AshPhoenix.html

**Contents:**
- AshPhoenix (ash_phoenix v2.3.17)
- Custom Input Transformations
- Usage
- Summary
- Functions
- Functions
- forms(body)

An extension to add form builders to the code interface.

There is currently no DSL for this extension.

This defines a form_to_<name> function for each code interface function. Arguments are processed according to any custom input transformations defined on the code interface, while the params option remains untouched.

The generated function passes all options through to AshPhoenix.Form.for_action/3

Update and destroy actions take the record being updated/destroyed as the first argument.

For example, given this code interface definition on a domain called MyApp.Accounts:

Adding the AshPhoenix extension would define form_to_register_with_password/2.

If your code interface defines custom inputs with transformations, the form interface will honor those transformations for arguments, but not for params passed via the params option:

For update/destroy actions, the record is required as the first parameter:

Update/destroy with options

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.3) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
resources do
  resource MyApp.Accounts.User do
    define :register_with_password, args: [:email, :password]
    define :update_user, action: :update, args: [:email, :password]
  end
end
```

Example 2 (javascript):
```javascript
# In your domain
resource MyApp.Blog.Comment do
  define :create_with_post do
    action :create_with_post_id
    args [:post]

    custom_input :post, :struct do
      constraints instance_of: MyApp.Blog.Post
      transform to: :post_id, using: & &1.id
    end
  end
end

# Usage - the post argument will be transformed
form = MyApp.Blog.form_to_create_with_post(
  %MyApp.Blog.Post{id: "some-id"},
  params: %{"text" => "Hello world"}
)
# The post struct gets transformed to post_id in the form
# The params remain unchanged
```

Example 3 (javascript):
```javascript
MyApp.Accounts.form_to_register_with_password()
#=> %AshPhoenix.Form{}
```

Example 4 (javascript):
```javascript
MyApp.Accounts.form_to_register_with_password(params: %{"email" => "placeholder@email"})
#=> %AshPhoenix.Form{}
```

---

## mix ash_phoenix.gen.html (ash_phoenix v2.3.17)

**URL:** https://hexdocs.pm/ash_phoenix/Mix.Tasks.AshPhoenix.Gen.Html.html

**Contents:**
- mix ash_phoenix.gen.html (ash_phoenix v2.3.17)
- Positional Arguments
- Options
- Summary
- Functions
- Functions
- run(args)

This task renders .ex and .heex templates and copies them to specified directories.

Callback implementation for Mix.Task.run/1.

Callback implementation for Mix.Task.run/1.

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.3) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
mix ash_phoenix.gen.html MyApp.Shop MyApp.Shop.Product --resource-plural products
```

---

## AshPhoenix.SubdomainPlug (ash_phoenix v2.3.17)

**URL:** https://hexdocs.pm/ash_phoenix/AshPhoenix.SubdomainPlug.html

**Contents:**
- AshPhoenix.SubdomainPlug (ash_phoenix v2.3.17)
- Summary
- Functions
- Functions
- live_tenant(socket, url)

This is a basic plug that loads the current tenant assign from a given value set on subdomain.

This was copied from Triplex.SubdomainPlug, here: https://github.com/ateliware/triplex/blob/master/lib/triplex/plugs/subdomain_plug.ex

:endpoint (atom/0) - Required. The endpoint that the plug is in, used for deterining the host

:assign (atom/0) - The key to use when assigning the current tenant The default value is :current_tenant.

:handle_subdomain - An mfa to call with the conn and a subdomain value. Can be used to do something like fetch the current user given the tenant. Must return the new conn.

To plug it on your router, you can use:

An additional helper here can be used for determining the host in your liveview, and/or using the host that was already assigned to the conn.

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.3) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
plug AshPhoenix.SubdomainPlug,
  endpoint: MyApp.Endpoint
```

Example 2 (python):
```python
def handle_params(params, uri, socket) do
  socket =
    assign_new(socket, :current_tenant, fn ->
      AshPhoenix.SubdomainPlug.live_tenant(socket, uri)
    end)

  socket =
    assign_new(socket, :current_organization, fn ->
      if socket.assigns[:current_tenant] do
        MyApp.Accounts.Ash.get!(MyApp.Accounts.Organization,
          subdomain: socket.assigns[:current_tenant]
        )
      end
    end)

  {:noreply, socket}
end
```

---

## mix ash_phoenix.gen.live (ash_phoenix v2.3.17)

**URL:** https://hexdocs.pm/ash_phoenix/Mix.Tasks.AshPhoenix.Gen.Live.html

**Contents:**
- mix ash_phoenix.gen.live (ash_phoenix v2.3.17)
- Example
- Options
- Summary
- Functions
- Functions
- igniter(igniter)

Generates liveviews for a given domain and resource.

The domain and resource must already exist, this task does not define them.

Callback implementation for Igniter.Mix.Task.igniter/1.

Callback implementation for Igniter.Mix.Task.igniter/1.

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.3) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
mix ash_phoenix.gen.live --domain MyApp.Shop --resource MyApp.Shop.Product --resourceplural products
```

---
