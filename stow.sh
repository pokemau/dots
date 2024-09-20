#!/bin/bash

distro=$1

rm -rf ~/.zshrc

stow alacritty dunst kitty nvim rofi tmux xfce4 zsh zed waybar clang-format

if [ "$distro" = "hyprland" ]; then
    echo "ARCH"
    rm -rf ~/.config/hypr
    stow hypr swappy scripts
elif [ "$distro" = "sway" ]; then
    echo "SWAY"
else
    echo "OPTIONS: [ hyprland, sway ]"
fi

