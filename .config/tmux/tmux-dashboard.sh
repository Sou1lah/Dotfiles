#!/usr/bin/env bash

TMUX_CONF="$HOME/.tmux.conf"

main_menu() {
  while true; do
    printf '\033[2J\033[H'
    echo "╔════════════════════════════════════════════╗"
    echo "║           🧩  TMUX DASHBOARD              ║"
    echo "╠════════════════════════════════════════════╣"
    echo "║ 1. Theme Selector                         ║"
    echo "║ 2. Split Horizontal                       ║"
    echo "║ 3. Split Vertical                         ║"
    echo "║ 4. New Window                             ║"
    echo "║ 5. Next Window                            ║"
    echo "║ 6. Previous Window                        ║"
    echo "║ 7. Quit tmux                              ║"
    echo "║ 8. Exit Dashboard                         ║"
    echo "╚════════════════════════════════════════════╝"
    read -p "Select an option [1-8]: " opt
    case $opt in
      1) theme_selector ;;
      2) tmux split-window -h; break ;;
      3) tmux split-window -v; break ;;
      4) tmux new-window; break ;;
      5) tmux next-window; break ;;
      6) tmux previous-window; break ;;
      7) tmux kill-server; exit ;;
      8) break ;;
      *) echo "Invalid option"; sleep 1 ;;
    esac
  done
}

theme_selector() {
  THEMES=(
    "Minimal"
    "Gruvbox"
    "Nord"
    "Nova-Gruvbox"
    "Nova-Rosepine"
    "Nova-Default"
    "Gold"
    "Snow"
    "Forest"
    "Violet"
    "Redwine"
    "Tokyo-Night"
    "Tokyo-Night-2"
  )
  THEME_MARKERS=(
    "## Minimal theme"
    "## Gruvbox"
    "##  Nord"
    "## NOVA gruvbox theme"
    "## NOVA rosepine"
    "## nova default"
    "### Gold Theme"
    "## Snow Theme"
    "## Forest Theme"
    "## Violet Theme"
    "## Redwine Theme"
    "## Tokyo Night Theme"
    "## Tokto NIght 2"
  )

  echo "Available Themes:"
  for i in "${!THEMES[@]}"; do
    printf "  %2d. %s\n" $((i+1)) "${THEMES[$i]}"
  done
  read -p "Select a theme [1-${#THEMES[@]}]: " theme_idx
  theme_idx=$((theme_idx-1))
  if [[ $theme_idx -lt 0 || $theme_idx -ge ${#THEMES[@]} ]]; then
    echo "Invalid theme selection."
    sleep 1
    return
  fi

  # Find all theme block start lines
  mapfile -t block_starts < <(for marker in "${THEME_MARKERS[@]}"; do grep -n -F "$marker" "$TMUX_CONF" | cut -d: -f1; done)
  block_starts+=("$(wc -l < "$TMUX_CONF")") # Add EOF as last block end

  # Comment all set/variable lines in all theme blocks
  for ((i=0; i<${#block_starts[@]}-1; i++)); do
    start=$((block_starts[i]+1))
    end=$((block_starts[i+1]-1))
    sed -i "${start},${end} s/^\(\s*\)\(set \|b_bg\|seg_a\|seg_b\|inactive_bg\|inactive_fg\|active_bg\|active_fg\)/#\1\2/" "$TMUX_CONF"
  done

  # Uncomment set/variable lines in the selected theme block
  sel_start=${block_starts[$theme_idx]}
  sel_end=$((block_starts[theme_idx+1]-1))
  sed -i "${sel_start},${sel_end} s/^#\(\s*\)\(set \|b_bg\|seg_a\|seg_b\|inactive_bg\|inactive_fg\|active_bg\|active_fg\)/\1\2/" "$TMUX_CONF"

  tmux source-file "$TMUX_CONF"
  tmux display-message "Theme '${THEMES[$theme_idx]}' applied and tmux reloaded."
  sleep 1
}
main_menu