---
name: external-api-integration
description: Third-party API client integration with ReqCassette, Mocks, and Explicit Contracts. Use when building API clients, integrating external services, HTTP requests, API testing with real responses, or working with third-party APIs.
---

# External API Integration Skill

Comprehensive assistance for building rock-solid external API integrations in Elixir/Phoenix/Ash applications using ReqCassette for capturing real responses, Mox for explicit contracts, and proper organization patterns.

## 🎯 THE GOLDEN RULES

### ALWAYS Use ReqCassette for Integration Tests

**CRITICAL:** When integrating with external APIs:

1. **ALWAYS use ReqCassette** to capture at least ONE test with actual API responses
2. **NEVER trust mocks alone** - real API responses often differ from documentation
3. **Organization is MANDATORY** - all API client code goes in `clients/provider_name/*`
4. **Group by provider** - all code for one API provider stays together

### The Rock-Solid Testing Strategy

**Integration Tests (PRIMARY - ReqCassette):**
- Capture REAL API responses with `ReqCassette.with_cassette/2`
- At least ONE test per API endpoint with actual responses
- Catches documentation vs reality mismatches
- Provides confidence real requests will work

**Unit Tests (SECONDARY - Mox with Explicit Contracts):**
- Use for business logic around API calls
- Faster tests that don't hit network
- Explicit behaviors define contracts
- Mock only at integration boundaries

### Organization Structure (MANDATORY)

```
lib/my_app/
└── clients/                    # ALL external API code here
    ├── dataforseo/             # One provider = one directory
    │   ├── client.ex           # Main client with behavior
    │   ├── http_client.ex      # Real HTTP implementation
    │   ├── mock_client.ex      # Test mock (implements behavior)
    │   ├── serp_api.ex         # SERP API requests
    │   ├── keywords_api.ex     # Keywords API requests
    │   └── types.ex            # Shared types/structs
    ├── openai/
    │   ├── client.ex
    │   ├── http_client.ex
    │   ├── mock_client.ex
    │   ├── completions.ex
    │   └── embeddings.ex
    └── stripe/
        ├── client.ex
        ├── http_client.ex
        └── ...
```

**NEVER put API clients in:**
- ❌ `lib/my_app_web/` - web layer shouldn't contain API clients
- ❌ Context modules like `lib/my_app/accounts/` - keep external APIs separate
- ❌ Ash resources/domains - API clients are infrastructure, not domain

## When to Use This Skill

Trigger this skill when:

**Building API Integrations:**
- Integrating with third-party APIs (Stripe, OpenAI, DataForSEO, etc.)
- Building HTTP clients for external services
- Working with REST APIs, GraphQL, or any HTTP-based integration

**Testing External APIs:**
- Setting up tests that need real API responses
- Capturing actual responses for replay
- Creating integration tests with confidence
- Mocking API responses for unit tests

**Organizing API Code:**
- Structuring client code for external services
- Grouping related API functionality
- Managing multiple API providers in one app

## Key Concepts

### ReqCassette: VCR-Style Recording

ReqCassette is a record-and-replay library that captures HTTP responses to files ("cassettes"):

- **First run:** Records actual API response to cassette file
- **Subsequent runs:** Replays instantly from cassette (no network!)
- **Benefits:** Faster tests, deterministic behavior, no network dependencies

### Recording Modes

ReqCassette supports three modes:

1. **`:record` (default)** - Record if cassette doesn't exist, otherwise replay
2. **`:replay`** - Only replay from cassette, error if missing (great for CI)
3. **`:bypass`** - Ignore cassettes entirely, always use network

### Sensitive Data Filtering

Protect API keys, tokens, and passwords with four filtering approaches:

1. **Regex-based replacement** - Replace patterns in URIs and bodies
2. **Header removal** - Remove sensitive headers
3. **Request callback filtering** - Custom logic for requests
4. **Response callback filtering** - Custom logic for responses

## Quick Reference

### 1. Basic ReqCassette Test

**Capture real API response and replay in tests:**

```elixir
import ReqCassette

test "fetches user data" do
  with_cassette "github_user" do
    response = Req.get!("https://api.github.com/users/wojtekmach")
    assert response.status == 200
    assert response.body["login"] == "wojtekmach"
  end
end
```

