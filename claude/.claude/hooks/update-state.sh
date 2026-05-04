#!/usr/bin/env bash
# Bridge hook → ~/.claude/state/<session_id>.env so the statusline can see signals
# that aren't in its own JSON (permission_mode, awaiting-user flag).
# Reads hook event JSON from stdin; writes a parseable KEY=VALUE file.
# Always exits 0 — never block a Claude event on statusline plumbing.

set -u

input=$(cat 2>/dev/null || true)
sid=$(printf '%s'   "$input" | jq -r '.session_id        // ""'        2>/dev/null) || sid=""
mode=$(printf '%s'  "$input" | jq -r '.permission_mode   // "default"' 2>/dev/null) || mode="default"
event=$(printf '%s' "$input" | jq -r '.hook_event_name   // ""'        2>/dev/null) || event=""

[ -z "$sid" ] && exit 0

dir="$HOME/.claude/state"
mkdir -p "$dir"
file="$dir/${sid}.env"

# Preserve fields not touched by this event
prev_awaiting=0
if [ -f "$file" ]; then
    prev_awaiting=$(awk -F= '/^CLAUDE_AWAITING=/{print $2}' "$file" 2>/dev/null)
    [ -z "$prev_awaiting" ] && prev_awaiting=0
fi

awaiting=$prev_awaiting
case "$event" in
    Notification)                 awaiting=1 ;;
    UserPromptSubmit|Stop|SubagentStop|SessionStart) awaiting=0 ;;
esac

{
    printf 'CLAUDE_MODE=%s\n'      "$mode"
    printf 'CLAUDE_AWAITING=%s\n'  "${awaiting:-0}"
    printf 'CLAUDE_LAST_EVENT=%s\n' "$event"
} > "$file.tmp" && mv "$file.tmp" "$file"

# Stale-sweep: remove any per-session env files older than 24h (crashed sessions)
find "$dir" -maxdepth 1 -name '*.env' -mtime +1 -delete 2>/dev/null || true

exit 0
