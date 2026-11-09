#!/usr/bin/env fish

set CLASS rmpc

if hyprctl clients | grep -q "class: $CLASS"
    hyprctl dispatch focuswindow "class:^(rmpc)\$"
else
    kitty --class rmpc fish -c rmpc
end