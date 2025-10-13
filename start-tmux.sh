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

# 3) Start the server and create sessions if they don't exist
if command -v tmux >/dev/null 2>&1; then
  tmux start-server >/dev/null 2>&1 || true
  
  # Your existing 'dev' session
  tmux has-session -t dev 2>/dev/null || tmux new-session -d -s dev -n shell "/usr/bin/zsh -l"
  
  # New 'dev-server' session: Detached, in project dir, runs the script
  PROJECT_DIR="$HOME/app"  # Define once; use env var for reusability if needed
  SCRIPT_PATH="$PROJECT_DIR/dev-server.sh"
  if [ -f "$SCRIPT_PATH" ]; then
    tmux has-session -t dev-server 2>/dev/null || tmux new-session -d -s dev-server -n server -c "$PROJECT_DIR" "./dev-server.sh run"
  else
    echo "WARN: $SCRIPT_PATH not found—skipping dev-server session creation. (Create/extract the script first.)"
  fi
fi

# Quick verification (no server required for these, but nicer with one)
if require_cmd tmux; then
  tmux start-server || true
  echo "tmux default-shell:   $(tmux show -g default-shell 2>/dev/null || echo '(no server)')"
  echo "tmux default-command: $(tmux show -g default-command 2>/dev/null || echo '(no server)')"
  echo "Sessions: $(tmux list-sessions -F '#{session_name}' 2>/dev/null || echo 'None')"
fi

echo "tmux bootstrap complete. 'dev-server' session ready (attach with 'tmux attach -t dev-server')."