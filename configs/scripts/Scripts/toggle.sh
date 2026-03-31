#!/bin/bash

edp_disabled=$(hyprctl monitors -j | jq '.[] | select(.name == "eDP-1") | .disabled')

if [ "$edp_disabled" = "false" ]; then
    echo "eDP-1 active → switching to HDMI-A-1 only"
    hyprctl keyword monitor eDP-1,disable
    hyprctl keyword monitor HDMI-A-1,1920x1080@100,0x0,1
else
    echo "HDMI-A-1 only → switching to both side-by-side"
    hyprctl keyword monitor HDMI-A-1,disable
    hyprctl keyword monitor eDP-1,1920x1200@60,0x0,1
    hyprctl keyword monitor HDMI-A-1,1920x1080@100,1920x0,1
fi

# Restart hyprpaper so wallpapers are re-applied to the new monitor layout
sleep 0.5
killall hyprpaper; hyprpaper &
