#!/bin/bash

# Get the workspace of the focused window
ws=$(hyprctl activewindow -j | jq -r '.workspace.id')
# Get the window ID
wid=$(hyprctl activewindow -j | jq -r '.address')

# If already in special workspace, move to last workspace
if [[ "$ws" == "special:magic" ]]; then
    hyprctl dispatch movetoworkspace last "$wid"
    hyprctl dispatch togglespecialworkspace magic
else
    hyprctl dispatch movetoworkspace special:magic "$wid"
    hyprctl dispatch togglespecialworkspace magic
fi