**First run:** Records to `test/cassettes/github_user.json`
**Subsequent runs:** Replays instantly from cassette (no network!)

### 2. Explicit Plug Usage

**Pass plug to reusable functions:**

```elixir
test "fetches data via helper function" do
  with_cassette "api_data", fn plug ->
    # Pass plug to any function that calls Req
    result = MyModule.fetch_data(plug: plug)
    assert result.success?
  end
end
```

### 3. Filter Sensitive Data

**Remove API keys and tokens from cassettes:**

```elixir
with_cassette "auth",
  [
    filter_request_headers: ["authorization", "x-api-key"],
    filter_response_headers: ["set-cookie"],
    filter_sensitive_data: [
      {~r/api_key=[\w-]+/, "api_key=<REDACTED>"},
      {~r/"token":"[^"]+"/, ~s("token":"<REDACTED>")}
    ]
  ],
  fn plug ->
    Req.post!("https://api.example.com/login", json: %{...}, plug: plug)
  end
```

### 4. Recording Modes

**Control when to record and replay:**

```elixir
# :record (default) - Record if missing, otherwise replay
with_cassette "api_call", [mode: :record], fn plug ->
  Req.get!("https://api.example.com/data", plug: plug)
end

# :replay - Only replay, error if missing (great for CI)
with_cassette "api_call", [mode: :replay], fn plug ->
  Req.get!("https://api.example.com/data", plug: plug)
end

# :bypass - Ignore cassettes, always use network
with_cassette "api_call", [mode: :bypass], fn plug ->
  Req.get!("https://api.example.com/data", plug: plug)
end
```

### 5. Client with Behavior Pattern

**Main client interface with compile-time configuration:**

```elixir
# lib/my_app/clients/dataforseo/client.ex
defmodule MyApp.Clients.DataForSEO.Client do
  @moduledoc """
  Main interface for DataForSEO API.
  Implementation injected via config.
  """

  @callback get_serp_results(keyword :: String.t(), location :: String.t()) ::
    {:ok, map()} | {:error, term()}

  @impl_module Application.compile_env!(:my_app, [__MODULE__, :impl])

  def get_serp_results(keyword, location) do
    @impl_module.get_serp_results(keyword, location)
  end
end
```

### 6. HTTP Client Implementation

**Real HTTP implementation for production:**

```elixir
# lib/my_app/clients/dataforseo/http_client.ex
defmodule MyApp.Clients.DataForSEO.HTTPClient do
  @behaviour MyApp.Clients.DataForSEO.Client

  def get_serp_results(keyword, location) do
    username = Application.fetch_env!(:my_app, :dataforseo_username)
    password = Application.fetch_env!(:my_app, :dataforseo_password)

    Req.post(
      "https://api.dataforseo.com/v3/serp/google/organic/live/advanced",
      auth: {:basic, "#{username}:#{password}"},
      json: %{keyword: keyword, location_name: location}
    )
    |> handle_response()
  end

  defp handle_response({:ok, %{status: 200, body: body}}), do: {:ok, body}
  defp handle_response({:ok, %{status: status, body: body}}), do: {:error, {:http_error, status, body}}
  defp handle_response({:error, reason}), do: {:error, reason}
end
```

### 7. Mock Implementation

**Simple mock for unit tests:**

```elixir
# lib/my_app/clients/dataforseo/mock_client.ex
defmodule MyApp.Clients.DataForSEO.MockClient do
  @behaviour MyApp.Clients.DataForSEO.Client

  def get_serp_results("error_keyword", _location) do
    {:error, :api_error}
  end

  def get_serp_results(_keyword, _location) do
    {:ok, %{
      "tasks" => [
        %{"result" => [%{"items" => [%{"title" => "Test Result"}]}]}
      ]
    }}
  end
end
```

### 8. Complete Integration Test

**Test with real API responses using ReqCassette:**

