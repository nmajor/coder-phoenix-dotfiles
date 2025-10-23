# Phoenix-Liveview - Forms

**Pages:** 1

---

## Phoenix.LiveView.HTMLFormatter (Phoenix LiveView v1.1.16)

**URL:** https://hexdocs.pm/phoenix_live_view/Phoenix.LiveView.HTMLFormatter.html

**Contents:**
- Phoenix.LiveView.HTMLFormatter (Phoenix LiveView v1.1.16)
- Setup
  - For umbrella projects
  - Editor support
- Options
- Formatting
  - Intentional new lines
  - Inline elements
- Skip formatting
- Summary

Format HEEx templates from .heex files or ~H sigils.

This is a mix format plugin.

Add it as a plugin to your .formatter.exs file and make sure to put the heex extension in the inputs option.

In umbrella projects you must also change two files at the umbrella root, add :phoenix_live_view to your deps in the mix.exs file and add plugins: [Phoenix.LiveView.HTMLFormatter] in the .formatter.exs file. This is because the formatter does not attempt to load the dependencies of all children applications.

Most editors that support mix format integration should automatically format .heex and ~H templates. Other editors may require custom integration or even provide additional functionality. Here are some reference posts:

:line_length - The Elixir formatter defaults to a maximum line length of 98 characters, which can be overwritten with the :line_length option in your .formatter.exs file.

:heex_line_length - change the line length only for the HEEx formatter.

:migrate_eex_to_curly_interpolation - Automatically migrate single expression <%= ... %> EEx expression to the curly braces one. Defaults to true.

:attribute_formatters - Specify formatters for certain attributes.

:inline_matcher - a list of regular expressions to determine if a component should be treated as inline. Defaults to ["link", "button"], which treats any component with link or button in its name as inline. Can be disabled by setting it to an empty list.

This formatter tries to be as consistent as possible with the Elixir formatter and also take into account "block" and "inline" HTML elements.

In the past, HTML elements were categorized as either "block-level" or "inline". While now these concepts are specified by CSS, the historical distinction remains as it typically dictates the default browser rendering behavior. In particular, adding or removing whitespace between the start and end tags of a block-level element will not change the rendered output, while it may for inline elements.

The following links further explain these concepts:

Given HTML like this:

It will be formatted as:

A block element will go to the next line, while inline elements will be kept in the current line as long as they fit within the configured line length.

It will also keep inline elements in their own lines if you intentionally write them this way:

This formatter will place all attributes on their own lines when they do not all fit in the current line. Therefore this:

Will be formatted to:

This formatter do

*[Content truncated]*

**Examples:**

Example 1 (unknown):
```unknown
[
  plugins: [Phoenix.LiveView.HTMLFormatter],
  inputs: ["*.{heex,ex,exs}", "priv/*/seeds.exs", "{config,lib,test}/**/*.{heex,ex,exs}"],
  # ...
]
```

Example 2 (unknown):
```unknown
[
  # ...omitted
  heex_line_length: 300
]
```

Example 3 (unknown):
```unknown
[
  plugins: [Phoenix.LiveView.HTMLFormatter],
  attribute_formatters: %{class: ClassFormatter},
]
```

Example 4 (unknown):
```unknown
<section><h1>   <b>{@user.name}</b></h1></section>
```

---
