#!/bin/bash

input=$(cat)

model=$(echo "$input" | jq -r '.model.display_name // "unknown"')
cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // empty')
case "$cwd" in
  "$HOME") dir="~" ;;
  "$HOME"/*) dir="~${cwd#$HOME}" ;;
  *) dir="$cwd" ;;
esac

branch=""
if command -v git >/dev/null 2>&1 && [ -n "$cwd" ]; then
  branch=$(git -C "$cwd" --no-optional-locks rev-parse --is-inside-work-tree >/dev/null 2>&1 && \
    git -C "$cwd" --no-optional-locks branch --show-current 2>/dev/null)
fi

used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')

five=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
week=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')

# Dim gray color for terminal
DIM='\033[2m'
RESET='\033[0m'

out="${DIM}${model}${RESET}"
[ -n "$dir" ] && out="${out} ${DIM}|${RESET} ${DIM}${dir}${RESET}"
[ -n "$branch" ] && out="${out} ${DIM}|${RESET} ${DIM}${branch}${RESET}"
[ -n "$used_pct" ] && out="${out} ${DIM}|${RESET} ${DIM}ctx: $(printf '%.0f' "$used_pct")%${RESET}"

limits=""
[ -n "$five" ] && limits="5h:$(printf '%.0f' "$five")%"
if [ -n "$week" ]; then
  [ -n "$limits" ] && limits="${limits} "
  limits="${limits}7d:$(printf '%.0f' "$week")%"
fi
[ -n "$limits" ] && out="${out} ${DIM}|${RESET} ${DIM}${limits}${RESET}"

printf "%b" "$out"
