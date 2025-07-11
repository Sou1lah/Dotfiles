#!/usr/bin/env bash

WINDOW_NAME="${1}"
SESSION_NAME="${2:-${WINDOW_NAME}}"

function create_session_if_needed() {
    if ! tmux has-session -t "${SESSION_NAME}" 2>/dev/null; then
        tmux new-session -d -s "${SESSION_NAME}"
    fi
}

function create_window() {
    window_id=$(tmux new-window -t "${SESSION_NAME}" -d -n "${WINDOW_NAME}" -P -F "#{window_id}")
    
    tmux switch-client -t "${window_id}"
}

function main() {
    create_session_if_needed
    create_window
}

main
