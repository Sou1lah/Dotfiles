#!/bin/bash

# Update wallpapers on both monitors simultaneously
# Usage: ./update_wallpapers.sh [wallpaper_path]
# If no path provided, it will use a random wallpaper from your wallpapers directory

WALLPAPER_DIR="/home/wael/Pictures/wallpapers"

if [ $# -eq 0 ]; then
    # No argument provided, pick a random wallpaper
    WALLPAPER=$(find "$WALLPAPER_DIR" -type f \( -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" -o -name "*.gif" -o -name "*.webp" \) | shuf -n 1)
    echo "Using random wallpaper: $WALLPAPER"
else
    # Use provided wallpaper path
    WALLPAPER="$1"
fi

# Check if wallpaper file exists
if [ ! -f "$WALLPAPER" ]; then
    echo "Error: Wallpaper file not found: $WALLPAPER"
    exit 1
fi

# Set the same wallpaper on all monitors
echo "Setting wallpaper on all monitors: $WALLPAPER"
swww img "$WALLPAPER"

# Alternative: Set different wallpapers per monitor (uncomment if needed)
# swww img --outputs eDP-1 "$WALLPAPER"
# swww img --outputs HDMI-A-1 "$WALLPAPER"
