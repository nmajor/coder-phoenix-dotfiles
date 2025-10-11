# CLAUDE.md - Coder Phoenix Dotfiles

## ⚠️ IMPORTANT: What This Repository Is

**This is NOT a typical software project.** This is a **dotfiles repository** specifically designed for **Coder workspaces** running on a **self-hosted Coder deployment** on a **home Kubernetes cluster**.

### Repository Purpose

This dotfiles repo configures development workspaces for building **Elixir Phoenix applications** in cloud development environments (CDEs) powered by Coder.

- **Target Platform**: Self-hosted Coder deployment on home Kubernetes cluster
- **Workspace Type**: Elixir Phoenix development environments
- **Automation**: Automatically applied via `coder dotfiles` command in workspace templates
- **Not For**: Local machines, production servers, or traditional application deployment

## Architecture Overview

### Coder Workspace Lifecycle

```
┌─────────────────────────────────────────────────────┐
│ 1. Workspace Creation (Kubernetes Pod)             │
│    ├─ Coder template provisions container           │
│    └─ startup_script executes                       │
└─────────────────────┬───────────────────────────────┘
                      │
┌─────────────────────▼───────────────────────────────┐
│ 2. Dotfiles Application                            │
│    ├─ coder dotfiles -y <repo-url>                  │
│    ├─ Clones this repository                        │
│    └─ Executes install.sh                           │
└─────────────────────┬───────────────────────────────┘
                      │
┌─────────────────────▼───────────────────────────────┐
│ 3. Environment Setup (install.sh)                  │
│    ├─ Symlinks config files                        │
│    ├─ Syncs Agent OS                                │
│    ├─ Configures Git/GitHub                         │
│    ├─ Installs dev tools (mix, hex, phx_new, etc.) │
│    └─ Sets up tmux, starship, claude                │
└─────────────────────┬───────────────────────────────┘
                      │
┌─────────────────────▼───────────────────────────────┐
│ 4. Ready for Phoenix Development                   │
│    ├─ Claude Code configured with Agent OS         │
│    ├─ Phoenix project templates ready               │
│    └─ Full Elixir toolchain available               │
└─────────────────────────────────────────────────────┘
```

## Repository Structure

### Configuration Files (Dotfiles)

These files are **symlinked** from this repo to `$HOME` in the workspace:

- **`dot-zshrc`** → `~/.zshrc`
  - Zsh shell configuration
  - Starship prompt initialization
  - asdf version manager setup

- **`dot-starship.toml`** → `~/.starship.toml`
  - Terminal prompt customization
  - Git status, language versions, etc.

- **`dot-tmux.conf`** → `~/.tmux.conf`
  - tmux terminal multiplexer configuration
  - Keybindings, appearance, behavior

- **`dot-default-claude.json`** → `~/.default-claude.json`
  - Default Claude Code configuration
  - Agent OS integration settings

### Installation Scripts

- **`install.sh`** - Main installer executed by Coder (see install.sh:1-110)
  - Symlinks dotfiles
  - Syncs Agent OS with smart update strategy
  - Runs helper scripts
  - Installs Elixir/Phoenix toolchain

- **`install-git-ssh.sh`** - Configures Git SSH authentication
- **`setup-gh-cli.sh`** - Authenticates GitHub CLI
- **`start-tmux.sh`** - Starts tmux session
- **`update-claude-config.sh`** - Updates Claude configuration

### Agent OS Integration

- **`agent-os/`** - Synced to `~/agent-os` in workspace
  - Multi-agent workflows for Claude Code
  - Profiles and roles for Elixir/Phoenix development
  - Preserves user customizations across workspace restarts
  - See README.md:52-78 for sync strategy details

## How Coder Applies This Repository

### Template Integration (HCL)

In a Coder workspace template, this repo is referenced via the `startup_script`:

```hcl
variable "dotfiles_uri" {
  description = "Dotfiles repo URI (optional)"
  default     = "https://github.com/YOUR_USERNAME/coder-phoenix-dotfiles"
}

resource "coder_agent" "dev" {
  arch           = "amd64"
  os             = "linux"
  startup_script = var.dotfiles_uri != "" ? "coder dotfiles -y ${var.dotfiles_uri}" : null

  # ... other agent config
}
```

### What Happens on Workspace Start

1. **Coder clones this repository** to a temporary location
2. **Executes `install.sh`** if present and executable
3. **Dotfiles are applied** to the workspace home directory
4. **Development tools are installed** (Elixir, Phoenix, etc.)
5. **Workspace is ready** for Phoenix development

## Development Tools Installed

The `install.sh` script installs the following Elixir/Phoenix ecosystem tools:

### Elixir Tools (via mix)
- **hex** - Elixir package manager (install.sh:97)
- **rebar** - Erlang build tool (install.sh:98)
- **igniter_new** - Phoenix code generator archive (install.sh:100)
- **phx_new** - Phoenix project generator v1.8.1 (install.sh:101)

### Python Tools
- **uv** - Fast Python package installer (install.sh:104)

### Node.js Tools (via npm)
- **bun** - Fast JavaScript runtime (install.sh:107)
- **@anthropic-ai/claude-code** - Claude Code CLI (install.sh:108)

## Agent OS Integration

