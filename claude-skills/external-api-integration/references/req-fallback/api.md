# Req - Api

**Pages:** 12

---

## Req.ArchiveError exception (req v0.5.15)

**URL:** https://hexdocs.pm/req/Req.ArchiveError.html

**Contents:**
- Req.ArchiveError exception (req v0.5.15)

Represents an error when unpacking archives fails, returned by Req.Steps.decode_body/1.

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.2) for the Elixir programming language

---

## Req (req v0.5.15)

**URL:** https://hexdocs.pm/req/Req.html

**Contents:**
- Req (req v0.5.15)
- Examples
- Headers
    - Note
- Summary
- Types
- Functions
- Functions (Making Requests)
- Functions (Async Response)
- Types

Req - the high-level API (you're here!)

Req.Request - the low-level API and the request struct

Req.Steps - the collection of built-in steps

Req.Test - the testing conveniences

The high-level API is what most users of Req will use most of the time.

Making a GET request with Req.get!/1:

Same, but by explicitly building request struct first:

Return the request that was sent using Req.run!/2:

Making a POST request with Req.post!/2:

Set connection timeout:

See run_finch for more connection related options and usage examples.

Stream response body using a callback:

Stream response body into a Collectable:

Stream response body to the current process and parse incoming messages using Req.parse_message/2.

Same as above, using enumerable API:

See :into option in Req.new/1 documentation for more information on response body streaming.

The HTTP specification requires that header names should be case-insensitive. Req allows two ways to access the headers; using functions and by accessing the data directly:

While we can ensure case-insensitive handling in the former case, we can't in the latter. For this reason, Req made the following design choices:

header names are stored as downcased

functions like Req.Request.get_header/2, Req.Request.put_header/3, Req.Response.get_header/2, Req.Response.put_header/3, etc automatically downcase the given header name.

Most Elixir/Erlang HTTP clients represent headers as lists of tuples like:

For interopability with those, use Req.get_headers_list/1.

Returns default options.

Sets default options for Req.new/1.

Returns request/response headers as list.

Updates a request struct.

Returns a new request struct with built-in steps.

Makes a DELETE request and returns a response or an error.

Makes a DELETE request and returns a response or raises an error.

Makes a GET request and returns a response or an error.

Makes a GET request and returns a response or raises an error.

Makes a HEAD request and returns a response or an error.

Makes a HEAD request and returns a response or raises an error.

Makes a PATCH request and returns a response or an error.

Makes a PATCH request and returns a response or raises an error.

Makes a POST request and returns a response or an error.

Makes a POST request and returns a response or raises an error.

Makes a PUT request and returns a response or an error.

Makes a PUT request and returns a response or raises an error.

Makes an HTTP request and returns a response or an error.


*[Content truncated]*

**Examples:**

Example 1 (unknown):
```unknown
iex> Req.get!("https://api.github.com/repos/wojtekmach/req").body["description"]
"Req is a batteries-included HTTP client for Elixir."
```

Example 2 (unknown):
```unknown
iex> req = Req.new(base_url: "https://api.github.com")
iex> Req.get!(req, url: "/repos/wojtekmach/req").body["description"]
"Req is a batteries-included HTTP client for Elixir."
```

Example 3 (unknown):
```unknown
iex> {req, resp} = Req.run!("https://httpbin.org/basic-auth/foo/bar", auth: {:basic, "foo:bar"})
iex> req.headers["authorization"]
["Basic Zm9vOmJhcg=="]
iex> resp.status
200
```

Example 4 (javascript):
```javascript
iex> Req.post!("https://httpbin.org/post", form: [comments: "hello!"]).body["form"]
%{"comments" => "hello!"}
```

---

## Req.DecompressError exception (req v0.5.15)

**URL:** https://hexdocs.pm/req/Req.DecompressError.html

**Contents:**
- Req.DecompressError exception (req v0.5.15)

Represents an error when decompression fails, returned by Req.Steps.decompress_body/1.

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.2) for the Elixir programming language

---

## Req.HTTPError exception (req v0.5.15)

**URL:** https://hexdocs.pm/req/Req.HTTPError.html

**Contents:**
- Req.HTTPError exception (req v0.5.15)

Represents an HTTP protocol error.

