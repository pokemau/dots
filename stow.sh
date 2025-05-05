#!/bin/bash

distro=$1

rm -rf ~/.zshrc

if [ "$distro" = "hypr-eos" ]; then
    stow alacritty kickstart tmux zsh zed waybar clang-format swappy \
        scripts
fi

# stow alacritty dunst kitty nvim rofi tmux xfce4 zsh zed waybar clang-format
