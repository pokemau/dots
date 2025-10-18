#!/bin/bash


monitors=$(hyprctl monitors)

# laptop only
# external monitor only
# both monitors

if echo "$monitors" | grep -wq eDP-1; then

    if echo "$monitors" | grep -wq HDMI-A-1; then
        echo "BOTH MONITORS"
        hyprctl keyword monitor eDP-1,disable
        hyprctl keyword monitor HDMI-A-1,1920x1080@100,0x0,1
        # niri msg output eDP-1 off
        # niri msg output HDMI-A-1 on
    else

        if hyprctl monitors all | grep -wq HDMI-A-1; then
            echo "LAPTOP WITH 2ND MONITOR"
            hyprctl keyword monitor HDMI-A-1,1920x1080@100,0x0,1
            hyprctl keyword monitor eDP-1,disable
            # niri msg output HDMI-A-1 on
            # niri msg output eDP-1 off
        fi

    fi

else
    echo "EXTERNAL MONITOR ONLY"
    hyprctl keyword monitor eDP-1,1366x768,0x0,1
    hyprctl keyword monitor HDMI-A-1,1920x1080@100,1366x0,1
    # niri msg output eDP-1 on
    # niri msg output HDMI-A-1 on
fi

# !/bin/bash
# monitors=$(hyprctl monitors)
# if echo "$monitors" | grep -wq eDP-1 && echo "$monitors" | grep -wq HDMI-A-1; then
#     echo "BOTH MONITORS CONNECTED"
#     # Disable laptop screen, use external monitor only
#     hyprctl keyword monitor eDP-1,disable
#     hyprctl keyword monitor HDMI-A-1,1920x1080@100,0x0,1
#
# elif echo "$monitors" | grep -wq eDP-1; then
#     echo "LAPTOP ONLY"
#     # Enable laptop screen only
#     hyprctl keyword monitor eDP-1,1366x768,0x0,1
#     hyprctl keyword monitor HDMI-A-1,disable
#
# elif echo "$monitors" | grep -wq HDMI-A-1; then
#     echo "EXTERNAL MONITOR ONLY"
#     # Enable external monitor only at position 0,0
#     hyprctl keyword monitor eDP-1,disable
#     hyprctl keyword monitor HDMI-A-1,1920x1080@100,0x0,1
#
# else
#     echo "NO MONITORS DETECTED - FALLBACK"
#     # Fallback configuration
#     hyprctl keyword monitor eDP-1,1366x768,0x0,1
# fi
