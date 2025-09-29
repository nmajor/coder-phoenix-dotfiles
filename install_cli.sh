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


