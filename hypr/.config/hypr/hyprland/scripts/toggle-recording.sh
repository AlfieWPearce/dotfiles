#!/bin/bash

if pgrep -x wf-recorder >/dev/null; then
  pkill -INT wf-recorder
  notify-send -t 1000 "Recording Stopped"
else
  wf-recorder -f ~/Videos/recording-$(date +%F-%H:%M:%S).mp4 &
  notify-send -t 1000 "Recording Started"
fi