This is a standardised exception that all Req adapters should use for HTTP-protocol-related errors.

This exception is based on Mint.HTTPError.

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.2) for the Elixir programming language

---

## Req.Response (req v0.5.15)

**URL:** https://hexdocs.pm/req/Req.Response.html

**Contents:**
- Req.Response (req v0.5.15)
- Summary
- Types
- Functions
- Types
- t()
- Functions
- delete_header(resp, name)
- Examples
- get_header(resp, name)

:status - the HTTP status code.

:headers - the HTTP response headers. The header names should be downcased. See also "Headers" section in Req module documentation.

:body - the HTTP response body.

:trailers - the HTTP response trailers. The trailer names must be downcased.

:private - a map reserved for libraries and frameworks to use. Prefix the keys with the name of your project to avoid any future conflicts. Only accepts atom/0 keys.

Deletes the header given by name.

Returns the values of the header specified by name.

Gets the value for a specific private key.

Returns the retry-after header delay value or nil if not found.

Builds or updates a response with JSON body.

Returns a new response.

Adds a new response header name if not present, otherwise replaces the previous value of that header with value.

Assigns a private key to value.

Converts response to a map for interoperability with other libraries.

Updates private key with the given function.

Deletes the header given by name.

All occurrences of the header are deleted, in case the header is repeated multiple times.

See also "Headers" section in Req module documentation.

Returns the values of the header specified by name.

See also "Headers" section in Req module documentation.

Gets the value for a specific private key.

Returns the retry-after header delay value or nil if not found.

Builds or updates a response with JSON body.

If the request already contains a 'content-type' header, it is kept as is:

Returns a new response.

Expects a keyword list, map, or struct containing the response keys.

Adds a new response header name if not present, otherwise replaces the previous value of that header with value.

See also "Headers" section in Req module documentation.

Assigns a private key to value.

Converts response to a map for interoperability with other libraries.

The resulting map has the folowing fields:

Note, body can be any term since Req built-in and custom steps usually transform it.

Updates private key with the given function.

If key is present in request private map then the existing value is passed to fun and its result is used as the updated value of key. If key is not present, default is inserted as the value of key. The default value will not be passed through the update function.

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.2) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
iex> Req.Response.get_header(resp, "cache-control")
["max-age=600", "no-transform"]
iex> resp = Req.Response.delete_header(resp, "cache-control")
iex> Req.Response.get_header(resp, "cache-control")
[]
```

Example 2 (unknown):
```unknown
iex> Req.Response.get_header(response, "content-type")
["application/json"]
```

Example 3 (javascript):
```javascript
iex> Req.Response.json(%{hello: 42})
%Req.Response{
  status: 200,
  headers: %{"content-type" => ["application/json"]},
  body: ~s|{"hello":42}|
}

