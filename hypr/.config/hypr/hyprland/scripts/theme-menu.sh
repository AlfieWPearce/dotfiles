#!/bin/bash

THEME_DIR="$HOME/.config/themes"
BAR_FILE="$THEME_DIR/.current-bar"
CURRENT_BAR=$(cat "$BAR_FILE" 2>/dev/null || echo "waybar")

CHOICE=$(
{
  echo "Toggle Bar (Current: $CURRENT_BAR)"
  find "$THEME_DIR" -mindepth 1 -maxdepth 1 -type d -printf "%f\n" | sort
} | rofi -dmenu -p "Theme" \
    -theme ~/.config/rofi/theme-switcher.rasi
    # -theme ~/.config/hypr/hyprland/scripts/rofi-theme.rasi
)

case "$CHOICE" in
  "Toggle Bar (Current: $CURRENT_BAR)")
    "$HOME/.config/hypr/hyprland/scripts/change-bar.sh"
    ;;
  "")
    exit 0
    ;;
  *)
    "$THEME_DIR/applyTheme.sh" "$CHOICE"
    ;;
esac
