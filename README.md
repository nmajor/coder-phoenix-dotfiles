## Coder dotfiles

This repo is designed to be used by Coder workspace templates via `coder dotfiles`.

### Files

- `dot-zshrc` → symlinked to `~/.zshrc`
- `dot-starship.toml` → symlinked to `~/.config/starship.toml`
- `dot-mcp.json` → symlinked to `~/.config/mcp/dot-mcp.json`
- `install` → executable installer run by Coder

### How it works in a template

Add a variable and wire it to the agent `startup_script` so Coder applies the repo at first boot:

```hcl
variable "dotfiles_uri" {
  description = <<-EOF
  Dotfiles repo URI (optional)
  see https://dotfiles.github.io
  EOF
  default = ""
}

resource "coder_agent" "dev" {
  # ...
  startup_script = var.dotfiles_uri != "" ? "coder dotfiles -y ${var.dotfiles_uri}" : null
}
```

Alternatively, you can hardcode the repo in the template:

```hcl
resource "coder_agent" "dev" {
  # ...
  startup_script = "coder dotfiles -y https://github.com/your-org/coder-phoenix-dotfiles"
}
```

### What the installer does

- Creates `~/.config` and `~/.config/mcp` if needed
- Symlinks the files listed above
- Attempts to install `starship` if missing (best-effort)
- Attempts to set login shell to `zsh` if available (best-effort)

### Local testing

Run the installer locally to preview:

```bash
./install
```

Ensure it is executable:

```bash
chmod +x install
```

### Persistence

For persistent home customizations across rebuilds, mount a home volume in templates.

### Notes

- `dot-zshrc` guards `starship` initialization if it is not installed.
- Keep this repository public for frictionless cloning by Coder.