iex> resp = Req.Response.new()
iex> Req.Response.json(resp, %{hello: 42})
%Req.Response{
  status: 200,
  headers: %{"content-type" => ["application/json"]},
  body: ~s|{"hello":42}|
}
```

Example 4 (javascript):
```javascript
iex> Req.Response.new()
iex> |> Req.Response.put_header("content-type", "application/vnd.api+json; charset=utf-8")
iex> |> Req.Response.json(%{hello: 42})
%Req.Response{
  status: 200,
  headers: %{"content-type" => ["application/vnd.api+json; charset=utf-8"]},
  body: ~s|{"hello":42}|
}
```

---

## Req.Request (req v0.5.15)

**URL:** https://hexdocs.pm/req/Req.Request.html

**Contents:**
- Req.Request (req v0.5.15)
- The Low-level API
- The Request Struct
- Steps
  - Request Steps
    - Examples
  - Response and Error Steps
  - Halting
- Writing Plugins
- Adapter

The low-level API and the request struct.

Req - the high-level API

Req.Request - the low-level API and the request struct (you're here!)

Req.Steps - the collection of built-in steps

Req.Test - the testing conveniences

The low-level API and the request struct is the foundation of Req's extensibility. Virtually all of the functionality is broken down into individual pieces - steps. Req works by running the request struct through these steps. You can easily reuse or rearrange built-in steps or write new ones.

To make using custom steps by others even easier, they can be packaged up into plugins. See "Writing Plugins" section for more information.

Most Req users would use it like this:

Here is the equivalent using the low-level API:

By putting the request pipeline yourself you have precise control of exactly what is running and in what order.

:method - the HTTP request method.

:url - the HTTP request URL.

:headers - the HTTP request headers. The header names should be downcased. See also "Headers" section in Req module documentation.

:body - the HTTP request body.

iodata - eagerly send request body

enumerable - stream request body

:into - where to send the response body. It can be one of:

nil - (default) read the whole response body and store it in the response.body field.

fun - stream response body using a function. The first argument is a {:data, data} tuple containing the chunk of the response body. The second argument is a {request, response} tuple. To continue streaming chunks, return {:cont, {req, resp}}. To cancel, return {:halt, {req, resp}}. For example:

collectable - stream response body into a Collectable.t/0. For example:

Note that the collectable is only used, if the response status is 200. In other cases, the body is accumulated and processed as usual.

:options - the options to be used by steps. The exact representation of options is private. Calling request.options[key], put_in(request.options[key], value), and update_in(request.options[key], fun) is allowed. get_option/3 and delete_option/2 are also available for additional ways to manipulate the internal representation.

:halted - whether the request pipeline is halted. See halt/2.

:adapter - a request step that makes the actual HTTP request. Defaults to Req.Steps.run_finch/1. See "Adapter" section below for more information.

:request_steps - the list of request steps

:response_steps - the list of response steps

:error_steps - the list of error steps

:private - a map 

*[Content truncated]*

**Examples:**

Example 1 (javascript):
```javascript
Req.get!("https://api.github.com/repos/wojtekmach/req").body["description"]
#=> "Req is a batteries-included HTTP client for Elixir."
```

Example 2 (javascript):
```javascript
url = "https://api.github.com/repos/wojtekmach/req"

req =
  Req.Request.new(method: :get, url: url)
  |> Req.Request.append_request_steps(
    put_user_agent: &Req.Steps.put_user_agent/1,
    # ...
  )
  |> Req.Request.append_response_steps(
    # ...
    decompress_body: &Req.Steps.decompress_body/1,
    decode_body: &Req.Steps.decode_body/1,
    # ...
  )
  |> Req.Request.append_error_steps(
    retry: &Req.Steps.retry/1,
    # ...
  )

{req, resp} = Req.Request.run_request(req)
resp.body["description"]
#=> "Req is a batteries-included HTTP client for Elixir."
```

Example 3 (unknown):
```unknown
into: fn {:data, data}, {req, resp} ->
  IO.puts(data)
  {:cont, {req, resp}}
end
```

Example 4 (unknown):
```unknown
into: File.stream!("path")
```

---

## Req.Test (req v0.5.15)

**URL:** https://hexdocs.pm/req/Req.Test.html

**Contents:**
- Req.Test (req v0.5.15)
- Example
- Concurrency and Allowances
- Broadway
- Summary
- Functions
- Functions (Mocks & Stubs)
- Functions
- html(conn, data)
- Examples

Req testing conveniences.

Req - the high-level API

Req.Request - the low-level API and the request struct

Req.Steps - the collection of built-in steps

Req.Test - the testing conveniences (you're here!)

Req already has built-in support for different variants of stubs via :plug, :adapter, and (indirectly) :base_url options. With this module you can:

Create request stubs using Req.Test.stub(name, plug) and mocks using Req.Test.expect(name, count, plug). Both can be used in concurrent tests.

Configure Req to run requests through mocks/stubs by setting plug: {Req.Test, name}. This works because Req.Test itself is a plug whose job is to fetch the mocks/stubs under name.

Easily create JSON responses with Req.Test.json(conn, body), HTML responses with Req.Test.html(conn, body), and text responses with Req.Test.text(conn, body).

Simulate network errors with Req.Test.transport_error(conn, reason).

Mocks and stubs are using the same ownership model of nimble_ownership, also used by Mox. This allows Req.Test to be used in concurrent tests.

Imagine we're building an app that displays weather for a given location using an HTTP weather service:

We configure it for production:

In tests, instead of hitting the network, we make the request against a plug stub named MyApp.Weather:

Now we can control our stubs in concurrent tests:

The example above works in concurrent tests because MyApp.Weather.get_rating/1 calls directly to Req.request/1 in the same process. It also works in many cases where the request happens in a spawned process, such as a Task, GenServer, and more.

However, if you are encountering issues with stubs not being available in spawned processes, it's likely that you'll need explicit allowances. For example, if MyApp.Weather.get_rating/1 was calling Req.request/1 in a process spawned with spawn/1, the stub would not be available in the spawned process:

To make stubs defined in the test process available in other processes, you can use allow/3. For example, imagine that the call to MyApp.Weather.get_rating/1 was happening in a spawned GenServer:

If you're using Req.Test with Broadway, you may need to use allow/3 to make stubs available in the Broadway processors. A great way to do that is to hook into the Telemetry events that Broadway publishes to manually allow the processors and batch processors to access the stubs. This approach is similar to what is documented in Broadway itself.

First, you should add the test PID (which is allowed to us

*[Content truncated]*

**Examples:**

Example 1 (javascript):
```javascript
defmodule MyApp.Weather do
  def get_rating(location) do
    case get_temperature(location) do
      {:ok, %{status: 200, body: %{"celsius" => celsius}}} ->
        cond do
          celsius < 18.0 -> {:ok, :too_cold}
          celsius < 30.0 -> {:ok, :nice}
          true -> {:ok, :too_hot}
        end

      _ ->
        :error
    end
  end

  def get_temperature(location) do
    [
      base_url: "https://weather-service",
      params: [location: location]
    ]
    |> Keyword.merge(Application.get_env(:myapp, :weather_req_options, []))
    |> Req.request()
  end
