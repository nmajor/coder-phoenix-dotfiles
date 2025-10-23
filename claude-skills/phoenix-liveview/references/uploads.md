# Phoenix-Liveview - Uploads

**Pages:** 5

---

## Uploads

**URL:** https://hexdocs.pm/phoenix_live_view/uploads.html

**Contents:**
- Uploads
- Built-in Features
- Allow uploads
- Render reactive elements
  - Upload entries
  - Entry validation
  - Cancel an entry
- Consume uploaded entries
- Appendix A: UploadLive

LiveView supports interactive file uploads with progress for both direct to server uploads as well as direct-to-cloud external uploads on the client.

Accept specification - Define accepted file types, max number of entries, max file size, etc. When the client selects file(s), the file metadata is automatically validated against the specification. See Phoenix.LiveView.allow_upload/3.

Reactive entries - Uploads are populated in an @uploads assign in the socket. Entries automatically respond to progress, errors, cancellation, etc.

Drag and drop - Use the phx-drop-target attribute to enable. See Phoenix.Component.live_file_input/1.

You enable an upload, typically on mount, via allow_upload/3.

For this example, we will also keep a list of uploaded files in a new assign named uploaded_files, but you could name it something else if you wanted.

That's it for now! We will come back to the LiveView to implement some form- and upload-related callbacks later, but most of the functionality around uploads takes place in the template.

Use the Phoenix.Component.live_file_input/1 component to render a file input for the upload:

Important: You must bind phx-submit and phx-change on the form.

Note that while live_file_input/1 allows you to set additional attributes on the file input, many attributes such as id, accept, and multiple will be set automatically based on the allow_upload/3 spec.

Reactive updates to the template will occur as the end-user interacts with the file input.

Uploads are populated in an @uploads assign in the socket. Each allowed upload contains a list of entries, irrespective of the :max_entries value in the allow_upload/3 spec. These entry structs contain all the information about an upload, including progress, client file info, errors, etc.

Let's look at an annotated example:

The section element in the example acts as the phx-drop-target for the :avatar upload. Users can interact with the file input or they can drop files over the element to add new entries.

Upload entries are created when a file is added to the form input and each will exist until it has been consumed, following a successfully completed upload.

Validation occurs automatically based on any conditions that were specified in allow_upload/3 however, as mentioned previously you are required to bind phx-change on the form in order for the validation to be performed. Therefore you must implement at least a minimal callback:

Entries for files that do not match the allow_uploa

*[Content truncated]*

**Examples:**

Example 1 (python):
```python
@impl Phoenix.LiveView
def mount(_params, _session, socket) do
  {:ok,
   socket
   |> assign(:uploaded_files, [])
   |> allow_upload(:avatar, accept: ~w(.jpg .jpeg), max_entries: 2)}
end
```

Example 2 (unknown):
```unknown
<%!-- lib/my_app_web/live/upload_live.html.heex --%>

<form id="upload-form" phx-change="validate" phx-submit="save">
  <.live_file_input upload={@uploads.avatar} />
  <button type="submit">Upload</button>
</form>
```

Example 3 (unknown):
```unknown
<%!-- lib/my_app_web/live/upload_live.html.heex --%>

<%!-- use phx-drop-target with the upload ref to enable file drag and drop --%>
<section phx-drop-target={@uploads.avatar.ref}>
  <%!-- render each avatar entry --%>
  <article :for={entry <- @uploads.avatar.entries} class="upload-entry">
    <figure>
      <.live_img_preview entry={entry} />
      <figcaption>{entry.client_name}</figcaption>
    </figure>

    <%!-- entry.progress will update automatically for in-flight entries --%>
    <progress value={entry.progress} max="100"> {entry.progress}% </progress>

    <%!-- a regular click eve
...
```

Example 4 (python):
```python
@impl Phoenix.LiveView
def handle_event("validate", _params, socket) do
  {:noreply, socket}
end
```

---

## Phoenix.LiveView.UploadEntry (Phoenix LiveView v1.1.16)

**URL:** https://hexdocs.pm/phoenix_live_view/Phoenix.LiveView.UploadEntry.html

**Contents:**
- Phoenix.LiveView.UploadEntry (Phoenix LiveView v1.1.16)
- Summary
- Types
- Types
- t()

The struct representing an upload entry.

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.3) for the Elixir programming language

---

## Phoenix.LiveView.UploadConfig (Phoenix LiveView v1.1.16)

**URL:** https://hexdocs.pm/phoenix_live_view/Phoenix.LiveView.UploadConfig.html

**Contents:**
- Phoenix.LiveView.UploadConfig (Phoenix LiveView v1.1.16)
- Summary
- Types
- Types
- t()

The struct representing an upload.

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.3) for the Elixir programming language

---

## External uploads

**URL:** https://hexdocs.pm/phoenix_live_view/external-uploads.html

**Contents:**
- External uploads
- Chunked HTTP Uploads
- Direct to S3
  - Direct to S3-Compatible

This guide continues from the configuration started in the server Uploads guide.

Uploads to external cloud providers, such as Amazon S3, Google Cloud, etc., can be achieved by using the :external option in allow_upload/3.

You provide a 2-arity function to allow the server to generate metadata for each upload entry, which is passed to a user-specified JavaScript function on the client.

Typically when your function is invoked, you will generate a pre-signed URL, specific to your cloud storage provider, that will provide temporary access for the end-user to upload data directly to your cloud storage.