This dotfiles repo includes [Agent OS](https://buildermethods.com/agent-os/installation) for enhanced Claude Code workflows.

### Sync Strategy

- **Smart rsync** with exclusions (`.agent-os-exclude`)
- **Preserves user customizations** (config.yml, custom profiles)
- **Automatic backups** (keeps last 3 in `~/.agent-os-backups/`)
- **Updates on workspace restart**

### Files Preserved (Never Overwritten)
- `~/agent-os/config.yml` - User configuration
- `~/agent-os/profiles/custom/*` - Custom profiles

### Files Auto-Updated
- Core scripts
- Default profiles and roles
- Workflow templates

## Typical Usage Patterns

### For Claude Code Users

When working in a workspace provisioned with these dotfiles:

1. **Agent OS is pre-configured** - Multi-agent workflows available
2. **Phoenix templates ready** - `mix phx.new` available immediately
3. **Git configured** - SSH keys and GitHub CLI authenticated
4. **tmux session active** - Terminal multiplexer ready

### Customizing Agent OS

Users can customize Agent OS in their workspace:

```bash
# Edit configuration
vim ~/agent-os/config.yml

# Create custom profile
~/agent-os/scripts/create-profile.sh my-profile

# Add custom role
~/agent-os/scripts/create-role.sh my-role
```

Changes persist across workspace restarts (see install.sh:63-71).

### Rolling Back Agent OS

If an update causes issues:

```bash
# List available backups
ls -la ~/.agent-os-backups/

# Restore from backup
cp -r ~/.agent-os-backups/20251011_083000 ~/agent-os
```

## Making Changes to This Repository

### Testing Changes Locally

Before committing changes, test the installer:

```bash
./install.sh
```

Ensure it's executable:

```bash
chmod +x install.sh
```

### Important Considerations

1. **Public Repository** - Keep public for frictionless Coder cloning
2. **Backwards Compatibility** - Changes affect all new workspace provisions
3. **User Data Preservation** - Respect existing user customizations
4. **Installation Speed** - Keep installer fast (runs on every workspace start)

### Modifying Agent OS Defaults

When updating Agent OS:

1. **Test in a workspace first** - Provision test workspace with changes
2. **Respect exclusions** - Check `.agent-os-exclude` (install.sh:63-65)
3. **Version backups** - Automatic backups protect users (install.sh:53-60)
4. **Document changes** - Update README.md with new features

## Key Files Reference

| File | Purpose | Coder Action |
|------|---------|--------------|
| `install.sh` | Main installer | Executed automatically |
| `dot-zshrc` | Zsh config | Symlinked to `~/.zshrc` |
| `dot-starship.toml` | Prompt config | Symlinked to `~/.starship.toml` |
| `dot-tmux.conf` | tmux config | Symlinked to `~/.tmux.conf` |
| `dot-default-claude.json` | Claude config | Symlinked to `~/.default-claude.json` |
| `agent-os/` | Agent OS files | Synced to `~/agent-os` |
| `.agent-os-exclude` | Sync exclusions | Used by rsync (install.sh:64) |

## Environment Details

### Self-Hosted Coder Deployment

This dotfiles repo is designed for:

- **Platform**: Kubernetes cluster (home lab)
- **Coder Version**: Self-hosted (not Coder Cloud)
- **Base Images**: Likely Ubuntu/Debian-based with asdf pre-installed
- **Networking**: Home network with internet access
- **Storage**: Persistent home volumes for workspace data

### Workspace Characteristics

- **Ephemeral containers** - Can be rebuilt from template
- **Persistent home** - User data survives rebuilds (if home volume mounted)
- **Pre-installed tools** - asdf, git, basic dev tools
- **Network access** - Can install packages, clone repos

## Common Modifications

### Adding a New Dotfile

1. Add file with `dot-` prefix (e.g., `dot-vimrc`)
2. Add symlink line to `install.sh`:
   ```bash
   [ -f "$REPO_ROOT/dot-vimrc" ] && ln -sf "$REPO_ROOT/dot-vimrc" "$HOME/.vimrc"
   ```

### Installing Additional Tools

Add to `install.sh` after existing installations:

```bash
# Install additional tool
mix archive.install hex my_new_tool --force
```

### Modifying Agent OS Sync

Edit `.agent-os-exclude` to change what gets preserved:

```
# Preserve additional user files
config.yml
profiles/custom/
my-custom-settings.yml
```

## Troubleshooting

### Dotfiles Not Applied

Check Coder workspace logs:
```bash
coder logs <workspace-name>
```

Look for `[dotfiles] applied` message (install.sh:41).

### Agent OS Not Synced

Verify sync completed:
```bash
ls -la ~/agent-os/
cat ~/.agent-os-backups/*/config.yml
```

Check backup creation (install.sh:53-60).

### Tools Not Installed

Re-run installation sections:
```bash
cd ~/
./install-git-ssh.sh
./setup-gh-cli.sh
```

## Additional Resources

- **Coder Documentation**: https://coder.com/docs
- **Dotfiles Guide**: https://dotfiles.github.io
- **Agent OS**: https://buildermethods.com/agent-os/installation
- **Phoenix Framework**: https://www.phoenixframework.org/

## Summary

This is a **dotfiles repository** for **Coder workspaces** on a **self-hosted Kubernetes deployment**. It is **not** a traditional application codebase. Its sole purpose is to configure cloud development environments for Elixir Phoenix development with Claude Code integration via Agent OS.

When you interact with this repository, you're modifying the baseline configuration that all Phoenix development workspaces will receive when provisioned from Coder templates that reference this dotfiles repo.
