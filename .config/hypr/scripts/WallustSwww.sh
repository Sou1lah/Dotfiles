#!/bin/bash
# /* ---- 💫 https://github.com/JaKooLit 💫 ---- */
# Wallust Colors for current wallpaper

# Get wallpaper path from argument or fallback to cache
wallpaper_path="$1"

# If no argument provided, try to read from cache (fallback)
if [ -z "$wallpaper_path" ]; then
    cache_dir="$HOME/.cache/swww/"
    current_monitor=$(hyprctl monitors -j | jq -r '.[] | select(.focused) | .name')
    cache_file="$cache_dir$current_monitor"
    
    if [ -f "$cache_file" ]; then
        wallpaper_path=$(grep -v 'Lanczos3' "$cache_file" | head -n 1)
    fi
fi

# Validate wallpaper path
if [ ! -f "$wallpaper_path" ]; then
    echo "Wallpaper path invalid: $wallpaper_path"
    exit 1
fi

echo "Using wallpaper: $wallpaper_path"

# Update symlink and copy wallpaper
ln -sf "$wallpaper_path" "$HOME/.config/rofi/.current_wallpaper"
cp -f "$wallpaper_path" "$HOME/.config/hypr/wallpaper_effects/.wallpaper_current"

echo "Updated current_wallpaper successfully"

# Execute wallust (uncomment to enable)
wallust run "$wallpaper_path" -s &
