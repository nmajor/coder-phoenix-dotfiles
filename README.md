## Coder dotfiles

This repo is designed to be used by Coder workspace templates via `coder dotfiles`.

## Setup

### Agent OS

### coderabbit

Authenticate within the Claude Code prompt

```
Run: coderabbit auth login

# Then after authenticated
Run: coderabbit auth status
```

### Credo

Add credo to mix.exs and `mix deps.get`

```
defp deps do
  [
    {:credo, "~> 1.7", only: [:dev, :test], runtime: false}
  ]
end
```

Then `mix deps.get`


