#!/usr/bin/env bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

function main {
    local sessions
    local session
    local query
    local sess_arr
    local retval

    local fzf_command=(fzf --exit-0 --print-query --reverse)

    if [ "${PREVIEW_ENABLED}" = "1" ]; then
        fzf_command+=(--preview "$CURRENT_DIR/preview_session.sh {}" --preview-window=right:60%)
    fi

    sessions=$(tmux list-sessions -F "#{session_name}" | "${fzf_command[@]}")
    retval=$?

    IFS=$'\n' read -rd '' -a sess_arr <<<"$sessions"

    session=${sess_arr[1]}
    query=${sess_arr[0]}

    if [ $retval -eq 0 ]; then
        if [ -z "$session" ]; then
            session="$query"
        fi
        tmux switch-client -t "$session"
    elif [ $retval -eq 1 ]; then
        tmux command-prompt -b -p "Press enter to create and go to [$query] session" \
            "run '$CURRENT_DIR/make_new_session.sh \"$query\" \"%1\"'"
    fi
}

main
