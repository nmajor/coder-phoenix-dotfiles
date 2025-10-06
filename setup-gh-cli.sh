#!/usr/bin/env bash
set -euo pipefail

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