#!/usr/bin/env bash
# Claude Code statusline — Dracula tmux look + a moody, animated crab mascot.
# Mood derives from real session signals (context %, idle, todos, agent, worktree).
# Frames cycle each second; pair with `"refreshInterval": 1` in settings.json.

set -u

input=$(cat)

model=$(printf '%s' "$input"        | jq -r '.model.display_name // .model.id // "claude"')
cwd=$(printf '%s' "$input"          | jq -r '.workspace.current_dir // .cwd // ""')
session_id=$(printf '%s' "$input"   | jq -r '.session_id // ""')
output_style=$(printf '%s' "$input" | jq -r '.output_style.name // ""')
transcript=$(printf '%s' "$input"   | jq -r '.transcript_path // ""')
ctx_pct=$(printf '%s' "$input"      | jq -r '.context_window.used_percentage // 0')
agent_name=$(printf '%s' "$input"   | jq -r '.agent.name // ""')
wt_name=$(printf '%s' "$input"      | jq -r '.worktree.name // ""')
vim_mode=$(printf '%s' "$input"     | jq -r '.vim.mode // ""')

# ── hook-bridged state (permission_mode, awaiting flag) ───────────────────────
# Populated by ~/.claude/hooks/update-state.sh on every hook event.
# Parsed (not sourced) so a corrupt file can't execute anything.
CLAUDE_MODE="default"
CLAUDE_AWAITING=0
state_file="$HOME/.claude/state/${session_id}.env"
if [ -n "$session_id" ] && [ -f "$state_file" ]; then
    while IFS='=' read -r k v; do
        case "$k" in
            CLAUDE_MODE)     CLAUDE_MODE="${v:-default}" ;;
            CLAUDE_AWAITING) CLAUDE_AWAITING="${v:-0}" ;;
        esac
    done < "$state_file"
fi

# ── pretty cwd ────────────────────────────────────────────────────────────────
if [ -n "$cwd" ]; then
    case "$cwd" in
        "$HOME")   dir_name="~" ;;
        "$HOME/"*) dir_name="~/$(basename "$cwd")" ;;
        *)         dir_name=$(basename "$cwd") ;;
    esac
else
    dir_name="?"
fi

# ── git: branch + dirty ───────────────────────────────────────────────────────
branch=""; dirty=0
if [ -n "$cwd" ] && git -C "$cwd" rev-parse --git-dir >/dev/null 2>&1; then
    branch=$(git -C "$cwd" symbolic-ref --short HEAD 2>/dev/null \
          || git -C "$cwd" rev-parse  --short HEAD 2>/dev/null \
          || true)
    git -C "$cwd" diff-index --quiet HEAD -- 2>/dev/null || dirty=1
fi

# ── session uptime + idle ─────────────────────────────────────────────────────
elapsed=0; idle_secs=9999
if [ -n "$transcript" ] && [ -f "$transcript" ]; then
    start=$(stat -f %B "$transcript" 2>/dev/null || echo "")
    [ -n "$start" ] && elapsed=$(( $(date +%s) - start ))
    last_touch=$(stat -f %m "$transcript" 2>/dev/null || echo 0)
    idle_secs=$(( $(date +%s) - last_touch ))
fi
uptime_str=""
if [ "$elapsed" -gt 0 ]; then
    h=$((elapsed/3600)); m=$(((elapsed%3600)/60)); s=$((elapsed%60))
    if   [ $h -gt 0 ]; then uptime_str=$(printf '%dh%02dm' "$h" "$m")
    elif [ $m -gt 0 ]; then uptime_str=$(printf '%dm%02ds' "$m" "$s")
    else                    uptime_str=$(printf '%ds' "$s")
    fi
fi

