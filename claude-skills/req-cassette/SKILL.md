---
name: req-cassette
description: VCR-style HTTP request recording for testing (fallback reference - used by external-api-integration skill). Do not use directly; this provides underlying ReqCassette library details.
---

# Req-Cassette Skill

Comprehensive assistance with req-cassette development, generated from official documentation.

## When to Use This Skill

This skill should be triggered when:
- Working with req-cassette
- Asking about req-cassette features or APIs
- Implementing req-cassette solutions
- Debugging req-cassette code
- Learning req-cassette best practices

## Quick Reference

### Common Patterns

**Pattern 1:** call(conn, opts) @spec call(Plug.Conn.t(), opts()) :: Plug.Conn.t() Handles an incoming HTTP request by either replaying from cassette or recording.This is the main entry point for the plug, called by Req for each HTTP request. The behavior depends on the configured mode::record (default) - Checks for matching interaction, records if not found:replay - Only uses cassettes, raises error if not found:bypass - Ignores cassettes, always uses networkParametersconn - The Plug.Conn struct representing the incoming requestopts - The plug options (see opts/0)ReturnsA Plug.Conn struct with the response set and halted.Request MatchingWhen looking for a matching interaction in an existing cassette, the plug uses the matchers specified in :match_requests_on. For example:[:method, :uri] - Match only method and path (ignore query params and body)[:method, :uri, :query] - Match method, path, and query params[:method, :uri, :query, :headers, :body] - Match everything (default)Query parameters and JSON body keys are normalized (order-independent) to ensure consistent matching.FilteringBefore recording, the plug applies filters in this order:Regex filters (:filter_sensitive_data) - Applied to URI, query string, and bodiesHeader filters (:filter_request_headers, :filter_response_headers) - Removes specified headersCallback filter (:before_record) - Custom transformation functionExamples# Direct plug usage with replay mode (CI environment) plug_opts = %{ cassette_name: "github_api", cassette_dir: "test/cassettes", mode: :replay } conn = %Plug.Conn{ method: "GET", request_path: "/users/octocat", # ... other fields } # Raises if cassette doesn't exist conn = ReqCassette.Plug.call(conn, plug_opts) # With custom matching (ignore body differences) plug_opts = %{ cassette_name: "api_call", match_requests_on: [:method, :uri, :query] } conn = ReqCassette.Plug.call(conn, plug_opts) # POST requests with different bodies will match the same interaction # With filtering plug_opts = %{ cassette_name: "auth_api", filter_sensitive_data: [ {~r/api_key=[\w-]+/, "api_key=<REDACTED>"} ], filter_request_headers: ["authorization"] } conn = ReqCassette.Plug.call(conn, plug_opts) # API keys in query string are redacted, authorization headers removedErrorsThis function raises in the following cases:Mode :replay with missing cassetteMode :replay with no matching interactionMode :record when network request failsThe error messages include context to help debug the issue. init(opts) @spec init(opts() | map()) :: opts() Initializes the plug with the given options.This callback is invoked by Req when the plug is first used. It merges the provided options with default values to create the final configuration.Parametersopts - A map of options (see opts/0)ReturnsThe merged options map with defaults applied.Default Optionscassette_dir: "cassettes" - Directory for storing cassette filesmode: :record - Record new interactions, replay existing onesmatch_requests_on: [:method, :uri, :query, :headers, :body] - Match on all criteriaExamples# Minimal options (uses defaults) opts = %{cassette_name: "my_api"} ReqCassette.Plug.init(opts) #=> %{ # cassette_name: "my_api", # cassette_dir: "cassettes", # mode: :record, # match_requests_on: [:method, :uri, :query, :headers, :body] # } # Custom options override defaults opts = %{ cassette_name: "my_api", mode: :replay, match_requests_on: [:method, :uri] } ReqCassette.Plug.init(opts) #=> %{ # cassette_name: "my_api", # cassette_dir: "cassettes", # mode: :replay, # match_requests_on: [:method, :uri] # }

```
@spec call(Plug.Conn.t(), opts()) :: Plug.Conn.t()
```

**Pattern 2:** When looking for a matching interaction in an existing cassette, the plug uses the matchers specified in :match_requests_on. For example:

```
:match_requests_on
```

### Example Code Patterns

**Example 1** (python):
```python
def deps do
  [
    {:req, "~> 0.5.15"},
    {:req_cassette, "~> 0.2.0"}
  ]
end
```

## Reference Files

This skill includes comprehensive documentation in `references/`:

- **api.md** - Api documentation

Use `view` to read specific reference files when detailed information is needed.

## Working with This Skill

### For Beginners
Start with the getting_started or tutorials reference files for foundational concepts.

### For Specific Features
Use the appropriate category reference file (api, guides, etc.) for detailed information.

### For Code Examples
The quick reference section above contains common patterns extracted from the official docs.

## Resources

### references/
Organized documentation extracted from official sources. These files contain:
- Detailed explanations
- Code examples with language annotations
- Links to original documentation
- Table of contents for quick navigation

### scripts/
Add helper scripts here for common automation tasks.

### assets/
Add templates, boilerplate, or example projects here.

## Notes

- This skill was automatically generated from official documentation
- Reference files preserve the structure and examples from source docs
- Code examples include language detection for better syntax highlighting
- Quick reference patterns are extracted from common usage examples in the docs

## Updating

To refresh this skill with updated documentation:
1. Re-run the scraper with the same configuration
2. The skill will be rebuilt with the latest information