end
```

Example 2 (unknown):
```unknown
# config/runtime.exs
config :myapp, weather_req_options: [
  auth: {:bearer, System.fetch_env!("MYAPP_WEATHER_API_KEY")}
]
```

Example 3 (unknown):
```unknown
# config/test.exs
config :myapp, weather_req_options: [
  plug: {Req.Test, MyApp.Weather}
]
```

Example 4 (javascript):
```javascript
use ExUnit.Case, async: true

test "nice weather" do
  Req.Test.stub(MyApp.Weather, fn conn ->
    Req.Test.json(conn, %{"celsius" => 25.0})
  end)

  assert MyApp.Weather.get_rating("Krakow, Poland") == {:ok, :nice}
end
```

---

## Req.Response.Async (req v0.5.15)

**URL:** https://hexdocs.pm/req/Req.Response.Async.html

**Contents:**
- Req.Response.Async (req v0.5.15)
- Examples

Asynchronous response body.

This is the response.body when making a request with into: :self, that is, streaming response body chunks to the current process mailbox.

This struct implements the Enumerable protocol where each element is a body chunk received from the current process mailbox. HTTP Trailer fields are ignored.

If the request is sent using HTTP/1, an extra process is spawned to consume messages from the underlying socket. On both HTTP/1 and HTTP/2 the messages are sent to the current process as soon as they arrive, as a firehose. If you wish to maximize request rate or have more control over how messages are streamed, use into: fun or into: collectable instead.

Note: This feature is currently experimental and it may change in future releases.

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.2) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
iex> resp = Req.get!("https://reqbin.org/ndjson?delay=1000", into: :self)
iex> resp.body
#Req.Response.Async<...>
iex> Enum.each(resp.body, &IO.puts/1)
# {"id":0}
# {"id":1}
# {"id":2}
:ok
```

---

## Req.TooManyRedirectsError exception (req v0.5.15)

**URL:** https://hexdocs.pm/req/Req.TooManyRedirectsError.html

**Contents:**
- Req.TooManyRedirectsError exception (req v0.5.15)

Represents an error when too many redirects occured, returned by Req.Steps.redirect/1.

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.2) for the Elixir programming language

---

## Req.TransportError exception (req v0.5.15)

**URL:** https://hexdocs.pm/req/Req.TransportError.html

**Contents:**
- Req.TransportError exception (req v0.5.15)

Represents an error with the transport used by an HTTP connection.

This is a standardised exception that all Req adapters should use for transport-layer-related errors.

This exception is based on Mint.TransportError.

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.2) for the Elixir programming language

---

## Req.Steps (req v0.5.15)

**URL:** https://hexdocs.pm/req/Req.Steps.html