```elixir
# test/my_app/clients/dataforseo/http_client_test.exs
defmodule MyApp.Clients.DataForSEO.HTTPClientTest do
  use ExUnit.Case, async: false  # ReqCassette needs async: false

  import ReqCassette
  alias MyApp.Clients.DataForSEO.HTTPClient

  @moduletag :integration

  describe "get_serp_results/2" do
    test "returns actual SERP results from API" do
      # Captures REAL API response on first run
      # Replays from cassette on subsequent runs
      with_cassette "dataforseo/serp_results_success" do
        assert {:ok, response} = HTTPClient.get_serp_results(
          "elixir phoenix",
          "United States"
        )

        # Validate actual response structure
        assert %{"tasks" => tasks} = response
        assert is_list(tasks)
      end
    end
  end
end
```

### 9. Configuration

**Switch between real and mock implementations:**

```elixir
# config/config.exs
config :my_app, MyApp.Clients.DataForSEO.Client,
  impl: MyApp.Clients.DataForSEO.HTTPClient

# config/test.exs
config :my_app, MyApp.Clients.DataForSEO.Client,
  impl: MyApp.Clients.DataForSEO.MockClient

# ReqCassette configuration
config :req_cassette,
  cassette_library_dir: "test/support/cassettes",
  filter_request_headers: ["authorization"],
  filter_response_body_keys: ["api_key", "secret"]
```

### 10. Custom Request Matching

**Match requests on specific criteria:**

```elixir
# Match only on method and URI (ignore headers, body)
plug: {ReqCassette.Plug, %{
  cassette_name: "api_call",
  match_requests_on: [:method, :uri]
}}

# Useful when request has dynamic timestamps or IDs
```

## Common Patterns

### Pattern: Multi-Step API Integration

For complex flows with multiple API calls:

```elixir
test "complete workflow with multiple API calls" do
  with_cassette "provider/complete_workflow" do
    # Step 1: Authenticate
    assert {:ok, token} = Client.authenticate()

    # Step 2: Create resource
    assert {:ok, resource} = Client.create_resource(token)

    # Step 3: Update resource
    assert {:ok, updated} = Client.update_resource(token, resource.id)

    # All captured in one cassette
  end
end
```

### Pattern: Error Handling

```elixir
test "handles rate limiting correctly" do
  with_cassette "provider/rate_limit_error" do
    # Captured actual 429 response
    assert {:error, {:rate_limit, retry_after}} = Client.make_request()
    assert is_integer(retry_after)
  end
end
```

### Pattern: LLM Testing

**Save money on LLM API calls:**

```elixir
test "generates completion" do
  with_cassette "openai/completion" do
    # First call: Costs money (real API call)
    # Subsequent runs: FREE (replays from cassette)
    assert {:ok, response} = OpenAI.create_completion(prompt)
    assert response.choices != []
  end
end
```

## Working with This Skill

### For Beginners

**Start with these steps:**

1. **Install dependencies** - Add `{:req, "~> 0.5.15"}` and `{:req_cassette, "~> 0.2.0"}` to `mix.exs`
2. **Create client structure** - Follow the mandatory organization: `lib/my_app/clients/provider_name/`
3. **Write one integration test** - Use `with_cassette` to capture a real API response
4. **Verify cassette** - Check `test/cassettes/` for the recorded JSON file

### For Intermediate Users

**Expand your integration:**

1. **Add multiple endpoints** - Keep them in the same provider directory
2. **Filter sensitive data** - Use `filter_request_headers` and `filter_sensitive_data`
3. **Add unit tests** - Use mock implementation for business logic tests
4. **Handle errors** - Capture error responses with ReqCassette

### For Advanced Users

**Optimize and scale:**

1. **Custom request matching** - Use `match_requests_on` for dynamic requests
2. **before_record hook** - Advanced filtering for complex scenarios
3. **CI configuration** - Use `:replay` mode in CI to ensure no network calls
4. **Multiple providers** - Organize multiple API integrations cleanly

### Navigation Tips

- **See integration test examples** - Check section 8 (Complete Integration Test)
- **Learn filtering** - See section 3 (Filter Sensitive Data)
- **Understand organization** - Review the Organization Structure at top
- **Quick patterns** - Check Common Patterns section

## Reference Files

This skill includes comprehensive documentation:

### ReqCassette Documentation (PRIMARY)

**api.md** - ReqCassette API and usage:
- `with_cassette/2` and `with_cassette/3` - Main testing macros
- `ReqCassette.Plug` - Low-level plug interface
- Recording modes (`:record`, `:replay`, `:bypass`)
- Cassette configuration options
- Sensitive data filtering approaches
- `before_record` hook for advanced use cases

