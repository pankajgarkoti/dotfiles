#!/usr/bin/env bash
# SessionEnd hook — fires on every exit path (clean, /clear, Ctrl-C, crash).
# Removes the per-session state file written by update-state.sh.

set -u

input=$(cat 2>/dev/null || true)
sid=$(printf '%s' "$input" | jq -r '.session_id // ""' 2>/dev/null) || sid=""

[ -n "$sid" ] && rm -f "$HOME/.claude/state/${sid}.env"

exit 0
