# Req-Cassette - Api

**Pages:** 5

---

## ReqCassette (ReqCassette v0.3.0)

**URL:** https://hexdocs.pm/req_cassette/ReqCassette.html

**Contents:**
- ReqCassette (ReqCassette v0.3.0)
- Features
- Quick Start
- Upgrading from v0.1
- Installation
- Recording Modes
- Sensitive Data Filtering
  - Filter Application Order
- Advanced: before_record Hook
  - ⚠️ Critical Warnings

A VCR-style record-and-replay library for Elixir's Req HTTP client.

ReqCassette captures HTTP responses to files ("cassettes") and replays them in subsequent test runs, making your tests faster, deterministic, and free from network dependencies.

First run: Records to test/cassettes/github_user.json Subsequent runs: Replays instantly from cassette (no network!)

⚠️ Important: v0.2.0 introduces breaking changes to improve the API and cassette format. See the Migration Guide for upgrade instructions.

Migration time: ~15-30 minutes for most projects

Control when to record and replay:

Protect API keys, tokens, and sensitive data:

ReqCassette provides four filtering approaches for sensitive data protection:

When recording, filters are applied in this sequence:

This ensures simple filters run first, then targeted callbacks, and finally the advanced before_record hook sees the complete filtered result.

Note: Only filter_request is also applied during replay matching to ensure requests match correctly. All other filters only run during recording.

For detailed filtering documentation, see ReqCassette.Filter.

⚠️ ADVANCED - Use with Caution

The :before_record option provides full access to the interaction for cross-field manipulation. This is NOT for filtering - use filter_request and filter_response for that instead.

Computing response fields based on request data:

Instead, use filter_request:

Only use before_record when you need to:

Save money on LLM API calls during testing:

First call: Costs money (real API call) Subsequent runs: FREE (replays from cassette)

Perfect for passing plug to reusable functions:

Cassettes are stored as pretty-printed JSON with native JSON objects:

Body types are automatically detected:

See with_cassette/3 for the full API and configuration options. See ReqCassette.Plug for low-level plug interface.

Execute code with a cassette, providing the plug explicitly.

Execute code with a cassette, providing the plug explicitly.

Unlike use_cassette/2 which auto-injects the plug, with_cassette/3 provides the plug configuration as an argument to your function, giving you explicit control over where and how it's used.

This is particularly useful for:

The return value of the provided function.

Hex Package Hex Preview Search HexDocs

Built using ExDoc (v0.38.4) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
import ReqCassette

test "fetches user data" do
  with_cassette "github_user", fn plug ->
    response = Req.get!("https://api.github.com/users/wojtekmach", plug: plug)
    assert response.status == 200
    assert response.body["login"] == "wojtekmach"
  end
end
```

Example 2 (python):
```python
def deps do
  [
    {:req, "~> 0.5.15"},
    {:req_cassette, "~> 0.2.0"}
  ]
end
```

Example 3 (unknown):
```unknown
# :record (default) - Record if cassette doesn't exist or interaction not found, otherwise replay
with_cassette "api_call", [mode: :record], fn plug ->
  Req.get!("https://api.example.com/data", plug: plug)
end

# :replay - Only replay from cassette, error if missing (great for CI)
with_cassette "api_call", [mode: :replay], fn plug ->
  Req.get!("https://api.example.com/data", plug: plug)
end

# :bypass - Ignore cassettes entirely, always use network
with_cassette "api_call", [mode: :bypass], fn plug ->
  Req.get!("https://api.example.com/data", plug: plug)
end

# To re-record a cassette: dele
...
```

Example 4 (unknown):
```unknown
with_cassette "auth",
  [
    filter_request_headers: ["authorization", "x-api-key"],
    filter_response_headers: ["set-cookie"],
    filter_sensitive_data: [
      {~r/api_key=[\w-]+/, "api_key=<REDACTED>"}
    ],
    filter_request: fn request ->
      update_in(request, ["body_json", "timestamp"], fn _ -> "<NORMALIZED>" end)
    end,
    filter_response: fn response ->
      update_in(response, ["body_json", "secret"], fn _ -> "<REDACTED>" end)
    end
  ],
  fn plug ->
    Req.post!("https://api.example.com/login", json: %{...}, plug: plug)
  end
