#!/bin/bash

distro=$1

rm -rf ~/.zshrc

if [ "$distro" = "hypr-eos" ]; then
    stow alacritty kickstart tmux zsh zed waybar clang-format swappy \
        scripts
fi

# stow [folder] -t ~