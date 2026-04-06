#!/bin/bash
# /* ---- 💫 https://github.com/JaKooLit 💫 ---- */
# This script for selecting wallpapers (SUPER W)

# WALLPAPERS PATH
terminal=kitty
wallDIR="$HOME/Pictures/wallpapers"
SCRIPTSDIR="$HOME/.config/hypr/scripts"
wallpaper_current="$HOME/.config/hypr/wallpaper_effects/.wallpaper_current"

# Directory for swaync
iDIR="$HOME/.config/swaync/images"
iDIRi="$HOME/.config/swaync/icons"

# swww transition config
FPS=60
TYPE="any"
DURATION=2
BEZIER=".43,1.19,1,.4"
SWWW_PARAMS="--transition-fps $FPS --transition-type $TYPE --transition-duration $DURATION --transition-bezier $BEZIER"

# Check if package bc exists
if ! command -v bc &>/dev/null; then
  notify-send -i "$iDIR/error.png" "bc missing" "Install package bc first"
  exit 1
fi

# Variables
rofi_theme="$HOME/.config/rofi/config-wallpaper.rasi"
focused_monitor=$(hyprctl monitors -j | jq -r '.[] | select(.focused) | .name')

# Ensure focused_monitor is detected
if [[ -z "$focused_monitor" ]]; then
  notify-send -i "$iDIR/error.png" "E-R-R-O-R" "Could not detect focused monitor"
  exit 1
fi

# Monitor details
scale_factor=$(hyprctl monitors -j | jq -r --arg mon "$focused_monitor" '.[] | select(.name == $mon) | .scale')
monitor_height=$(hyprctl monitors -j | jq -r --arg mon "$focused_monitor" '.[] | select(.name == $mon) | .height')

icon_size=$(echo "scale=1; ($monitor_height * 3) / ($scale_factor * 150)" | bc)
adjusted_icon_size=$(echo "$icon_size" | awk '{if ($1 < 15) $1 = 20; if ($1 > 25) $1 = 25; print $1}')
rofi_override="element-icon{size:${adjusted_icon_size}%;}"

# Kill existing wallpaper daemons for video
kill_wallpaper_for_video() {
  swww kill 2>/dev/null
  pkill mpvpaper 2>/dev/null
  pkill swaybg 2>/dev/null
  pkill hyprpaper 2>/dev/null
}

# Kill existing wallpaper daemons for image
kill_wallpaper_for_image() {
  pkill mpvpaper 2>/dev/null
  pkill swaybg 2>/dev/null
  pkill hyprpaper 2>/dev/null
}

