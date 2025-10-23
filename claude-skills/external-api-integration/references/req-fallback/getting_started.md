# Req - Getting Started

**Pages:** 1

---

## Req

**URL:** https://hexdocs.pm/req/readme.html

**Contents:**
- Req
- Features
- Usage
- Configuration
- Related Packages
- Presentations
- Acknowledgments
- License

Req is a batteries-included HTTP client for Elixir.

With just a couple lines of code:

we get automatic response body decompression & decoding, following redirects, retrying on errors, and much more. Virtually all of the features are broken down into individual functions called steps. You can easily re-use and re-arrange built-in steps (see Req.Steps module) and write new ones.

An easy to use high-level API: Req.request/1, Req.new/1, Req.get!/2, Req.post!/2, etc.

Extensibility via request, response, and error steps.

Request body compression (via compress_body step)

Automatic response body decompression (via compressed and decompress_body steps). Supports gzip, brotli, and zstd.

Request body encoding. Supports urlencoded and multipart forms, and JSON. See encode_body.

Automatic response body decoding (via decode_body step.)

Encode params as query string (via put_params step.)

Setting base URL (via put_base_url step.)

Templated request paths (via put_path_params step.)

Basic, bearer, and .netrc authentication (via auth step.)

Range requests (via put_range) step.)

Use AWS V4 Signature (via put_aws_sigv4) step.)

Request body streaming (by setting body: enumerable.)

Response body streaming (by setting into: fun | collectable | :self.)

Follows redirects (via redirect step.)

Retries on errors (via retry step.)

Raise on 4xx/5xx errors (via handle_http_errors step.)

Verify response body against a checksum (via checksum step.)

Basic HTTP caching (via cache step.)

Easily create test stubs (see Req.Test.)

Running against a plug (via run_plug step.)

Pluggable adapters. By default, Req uses Finch (via run_finch step.)

The easiest way to use Req is with Mix.install/2 (requires Elixir v1.12+):

If you want to use Req in a Mix project, you can add the above dependency to your mix.exs.

Here's an example POST with JSON data:

You can stream request body:

and stream the response body:

(See Req module documentation for more examples of response body streaming.)

If you are planning to make several similar requests, you can build up a request struct with desired common options and re-use it:

See Req.new/1 for more information on available options.

Virtually all of Req's features are broken down into individual pieces - steps. Req works by running the request struct through these steps. You can easily reuse or rearrange built-in steps or write new ones. Importantly, steps are just regular functions. Here is another example where we append a request s

*[Content truncated]*

**Examples:**

Example 1 (javascript):
```javascript
Mix.install([
  {:req, "~> 0.5.0"}
])

Req.get!("https://api.github.com/repos/wojtekmach/req").body["description"]
#=> "Req is a batteries-included HTTP client for Elixir."
```

Example 2 (javascript):
```javascript
Mix.install([
  {:req, "~> 0.5.0"}
])

Req.get!("https://api.github.com/repos/wojtekmach/req").body["description"]
#=> "Req is a batteries-included HTTP client for Elixir."
```

Example 3 (javascript):
```javascript
iex> Req.post!("https://httpbin.org/post", json: %{x: 1, y: 2}).body["json"]
%{"x" => 1, "y" => 2}
```

Example 4 (unknown):
```unknown
iex> stream = Stream.duplicate("foo", 3)
iex> Req.post!("https://httpbin.org/post", body: stream).body["data"]
"foofoofoo"
```

---
