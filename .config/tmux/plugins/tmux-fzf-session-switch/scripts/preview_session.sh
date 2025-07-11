#!/usr/bin/env bash

session_name="${1}"

# Get the session ID using the session name
session_id=$(tmux list-sessions -F '#{session_id}:#{session_name}' | awk -F':' -v name="$session_name" '$2 == name {print $1}')

if [ -z "${session_id}" ]; then
  echo "Unknown session: ${session_name}"
  exit 1
fi

# Get the active pane of the session
active_pane=$(tmux list-panes -t "${session_name}" -F '#{pane_id} #{pane_active}' | awk '$2 == "1" {print $1}')

if [ -z "${active_pane}" ]; then
  echo "No active pane found for session ${session_name}"
  exit 1
fi

# Display the contents of the session's active pane
tmux capture-pane -ep -t "${active_pane}"
