#!/bin/bash

set -euo pipefail

echo "🚀 Setting up Elixir Phoenix development environment..."

export OTP_VERSION="28.1"
export ELIXIR_VERSION="1.18.4"
export NODE_VERSION="22.10.0"

# Make versions available to subscripts and resolve script dir
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

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

# Install minimal dependencies (no compilation needed!)
echo "📦 Installing minimal dependencies..."
wait_for_apt
sudo apt-get update
wait_for_apt
sudo apt-get install -y curl unzip zsh git inotify-tools jq

# Install Erlang/OTP and Elixir (delegated, sourced so PATH persists)
source "$SCRIPT_DIR/install_elixir_erlang_otp.sh"

# Install Node.js (delegated, sourced so PATH/npm prefix persists)
source "$SCRIPT_DIR/install_nodejs.sh"

# Install Python (for MCPs like Zen)
source "$SCRIPT_DIR/install_python.sh"

# Install CLIs (e.g., GitHub CLI)
  source "$SCRIPT_DIR/install_cli.sh"

# Create app directory and set as default
echo "📁 Creating app directory..."
mkdir -p /home/coder/app


# Setup zsh with Oh My Zsh and Starship prompt
echo "🐚 Setting up zsh with Oh My Zsh and Starship prompt..."
# Install Oh My Zsh (skip if already exists)
if [ -d "$HOME/.oh-my-zsh" ]; then
    echo "Oh My Zsh is already installed, skipping installation."
else
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# Restore our zsh config to avoid template overwrite
if [ -f "$SCRIPT_DIR/dot-zshrc" ]; then
    cp -f "$SCRIPT_DIR/dot-zshrc" "$HOME/.zshrc"
fi

# Ensure npm global bin is on zsh PATH (survives template overwrite)
if ! grep -q "/.local/npm/bin" "$HOME/.zshrc" 2>/dev/null; then
    echo "export PATH=\$HOME/.local/npm/bin:\$PATH" >> "$HOME/.zshrc"
fi

# Install Starship prompt
echo "⭐ Installing Starship prompt..."
curl -sS https://starship.rs/install.sh | sh -s -- --yes

# Change default shell to zsh
sudo chsh -s $(which zsh) coder

# Install MCP config (delegated)
source "$SCRIPT_DIR/install_mcp.sh"

echo "🎉 Environment ready!"
echo "📊 Database: postgres://postgres:postgres@localhost:5432"
echo "📁 Default directory: ~/app (automatically set for SSH sessions)"
echo "🚀 Create Phoenix app: cd ~/app && mix phx.new my_app"
echo "🗄️ Setup database: mix ecto.create"
echo "🌐 Start server: mix phx.server"
echo ""
echo "📋 Installed versions:"
echo "  • Erlang: $(erl -eval 'erlang:display(erlang:system_info(otp_release)), halt().' -noshell)"
echo "  • Elixir: $(elixir --version | head -n1)"
echo "  • Node: $(node -v)"
echo "  • npm: $(npm -v)"
echo "  • Shell: $(zsh --version)"
echo "📝 Note: Pre-built binaries installed - no compilation required!"
echo "📝 Note: Databases persist across workspace restarts"
echo "🐚 Note: zsh with Oh My Zsh and Starship prompt configured with Phoenix aliases"
echo "📁 Note: ~/app directory created and set as default working directory"
 

echo "✅ Dotfiles setup complete!"
echo "🔄 Please restart your shell or run 'source ~/.bashrc' (or equivalent) to apply changes."