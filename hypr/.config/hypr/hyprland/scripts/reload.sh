#!/bin/bash

CURRENT_THEME=$(cat "$HOME/.config/themes/.current-theme")

if [ -n "CURRENT_THEME" ]; then
	"$HOME/.config/themes/applyTheme.sh" "$CURRENT_THEME"
fi

#"$HOME/.config/waybar/scripts/launch.sh"
