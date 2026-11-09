#!/bin/bash

BAR=$(cat ~/.config/themes/.current-bar 2>/dev/null || echo waybar)

killall -q waybar
qs kill

case "$BAR" in
  waybar)
    waybar &
    ;;

  qs)
    qs -p "$HOME/.config/quickshell" &
    ;;
esac
