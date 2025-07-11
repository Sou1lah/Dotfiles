#!/usr/bin/env bash

set -euo pipefail

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Place holder for status left/right
place_holder="\#{keyboard_layout}"

option_scope_config='@keyboard_layout:option_scope'
length_config='@keyboard_layout:length'
get_keyboard_layout="$CURRENT_DIR/scripts/get_keyboard_layout.sh"

interpolate() {
    local -r option=$1
    local -r replacement=$2
    local -r option_scope=${3#-}
    local -r option_value=$(tmux show-option -Aqv "$option")
    tmux set-option -"$option_scope"q "$option" "${option_value/$place_holder/$replacement}"
}

main() {
    local -r option_scope=$(tmux show-option -gqv "${option_scope_config}")
    local -r length=$(tmux show-option -gqv "${length_config}")
    # https://unix.stackexchange.com/a/3455
    local -r keyboard_layout="#($get_keyboard_layout | cut -c1-${length:-16})"
    interpolate "status-left" "$keyboard_layout" "${option_scope:-g}"
    interpolate "status-right" "$keyboard_layout" "${option_scope:-g}"
}

main
