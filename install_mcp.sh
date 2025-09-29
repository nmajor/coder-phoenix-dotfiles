#!/bin/bash

set -euo pipefail

# Install user-level MCP configuration from dotfiles into supported clients.
# Source of truth: default-mcp.json (schema: { "mcpServers": { ... } })

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC_JSON="$SCRIPT_DIR/default-mcp.json"

if [ ! -f "$SRC_JSON" ] || [ ! -s "$SRC_JSON" ]; then
  echo "ℹ️ No MCP config found at $SRC_JSON (file missing or empty). Skipping MCP setup."
  exit 0
fi

echo "🧩 Installing user-level MCP configuration..."

# Cursor (global): ~/.cursor/mcp.json
mkdir -p "$HOME/.cursor"
cp -f "$SRC_JSON" "$HOME/.cursor/mcp.json"

# Claude Desktop (Linux): ~/.config/Claude/claude_desktop_config.json
mkdir -p "$HOME/.config/Claude"
cp -f "$SRC_JSON" "$HOME/.config/Claude/claude_desktop_config.json"

# VS Code (user): ~/.config/Code/User/mcp.json
mkdir -p "$HOME/.config/Code/User"
cp -f "$SRC_JSON" "$HOME/.config/Code/User/mcp.json"

# Claude Code user-level: merge only mcpServers into ~/.claude.json
CLAUDE_JSON="$HOME/.claude.json"
TMP_OUT="$(mktemp)"
if [ -f "$CLAUDE_JSON" ] && [ -s "$CLAUDE_JSON" ]; then
  jq -s '.[0] * {"mcpServers": (.[1].mcpServers // {}) }' "$CLAUDE_JSON" "$SRC_JSON" > "$TMP_OUT"
else
  # Create minimal file with only mcpServers from default
  jq '{"mcpServers": (.mcpServers // {}) }' "$SRC_JSON" > "$TMP_OUT"
fi
mv "$TMP_OUT" "$CLAUDE_JSON"

echo "✅ MCP config installed to:"
echo "  • Cursor:        $HOME/.cursor/mcp.json"
echo "  • Claude Desktop: $HOME/.config/Claude/claude_desktop_config.json"
echo "  • VS Code:        $HOME/.config/Code/User/mcp.json"
echo "  • Claude Code:    $HOME/.claude.json (mcpServers merged)"

exit 0


