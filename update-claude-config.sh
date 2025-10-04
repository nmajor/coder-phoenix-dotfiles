#!/usr/bin/env bash
set -euo pipefail
cd "$HOME"
command -v jq >/dev/null || { echo "jq not found"; exit 1; }
[ -f .default-claude.json ] || { echo ".default-claude.json missing"; exit 1; }
if [ -f .claude.json ]; then
  jq -s '.[0] * .[1]' .claude.json .default-claude.json > .claude.json.tmp
else
  cp .default-claude.json .claude.json.tmp
fi
mv .claude.json.tmp .claude.json

