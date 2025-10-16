## External API integration standards

**Canonical guide for integrating with external APIs** in Elixir projects using the "Mocks and Explicit Contracts" pattern established by José Valim and the Elixir community.

**Opinionated Stack:**

- **Mox** - The only acceptable mocking library (behaviour-based, concurrent-safe)
- **Req** - The only acceptable HTTP client (batteries-included, built on Finch)

### The Origin Story

##### Philosophy: Mocks and Explicit Contracts

In October 2015, José Valim (creator of Elixir) published ["Mocks and Explicit Contracts"](https://dashbit.co/blog/mocks-and-explicit-contracts), fundamentally changing how the Elixir community approaches testing external dependencies. Two years later, Dashbit released Mox, a library that embodies these principles.

### Core Principle: Mock as a Noun, Never a Verb

**Traditional mocking treats "mock" as a verb** - you _mock_ an existing module, changing its behavior globally or for specific tests. This creates:

- Shared mutable state across tests
- Inability to run tests concurrently (`async: true` forbidden)
- Tight coupling to implementation details
- Hidden dependencies that break silently

**The Elixir approach treats "mock" as a noun** - a Mock is a concrete module that implements a behavior. This enables:

- No shared state (each test gets its own expectations)
- Concurrent test execution with `async: true`
- If you have a test file that uses both async: true and import Mox, you should always add Mox.set_mox_private() in the setup block.
- Compiler-verified contracts between mock and real implementation
- Explicit boundaries between components

### The Contract-First Design

**Quote from José Valim:**

> "Mocks/stubs do not remove the need to define an explicit interface between your components... Defining contracts allows you to see the complexity in your dependencies and make it as explicit as you can."

Every external dependency MUST be hidden behind an explicit behavior (contract). This forces you to:

1. **Think about boundaries** - What does your application actually need from this API?
2. **Make complexity visible** - Each `@callback` represents a dependency
3. **Enable testability** - Swap implementations via configuration
4. **Support concurrent tests** - No global mocking, no shared state

### Core Philosophy: Mocks and Explicit Contracts

- **Mock as Noun Not Verb**: Treat "mock" as a concrete module implementing a behavior, not an action that modifies existing modules
- **Explicit Contracts Required**: Every external dependency MUST be hidden behind an explicit behavior (contract)
- **Compiler-Verified**: Mocks implement behaviors - if real implementation changes, mock breaks at compile time
- **Concurrent Testing**: Process-based expectations allow tests to run with `async: true` safely
- **No Shared State**: Each test gets its own expectations - no global mocking

### Opinionated Library Choices

- **Mox Only**: The ONLY acceptable mocking library - behavior-based, concurrent-safe, recommended by Elixir core team
- **Req Only**: The ONLY acceptable HTTP client - batteries-included, built on Finch, designed for testing
- **Never HTTPoison**: Legacy library with poor testing support - use Req instead
- **Never Tesla**: Overly complex adapter pattern - use Req instead
- **Never Mimic/Mockery**: Bypass behaviors and safety guarantees - use Mox instead

### Three-Layer Architecture (Mandatory)

- **Layer 1 - Behavior Contract**: Define `@callback` functions in behavior module (e.g., `MyApp.Clients.StripeAPI`)
- **Layer 2 - HTTP Implementation**: Implement behavior with Req HTTP client (e.g., `MyApp.Clients.StripeAPI.HTTP`)
- **Layer 3 - Public Facade**: Provide public API using `defdelegate` and `Application.compile_env/3` (e.g., `MyApp.Stripe`)
- **No Variations Allowed**: This structure is mandatory for all external API integrations

### Behavior Contract (Layer 1)

- **Define in lib/my_app/clients/**: Create `api_name.ex` with behavior module
- **Document Every Callback**: Use `@doc` to document each `@callback` with purpose, parameters, and return types
- **Specific Types**: Use precise types (`:string`, `:map`, `{:ok, map()}`) not just `term()`
- **Tuple Returns**: All functions MUST return `{:ok, result} | {:error, reason}` tuples
- **Implementation Notes**: Include comments explaining complex behaviors and API quirks

### HTTP Implementation (Layer 2)

- **Implement Behavior**: Add `@behaviour MyApp.Clients.APIName` directive
- **Use @impl true**: Mark all callback implementations with `@impl true` for compiler verification
- **Build Req at Compile Time**: Use `@req Req.new(base_url: "...", retry: :transient)` module attribute
- **Handle All Responses**: Normalize 2xx (success), 4xx (client error), 5xx (server error), network errors
- **Normalize Errors**: Return `{:error, {:client_error, status, body}}`, `{:error, {:server_error, status, body}}`, `{:error, {:network_error, reason}}`
- **Retrieve API Keys at Runtime**: Use `Application.fetch_env!/2` in private function, not compile time
- **Built-in Retry**: Use Req's `:retry` option for transient failures (network issues, 5xx errors)

### Public Facade (Layer 3)

- **Use compile_env**: Select implementation with `@client Application.compile_env(:my_app, :api_client, MyApp.Clients.API.HTTP)`
- **Pure Delegation**: Use `defdelegate function(args), to: @client` for all public functions
- **No Business Logic**: Facade must contain zero business logic - only delegation
- **Document Swap Mechanism**: Explain in moduledoc how implementation swaps per environment
- **Clear Usage Examples**: Show how application code calls the facade in moduledoc

### Configuration Strategy

- **config/config.exs**: Shared configuration (base URLs, timeouts)
- **config/dev.exs**: HTTP client for development with test API keys from env vars
- **config/prod.exs**: HTTP client for production
- **config/runtime.exs**: Runtime secrets with `System.fetch_env!/1` for production
- **config/test.exs**: Mock client (e.g., `MyApp.Clients.API.Mock`) with fake values
- **compile_env for Client**: Use `Application.compile_env/3` to select client module (compile-time optimization)
- **fetch_env for Secrets**: Use `Application.fetch_env!/2` for API keys and URLs (runtime retrieval)

### Mox Setup and Usage

- **Define in test_helper.exs**: `Mox.defmock(MyApp.Clients.API.Mock, for: MyApp.Clients.API)` once for entire suite
- **Global Mode**: Use `Mox.def_mock_global(MyApp.Clients.API.Mock)` to allow concurrent testing
- **Never Per-Test**: Do not define mocks in individual tests - define once globally
- **Import Mox**: Add `import Mox` to test modules that use expectations
- **verify_on_exit!**: Use `setup :verify_on_exit!` to ensure expectations are met
- **expect not stub**: Use `expect/4` for specific test expectations, not `stub/3` (stubs are for setup blocks)

### Primary Testing Strategy: Mox for Business Logic

- **99% of Tests**: Use Mox-based testing for all business logic that depends on external APIs
- **Always async true**: Every test file MUST start with `use ExUnit.Case, async: true`
- **Set Expectations**: Use `expect(MyApp.Clients.API.Mock, :function_name, fn args -> result end)` in each test
- **Test Business Logic**: Focus on testing YOUR code's behavior, not HTTP request details
- **Fast Execution**: No network calls means instant test feedback
- **Deterministic Results**: Same input always produces same output - no API rate limits or network issues

### Secondary Testing Strategy: Req.Test for HTTP Layer

- **Test HTTP Implementation Only**: Use `Req.Test` ONLY for testing Layer 2 (HTTP client), not business logic
- **Verify Request Format**: Test that requests have correct headers, body structure, authentication
- **Test Response Parsing**: Verify HTTP client correctly parses API responses into expected format
- **Test Error Normalization**: Ensure 4xx, 5xx, and network errors are normalized correctly
- **Still Concurrent**: Req.Test tests can run with `async: true`

### Optional Testing Strategy: Bypass for Integration

- **Use Sparingly**: Only when Req.Test insufficient for testing network-level behavior
- **Tag Integration**: Mark with `@moduletag :integration` and `@moduletag :skip` by default
- **Cannot Run Async**: Bypass is not concurrent-safe - must use `async: false`
- **Test Retry Logic**: Verify exponential backoff and retry behavior with simulated failures
- **Test Network Failures**: Simulate connection refused, timeouts, and partial responses
- **Manual or Nightly**: Run manually or in nightly builds, not every commit

### Testing Best Practices

- **Test Error Scenarios**: Always test client errors (4xx), server errors (5xx), and network failures
- **Verify Error Handling**: Ensure your business logic handles each error type appropriately
- **Simple Expectations**: Keep mock expectations focused - assert only what matters for that specific test
- **One Integration Test**: Create ONE integration test per API endpoint that uses real HTTP (skip by default)
- **No Real Requests in CI**: Never make actual API calls in continuous integration - too slow, costs money, non-deterministic

### Real-World Fixture Testing Strategy

- **Capture Real Responses**: Record actual API responses at least once using ReqCassette (for Req) to capture real edge cases (NaN, Infinity, malformed data)
- **Store as Test Fixtures**: Save recorded responses in `test/fixtures/api_name/` as JSON cassettes committed to version control
- **Test Against Fixtures**: Create dedicated fixture tests that process all recorded responses to verify edge case handling
- **Sanitize Sensitive Data**: Use ReqCassette's filtering or manual sanitization to remove API keys, tokens, PII before committing fixtures
- **ReqCassette Setup**: Add `plug: {ReqCassette.Plug, cassette_dir: "test/fixtures/api_name"}` to Req client for recording
- **Still Use Mox Primary**: Real fixtures supplement (not replace) Mox tests - use fixtures to discover edge cases, then add specific Mox tests for them

### Anti-Patterns to Avoid

- **Never Mock HTTP Library Directly**: Don't mock Req directly - always mock your behavior
- **Never Skip Behavior Contract**: Every API client needs explicit behavior definition with `@callback`
- **Never Use async false Without Reason**: If test can't run concurrently, design is wrong - fix it
- **Never Hardcode Secrets**: Always use environment variables for API keys - fail fast if missing
- **Never Test HTTP Details in Business Logic Tests**: Mox tests should focus on business logic, not request formatting
- **Never Forget Integration Tests**: Create at least one real API test per endpoint (even if skipped by default)
- **Never Modify Config in Tests**: Configure once in config/test.exs, not with `Application.put_env` per test

### Implementation Checklist

- **Step 1**: Define behavior contract with `@callback` declarations in `lib/my_app/clients/api_name.ex`
- **Step 2**: Implement HTTP client with `@behaviour` and Req in `lib/my_app/clients/api_name/http.ex`
- **Step 3**: Create public facade with `defdelegate` in `lib/my_app/api_name.ex`
- **Step 4**: Configure environments (HTTP in dev/prod, Mock in test)
- **Step 5**: Define Mox mock in `test/test_helper.exs`
- **Step 6**: Write unit tests for business logic using Mox (async true)
- **Step 7**: Write HTTP client tests using Req.Test
- **Step 8**: Create one integration test (tagged, skipped by default)

### Why This Pattern Matters

- **Concurrent Tests**: Process-based mocks allow all tests to run in parallel (fast test suites)
- **Compile-Time Safety**: Behavior changes break mocks at compile time, not runtime
- **Clear Boundaries**: Explicit contracts make dependencies visible and manageable
- **Testability**: Swap implementations via configuration - no code changes needed
- **Maintainability**: All API integration code follows same structure - easy to find and modify
- **Reliability**: No network calls in tests means consistent, fast feedback

### Common Gotchas

- **Forgetting @impl true**: Compiler won't verify callback matches behavior
- **Using get_env Instead of compile_env**: Loses compile-time optimization and error checking
- **Complex Mock Expectations**: Keep expectations simple - assert only what this test needs
- **Testing Too Much in One Test**: One expectation per test for clarity
- **Not Using verify_on_exit!**: Mocks may not be called as expected without verification
- **Hardcoding Test URLs**: Use configuration even for test values to prevent accidental real requests

### Documentation Requirements

- **Behavior Module**: Document the contract, explain what application needs from API
- **HTTP Implementation**: Document error formats, authentication, and rate limiting
- **Public Facade**: Show usage examples, explain swap mechanism
- **Test Examples**: Include example tests in behavior moduledoc
- **Error Handling**: Document all possible error tuples and what they mean

### Error Handling Standards

- **Consistent Error Format**: All errors as tuples `{:error, {:category, details}}`
- **Client Errors (4xx)**: `{:error, {:client_error, status, body}}` - invalid request, auth failure
- **Server Errors (5xx)**: `{:error, {:server_error, status, body}}` - API unavailable, internal error
- **Network Errors**: `{:error, {:network_error, reason}}` - timeout, connection refused, DNS failure
- **Business Logic**: Convert API errors to domain errors (e.g., `{:error, :invalid_email}` from 400 status)

### Benefits Summary

- **Fast Tests**: No network calls means test suite runs in milliseconds, not minutes
- **Reliable Tests**: Deterministic behavior - no flaky tests from network issues or API changes
- **Safe Refactoring**: Compiler catches contract violations when changing implementations
- **Easy Debugging**: Clear error messages when mocks not called as expected
- **Concurrent Execution**: All tests run in parallel for maximum speed
- **Clear Dependencies**: Explicit contracts make it obvious what your app depends on
- **Production Confidence**: Integration tests verify real API still matches mocked behavior
