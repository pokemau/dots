#!/bin/bash

# Get current power profile and show appropriate icon
get_power_icon() {
    current=$(powerprofilesctl get 2>/dev/null)
    case "$current" in
        "power-saver")
            echo "ps"
            ;;
        "balanced")
            echo "b"
            ;;
        "performance")
            echo "p"
            ;;
        *)
            echo "d"
            ;;
    esac
}

# If called with --icon-only, just return the icon
if [ "$1" = "--icon-only" ]; then
    get_power_icon
    exit 0
fi

# Otherwise, cycle through profiles
current=$(powerprofilesctl get 2>/dev/null)

case "$current" in
    "power-saver")
        powerprofilesctl set balanced
        new_profile="balanced"
        ;;
    "balanced")
        powerprofilesctl set performance
        new_profile="performance"
        ;;
    "performance")
        powerprofilesctl set power-saver
        new_profile="power-saver"
        ;;
    *)
        powerprofilesctl set balanced
        new_profile="balanced"
        ;;
esac

# Get the new icon
new_icon=$(get_power_icon)

# Send notification about the change
notify-send -u normal "Power Profile" "Switched to $new_profile $new_icon" || true
