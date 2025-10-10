## Coder dotfiles

This repo is designed to be used by Coder workspace templates via `coder dotfiles`.

### Files

- `dot-zshrc` → symlinked to `~/.zshrc`
- `dot-starship.toml` → symlinked to `~/.starship.toml`
- `dot-default-claude.json` → symlinked to `~/.default-claude.json`
- `dot-tmux.conf` → symlinked to `~/.tmux.conf`
- `install.sh` → executable installer run by Coder
- `agent-os/` → synced to `~/agent-os` (preserves user customizations)

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

- Symlinks config files from this repo to `$HOME`
- Syncs Agent OS directory to `~/agent-os` with smart update strategy
- Copies and executes helper scripts (start-tmux.sh, update-claude-config.sh, etc.)
- Sets up GitHub CLI authentication
- Configures Git SSH keys
- Installs development tools (mix, uv, npm packages)

### Agent OS Integration

This dotfiles repo includes [Agent OS](https://buildermethods.com/agent-os/installation) for enhanced Claude Code workflows.

**How it works:**
- `agent-os/` directory is synced to `~/agent-os` on workspace creation and restart
- Uses smart rsync strategy to preserve user customizations
- Creates automatic backups (keeps last 3) in `~/.agent-os-backups/`

**User customizations preserved:**
- `~/agent-os/config.yml` - Your Agent OS configuration settings
- `~/agent-os/profiles/custom/` - Your custom profiles and workflows

**Auto-updated from repo:**
- Core scripts, default profiles, and workflows
- Ensures you get latest improvements when workspace restarts

**Customizing Agent OS:**
1. Edit `~/agent-os/config.yml` to change settings (multi-agent mode, profile, etc.)
2. Create custom profiles in `~/agent-os/profiles/custom/`
3. Your changes persist across workspace restarts

**Rolling back:**
If an update causes issues, restore from backup:
```bash
ls -la ~/.agent-os-backups/
cp -r ~/.agent-os-backups/YYYYMMDD_HHMMSS ~/agent-os
```

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
