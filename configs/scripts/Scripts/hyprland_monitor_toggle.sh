#!/usr/bin/env bash

MONITOR_FILE="$HOME/.config/hypr/monitors.txt"
LAPTOP="eDP-1"
EXTERNAL="HDMI-A-1"

# Check if the laptop monitor is currently active
if hyprctl monitors | grep -q "Monitor $LAPTOP"; then
    echo "1" > $MONITOR_FILE
    # Disable the laptop screen
    hyprctl eval "hl.monitor({ output = '$LAPTOP', disabled = true })"
    notify-send "Hyprland" "Switched to HDMI Only"
else
    echo "0" > $MONITOR_FILE
    # Re-enable the laptop screen explicitly with 'disabled = false'
    hyprctl eval "hl.monitor({ output = '$LAPTOP', mode = 'preferred', position = '0x0', scale = 1, disabled = false })"
    hyprctl eval "hl.monitor({ output = '$EXTERNAL', mode = 'preferred', position = 'auto', scale = 1 })"
    notify-send "Hyprland" "Switched to Dual Monitors"
fi
