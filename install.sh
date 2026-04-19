#!/usr/bin/env bash
set -euo pipefail

# Minimal Coder dotfiles installer.
# Language toolchains, global CLIs (claude, codex, gemini, omc, bun, uv),
# mix archives, apt deps and code-server are baked into the workspace image.
# This script only handles HOME/PVC-scoped setup: rc files, auth, per-user dirs.

REPO_ROOT="$(cd "$(dirname "$0")" && pwd)"

# Symlink rc files
[ -f "$REPO_ROOT/dot-zshrc" ]               && ln -sf "$REPO_ROOT/dot-zshrc"               "$HOME/.zshrc"
[ -f "$REPO_ROOT/dot-starship.toml" ]       && ln -sf "$REPO_ROOT/dot-starship.toml"       "$HOME/.starship.toml"
[ -f "$REPO_ROOT/dot-default-claude.json" ] && ln -sf "$REPO_ROOT/dot-default-claude.json" "$HOME/.default-claude.json"
[ -f "$REPO_ROOT/dot-tmux.conf" ]           && ln -sf "$REPO_ROOT/dot-tmux.conf"           "$HOME/.tmux.conf"

# Codex config (MCP servers etc.)
if [ -f "$REPO_ROOT/dot-codex-config.toml" ]; then
  mkdir -p "$HOME/.codex"
  ln -sf "$REPO_ROOT/dot-codex-config.toml" "$HOME/.codex/config.toml"
fi

# tmux sessions bootstrap
if [ -f "$REPO_ROOT/start-tmux.sh" ]; then
  cp "$REPO_ROOT/start-tmux.sh" "$HOME/start-tmux.sh"
  chmod +x "$HOME/start-tmux.sh"
  "$HOME/start-tmux.sh"
fi

# Merge ~/.claude.json with our defaults
if [ -f "$REPO_ROOT/update-claude-config.sh" ]; then
  cp "$REPO_ROOT/update-claude-config.sh" "$HOME/update-claude-config.sh"
  chmod +x "$HOME/update-claude-config.sh"
  "$HOME/update-claude-config.sh"
fi

# gh auth (runs before SSH so gh can upload the key)
if [ -f "$REPO_ROOT/setup-gh-cli.sh" ]; then
  cp "$REPO_ROOT/setup-gh-cli.sh" "$HOME/setup-gh-cli.sh"
  chmod +x "$HOME/setup-gh-cli.sh"
  "$HOME/setup-gh-cli.sh"
fi

# Git SSH key install
if [ -f "$REPO_ROOT/install-git-ssh.sh" ]; then
  cp "$REPO_ROOT/install-git-ssh.sh" "$HOME/install-git-ssh.sh"
  chmod +x "$HOME/install-git-ssh.sh"
  "$HOME/install-git-ssh.sh"
fi

# Claude Skills sync (exact mirror)
if [ -d "$REPO_ROOT/claude-skills" ]; then
  mkdir -p "$HOME/.claude/skills"
  rsync -av --delete \
    --exclude-from="$REPO_ROOT/.claude-skills-exclude" \
    "$REPO_ROOT/claude-skills/" "$HOME/.claude/skills/"
fi

echo "[dotfiles] applied"
