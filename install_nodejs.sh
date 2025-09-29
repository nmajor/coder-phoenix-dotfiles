#!/bin/bash

set -euo pipefail

# Ubuntu-native Node.js install using NodeSource APT repository.
# Respects NODE_VERSION:
#   - "latest": install latest in the chosen default major (22.x by default)
#   - "22": install latest 22.x
#   - "22.10.0": attempt to pin exact package version if available, else fallback to latest 22.x

echo "🟢 Installing Node.js via NodeSource (Ubuntu APT)..."

# Wait for apt/dpkg locks (e.g., other installers during workspace boot)
wait_for_apt() {
  echo "⏳ Waiting for apt/dpkg to be available..."
  while \
    sudo fuser /var/lib/dpkg/lock-frontend >/dev/null 2>&1 || \
    sudo fuser /var/lib/dpkg/lock >/dev/null 2>&1 || \
    sudo fuser /var/cache/apt/archives/lock >/dev/null 2>&1 || \
    pgrep -x apt >/dev/null || pgrep -x apt-get >/dev/null || pgrep -x dpkg >/dev/null; do
    sleep 3
  done
  sudo dpkg --configure -a || true
}

wait_for_apt
sudo apt-get update
wait_for_apt
sudo apt-get install -y curl ca-certificates gnupg

want="${NODE_VERSION:-latest}"

# Determine major line
if [ "$want" = "latest" ]; then
  major="22"  # default track; adjust in install.sh if needed
else
  major="${want%%.*}"
fi

# Add NodeSource repo for selected major
wait_for_apt
curl -fsSL "https://deb.nodesource.com/setup_${major}.x" | sudo -E bash -

wait_for_apt
sudo apt-get update

# If full patch requested, try to pin exact package version
if [[ "$want" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  echo "🔎 Attempting exact pin to $want from NodeSource..."
  pkg_ver=$(apt-cache madison nodejs | awk '{print $3}' | grep -E "^${want}[~+-]" | head -n1 || true)
  if [ -n "${pkg_ver:-}" ]; then
    wait_for_apt
    sudo apt-get install -y "nodejs=${pkg_ver}"
  else
    echo "⚠️ Exact ${want} not found in APT. Installing latest ${major}.x instead."
    wait_for_apt
    sudo apt-get install -y nodejs
  fi
else
  # Install latest in this major line
  wait_for_apt
  sudo apt-get install -y nodejs
fi

# Configure npm to use a user-writable global prefix to avoid EACCES
npm_prefix="$HOME/.local/npm"
mkdir -p "$npm_prefix"
npm config set prefix "$npm_prefix"
if ! grep -q "/.local/npm/bin" ~/.bashrc 2>/dev/null; then
  echo "export PATH=\$HOME/.local/npm/bin:\$PATH" >> ~/.bashrc
fi
export PATH="$npm_prefix/bin:$PATH"

# Ensure zsh sessions can see npm global binaries
if [ -f "$HOME/.zshrc" ]; then
  if ! grep -q "/.local/npm/bin" "$HOME/.zshrc" 2>/dev/null; then
    echo "export PATH=\$HOME/.local/npm/bin:\$PATH" >> "$HOME/.zshrc"
  fi
fi

# Enable Corepack (bundled with Node >=16.10). On NodeSource builds this may
# attempt to write shims into /usr/bin and fail with EACCES; fall back to user-global tools.
if ! corepack enable 2>/dev/null; then
  echo "⚠️ Corepack enable failed (likely permissions). Installing yarn & pnpm globally in user prefix."
  npm install -g yarn pnpm
fi

echo "✅ Installed Node.js: $(node -v) (npm $(npm -v))"

echo "Installing global npm packages..."

npm install -g @anthropic-ai/claude-code

