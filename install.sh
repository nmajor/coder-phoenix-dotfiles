#!/usr/bin/env bash
set -euo pipefail

# Minimal Coder dotfiles installer (runs if present & executable)
REPO_ROOT="$(cd "$(dirname "$0")" && pwd)"

# Symlink configs from this repo to $HOME
[ -f "$REPO_ROOT/dot-zshrc" ] && ln -sf "$REPO_ROOT/dot-zshrc" "$HOME/.zshrc"
[ -f "$REPO_ROOT/dot-starship.toml" ] && ln -sf "$REPO_ROOT/dot-starship.toml" "$HOME/.starship.toml"
[ -f "$REPO_ROOT/dot-default-claude.json" ] && ln -sf "$REPO_ROOT/dot-default-claude.json" "$HOME/.default-claude.json"
[ -f "$REPO_ROOT/dot-tmux.conf" ] && ln -sf "$REPO_ROOT/dot-tmux.conf" "$HOME/.tmux.conf"

# Copy start-tmux into $HOME and run it so it can assume HOME context
if [ -f "$REPO_ROOT/start-tmux.sh" ]; then
  cp "$REPO_ROOT/start-tmux.sh" "$HOME/start-tmux.sh"
  chmod +x "$HOME/start-tmux.sh"
  "$HOME/start-tmux.sh"
fi

# Copy updater into $HOME and run it so it can assume HOME context
if [ -f "$REPO_ROOT/update-claude-config.sh" ]; then
  cp "$REPO_ROOT/update-claude-config.sh" "$HOME/update-claude-config.sh"
  chmod +x "$HOME/update-claude-config.sh"
  "$HOME/update-claude-config.sh"
fi

# Authenticate GitHub CLI (if token present) before SSH setup
if [ -f "$REPO_ROOT/setup-gh-cli.sh" ]; then
  cp "$REPO_ROOT/setup-gh-cli.sh" "$HOME/setup-gh-cli.sh"
  chmod +x "$HOME/setup-gh-cli.sh"
  "$HOME/setup-gh-cli.sh"
fi

# Add SSH keys for git access (copy to HOME, make executable, then run)
if [ -f "$REPO_ROOT/install-git-ssh.sh" ]; then
  cp "$REPO_ROOT/install-git-ssh.sh" "$HOME/install-git-ssh.sh"
  chmod +x "$HOME/install-git-ssh.sh"
  "$HOME/install-git-ssh.sh"
fi

echo "[dotfiles] applied"

# asdf env (optional for the script itself)
. /etc/profile.d/asdf.sh

# Zsh completion system-wide (no home writes)
sudo mkdir -p /usr/share/zsh/site-functions
asdf completion zsh | sudo tee /usr/share/zsh/site-functions/_asdf >/dev/null

# Installing a different nodejs version than the default image one
# . /etc/profile.d/asdf.sh
# asdf list all nodejs | tail -n 20
# asdf install nodejs 22.11.0
# export ASDF_NODEJS_VERSION=22.11.0
# rehash 2>/dev/null || hash -r
# node -v
# asdf which node

echo "[dotfiles] Installing packages"

# Install hex
mix local.hex --force
mix local.rebar --force

mix archive.install hex igniter_new --force
mix archive.install hex phx_new 1.8.1 --force

# Install uv
curl -LsSf https://astral.sh/uv/install.sh | sh

# Install npm packages
npm install -g bun
npm install -g @anthropic-ai/claude-code

echo "[dotfiles] Done installing packages"