**Contents:**
- Req.Steps (req v0.5.15)
- Summary
- Request Steps
- Response Steps
- Error Steps
- Request Steps
- auth(request)
- Request Options
- Examples
- cache(request)

The collection of built-in steps.

Req - the high-level API

Req.Request - the low-level API and the request struct

Req.Steps - the collection of built-in steps (you're here!)

Req.Test - the testing conveniences

Sets request authentication.

Performs HTTP caching using if-modified-since header.

Sets expected response body checksum.

Compresses the request body.

Asks the server to return compressed response.

Encodes the request body.

Signs request with AWS Signature Version 4.

Sets base URL for all requests.

Adds params to request query string.

Uses a templated request path.

Sets adapter to run_plug/1.

Sets the "Range" request header.

Sets the user-agent header.

Runs the request using Finch.

Runs the request against a plug instead of over the network.

Decodes response body based on the detected format.

Decompresses the response body based on the content-encoding header.

Handles HTTP 4xx/5xx error responses.

Verifies the response body checksum.

Retries a request in face of errors.

Sets request authentication.

:auth - sets the authorization header:

string - sets to this value;

{:basic, userinfo} - uses Basic HTTP authentication;

{:bearer, token} - uses Bearer HTTP authentication;

:netrc - load credentials from .netrc at path specified in NETRC environment variable. If NETRC is not set, load .netrc in user's home directory;

{:netrc, path} - load credentials from path

fn -> {:bearer, "eyJ0eXAi..." } end - a 0-arity function that returns one of the aforementioned types.

Performs HTTP caching using if-modified-since header.

Only successful (200 OK) responses are cached.

This step also prepends a response step that loads and writes the cache. Be careful when prepending other response steps, make sure the cache is loaded/written as soon as possible.

:cache - if true, performs simple caching using if-modified-since header. Defaults to false.

:cache_dir - the directory to store the cache, defaults to <user_cache_dir>/req (see: :filename.basedir/3)

Sets expected response body checksum.

:checksum - if set, this is the expected response body checksum.

Compresses the request body.

Asks the server to return compressed response.

br (if brotli is installed)

zstd (if ezstd is installed)

:compressed - if set to true, sets the accept-encoding header with compression algorithms that Req supports. Defaults to true.

When streaming response body (into: fun | collectable), compressed defaults to false.

Req automatically decompresses respons

*[Content truncated]*

**Examples:**

Example 1 (unknown):
```unknown
iex> Req.get!("https://httpbin.org/basic-auth/foo/bar", auth: {:basic, "foo:foo"}).status
401
iex> Req.get!("https://httpbin.org/basic-auth/foo/bar", auth: {:basic, "foo:bar"}).status
200
iex> Req.get!("https://httpbin.org/basic-auth/foo/bar", auth: fn -> {:basic, "foo:bar"} end).status
200

iex> Req.get!("https://httpbin.org/bearer", auth: {:bearer, ""}).status
401
iex> Req.get!("https://httpbin.org/bearer", auth: {:bearer, "foo"}).status
200
iex> Req.get!("https://httpbin.org/bearer", auth: fn -> {:bearer, "foo"} end).status
200

iex> System.put_env("NETRC", "./test/my_netrc")
iex> Req.get!(
...
```

Example 2 (unknown):
```unknown
iex> url = "https://elixir-lang.org"
iex> response1 = Req.get!(url, cache: true)
iex> response2 = Req.get!(url, cache: true)
iex> response1 == response2
true
```

Example 3 (unknown):
```unknown
iex> resp = Req.get!("https://httpbin.org/json", checksum: "sha1:9274ffd9cf273d4a008750f44540c4c5d4c8227c")
iex> resp.status
200

iex> Req.get!("https://httpbin.org/json", checksum: "sha1:bad")
** (Req.ChecksumMismatchError) checksum mismatch
expected: sha1:bad
actual:   sha1:9274ffd9cf273d4a008750f44540c4c5d4c8227c
```

Example 4 (unknown):
```unknown
iex> response = Req.get!("https://elixir-lang.org", raw: true)
iex> Req.Response.get_header(response, "content-encoding")
["gzip"]
iex> response.body |> binary_part(0, 2)
<<31, 139>>
```

---

## 

**URL:** https://hexdocs.pm/req/req.epub

---
