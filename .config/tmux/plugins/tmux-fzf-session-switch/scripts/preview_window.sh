#!/usr/bin/env bash

window_spec="${1}"
IFS=':' read -r session_name window_index window_name <<< "$window_spec"

if [ -z "${session_name}" ] || [ -z "${window_index}" ]; then
  echo "Invalid window specification: '${window_spec}'"
  exit 1
fi

target="${session_name}:${window_index}"
active_pane=$(tmux list-panes -t "${target}" -F '#{pane_id} #{pane_active}' | awk '$2 == "1" {print $1}')

if [ -z "${active_pane}" ]; then
  echo "No active pane found for window ${target}"
  exit 1
fi

# Display the contents of the window's active pane
tmux capture-pane -ep -t "${active_pane}"
