#!/bin/bash

BARFILE="$HOME/.config/themes/.current-bar"

CURRENT=$(cat "$BARFILE" 2>/dev/null)

if [[ "$CURRENT" == "waybar" ]]; then
  echo "qs" > "$BARFILE"
  notify-send "Bar" "Switched to Quickshell"
else
  echo "waybar" > "$BARFILE"
  notify-send "Bar" "Switched to Waybar"
fi

CURRENT_THEME=$(cat "$HOME/.config/themes/.current-theme")
"$HOME/.config/themes/applyTheme.sh" "$CURRENT_THEME"
