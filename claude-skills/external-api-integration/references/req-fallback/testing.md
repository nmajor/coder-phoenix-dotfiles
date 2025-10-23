# Req - Testing

**Pages:** 1

---

## CHANGELOG

**URL:** https://hexdocs.pm/req/changelog.html

**Contents:**
- CHANGELOG
- v0.5.15 (2025-07-14)
- v0.5.14 (2025-07-02)
- v0.5.13 (2025-07-02)
- v0.5.12 (2025-06-24)
- v0.5.11 (2025-06-23)
- v0.5.10 (2025-03-21)
- v0.5.9 (2025-03-17)
- v0.5.8 (2024-11-29)
- v0.5.7 (2024-10-29)

run_plug: Remove warning about into: fun with {:halt, acc} result.

The warning never been particularly useful because it's not like users can do anything about it.

run_plug: Ease transition to automatically parsing request body.

Since v0.5.11, this code:

Needed to be updated to:

This change makes it so both work. The latter will be required, however.

run_plug: Do not raise on unknown content types.

Req.Test: Improve Req.Test.transport_error/2 error message.

encode_body: Fix leading newline before multipart body.

run_finch: Handle initial transport errors on into: :self.

run_plug: Automatically parse request body.

Prior to this change, users would typically write:

This is a breaking change as Plug.Conn.read_body will now return "".

It can be easily fixed by using Req.Test.raw_body/1 which returns copy of the request raw body:

Furthermore, prior to this change conn.body_params was unfetched:

If in your :plug usage you look at conn.params, it will now include conn.body_params as Plug always merges them.

retry: Use jitter by default

Req.Request: Add Req.Request.put_option/3.

Req.Request: Add Req.Request.put_new_option/3.

Req.Request: Add Req.Request.merge_new_options/2.

Req.Test: Add [Req.Test.redirect/2].

encode_body: Support any enumerable in :form_multipart

Req.Test.expect/3: Fix usage in shared mode

retry: Do not carry halt between retries

(Internal) Support custom headers in Req.Utils.aws_sigv4_url/1

(Internal) Support custom query params in Req.Utils.aws_sigv4_url/1

Req: Check legacy headers when streaming headers

Req: Ignore :into collectable for non-200 responses

put_aws_sigv4: Fix encoding path

run_finch: Add option to configure Finch :pool_max_idle_time

run_finch: Prepare for upcoming Finch v0.20

put_aws_sigv4: Fix signature when using custom port

retry: Do not call retry_delay fun twice

auth: Support passing a 0-arity function

put_aws_sigv4: Fix detecting service

put_aws_sigv4: Raise on no :access_key_id/:secret_access_key/:service

put_aws_sigv4: Fix handling ?name (no value)

handle_http_errors: should run before verify_checksum

encode_body: Support %File.Stream{} in :form_multipart

encode_body: Support %File.Stream{} from other nodes in :form_multipart

Req.Test: Fix using shared mode

encode_body: Add :form_multipart option

put_aws_sigv4: Try detecting the service

run_finch: Fix setting :finch option

put_aws_sigv4: Fix bug when using custom headers

put_aws_sigv4: Add :token option

redirect: Cancel async 

*[Content truncated]*

**Examples:**

Example 1 (javascript):
```javascript
plug = fn conn ->
  {:ok, body, conn} = Plug.Conn.read_body(conn)
  assert JSON.decode!(body) == %{"x" => 1}
  Plug.Conn.send_resp(conn, 200, "ok")
end

Req.put!(plug: plug, json: %{x: 1})
```

Example 2 (javascript):
```javascript
plug = fn conn ->
  assert conn.body_params == %{"x" => 1}
  Plug.Conn.send_resp(conn, 200, "ok")
end

Req.put!(plug: plug, json: %{x: 1})
```

Example 3 (javascript):
```javascript
plug = fn conn ->
  {:ok, body, conn} = Plug.Conn.read_body(conn)
  assert JSON.decode!(body) == %{"x" => 1}
  Plug.Conn.send_resp(conn, 200, "ok")
end

Req.put!(plug: plug, json: %{x: 1})
```

Example 4 (javascript):
```javascript
plug = fn conn ->
  assert conn.params == %{"x" => 1}
  Plug.Conn.send_resp(conn, 200, "ok")
end

Req.put!(plug: plug, json: %{x: 1})
```

---
