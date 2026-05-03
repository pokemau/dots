#!/bin/bash

OUTPUTS=$(niri msg --json outputs)

edp_enabled=$(echo "$OUTPUTS" | jq -r '."eDP-1".logical != null')

if [ "$edp_enabled" = "true" ]; then
    echo "eDP-1 active → switching to HDMI-A-1 only"
    niri msg output HDMI-A-1 on
    niri msg output eDP-1 off
else
    echo "HDMI-A-1 only → switching to both side-by-side"
    niri msg output eDP-1 on
    niri msg output HDMI-A-1 on
fi