# ── todos: victory if all complete ────────────────────────────────────────────
todo_total=0; todo_done=0
if [ -n "$session_id" ]; then
    for tf in "$HOME/.claude/todos/${session_id}"*.json; do
        [ -f "$tf" ] || continue
        counts=$(jq -r '"\(length) \([.[] | select(.status=="completed")] | length)"' "$tf" 2>/dev/null) || continue
        todo_total=$(( todo_total + ${counts%% *} ))
        todo_done=$(( todo_done + ${counts##* } ))
    done
fi

# ── time + tz ─────────────────────────────────────────────────────────────────
now=$(date +"%H:%M")
tz=$(date +"%Z")
hr=$(date +"%H"); hr=${hr#0}; [ -z "$hr" ] && hr=0

# ── Dracula palette ───────────────────────────────────────────────────────────
PINK="255;121;198"; PURPLE="189;147;249"; CYAN="139;233;253"
GREEN="80;250;123"; YELLOW="241;250;140";  ORANGE="255;184;108"
RED="255;85;85";   COMMENT="98;114;164";    DARK="40;42;54"

ARROW=$''
SEP="⸗"

esc()   { printf '\033[%sm' "$1"; }
fg()    { esc "38;2;$1"; }
bg()    { esc "48;2;$1"; }
reset() { esc "0"; }
segment() {
    local b="$1" prev="$2" text="$3"
    [ -n "$prev" ] && printf '%s%s%s' "$(bg "$b")$(fg "$prev")" "$ARROW" ""
    printf '%s%s %s ' "$(bg "$b")" "$(fg "$DARK")" "$text"
}

# ── mood machine — first match wins ───────────────────────────────────────────
ctx_int=${ctx_pct%.*}
# Fixed 3-digit slot (" 9%" … "100%") so ctx changes never shift the layout.
ctx_str=$(printf "%3d%%" "${ctx_int:-0}")
mood="default"
case "$cwd" in
    *dotfiles*|*/nvim*|*/.config*) cwd_wizardly=1 ;;
    *) cwd_wizardly=0 ;;
esac

if   [ "${ctx_int:-0}" -ge 90 ]; then mood="panic"
elif [ "${ctx_int:-0}" -ge 75 ]; then mood="stressed"
elif [ "${ctx_int:-0}" -ge 50 ]; then mood="warming"
elif [ "$CLAUDE_MODE" = "bypassPermissions" ]; then mood="yolo"
elif [ "$CLAUDE_MODE" = "plan" ]; then mood="plan"
elif [ "$CLAUDE_AWAITING" = "1" ]; then mood="awaiting"
elif [ "$todo_total" -gt 0 ] && [ "$todo_done" -eq "$todo_total" ]; then mood="victory"
elif [ -n "$agent_name" ]; then mood="subagent"
elif [ -n "$wt_name" ]; then mood="worktree"
elif [ "$elapsed" -gt 0 ] && [ "$elapsed" -lt 20 ]; then mood="fresh"
elif [ "$idle_secs" -gt 90 ]; then mood="sleepy"
elif [ "$cwd_wizardly" -eq 1 ]; then mood="wizard"
elif [ "$hr" -ge 0 ] && [ "$hr" -lt 5 ]; then mood="vampire"
elif [ "$idle_secs" -lt 4 ]; then mood="working"
fi

# ── display width (terminal columns) of each arg, one per line ───────────────
# Wide/fullwidth chars (CJK, emoji) count 2, combining marks count 0.
disp_width() {
    perl -CSA -e 'for (@ARGV) { my $w = 0;
        for my $c (split //) {
            if    ($c =~ /[\p{Mn}\p{Me}\p{Cf}]/)  { }
            elsif ($c =~ /[\p{EA=W}\p{EA=F}]/)    { $w += 2 }
            else                                  { $w += 1 }
        } print "$w\n" }' -- "$@"
}

frame=$(( $(date +%s) % 4 ))
suffix=""

# Each mood defines exactly 4 frames; the current one is padded to the widest
# so the statusline doesn't shift as frames cycle.
case "$mood" in
    panic)
        icon_bg="$RED"
        frames=("(╯°□°)╯︵┻━┻" "(ノಠ益ಠ)ノ彡┻━┻" "(┛◉Д◉)┛彡┻━┻" "(ノಥДಥ)ノ彡┻━┻")
        suffix=" $ctx_str" ;;
    stressed)
        icon_bg="$RED"
        frames=("(;´д｀)ゞ" "(>﹏<);;" "(;´д｀)ゞ" "(>﹏<);;")
        suffix=" $ctx_str" ;;
    warming)
        icon_bg="$ORANGE"
        frames=("(°,,°);" "(°,,°)~~" "(°,,°);" "(°,,°)~~")
        suffix=" $ctx_str" ;;
    yolo)
        icon_bg="$RED"
        frames=("( •̀ᴗ•́ )و" "(╬ ಠ益ಠ)" "( •̀ᴗ•́ )و🔥" "(ง •̀_•́)ง")
        suffix=" YOLO" ;;
    plan)
        icon_bg="$CYAN"
        frames=("(¬‿¬ )" "(  ・_・)" "( ¬‿¬)" "(・_・  )")
        suffix=" plan" ;;
    awaiting)
        icon_bg="$YELLOW"
        frames=("(°,,°)╯" "╰(°,,°)" "(°,,°)╯" "╰(°,,°)")
        suffix=" ?" ;;
    victory)
        icon_bg="$GREEN"
        frames=("╰(°▽°)╯" "\\(°ヮ°)/" "ᕦ(ò_óˇ)ᕤ" "\\(°ヮ°)/")
        suffix=" ${todo_done}/${todo_total}✓" ;;
    subagent)
        icon_bg="$CYAN"
        frames=("[¬‿¬]" "[•‿•]" "[¬‿¬]" "[•‿•]")
        suffix=" $agent_name" ;;
    worktree)
        icon_bg="$PURPLE"
        frames=("(°,,°)║(°,,°)" "(°,,°)║(•,,•)" "(°,,°)║(°,,°)" "(°,,°)║(•,,•)")
        suffix=" $wt_name" ;;
    fresh)
        icon_bg="$YELLOW"
        frames=("\\(◕ヮ◕)/" "\\(°ヮ°)/" "\\(◕ヮ◕)/" "\\(°ヮ°)/") ;;
    sleepy)
        icon_bg="$PURPLE"
        frames=("(--,,--) z" "(--,,--) zZ" "(--,,--) zZz" "(--,,--)") ;;
    wizard)
        icon_bg="$CYAN"
        frames=("(◑.◑)ᕗ" "ᕦ(ò_óˇ)ᕤ" "(◑.◑)ᕗ" "(∩ᵔᗜᵔ)⊃━☆") ;;
    vampire)
        icon_bg="$PURPLE"
        frames=("(ʘᗩʘ')" "(¬‿¬ )" "(ʘᗩʘ')" "(⊙_⊙ )") ;;
    working)
        icon_bg="$GREEN"
        frames=("┏(°,,°)┛" "♪┏(°,,°)┛♪" "♪┗(°,,°)┓♪" "┗(°,,°)┓") ;;
    default|*)
        icon_bg="$PINK"
        frames=("\\(°,,°)/" " (°,,°) " "/(°,,°)\\" " (°,,°) ") ;;
