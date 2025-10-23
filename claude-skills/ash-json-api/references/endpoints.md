# Ash-Json-Api - Endpoints

**Pages:** 4

---

## AshJsonApi.Domain.BaseRoute (ash_json_api v1.4.45)

**URL:** https://hexdocs.pm/ash_json_api/AshJsonApi.Domain.BaseRoute.html

**Contents:**
- AshJsonApi.Domain.BaseRoute (ash_json_api v1.4.45)

Introspection target for base routes in AshJsonApi.Domain

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## AshJsonApi.Resource.Route (ash_json_api v1.4.45)

**URL:** https://hexdocs.pm/ash_json_api/AshJsonApi.Resource.Route.html

**Contents:**
- AshJsonApi.Resource.Route (ash_json_api v1.4.45)
- Summary
- Types
- Types
- t()

Represents a route for a resource

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## AshJsonApi (ash_json_api v1.4.45)

**URL:** https://hexdocs.pm/ash_json_api/AshJsonApi.html

**Contents:**
- AshJsonApi (ash_json_api v1.4.45)
- Summary
- Functions
- Functions
- authorize?(domain)
- log_errors?(domain)
- prefix(domain)
- router(domain)
- serve_schema?(domain)

Introspection functions for AshJsonApi domains.

For domain DSL documentation, see AshJsonApi.Domain.

For Resource DSL documentation, see AshJsonApi.Resource

To get started, see the getting started guide

See AshJsonApi.Domain.Info.authorize?/1.

See AshJsonApi.Domain.Info.log_errors?/1.

See AshJsonApi.Domain.Info.prefix/1.

See AshJsonApi.Domain.Info.router/1.

See AshJsonApi.Domain.Info.serve_schema?/1.

See AshJsonApi.Domain.Info.authorize?/1.

See AshJsonApi.Domain.Info.log_errors?/1.

See AshJsonApi.Domain.Info.prefix/1.

See AshJsonApi.Domain.Info.router/1.

See AshJsonApi.Domain.Info.serve_schema?/1.

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.4) for the Elixir programming language

---

## Open API

**URL:** https://hexdocs.pm/ash_json_api/open-api.html

**Contents:**
- Open API
- Use with Phoenix
- Use with Plug
- Customize values in the OpenAPI documentation
- Generate spec files via CLI
  - Setting a route prefix for generated files
- Using this file in production
- Known issues/limitations
  - Swagger UI
  - Redoc

To set up the Open API endpoints for your application, first include the :open_api_spex dependency:

Then in the module where you call use AshJsonApi.Router add the following option:

Finally, you can use utilities provided by open_api_spex to show UIs for your API. Be sure to put your forward call last, if you are putting your API at a sub-path.

Now you can go to /api/swaggerui and /api/redoc!

To set up the open API endpoints for your application, first include the :open_api_spex and :redoc_ui_plug dependency:

Then in the module where you call use AshJsonApi.Router add the following option:

Finally, you can use utilities provided by open_api_spex to show UIs for your API. Be sure to put your forward call last, if you are putting your API at a sub-path.

Now you can go to /api/swaggerui and /api/redoc!

To customize the main values of the OpenAPI spec, a few options are available:

If :open_api_servers is not specified, a default server is automatically derived from your app's Phoenix endpoint, as retrieved from inbound connections on the open_api HTTP route.

In case an active connection is not available, for example when generating the OpenAPI spec via CLI, you can explicitely specify a reference to the Phoenix endpoint:

To override any value in the OpenApi documentation you can use the :modify_open_api options key:

You can write the OpenAPI spec file to disk using the Mix tasks provided by OpenApiSpex.

Supposing you have setup AshJsonApi as:

you can generate the files with:

The route prefix in normal usage is automatically inferred, but when generating files we will use the prefix option set in the json_api section of the relevant Ash.Domain module.

To generate the YAML file you need to add the ymlr dependency.

You can also use the --check option to confirm that your checked in spec file(s) match.

To avoid generating the spec every time your open_api endpoint is hit, you can use the open_api_file option. Ensure that it points to an existing .json file. You will almost certainly want to do this only for production so that the schema is generated dynamically in dev, but served statically in production.

SwaggerUI does not properly render recursive types. This affects the examples and type documentation for the filter parameter especially.

Redoc does not show all available schemas in the sidebar. This means that some schemas that are referenced only but have no endpoints that refer to them are effectively un-discoverable without downloading th

*[Content truncated]*

**Examples:**

Example 1 (unknown):
```unknown
{:open_api_spex, "~> 3.16"},
```

Example 2 (unknown):
```unknown
use AshJsonApi.Router, domains: [...], open_api: "/open_api"
```

Example 3 (unknown):
```unknown
forward "/api/swaggerui",
  OpenApiSpex.Plug.SwaggerUI,
  path: "/api/open_api",
  default_model_expand_depth: 4

forward "/api/redoc",
  Redoc.Plug.RedocUI,
  spec_url: "/api/open_api"

forward "/api", YourApp.YourApiRouter
```

Example 4 (unknown):
```unknown
{:open_api_spex, "~> 3.16"},
{:redoc_ui_plug, "~> 0.2.1"},
```

---
