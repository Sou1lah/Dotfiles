#!/usr/bin/env bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

default_key_bindings_goto="C-f"
default_width=55
default_height=10
default_width_preview=80
default_height_preview=20
default_without_prefix=false
default_search_session_only=false
default_preview_enabled=false

tmux_option_goto="@fzf-goto-session"
tmux_option_goto_without_prefix="@fzf-goto-session-without-prefix"
tmux_option_width="@fzf-goto-win-width"
tmux_option_height="@fzf-goto-win-height"
tmux_option_width_preview="@fzf-goto-win-width-preview"
tmux_option_height_preview="@fzf-goto-win-height-preview"
tmux_option_search_session_only="@fzf-goto-session-only"
tmux_option_preview_enabled="@fzf-goto-preview-enabled"

get_tmux_option() {
    local option=$1
    local default_value=$2
    local option_value=$(tmux show-option -gqv "$option")
    if [ -z "$option_value" ]; then
        echo "$default_value"
    else
        echo "$option_value"
    fi
}

function set_goto_session_bindings {
    local key_bindings=$(get_tmux_option "$tmux_option_goto" "$default_key_bindings_goto")
    local without_prefix=$(get_tmux_option "$tmux_option_goto_without_prefix" "$default_without_prefix")
    local search_session_only=$(get_tmux_option "$tmux_option_search_session_only" "$default_search_session_only")
    local preview_enabled=$(get_tmux_option "$tmux_option_preview_enabled" "$default_preview_enabled")

    # Determine width and height based on whether preview is enabled
    local width
    local height

    if [ "$preview_enabled" = true ]; then
        width=$(get_tmux_option "$tmux_option_width_preview" "$default_width_preview")
        height=$(get_tmux_option "$tmux_option_height_preview" "$default_height_preview")
    else
        width=$(get_tmux_option "$tmux_option_width" "$default_width")
        height=$(get_tmux_option "$tmux_option_height" "$default_height")
    fi

    # Pass the preview_enabled option to the scripts as an environment variable
    local preview_option=""
    if [ "$preview_enabled" = true ]; then
        preview_option="PREVIEW_ENABLED=1"
    else
        preview_option="PREVIEW_ENABLED=0"
    fi

    if [ "$search_session_only" = false ]; then
        if [ "$without_prefix" = true ]; then
            local key
            for key in $key_bindings; do
                tmux bind -n "$key" display-popup -w "$width" -h "$height" -y 15 -E "$preview_option $CURRENT_DIR/scripts/switch_session_window.sh"
            done
        else
            local key
            for key in $key_bindings; do
                tmux bind "$key" display-popup -w "$width" -h "$height" -y 15 -E "$preview_option $CURRENT_DIR/scripts/switch_session_window.sh"
            done
        fi
    else
        if [ "$without_prefix" = true ]; then
            local key
            for key in $key_bindings; do
                tmux bind -n "$key" display-popup -w "$width" -h "$height" -y 15 -E "$preview_option $CURRENT_DIR/scripts/switch_session.sh"
            done
        else
            local key
            for key in $key_bindings; do
                tmux bind "$key" display-popup -w "$width" -h "$height" -y 15 -E "$preview_option $CURRENT_DIR/scripts/switch_session.sh"
            done
        fi
    fi
}

function main {
    set_goto_session_bindings
}
main
