#!/usr/bin/env bash
MCP="$HOME/.mcp.json"
CLAUDE="$HOME/.claude.json"
command -v jq >/dev/null || { echo "jq not found"; exit 1; }
[ -f "$MCP" ] || { echo "$MCP missing"; exit 1; }
M=$(jq '.mcpServers' "$MCP")
jq --argjson m "$M" '.mcpServers=$m | .enableAllProjectMcpServers=true' "$CLAUDE" 2>/dev/null > "$CLAUDE.tmp" || echo '{}' | jq --argjson m "$M" '.mcpServers=$m | .enableAllProjectMcpServers=true' > "$CLAUDE.tmp"
mv "$CLAUDE.tmp" "$CLAUDE"

