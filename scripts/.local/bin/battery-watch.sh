#!/bin/bash

BAT_PATH=$(ls /sys/class/power_supply | grep BAT | head -n 1)

warned=0

while true; do
  bat_lvl=$(cat /sys/class/power_supply/$BAT_PATH/capacity)
  status=$(cat /sys/class/power_supply/$BAT_PATH/status)

  if [ "$status" = "Discharging" ] && [ "$bat_lvl" -le 15 ] && [ "$warned" -eq 0 ]; then
    notify-send -u critical "Battery Low ⚠️" "Level: ${bat_lvl}%"
    warned=1
  fi

  if [ "$bat_lvl" -gt 20 ]; then
    warned=0
  fi

  sleep 60
done
