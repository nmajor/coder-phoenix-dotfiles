#!/bin/bash

set -euo pipefail

echo "🛠️ Installing GitHub CLI (Ubuntu via APT)..."

maybe_wait_for_apt() {
  if type -t wait_for_apt >/dev/null 2>&1; then
    wait_for_apt
  fi
}

# Follow upstream instructions: https://github.com/cli/cli/blob/trunk/docs/install_linux.md
maybe_wait_for_apt
sudo apt-get update
maybe_wait_for_apt
sudo apt-get install -y curl ca-certificates gnupg
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg >/dev/null
sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list >/dev/null
maybe_wait_for_apt
sudo apt-get update
maybe_wait_for_apt
sudo apt-get install -y gh

if command -v gh >/dev/null 2>&1; then
  echo "✅ gh installed: $(gh --version | head -n1)"
else
  echo "⚠️ gh not installed (see logs above)."
fi


# Non-interactive authentication if a token is provided
# Preferred env var is GH_TOKEN; fallback to GITHUB_TOKEN per gh help environment
if [ -z "${GH_TOKEN:-}" ] && [ -n "${GITHUB_TOKEN:-}" ]; then
  export GH_TOKEN="$GITHUB_TOKEN"
fi

if command -v gh >/dev/null 2>&1 && [ -n "${GH_TOKEN:-}" ]; then
  echo "🔐 Authenticating gh using GH_TOKEN..."
  # Persist credentials for API and git operations
  echo "$GH_TOKEN" | gh auth login --with-token --hostname github.com --git-protocol https || true
  # Configure git to use gh as credential helper (canonical helper on Linux)
  if ! gh auth setup-git --hostname github.com 2>/dev/null; then
    git config --global credential.helper "!$(command -v gh) auth git-credential"
  fi
  # Optional: set git identity if provided
  if [ -n "${GIT_USER_NAME:-}" ]; then git config --global user.name "$GIT_USER_NAME"; fi
  if [ -n "${GIT_USER_EMAIL:-}" ]; then git config --global user.email "$GIT_USER_EMAIL"; fi
  echo "✅ gh auth configured; git credential helper set to gh."
fi


