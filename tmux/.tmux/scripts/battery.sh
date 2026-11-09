#!/usr/bin/env bash
# Status line battery segment, used instead of the Dracula plugin's battery.sh
# (kept outside plugins/ so plugin updates can't overwrite it). The plugin's
# script reads the last power_supply entry, which on Linux may be a USB-C port
# rather than the laptop battery, so it shows AC while unplugged.

[ "$(uname -s)" = Linux ] || exec "$(dirname "${BASH_SOURCE[0]}")/../plugins/tmux/scripts/battery.sh"

label=$(tmux show-option -gqv @dracula-battery-label)
label=${label:-♥}

# System battery only: scope=Device entries are peripherals such as a mouse.
for d in /sys/class/power_supply/*; do
  [ "$(cat "$d/type" 2>/dev/null)" = Battery ] || continue
  [ "$(cat "$d/scope" 2>/dev/null)" = Device ] && continue
  status=$(cat "$d/status")
  percent=$(cat "$d/capacity")
  if [ "$status" = Discharging ]; then
    echo "$label $percent"
  else
    echo "$label AC $percent"
  fi
  exit 0
done

echo "$label AC"