**ReqCassette.Filter** - Filtering sensitive data:
- Regex-based replacement patterns
- Header removal for auth tokens
- Request/response callback filtering
- Filter application order
- Choosing the right filter type

**ReqCassette.BodyType** - Body type detection:
- JSON, text, and binary body handling
- Automatic content-type detection
- Pretty-printed cassette format

**ReqCassette.Cassette** - Cassette file management:
- V1.0 cassette format
- Multiple interaction storage
- Human-readable JSON files

### Req Documentation (FALLBACK REFERENCE)

Located in `references/req-fallback/`:
- **testing.md** - Req.Test for ownership-based mocking
- **api.md** - Req client API reference
- **getting_started.md** - Basic Req HTTP client usage

### Mox Documentation (FALLBACK REFERENCE)

Located in `references/mox-fallback/`:
- **api.md** - Mox API (defmock, expect, stub)
- Behavior-based mocking patterns
- Concurrent testing with Mox

## Testing Strategy Details

### Level 1: Integration Tests with ReqCassette (PRIMARY)

**Purpose:** Verify your client handles REAL API responses correctly

```elixir
test "handles actual pagination from API" do
  with_cassette "provider/paginated_response" do
    # Tests against REAL API pagination format
    assert {:ok, page1} = Client.get_page(1)
    assert {:ok, page2} = Client.get_page(2)

    # Validates actual response structure
    assert length(page1.items) == 100
    assert page1.has_next? == true
  end
end
```

**When to use:**
- Testing each API endpoint
- Validating response parsing
- Error handling scenarios
- Edge cases from production

**Benefits:**
- Catches documentation mismatches
- Tests actual error formats
- Provides confidence
- Fast after first run (cached)

### Level 2: Unit Tests with Mox (SECONDARY)

**Purpose:** Test business logic around API calls

```elixir
test "retries failed API calls" do
  expect(ClientMock, :get_data, 3, fn ->
    {:error, :timeout}
  end)

  # Test your retry logic
  assert {:error, :max_retries_exceeded} = MyFeature.fetch_with_retry()
end
```

**When to use:**
- Testing business logic
- Retry mechanisms
- Error handling flows
- Fast feedback loops

### Level 3: Live Integration Tests (Optional)

```elixir
@tag :external_api
@tag timeout: 30_000
test "actually calls live API" do
  # No cassette - hits real API
  assert {:ok, result} = HTTPClient.get_current_data()
end

# Run with: mix test --include external_api
```

**When to use:**
- Before deployments
- Validating API access
- Checking for API changes
- Run manually or in CI

## Why This Structure Works

### Problem: Documentation vs Reality

Real API responses often differ from documentation:
- Extra fields not documented
- Different error formats
- Unexpected null values
- Rate limiting behavior
- Network issues

**ReqCassette solves this** by capturing ACTUAL responses.

### Problem: Slow Tests

Network requests make tests slow and flaky.

**Solution:**
- ReqCassette: First run hits API, subsequent runs replay (fast!)
- Mox: Unit tests are instant (no network)

### Problem: Scattered API Code

LLMs often put API code in wrong places, making maintenance hard.

**Solution:**
- `clients/provider_name/*` - everything in one place
- Easy to find all Stripe code
- Easy to see all API integrations at a glance

## Notes

- **ReqCassette First:** ALWAYS use for integration tests with real responses
- **Organization:** `clients/provider_name/*` is MANDATORY
- **Group by Provider:** Keep all code for one API together
- **At Least One Real Test:** Every endpoint needs ReqCassette test
- **Cassettes in Git:** Commit cassettes (they're test fixtures)
- **Update Cassettes:** Delete cassette file to re-record
- **async: false:** ReqCassette tests must have `async: false`

## Resources

- [ReqCassette HexDocs](https://hexdocs.pm/req_cassette/)
- [Mocks and Explicit Contracts](https://dashbit.co/blog/mocks-and-explicit-contracts)
- [Req API Client Testing](https://dashbit.co/blog/req-api-client-testing)
- [Req HexDocs](https://hexdocs.pm/req/)
- [Mox HexDocs](https://hexdocs.pm/mox/)