esac

icon="${frames[$frame]}"
widths=( $(disp_width "${frames[@]}") )
max_w=0
for w in "${widths[@]}"; do [ "$w" -gt "$max_w" ] && max_w=$w; done
pad=$(( max_w - ${widths[$frame]} ))
[ "$pad" -gt 0 ] && icon="$icon$(printf '%*s' "$pad" "")"
icon="$icon$suffix"

# ── render: split into LEFT (icon + model) and RIGHT (everything else) ────────
LARROW=$''   # left-pointing powerline arrow

# Left: icon + model, then powerline exit arrow
left=""
left+=$(segment "$icon_bg" ""         "$icon")
left+=$(segment "$PURPLE"  "$icon_bg" "$model")
left+="$(reset)$(fg "$PURPLE")${ARROW}$(reset)"

# Right: starts with a left-pointing arrow into the cwd segment
right="$(reset)$(fg "$CYAN")${LARROW}$(reset)"
right+=$(segment "$CYAN" "" "$dir_name")
prev="$CYAN"

if [ -n "$branch" ]; then
    if [ "$dirty" -eq 1 ]; then
        right+=$(segment "$YELLOW" "$prev" " $branch *"); prev="$YELLOW"
    else
        right+=$(segment "$GREEN" "$prev" " $branch"); prev="$GREEN"
    fi
