#!/bin/bash

distro=$1

rm -rf ~/.zshrc ~/.tmux.conf ~/.clang-format

if [ "$distro" = "gnome" ]; then
    cd configs && stow alacritty clang-format ghostty kitty nvim scripts \
        tmux xfce4 zed zsh -t ~
fi

# stow [folder] -t ~
