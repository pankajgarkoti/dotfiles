#!/usr/bin/env bash
# ranger text previews (EVA): bat for text, listings for archives, pdftotext, media info.
# Exit codes follow ranger's scope.sh contract: 0 = show output, 1 = no preview.
path="$1" width="${2:-80}" height="${3:-40}"
mime=$(file --dereference --brief --mime-type -- "$path")
case "${path,,}" in
  *.tar|*.tgz|*.tar.*|*.txz|*.tbz2) tar tvf "$path" 2>/dev/null | head -n "$height"; exit 0 ;;
  *.zip|*.jar|*.apk) unzip -l "$path" 2>/dev/null | head -n "$height"; exit 0 ;;
  *.7z|*.rar) command -v 7z >/dev/null && 7z l "$path" | head -n "$height" && exit 0 ;;
  *.pdf) command -v pdftotext >/dev/null && pdftotext -l 5 -layout "$path" - | head -n "$height" && exit 0 ;;
  *.json) command -v jq >/dev/null && jq -C . "$path" 2>/dev/null | head -n "$height" && exit 0 ;;
esac
case "$mime" in
  text/*|*/xml|*/json|*/javascript|*/x-shellscript|application/x-empty)
    if command -v bat >/dev/null; then
      bat --color=always --style=plain --paging=never --theme=ansi --terminal-width="$width" --line-range=:"$height" -- "$path"
    else head -n "$height" -- "$path"; fi
    exit 0 ;;
  image/*|video/*|audio/*)
    if command -v mediainfo >/dev/null; then mediainfo "$path"
    elif command -v ffprobe >/dev/null; then ffprobe -hide_banner -- "$path" 2>&1
    else file --brief -- "$path"; fi
    exit 0 ;;
esac
file --dereference --brief -- "$path"
exit 0
