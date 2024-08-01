#!/bin/bash


if hyprctl monitors | grep eDP-1; then
    hyprctl keyword monitor eDP-1, disable   
else
    hyprctl keyword monitor eDP-1,1366x768,0x0,1
    hyprctl keyword monitor  DP-1,1366x768,1366x0,1
fi
