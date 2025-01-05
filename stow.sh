#!/bin/bash

distro=$1

rm -rf ~/.zshrc

stow alacritty dunst kitty temp_nvim rofi tmux xfce4 zsh zed waybar clang-format

if [ "$distro" = "hyprland" ]; then
    echo "ARCH"
    rm -rf ~/.config/hypr
    stow hypr swappy scripts
elif [ "$distro" = "fedorasway" ]; then
    stow rofi_fedora_sway sway_fedora waybar_fedora_sway
else
    echo "OPTIONS: [ hyprland, sway ]"
fi

