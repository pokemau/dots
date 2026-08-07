#!/bin/sh
playerctl pause 2>/dev/null
hyprlock &
sleep 1
systemctl suspend
