#!/usr/bin/env bash
set -euo pipefail

require_cmd() { command -v "$1" >/dev/null 2>&1; }

# 1) Ensure tmux exists (skip install if not root)
if ! require_cmd tmux; then
  if [ "$(id -u)" -eq 0 ] && require_cmd apt-get; then
    apt-get update && apt-get install -y tmux
  else
    echo "WARN: tmux not found and cannot install (need root)."
  fi
fi

# Load config into running server (if any), otherwise start+source quietly
TMUX_DST="${HOME}/.tmux.conf"
if require_cmd tmux; then
  tmux start-server || true
  if [ -f "$TMUX_DST" ]; then
    tmux source-file "$TMUX_DST" || true
  fi
fi

# Start the server and create a single new dev session if it doesn't exist
if command -v tmux >/dev/null 2>&1; then
  tmux start-server >/dev/null 2>&1 || true
  tmux has-session -t dev 2>/dev/null || tmux new-session -d -s dev -n shell "/usr/bin/zsh -l"
fi

# Quick verification (no server required for these, but nicer with one)
if require_cmd tmux; then
  tmux start-server || true
  echo "tmux default-shell:   $(tmux show -g default-shell 2>/dev/null || echo '(no server)')"
  echo "tmux default-command: $(tmux show -g default-command 2>/dev/null || echo '(no server)')"
fi


echo "tmux bootstrap complete."