#!/bin/bash
# filepath: ~/.config/hypr/scripts/toggle_move_workspace6.sh

STATE_FILE="/tmp/hypr_toggle_workspace6"
WIN_ID=$(hyprctl activewindow -j | jq -r '.address')
CUR_WS=$(hyprctl activewindow -j | jq -r '.workspace.id')

# If the state file exists, try to restore the window
if [[ -f "$STATE_FILE" ]]; then
    read SAVED_WIN SAVED_WS < "$STATE_FILE"
    if [[ "$SAVED_WIN" == "$WIN_ID" ]]; then
        hyprctl dispatch movetoworkspace "$SAVED_WS,address:$SAVED_WIN"
        rm "$STATE_FILE"
        exit 0
    fi
fi

# Otherwise, move the window to workspace 6 and save its state
echo "$WIN_ID $CUR_WS" > "$STATE_FILE"
hyprctl dispatch movetoworkspace 6,address:$WIN_ID