```

---

## ReqCassette.Plug (ReqCassette v0.3.0)

**URL:** https://hexdocs.pm/req_cassette/ReqCassette.Plug.html

**Contents:**
- ReqCassette.Plug (ReqCassette v0.3.0)
- Usage
    - Cassette Naming Best Practice
- Options
- Recording Modes
  - :record (default)
  - :replay
  - :bypass
- Request Matching
- Cassette File Format

A Plug that intercepts Req HTTP requests and records/replays them from cassette files.

This module implements the Plug behaviour and is designed to be used with Req's :plug option to enable VCR-style testing for HTTP clients.

The easiest way to use this plug is via the ReqCassette.with_cassette/3 function, but it can also be used directly with Req:

Always provide :cassette_name for human-readable, maintainable cassette files.

Without cassette_name (not recommended):

With cassette_name (recommended):

The MD5 hash fallback exists for backward compatibility but should be avoided in new code.

ReqCassette supports three recording modes that control when cassettes are created/used:

Records new interactions, replays existing ones. Appends to existing cassettes. Ideal for development:

Only replays from cassettes. Raises error if cassette or matching interaction not found. Perfect for CI environments to ensure no unexpected network calls:

Ignores cassettes completely, always hits the network. Never saves. Useful for debugging or selectively disabling cassettes:

By default, requests are matched on all criteria (method, URI, query, headers, body). You can customize this with :match_requests_on:

Cassettes use v1.0 format with pretty-printed JSON and multiple interactions:

Responses are stored in one of three formats based on content type:

This approach produces compact, human-readable cassette files.

This plug uses Req's native plug system, which provides:

Recording Flow (:record mode):

Replay Flow (:replay or :record with existing cassette):

Bypass Flow (:bypass mode):

Works seamlessly with ReqLLM for testing LLM integrations:

Options for configuring the cassette plug.

Handles an incoming HTTP request by either replaying from cassette or recording.

Initializes the plug with the given options.

Options for configuring the cassette plug.

Handles an incoming HTTP request by either replaying from cassette or recording.

This is the main entry point for the plug, called by Req for each HTTP request. The behavior depends on the configured mode:

A Plug.Conn struct with the response set and halted.

When looking for a matching interaction in an existing cassette, the plug uses the matchers specified in :match_requests_on. For example:

Query parameters and JSON body keys are normalized (order-independent) to ensure consistent matching.

Before recording, the plug applies filters in this order:

This function raises in the following cases:

The error m

*[Content truncated]*

**Examples:**

Example 1 (unknown):
```unknown
# With with_cassette/3 (recommended)
ReqCassette.with_cassette("my_api_call", [cassette_dir: "test/cassettes"], fn plug ->
  Req.get!("https://api.example.com/data", plug: plug)
end)

# Direct usage
Req.get!(
  "https://api.example.com/data",
  plug: {ReqCassette.Plug, %{
    cassette_name: "my_api_call",
    cassette_dir: "test/cassettes"
  }}
)
```

Example 2 (unknown):
```unknown
plug: {ReqCassette.Plug, %{cassette_dir: "test/cassettes"}}
# Creates: a1b2c3d4e5f6789012345678901234ab.json
# ❌ Cryptic MD5 hash - hard to identify which test this belongs to
```

Example 3 (unknown):
```unknown
plug: {ReqCassette.Plug, %{cassette_name: "github_user", cassette_dir: "test/cassettes"}}
# Creates: github_user.json
# ✅ Clear, readable - easy to manage and understand
```

Example 4 (unknown):
```unknown
# First run: records interaction to cassette
ReqCassette.with_cassette("api", [], fn plug ->
  Req.get!("https://api.example.com/data", plug: plug)
end)

# Subsequent runs: replays from cassette (no network call)

# To re-record: delete cassette file first
File.rm!("test/cassettes/api.json")
```

---

## ReqCassette.Filter (ReqCassette v0.3.0)

**URL:** https://hexdocs.pm/req_cassette/ReqCassette.Filter.html

**Contents:**
- ReqCassette.Filter (ReqCassette v0.3.0)
- Why Filter Cassettes?
- Filtering Types
  - 1. Regex-Based Replacement ✅ Recommended for patterns
  - 2. Header Removal ✅ Recommended for auth headers
  - 3. Request Callback Filtering ✅ Safe for complex request filtering
  - 4. Response Callback Filtering ✅ Always safe
- Filter Application Order
- Choosing the Right Filter Type
- Usage

Filters sensitive data from cassette interactions before saving.

This module provides comprehensive filtering capabilities to remove or redact sensitive information (API keys, tokens, passwords, etc.) from cassette files before they're saved. This ensures that cassettes can be safely committed to version control without exposing secrets.

Cassettes record real HTTP interactions, which often contain sensitive data:

Filtering prevents these secrets from being committed to your repository.

ReqCassette supports four complementary filtering approaches:

Replace patterns in URIs, query strings, and request/response bodies using regular expressions:

Remove sensitive headers from requests and responses:

Target request-only filtering with custom logic:

⚠️ Important: If filter_request modifies fields used for matching (method, uri, query, headers, body), consider adjusting match_requests_on to exclude those fields, or ensure transformations are idempotent.

Target response-only filtering:

Filters are applied in this specific order during recording:

Regex filters (filter_sensitive_data) - Applied to:

Header filters - Applied to:

Request callback (filter_request) - Applied to:

Response callback (filter_response) - Applied to:

Full interaction callback (before_record) - Applied to:

This ordering ensures coarse-grained filters (regex, headers) run first, then specific callbacks (request/response), and finally the advanced before_record can access the complete filtered result.

For JSON bodies, regex filters are applied intelligently:

This allows patterns like ~r/"token":"[^"]+" to match the JSON structure directly, while also supporting value-level patterns like ~r/secret_value/.

Applies all configured filters to an interaction before saving.

Applies all configured filters to an interaction before saving.

Filtered interaction map

This function also supports the advanced :before_record option for backward compatibility and special use cases. See ReqCassette module documentation for details on when to use it.

Hex Package Hex Preview Search HexDocs

Built using ExDoc (v0.38.4) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
filters = [
  filter_sensitive_data: [
    {~r/api_key=[\w-]+/, "api_key=<REDACTED>"},
    {~r/"token":"[^"]+"/, ~s("token":"<REDACTED>")},
    {~r/Bearer [\w.-]+/, "Bearer <REDACTED>"}
  ]
]
```

