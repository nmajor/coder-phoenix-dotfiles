#!/bin/bash

set -euo pipefail

# Minimal Python setup for Ubuntu (required by Zen MCP wrapper)

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

echo "🐍 Ensuring Python runtime..."
wait_for_apt
sudo apt-get update
wait_for_apt
sudo apt-get install -y python3 python3-venv python3-pip

# Ensure ~/.local/bin (pip --user scripts) is on PATH for non-login shells
if ! grep -q "/.local/bin" "$HOME/.bashrc" 2>/dev/null; then
  echo "export PATH=\$HOME/.local/bin:\$PATH" >> "$HOME/.bashrc"
fi
if [ -f "$HOME/.zshrc" ]; then
  if ! grep -q "/.local/bin" "$HOME/.zshrc" 2>/dev/null; then
    echo "export PATH=\$HOME/.local/bin:\$PATH" >> "$HOME/.zshrc"
  fi
fi

echo "✅ Python ready: $(python3 --version 2>/dev/null || echo 'python3 missing?')"


