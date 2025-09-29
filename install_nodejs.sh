#!/bin/bash

set -euo pipefail

# Ubuntu-native Node.js install using NodeSource APT repository.
# Respects NODE_VERSION:
#   - "latest": install latest in the chosen default major (22.x by default)
#   - "22": install latest 22.x
#   - "22.10.0": attempt to pin exact package version if available, else fallback to latest 22.x

echo "🟢 Installing Node.js via NodeSource (Ubuntu APT)..."

sudo apt-get update
sudo apt-get install -y curl ca-certificates gnupg

want="${NODE_VERSION:-latest}"

# Determine major line
if [ "$want" = "latest" ]; then
  major="22"  # default track; adjust in install.sh if needed
else
  major="${want%%.*}"
fi

# Add NodeSource repo for selected major
curl -fsSL "https://deb.nodesource.com/setup_${major}.x" | sudo -E bash -

sudo apt-get update

# If full patch requested, try to pin exact package version
if [[ "$want" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  echo "🔎 Attempting exact pin to $want from NodeSource..."
  pkg_ver=$(apt-cache madison nodejs | awk '{print $3}' | grep -E "^${want}[~+-]" | head -n1 || true)
  if [ -n "${pkg_ver:-}" ]; then
    sudo apt-get install -y "nodejs=${pkg_ver}"
  else
    echo "⚠️ Exact ${want} not found in APT. Installing latest ${major}.x instead."
    sudo apt-get install -y nodejs
  fi
else
  # Install latest in this major line
  sudo apt-get install -y nodejs
fi

# Enable Corepack (bundled with Node >=16.10)
corepack enable || true

echo "✅ Installed Node.js: $(node -v) (npm $(npm -v))"

echo "Installing global npm packages..."

npm install -g @anthropic-ai/claude-code