# Retrieve wallpapers (both images & videos)
mapfile -d '' PICS < <(find -L "${wallDIR}" -type f \( \
  -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" -o \
  -iname "*.bmp" -o -iname "*.tiff" -o -iname "*.webp" -o \
  -iname "*.mp4" -o -iname "*.mkv" -o -iname "*.mov" -o -iname "*.webm" \) -print0)

RANDOM_PIC="${PICS[$((RANDOM % ${#PICS[@]}))]}"
RANDOM_PIC_NAME=". random"

# Rofi command
rofi_command="rofi -i -show -dmenu -config $rofi_theme -theme-str $rofi_override"

# Sorting Wallpapers
menu() {
  IFS=$'\n' sorted_options=($(sort <<<"${PICS[*]}"))

  printf "%s\x00icon\x1f%s\n" "$RANDOM_PIC_NAME" "$RANDOM_PIC"

  for pic_path in "${sorted_options[@]}"; do
    pic_name=$(basename "$pic_path")
    if [[ "$pic_name" =~ \.gif$ ]]; then
      cache_gif_image="$HOME/.cache/gif_preview/${pic_name}.png"
      if [[ ! -f "$cache_gif_image" ]]; then
        mkdir -p "$HOME/.cache/gif_preview"
        magick "$pic_path[0]" -resize 1920x1080 "$cache_gif_image"
      fi
      printf "%s\x00icon\x1f%s\n" "$pic_name" "$cache_gif_image"
    elif [[ "$pic_name" =~ \.(mp4|mkv|mov|webm|MP4|MKV|MOV|WEBM)$ ]]; then
      cache_preview_image="$HOME/.cache/video_preview/${pic_name}.png"
      if [[ ! -f "$cache_preview_image" ]]; then
        mkdir -p "$HOME/.cache/video_preview"
        ffmpeg -v error -y -i "$pic_path" -ss 00:00:01.000 -vframes 1 "$cache_preview_image"
      fi
      printf "%s\x00icon\x1f%s\n" "$pic_name" "$cache_preview_image"
    else
      printf "%s\x00icon\x1f%s\n" "$(echo "$pic_name" | cut -d. -f1)" "$pic_path"
    fi
  done
}

# Offer SDDM Simple Wallpaper Option (only for non-video wallpapers)
set_sddm_wallpaper() {
  sleep 1
  sddm_simple="/usr/share/sddm/themes/simple_sddm_2"

  if [ -d "$sddm_simple" ]; then

    # Check if yad is running to avoid multiple notifications
    if pidof yad >/dev/null; then
      killall yad
    fi

    if yad --info --text="Set current wallpaper as SDDM background?\n\nNOTE: This only applies to SIMPLE SDDM v2 Theme" \
      --text-align=left \
      --title="SDDM Background" \
      --timeout=5 \
      --timeout-indicator=right \
      --button="yes:0" \
      --button="no:1"; then

      # Check if terminal exists
      if ! command -v "$terminal" &>/dev/null; then
        notify-send -i "$iDIR/error.png" "Missing $terminal" "Install $terminal to enable setting of wallpaper background"
        exit 1
      fi

      # Open terminal to enter password
      $terminal -e bash -c "echo 'Enter your password to set wallpaper as SDDM Background'; \
            sudo cp -r $wallpaper_current '$sddm_simple/Backgrounds/default' && \
            notify-send -i '$iDIR/ja.png' 'SDDM' 'Background SET'"
    fi
  fi
}

modify_startup_config() {
  local selected_file="$1"
  local startup_config="$HOME/.config/hypr/UserConfigs/Startup_Apps.conf"

  # Check if it's a live wallpaper (video)
  if [[ "$selected_file" =~ \.(mp4|mkv|mov|webm)$ ]]; then
    # For video wallpapers: keep mpvpaper startup, just update variable
    sed -i '/^\s*exec-once\s*=\s*swww-daemon\s*--format\s*xrgb\s*$/s/^/\#/' "$startup_config"

    # Update the livewallpaper variable with the selected video path (using $HOME)
    selected_file="${selected_file/#$HOME/\$HOME}" # Replace /home/user with $HOME
    sed -i "s|^\$livewallpaper=.*|\$livewallpaper=\"$selected_file\"|" "$startup_config"

    echo "Configured for live wallpaper (video)."
  else
    # For image wallpapers: only touch swww, do not disable mpvpaper startup
    sed -i '/^\s*#\s*exec-once\s*=\s*swww-daemon\s*--format\s*xrgb\s*$/s/^\s*#\s*//;' "$startup_config"

    echo "Configured for static wallpaper (image)."
  fi
}

# Apply Image Wallpaper
apply_image_wallpaper() {
  local image_path="$1"

  kill_wallpaper_for_image

  if ! pgrep -x "swww-daemon" >/dev/null; then
    echo "Starting swww-daemon..."
    swww-daemon --format xrgb &
  fi

  # Apply wallpaper to all monitors, not just the focused one
  while IFS= read -r mon; do
    [ -n "$mon" ] || continue
    swww img -o "$mon" "$image_path" $SWWW_PARAMS
  done < <(hyprctl monitors -j | jq -r '.[].name')

  # Run additional scripts - pass the wallpaper path as argument
  "$SCRIPTSDIR/WallustSwww.sh" "$image_path"
  sleep 2
  "$SCRIPTSDIR/RefreshNoWaybar.sh"
  sleep 1

  set_sddm_wallpaper
}

apply_video_wallpaper() {
  local video_path="$1"

  # Check if mpvpaper is installed
  if ! command -v mpvpaper &>/dev/null; then
    notify-send -i "$iDIR/error.png" "E-R-R-O-R" "mpvpaper not found"
    return 1
  fi
  kill_wallpaper_for_video

  # Apply video wallpaper using mpvpaper
  mpvpaper '*' -o "load-scripts=no no-audio --loop" "$video_path" &
}

# Main function
main() {
    choice=$(menu | $rofi_command)
    choice=$(echo "$choice" | xargs)
    RANDOM_PIC_NAME=$(echo "$RANDOM_PIC_NAME" | xargs)

    echo "DEBUG: Selected choice: '$choice'" > /tmp/wallpaper_debug.log
    echo "DEBUG: RANDOM_PIC_NAME: '$RANDOM_PIC_NAME'" >> /tmp/wallpaper_debug.log

    if [[ -z "$choice" ]]; then
        echo "No choice selected. Exiting."
        exit 0
    fi

    if [[ "$choice" == "$RANDOM_PIC_NAME" ]]; then
        choice=$(basename "$RANDOM_PIC")
        echo "DEBUG: Random selected, using: '$choice'" >> /tmp/wallpaper_debug.log
    fi

    choice_basename=$(basename "$choice" | sed 's/\(.*\)\.[^.]*$/\1/')
    echo "DEBUG: Searching for: '$choice_basename'" >> /tmp/wallpaper_debug.log

    selected_file=$(find "$wallDIR" -iname "$choice_basename.*" -print -quit)
    echo "DEBUG: Found file: '$selected_file'" >> /tmp/wallpaper_debug.log

    if [[ -z "$selected_file" ]]; then
        echo "DEBUG: File not found!" >> /tmp/wallpaper_debug.log
        notify-send "Error" "Wallpaper file not found: $choice"
        exit 1
    fi

    # Update current wallpaper file immediately
    echo "$selected_file" > "$wallpaper_current"
    echo "DEBUG: Updated $wallpaper_current with: $selected_file" >> /tmp/wallpaper_debug.log

    modify_startup_config "$selected_file"

    if [[ "$selected_file" =~ \.(mp4|mkv|mov|webm|MP4|MKV|MOV|WEBM)$ ]]; then
        echo "DEBUG: Applying video wallpaper" >> /tmp/wallpaper_debug.log
        apply_video_wallpaper "$selected_file"
    else
        echo "DEBUG: Applying image wallpaper" >> /tmp/wallpaper_debug.log
        apply_image_wallpaper "$selected_file"
    fi
    
    echo "DEBUG: Script completed" >> /tmp/wallpaper_debug.log
}

# Check if rofi is already running
if pidof rofi >/dev/null; then
  pkill rofi
fi

main