For any service that supports large file uploads via chunked HTTP requests with Content-Range headers, you can use the UpChunk JS library by Mux to do all the hard work of uploading the file. For small file uploads or to get started quickly, consider uploading directly to S3 instead.

You only need to wire the UpChunk instance to the LiveView UploadEntry callbacks, and LiveView will take care of the rest.

Install UpChunk by saving its contents to assets/vendor/upchunk.js or by installing it with npm:

Configure your uploader on Phoenix.LiveView.mount/3:

Supply the :external option to Phoenix.LiveView.allow_upload/3. It requires a 2-arity function that generates a signed URL where the client will push the bytes for the upload entry. This function must return either {:ok, meta, socket} or {:error, meta, socket}, where meta must be a map.

For example, if you were using a context that provided a start_session function, you might write something like this:

Finally, on the client-side, we use UpChunk to create an upload from the temporary URL generated on the server and attach listeners for its events to the entry's callbacks:

The largest object that can be uploaded to S3 in a single PUT is 5 GB according to S3 FAQ. For larger file uploads, consider using chunking as shown above.

This guide assumes an existing S3 bucket is set up with the correct CORS configuration which allows uploading directly to the bucket.

An example CORS config is:

You may put your domain in the "allowedOrigins" instead. More information on configuring CORS for S3 buckets is available on AWS.

In order to enforce all of your file constraints when uploading to S3, it is necessary to perform a multipart form POST with your file data. You should have the following S3 information ready before proceeding:

We will first implement the LiveView portion:

Here, we implemented a presign_upload

*[Content truncated]*

**Examples:**

Example 1 (unknown):
```unknown
$ npm install --prefix assets --save @mux/upchunk
```

Example 2 (python):
```python
def mount(_params, _session, socket) do
  {:ok,
   socket
   |> assign(:uploaded_files, [])
   |> allow_upload(:avatar, accept: :any, max_entries: 3, external: &presign_upload/2)}
end
```

Example 3 (javascript):
```javascript
defp presign_upload(entry, socket) do
  {:ok, %{"Location" => link}} =
    SomeTube.start_session(%{
      "uploadType" => "resumable",
      "x-upload-content-length" => entry.client_size
    })

  {:ok, %{uploader: "UpChunk", entrypoint: link}, socket}
end
```

Example 4 (python):
```python
import * as UpChunk from "@mux/upchunk"

let Uploaders = {}

Uploaders.UpChunk = function(entries, onViewError){
  entries.forEach(entry => {
    // create the upload session with UpChunk
    let { file, meta: { entrypoint } } = entry
    let upload = UpChunk.createUpload({ endpoint: entrypoint, file })

    // stop uploading in the event of a view error
    onViewError(() => upload.pause())

    // upload error triggers LiveView error
    upload.on("error", (e) => entry.error(e.detail.message))

    // notify progress events to LiveView
    upload.on("progress", (e) => {
      if(e.detail < 1
...
```

---

## Phoenix.LiveView.UploadWriter behaviour (Phoenix LiveView v1.1.16)

**URL:** https://hexdocs.pm/phoenix_live_view/Phoenix.LiveView.UploadWriter.html

**Contents:**
- Phoenix.LiveView.UploadWriter behaviour (Phoenix LiveView v1.1.16)
- Close reasons
- Summary
- Callbacks
- Callbacks
- close(state, reason)
- init(opts)
- meta(state)
- write_chunk(data, state)

Provide a behavior for writing uploaded chunks to a final destination.

By default, uploads are written to a temporary file on the server and consumed by the LiveView by reading the temporary file or copying it to durable location. Some usecases require custom handling of the uploaded chunks, such as streaming a user's upload to another server. In these cases, we don't want the chunks to be written to disk since we only need to forward them on.

Note: Upload writers run inside the channel uploader process, so any blocking work will block the channel errors will crash the channel process.

Custom implementations of Phoenix.LiveView.UploadWriter can be passed to allow_upload/3. To initialize the writer with options, define a 3-arity function that returns a tuple of {writer, writer_opts}. For example imagine an upload writer that logs the chunk sizes and tracks the total bytes sent by the client:

And such an EchoWriter could look like this:

When the LiveView consumes the uploaded entry, it will receive the %{level: ...} returned from the meta callback. This allows the writer to keep state as it handles chunks to be later relayed to the LiveView when consumed.

The close/2 callback is called when the upload is complete or cancelled. The following values can be passed:

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.38.3) for the Elixir programming language

**Examples:**

Example 1 (unknown):
```unknown
socket
|> allow_upload(:avatar,
  accept: :any,
  writer: fn _name, _entry, _socket -> {EchoWriter, level: :debug} end
)
```

Example 2 (python):
```python
defmodule EchoWriter do
  @behaviour Phoenix.LiveView.UploadWriter

  require Logger

  @impl true
  def init(opts) do
    {:ok, %{total: 0, level: Keyword.fetch!(opts, :level)}}
  end

  @impl true
  def meta(state), do: %{level: state.level}

  @impl true
  def write_chunk(data, state) do
    size = byte_size(data)
    Logger.log(state.level, "received chunk of #{size} bytes")
    {:ok, %{state | total: state.total + size}}
  end

  @impl true
  def close(state, reason) do
    Logger.log(state.level, "closing upload after #{state.total} bytes, #{inspect(reason)}")
    {:ok, state}
  end
end
```

---