fi

if [ -n "$vim_mode" ]; then
    right+=$(segment "$ORANGE" "$prev" "vim:$vim_mode"); prev="$ORANGE"
fi

case "$CLAUDE_MODE" in
    acceptEdits) right+=$(segment "$GREEN"  "$prev" "auto-edit"); prev="$GREEN" ;;
    auto)        right+=$(segment "$PURPLE" "$prev" "⏵⏵ auto");  prev="$PURPLE" ;;
    dontAsk)     right+=$(segment "$ORANGE" "$prev" "dont-ask");  prev="$ORANGE" ;;
esac

if [ -n "$output_style" ] && [ "$output_style" != "default" ]; then
    right+=$(segment "$PINK" "$prev" "$output_style"); prev="$PINK"
fi

# Always show ctx% — color tier matches the mood thresholds
if [ "${ctx_int:-0}" -ge 90 ];  then ctx_bg="$RED"
elif [ "${ctx_int:-0}" -ge 75 ]; then ctx_bg="$RED"
elif [ "${ctx_int:-0}" -ge 50 ]; then ctx_bg="$ORANGE"
elif [ "${ctx_int:-0}" -ge 25 ]; then ctx_bg="$YELLOW"
else                                  ctx_bg="$COMMENT"
fi
right+=$(segment "$ctx_bg" "$prev" "ctx $ctx_str"); prev="$ctx_bg"

if [ "$todo_total" -gt 0 ] && [ "$todo_done" -lt "$todo_total" ]; then
    right+=$(segment "$CYAN" "$prev" "${todo_done}/${todo_total}"); prev="$CYAN"
fi

if [ -n "$uptime_str" ]; then
    right+=$(segment "$YELLOW" "$prev" "↑ $uptime_str"); prev="$YELLOW"
fi

right+=$(segment "$ORANGE" "$prev" " ${now} ${SEP} ${tz}")
right+="$(reset)$(fg "$ORANGE")${ARROW}$(reset)"

# ── pad the middle to span the full terminal width ───────────────────────────
# Strip ANSI, then measure real terminal columns.
vis_len() {
    local s
    s=$(printf '%s' "$1" | sed -E $'s/\x1b\\[[0-9;]*m//g')
    disp_width "$s"
}

# The harness runs us without a tty and doesn't set $COLUMNS (tput would just say
# 80), so walk up the process tree to the first ancestor with a tty — claude
# itself — and ask that tty for its size.
tty_width() {
    local pid=$PPID t
    while [ -n "$pid" ] && [ "$pid" -gt 1 ]; do
        t=$(ps -o tty= -p "$pid" 2>/dev/null | tr -d ' ')
        if [ -n "$t" ] && [ "$t" != "??" ]; then
            stty -f "/dev/$t" size 2>/dev/null | awk '{ print $2 }'
            return
        fi
        pid=$(ps -o ppid= -p "$pid" 2>/dev/null | tr -d ' ')
    done
}

# Columns to hold back from the right edge (0 = flush to the terminal edge).
EDGE_MARGIN=0

term_width=${COLUMNS:-0}
[ "$term_width" -lt 20 ] && term_width=$(tty_width)
[ "${term_width:-0}" -lt 20 ] && term_width=120
term_width=$(( term_width - EDGE_MARGIN ))

left_w=$(vis_len "$left")
right_w=$(vis_len "$right")
gap=$(( term_width - left_w - right_w ))
[ "$gap" -lt 1 ] && gap=1

printf '%s' "$left"
printf '%*s' "$gap" ""
printf '%s' "$right"
