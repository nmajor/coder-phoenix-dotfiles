#!/bin/bash

set -euo pipefail

echo "🔑 Setting up Git SSH access (env-provided key only)..."

# Require key via env; otherwise no-op
if [ -z "${GIT_SSH_PRIVATE_KEY:-}" ]; then
  echo "ℹ️ GIT_SSH_PRIVATE_KEY not set; skipping SSH setup."
  exit 0
fi

mkdir -p "$HOME/.ssh"
chmod 700 "$HOME/.ssh"

key_path="$HOME/.ssh/id_ed25519"
pub_path="$HOME/.ssh/id_ed25519.pub"

echo "🔐 Importing SSH private key from environment..."
# First try: interpret \n escapes and strip CR
printf "%b" "$GIT_SSH_PRIVATE_KEY" | tr -d '\r' > "$key_path"
chmod 600 "$key_path"

# Validate format; if not OpenSSH PEM, try base64 decode fallback
if ! head -1 "$key_path" | grep -q '^-----BEGIN OPENSSH PRIVATE KEY-----$'; then
  printf "%s" "$GIT_SSH_PRIVATE_KEY" | tr -d '\r' | base64 -d > "$key_path" 2>/dev/null || true
  chmod 600 "$key_path"
fi

# Derive public key (best-effort)
if command -v ssh-keygen >/dev/null 2>&1; then
  ssh-keygen -y -f "$key_path" > "$pub_path" 2>/dev/null || true
  chmod 644 "$pub_path" 2>/dev/null || true
fi

# Known hosts for GitHub
touch "$HOME/.ssh/known_hosts"
ssh-keyscan -H github.com 2>/dev/null >> "$HOME/.ssh/known_hosts" || true
chmod 600 "$HOME/.ssh/known_hosts"

# SSH config for GitHub
ssh_config="$HOME/.ssh/config"
touch "$ssh_config"
chmod 600 "$ssh_config"
if ! grep -q "^Host github.com$" "$ssh_config" 2>/dev/null; then
  {
    echo "Host github.com"
    echo "  HostName github.com"
    echo "  User git"
    echo "  IdentityFile ~/.ssh/id_ed25519"
    echo "  IdentitiesOnly yes"
    echo "  AddKeysToAgent yes"
  } >> "$ssh_config"
fi

# Start agent if not running and add key
if [ -z "${SSH_AUTH_SOCK:-}" ] || ! ssh-add -l >/dev/null 2>&1; then
  eval "$(ssh-agent -s)" >/dev/null 2>&1 || true
fi
ssh-add "$key_path" >/dev/null 2>&1 || true

# Optionally rewrite HTTPS to SSH
# Keep HTTPS defaults; no global rewrite

# Upload public key to GitHub if gh is installed and authenticated via GH_TOKEN
if command -v gh >/dev/null 2>&1; then
  if gh auth status >/dev/null 2>&1; then
    title="$(hostname)-$(date +%Y-%m-%d)"
    # Avoid duplicate upload by checking if the key text already exists remotely is non-trivial.
    # Rely on gh to error gracefully if duplicate; ignore errors.
    if [ -f "$pub_path" ]; then gh ssh-key add "$pub_path" -t "$title" --type authentication >/dev/null 2>&1 || true; fi
    echo "✅ SSH key available and registered with GitHub (if not previously added)."
  else
    echo "ℹ️ gh not authenticated; showing public key to add manually:"
    echo "----- PUBLIC KEY -----"
    cat "$HOME/.ssh/id_ed25519.pub"
    echo "----------------------"
  fi
else
  echo "ℹ️ gh not installed; showing public key to add manually:"
  echo "----- PUBLIC KEY -----"
  cat "$HOME/.ssh/id_ed25519.pub"
  echo "----------------------"
fi

echo "🔧 Git SSH setup complete."


