#!/usr/bin/env bash

TMUX_CONF="$HOME/.tmux.conf"

# List of available themes and their plugin lines
declare -A THEMES
THEMES["tokyo-night"]="set -g @plugin 'janoamaral/tokyo-night-tmux'"
THEMES["gruvbox"]="set -g @plugin 'egel/tmux-gruvbox'"
THEMES["dracula"]="set -g @plugin 'dracula/tmux-cappuccino'"
THEMES["nord"]="set -g @plugin 'arcticicestudio/nord-tmux'"

function select_theme() {
  echo "Available tmux themes:"
  select theme in "${!THEMES[@]}"; do
    if [[ -n "$theme" ]]; then
      # Remove all theme plugin lines
      sed -i "/@plugin 'janoamaral\/tokyo-night-tmux'/d" "$TMUX_CONF"
      sed -i "/@plugin 'egel\/tmux-gruvbox'/d" "$TMUX_CONF"
      sed -i "/@plugin 'dracula\/tmux-cappuccino'/d" "$TMUX_CONF"
      sed -i "/@plugin 'arcticicestudio\/nord-tmux'/d" "$TMUX_CONF"
      # Add the selected theme plugin after TPM core
      awk -v pline="${THEMES[$theme]}" '
        BEGIN {added=0}
        {print}
        /tmux-plugins\/tpm/ && !added {print pline; added=1}
      ' "$TMUX_CONF" > "$TMUX_CONF.tmp" && mv "$TMUX_CONF.tmp" "$TMUX_CONF"
      echo "Theme set to $theme. Reload tmux with: tmux source-file $TMUX_CONF"
      break
    fi
  done
}

function set_prefix() {
  read -p "Enter new tmux prefix (e.g. C-s): " newprefix
  sed -i "s/^set -g prefix .*/set -g prefix $newprefix/" "$TMUX_CONF"
  echo "Prefix set to $newprefix. Reload tmux with: tmux source-file $TMUX_CONF"
}

function dashboard_menu() {
  while true; do
    echo "==== TMUX DASHBOARD ===="
    echo "1) Change theme"
    echo "2) Change prefix key"
    echo "3) Reload tmux config"
    echo "4) Exit"
    read -p "Choose an option: " opt
    case $opt in
      1) select_theme ;;
      2) set_prefix ;;
      3) tmux source-file "$TMUX_CONF"; echo "Config reloaded!" ;;
      4) break ;;
      *) echo "Invalid option" ;;
    esac
    echo
  done
}

dashboard_menu