Example 2 (unknown):
```unknown
# API keys
{~r/api_key=[\w-]+/, "api_key=<REDACTED>"}
{~r/"apiKey":"[^"]+"/, ~s("apiKey":"<REDACTED>")}

# Tokens
{~r/Bearer [\w.-]+/, "Bearer <REDACTED>"}
{~r/"token":"[^"]+"/, ~s("token":"<REDACTED>")}

# Email addresses
{~r/[\w.+-]+@[\w.-]+\.[a-zA-Z]{2,}/, "user@example.com"}

# Credit cards
{~r/\d{4}[- ]?\d{4}[- ]?\d{4}[- ]?\d{4}/, "XXXX-XXXX-XXXX-XXXX"}

# UUIDs (for consistent cassettes)
{~r/[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}/, "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"}
```

Example 3 (unknown):
```unknown
filters = [
  filter_request_headers: ["authorization", "x-api-key", "cookie"],
  filter_response_headers: ["set-cookie", "x-secret-token"]
]
```

Example 4 (unknown):
```unknown
filters = [
  filter_request: fn request ->
    request
    |> update_in(["body_json", "email"], fn _ -> "redacted@example.com" end)
    |> update_in(["body_json", "timestamp"], fn _ -> "<NORMALIZED>" end)
  end
]
```

---

## ReqCassette.BodyType (ReqCassette v0.3.0)

**URL:** https://hexdocs.pm/req_cassette/ReqCassette.BodyType.html

**Contents:**
- ReqCassette.BodyType (ReqCassette v0.3.0)
- Body Types
  - :json - JSON Data
  - :text - Plain Text
  - :blob - Binary Data
- Detection Algorithm
- Usage
- Examples
- Summary
- Types

Detects and handles different body types for optimal cassette storage.

This module provides intelligent body type detection and encoding/decoding to ensure cassettes are human-readable, compact, and easy to edit. It distinguishes between three body types based on content-type headers and content analysis.

JSON responses are stored as native Elixir data structures in the body_json field. When the cassette is saved, Jason pretty-prints the JSON for readability.

Text responses (HTML, XML, CSV, plain text) are stored as strings in the body field.

Binary responses (images, PDFs, videos) are base64-encoded in the body_blob field.

The module uses a multi-step detection process:

Content-Type Header - Check for explicit type hints

Already Decoded - If Req already decoded the body to a map/list → :json

JSON Parsing - Attempt to parse as JSON, if successful → :json

Printability Check - Use String.printable?/1:

This ensures accurate detection even when content-type headers are missing or incorrect.

This module is used internally by ReqCassette.Cassette when adding interactions:

You typically don't need to use this module directly - it's called automatically by the cassette system.

Decodes body from cassette storage.

Detects the body type from content and headers.

Encodes body for cassette storage based on its type.

Decodes body from cassette storage.

Decoded body as binary string

Detects the body type from content and headers.

Body type: :json, :text, or :blob

Encodes body for cassette storage based on its type.

Tuple of {field_name, encoded_value} where:

Hex Package Hex Preview Search HexDocs

Built using ExDoc (v0.38.4) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
"body_json": {
  "id": 1,
  "name": "Alice",
  "roles": ["admin", "user"]
}
```

Example 2 (unknown):
```unknown
"body": "<html><head><title>Page</title></head><body>...</body></html>"
```

Example 3 (unknown):
```unknown
"body_blob": "iVBORw0KGgoAAAANSUhEUgAAAAUA..."
```

Example 4 (unknown):
```unknown
# Automatic type detection and encoding
body_type = BodyType.detect_type(response.body, response.headers)
{field, value} = BodyType.encode(response.body, body_type)

