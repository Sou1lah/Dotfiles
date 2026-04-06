#!/bin/bash
# /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  ##
# Battery Warning Script - Shows warning when battery is low

# Configuration
LOW_BATTERY_THRESHOLD=5
CRITICAL_BATTERY_THRESHOLD=3
WARNING_INTERVAL=300  # 5 minutes between warnings
CRITICAL_INTERVAL=60  # 1 minute between critical warnings

# Paths
iDIR="$HOME/.config/swaync/icons"
TEMP_DIR="/tmp"
LAST_WARNING_FILE="$TEMP_DIR/battery_last_warning"
LAST_CRITICAL_FILE="$TEMP_DIR/battery_last_critical"

# Sound script
SOUND_SCRIPT="$HOME/.config/hypr/scripts/Sounds.sh"

# Get battery information
get_battery_info() {
    battery_info=$(upower -i $(upower -e | grep 'BAT') 2>/dev/null)
    if [[ -z "$battery_info" ]]; then
        # Fallback to /sys/class/power_supply if upower fails
        if [[ -f /sys/class/power_supply/BAT0/capacity ]]; then
            battery_level=$(cat /sys/class/power_supply/BAT0/capacity)
            battery_status=$(cat /sys/class/power_supply/BAT0/status)
        else
            return 1
        fi
    else
        battery_level=$(echo "$battery_info" | grep -E "percentage" | awk '{print $2}' | sed 's/%//')
        battery_status=$(echo "$battery_info" | grep -E "state" | awk '{print $2}')
    fi
    
    # Ensure battery_level is a number
    if ! [[ "$battery_level" =~ ^[0-9]+$ ]]; then
        return 1
    fi
    
    return 0
}

# Check if enough time has passed since last warning
should_show_warning() {
    local warning_file="$1"
    local interval="$2"
    
    if [[ ! -f "$warning_file" ]]; then
        return 0  # Show warning if no previous warning file exists
    fi
    
    local last_warning=$(cat "$warning_file" 2>/dev/null || echo "0")
    local current_time=$(date +%s)
    local time_diff=$((current_time - last_warning))
    
    if [[ $time_diff -ge $interval ]]; then
        return 0  # Enough time has passed
    else
        return 1  # Too soon for another warning
    fi
}

# Record warning time
record_warning() {
    local warning_file="$1"
    date +%s > "$warning_file"
}

# Show critical battery warning
show_critical_warning() {
    local level="$1"
    local status="$2"
    
    if should_show_warning "$LAST_CRITICAL_FILE" "$CRITICAL_INTERVAL"; then
        # Play error sound if available
        if [[ -x "$SOUND_SCRIPT" ]]; then
            "$SOUND_SCRIPT" --error &
        fi
        
        # Show critical notification
        notify-send \
            -u critical \
            -t 0 \
            -i "${iDIR}/battery-low.png" \
            "🔋 CRITICAL BATTERY WARNING!" \
            "Battery level: ${level}%\nStatus: ${status}\n\nConnect charger immediately!\nSystem may shut down soon." \
            --hint="int:transient:0"
        
        record_warning "$LAST_CRITICAL_FILE"
        
        # Log the warning
        echo "$(date): CRITICAL battery warning - ${level}% (${status})" >> "$HOME/.config/hypr/logs/battery.log"
    fi
}

# Show low battery warning
show_low_warning() {
    local level="$1"
    local status="$2"
    
    if should_show_warning "$LAST_WARNING_FILE" "$WARNING_INTERVAL"; then
        # Play warning sound if available
        if [[ -x "$SOUND_SCRIPT" ]]; then
            "$SOUND_SCRIPT" --screenshot &
        fi
        
        # Show low battery notification
        notify-send \
            -u normal \
            -t 15000 \
            -i "${iDIR}/battery-low.png" \
            "🔋 Low Battery Warning" \
            "Battery level: ${level}%\nStatus: ${status}\n\nPlease connect your charger soon."
        
        record_warning "$LAST_WARNING_FILE"
        
        # Log the warning
        echo "$(date): Low battery warning - ${level}% (${status})" >> "$HOME/.config/hypr/logs/battery.log"
    fi
}

# Main monitoring function
monitor_battery() {
    if ! get_battery_info; then
        echo "Error: Could not get battery information"
        return 1
    fi
    
    # Skip warnings if battery is charging above critical level
    if [[ "$battery_status" == "charging" ]] && [[ $battery_level -gt $CRITICAL_BATTERY_THRESHOLD ]]; then
        # Clear warning files when charging starts
        [[ -f "$LAST_WARNING_FILE" ]] && rm "$LAST_WARNING_FILE"
        [[ -f "$LAST_CRITICAL_FILE" ]] && rm "$LAST_CRITICAL_FILE"
        return 0
    fi
    
    # Show warnings based on battery level and status
    if [[ $battery_level -le $CRITICAL_BATTERY_THRESHOLD ]]; then
        show_critical_warning "$battery_level" "$battery_status"
    elif [[ $battery_level -le $LOW_BATTERY_THRESHOLD ]]; then
        show_low_warning "$battery_level" "$battery_status"
    else
        # Clear warning files when battery is above threshold
        [[ -f "$LAST_WARNING_FILE" ]] && rm "$LAST_WARNING_FILE"
        [[ -f "$LAST_CRITICAL_FILE" ]] && rm "$LAST_CRITICAL_FILE"
    fi
}

# Create log directory if it doesn't exist
mkdir -p "$HOME/.config/hypr/logs"

# Run based on argument
case "$1" in
    "--daemon")
        # Run as daemon - continuous monitoring
        echo "Starting battery monitoring daemon..."
        while true; do
            monitor_battery
            sleep 30  # Check every 30 seconds
        done
        ;;
    "--check")
        # Single check
        monitor_battery
        ;;
    "--status")
        # Show current battery status
        if get_battery_info; then
            echo "Battery: ${battery_level}% (${battery_status})"
        else
            echo "Error: Could not get battery information"
            exit 1
        fi
        ;;
    *)
        echo "Battery Warning Script"
        echo "Usage: $0 [--daemon|--check|--status]"
        echo "  --daemon  Run continuous battery monitoring"
        echo "  --check   Perform single battery check"
        echo "  --status  Show current battery status"
        exit 1
        ;;
esac
