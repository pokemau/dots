#!/bin/bash


monitors=$(hyprctl monitors)

# laptop only
# external monitor only
# both monitors

if echo "$monitors" | grep -wq eDP-1; then

    if echo "$monitors" | grep -wq HDMI-A-1; then
        echo "BOTH MONITORS"
        hyprctl keyword monitor HDMI-A-1, 1920x1080@100, 0x0, 1
        hyprctl keyword monitor eDP-1, disable
    else

        hyprctl keyword monitor eDP-1, 1366x768, 0x0, 1

        # if hyprctl monitors all | grep -wq HDMI-A-1; then
        #     echo "LAPTOP WITH 2ND MONITOR"
        #     hyprctl keyword monitor  HDMI-A-1,1366x768,0x0,1
        #     hyprctl keyword monitor eDP-1,disable
        # fi

    fi

# else
#     echo "EXTERNAL MONITOR ONLY"
#     hyprctl keyword monitor eDP-1,1366x768,0x0,1
#     hyprctl keyword monitor HDMI-A-1,1366x768,1366x0,1
# fi

#if hyprctl monitors | grep eDP-1; then
#    hyprctl keyword monitor eDP-1, disable   
#else
#    hyprctl keyword monitor eDP-1,1366x768,0x0,1
#    hyprctl keyword monitor  HDMI-A-1,1366x768,1366x0,1
#fi

