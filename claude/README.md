# claude

Claude Code config — Dracula-flavored statusline with a moody, animated crab mascot.

```
\(°,,°)/  Opus 4.7                                      ~/code   main   ctx 8%   ↑ 12m04s    06:43 ⸗ IST
```

The mascot's expression and color shift based on what's happening in your session:
context fill, idle time, permission mode, todo progress, subagent activity. Most signals
come from the statusline's stdin JSON; the rest is bridged via hooks that write a tiny
per-session state file.

## Layout

```
┌─ left ─────────┐                     ┌─ right ────────────────────────────────────────┐
 mascot   model                         cwd   branch   vim   auto-edit   ctx%   X/Y   ↑uptime   HH:MM
└────────────────┘   <padded to width>  └────────────────────────────────────────────────┘
```

Left group is anchored to column 1; right group is right-aligned by padding the gap to
terminal width.

## Moods

First match wins. Crab stays wherever possible — it's the mascot.

| Mood        | Trigger                                                        | Vibe                                          |
| ----------- | -------------------------------------------------------------- | --------------------------------------------- |
| `panic`     | `context_window.used_percentage` ≥ 90                          | red, table-flip — `(╯°□°)╯︵┻━┻`              |
| `stressed`  | ctx ≥ 75                                                       | red, sweating — `(;´д｀)ゞ`                  |
| `warming`   | ctx ≥ 50                                                       | orange, drippy — `(°,,°)~~`                  |
| `yolo`      | `permission_mode == bypassPermissions` (via hook bridge)       | red, fired up — `(╬ ಠ益ಠ) YOLO`              |
| `plan`      | `permission_mode == plan` (via hook bridge)                    | cyan, contemplative — `( ¬‿¬ )`              |
| `awaiting`  | `Notification` hook fired, no prompt yet (via hook bridge)     | yellow, hand-up — `╰(°,,°) ?`                |
| `victory`   | session todos exist & all `completed`                          | green party — `╰(°▽°)╯`, `ᕦ(ò_óˇ)ᕤ`         |
| `subagent`  | `agent.name` present in JSON                                   | cyan masked — `[•‿•] <name>`                 |
| `worktree`  | `worktree.name` present                                        | purple twins — `(°,,°)║(°,,°) <name>`        |
| `fresh`     | session uptime < 20s                                           | yellow, excited — `\(◕ヮ◕)/`                 |
| `sleepy`    | idle > 90s since last transcript update                        | purple, snoozing — `(--,,--) zZz`            |
| `wizard`    | cwd matches `dotfiles\|nvim\|.config`                          | cyan, casting — `(◑.◑)ᕗ`, `(∩ᵔᗜᵔ)⊃━☆`       |
| `vampire`   | local hour ∈ [0, 5)                                            | purple, awake — `(ʘᗩʘ')`                     |
| `working`   | idle < 4s                                                      | green, dancing — `♪┏(°,,°)┛♪`                |
| `default`   | nothing else                                                   | pink, waving — `\(°,,°)/  /(°,,°)\`         |

Plus subtle non-mood indicators on the right side:

- **branch** turns yellow with `*` when the working tree is dirty
- **vim mode** segment when `vim.mode` is in the JSON
- **`auto-edit`** segment in green when `permission_mode == acceptEdits` (subtle — it's
  an everyday mode that doesn't deserve to hijack the mascot)
- **`X/Y`** segment shows todo progress (cyan) when not yet at victory
- **`ctx N%`** is always visible; color tier matches mood thresholds

## Architecture

```
                        ┌─────────────────────┐
   user prompt   ───►   │ Claude Code harness │   ───►   permission_mode change?
                        └─────────────────────┘                    │
                                  │                                ▼
                          (every event)                    (Shift+Tab toggle —
                                  │                         no hook fires until
                                  ▼                         next event)
            ┌───────────────────────────────────┐
            │ hooks/update-state.sh             │
            │ writes ~/.claude/state/<sid>.env  │
            │   CLAUDE_MODE=plan                │
            │   CLAUDE_AWAITING=0               │
            │   CLAUDE_LAST_EVENT=PostToolUse   │
            └───────────────────────────────────┘
                                  │
                                  ▼
            ┌───────────────────────────────────┐
            │ statusline.sh                     │
            │  • parses (does NOT source)       │
            │    the state file                 │
            │  • reads stdin JSON               │
            │  • picks mood, frame, colors      │
            │  • renders left+right groups      │
            └───────────────────────────────────┘
                                  │
                                  ▼
                        rendered every ~1s
                        via refreshInterval
```

`SessionEnd` fires on every exit path (clean / `/clear` / Ctrl-C / crash) and runs
`hooks/clear-state.sh`, which removes the state file. As a backstop, `update-state.sh`
sweeps any per-session env files older than 24h on every event.

## Files

```
.claude/
├── settings.json              # statusLine config + 6 hook bindings
├── statusline.sh              # mood machine, ~280 LOC
└── hooks/
    ├── update-state.sh        # writes ~/.claude/state/<session_id>.env
    └── clear-state.sh         # SessionEnd cleanup
```

State files (runtime, not version-controlled):

```
~/.claude/state/<session_id>.env
```

## Install

This package is stowed via GNU Stow alongside the rest of the dotfiles:

```sh
cd ~/dotfiles && stow claude
```

`setup.sh` includes `claude` in its targets list, so a fresh checkout picks it up.

After installing, restart Claude Code (or `/clear`) so the harness re-reads
`settings.json` and registers the hooks. On first registration Claude Code may prompt
you to approve the hooks — that's expected, since hooks run shell commands.

## Tweaking

- **Add a mood**: append a `case` arm in `statusline.sh` (search for the `case "$mood"`
  block) and a corresponding branch in the cascade above it.
- **Change colors**: the Dracula palette is at the top of `statusline.sh` as
  `R;G;B` triples for ANSI 24-bit.
- **Change the icon entirely**: replace the per-mood `icon=...` lines. The script
  doesn't care about character widths — anything renders.
- **Slow down animation**: change `refreshInterval` in `settings.json`. The frame
  index is `(date +%s) % 4`, so frames change every second regardless.

## Caveats

- `permission_mode` is bridged through hooks because it is **not** in the statusline
  JSON ([docs][1]). A Shift+Tab toggle mid-conversation isn't reflected until the next
  hook fires (next prompt, tool call, or notification).
- Width detection uses `$COLUMNS` → `tput cols` → `120`. If the layout looks misaligned,
  the harness probably isn't propagating `$COLUMNS`.
- Wide CJK characters in some mascots (e.g., the panic table-flip) are slightly
  under-counted by the naive char counter, leaving 1–3 extra cells of gap. Not broken,
  just slightly loose.

[1]: https://code.claude.com/docs/en/statusline
