#!/bin/bash

set -euo pipefail

# This script intentionally preserves the previous Erlang/OTP + Elixir install logic.
# It relies on OTP_VERSION and ELIXIR_VERSION provided by the caller.

echo "💎 Installing Elixir ${ELIXIR_VERSION:-} with OTP ${OTP_VERSION:-}..."

# Download and run official Elixir install script in a temp dir to avoid cwd conflicts
tmpdir=$(mktemp -d)
trap 'rm -rf "$tmpdir"' EXIT
(
  cd "$tmpdir"
  curl -fsSO https://elixir-lang.org/install.sh
  sh install.sh elixir@${ELIXIR_VERSION} otp@${OTP_VERSION}
)

# Set up PATH using the actual installed directories
installs_dir=$HOME/.elixir-install/installs

# Find the actual installed versions (install script may pick different versions)
otp_actual_dir=$(ls -1 $installs_dir/otp/ | head -1)
elixir_actual_dir=$(ls -1 $installs_dir/elixir/ | head -1)

echo "📋 Found installations:"
echo "  • OTP: $otp_actual_dir"
echo "  • Elixir: $elixir_actual_dir"

# Add to bashrc for future sessions using actual directories
echo "export PATH=\$HOME/.elixir-install/installs/otp/$otp_actual_dir/bin:\$PATH" >> ~/.bashrc
echo "export PATH=\$HOME/.elixir-install/installs/elixir/$elixir_actual_dir/bin:\$PATH" >> ~/.bashrc

# Export for current session using actual directories
export PATH=$installs_dir/otp/$otp_actual_dir/bin:$PATH
export PATH=$installs_dir/elixir/$elixir_actual_dir/bin:$PATH

# Verify PATH is working
echo "🔍 Verifying Elixir installation..."
which elixir && which mix

# Install Elixir development tools
echo "🔧 Installing Elixir development tools..."
mix local.hex --force
mix local.rebar --force
mix archive.install hex phx_new --force

# Install global elixir libs
mix archive.install hex igniter_new --force
mix archive.install hex phx_new 1.8.1 --force

echo "✅ Elixir/Erlang/OTP installation complete."