# Later, when replaying
decoded_body = BodyType.decode(cassette_response)
```

---

## ReqCassette.Cassette (ReqCassette v0.3.0)

**URL:** https://hexdocs.pm/req_cassette/ReqCassette.Cassette.html

**Contents:**
- ReqCassette.Cassette (ReqCassette v0.3.0)
- Cassette Format v1.0
- Key Features
  - Multiple Interactions Per Cassette
  - Body Type Discrimination
  - Pretty-Printed JSON
  - Request Matching with Normalization
- Examples
- See Also
- Summary

Handles cassette file format v1.0 with multiple interactions per file.

This module provides the core functionality for creating, loading, saving, and searching cassette files. Cassettes store HTTP request/response pairs ("interactions") in a human-readable JSON format.

Each cassette file contains a version field and an array of interactions:

Multiple interactions can be stored in a single cassette file with human-readable names:

Bodies are stored in one of three formats based on content type:

Example JSON storage:

All cassettes are saved with Jason.encode!(cassette, pretty: true) for:

Requests are matched using configurable criteria with automatic normalization:

A single HTTP request/response interaction

HTTP response details

A cassette file containing multiple interactions

Adds an interaction to a cassette.

Finds a matching interaction in the cassette based on request matching criteria.

Loads a cassette from disk.

Creates a new empty cassette with version 1.0.

Saves a cassette to disk as pretty-printed JSON.

A single HTTP request/response interaction

HTTP response details

A cassette file containing multiple interactions

Adds an interaction to a cassette.

Creates a new interaction from the given request and response, applies any configured filters, and appends it to the cassette's interactions array.

The opts parameter can include:

See ReqCassette.Filter for details on filtering.

Updated cassette map with the new interaction appended to the "interactions" array.

This function automatically detects the body type for both request and response:

Each interaction includes a recorded_at field with an ISO8601 UTC timestamp indicating when the interaction was captured.

Finds a matching interaction in the cassette based on request matching criteria.

Searches through all interactions in the cassette to find one where the request matches the given conn and body according to the specified matchers. Returns the first matching interaction's response.

The match_on parameter accepts a list of atoms that specify what to match:

Common matching strategies:

To ensure consistent matching, certain fields are normalized:

This allows for flexible matching while maintaining deterministic behavior.

Loads a cassette from disk.

Supports both v1.0 and v0.1 formats for backward compatibility.

Creates a new empty cassette with version 1.0.

Saves a cassette to disk as pretty-printed JSON.

Hex Package Hex Preview Search HexDocs

Built using ExDoc (v0.38

*[Content truncated]*

**Examples:**

Example 1 (unknown):
```unknown
{
  "version": "1.0",
  "interactions": [
    {
      "request": {
        "method": "GET",
        "uri": "https://api.example.com/users/1",
        "query_string": "filter=active",
        "headers": {
          "accept": ["application/json"],
          "user-agent": ["req/0.5.15"]
        },
        "body_type": "text",
        "body": ""
      },
      "response": {
        "status": 200,
        "headers": {
          "content-type": ["application/json"]
        },
        "body_type": "json",
        "body_json": {
          "id": 1,
          "name": "Alice"
        }
      },
      "re
...
```

Example 2 (unknown):
```unknown
# All requests in one test go to one cassette
ReqCassette.with_cassette("user_workflow", [], fn plug ->
  user = Req.get!("/users/1", plug: plug)      # Interaction 1
  posts = Req.get!("/posts", plug: plug)       # Interaction 2
  comments = Req.get!("/comments", plug: plug) # Interaction 3
end)
# Creates: user_workflow.json with 3 interactions
```

Example 3 (unknown):
```unknown
"body_json": {
  "id": 1,
  "name": "Alice"
}
```

Example 4 (javascript):
```javascript
# Create a new cassette
cassette = ReqCassette.Cassette.new()
#=> %{"version" => "1.0", "interactions" => []}

# Add an interaction
cassette = add_interaction(cassette, conn, request_body, response)

# Save to disk (pretty-printed)
save("test/cassettes/my_api.json", cassette)

# Load from disk
{:ok, cassette} = load("test/cassettes/my_api.json")

# Find a matching interaction
case find_interaction(cassette, conn, body, [:method, :uri]) do
  {:ok, response} -> response
  :not_found -> # Record new interaction
end

# Multiple interactions in one cassette
cassette = new()
cassette = add_interacti
...
```

---
