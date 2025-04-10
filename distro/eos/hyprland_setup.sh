#!/bin/bash

yay -S hyprland hyprlock hypridle kitty dunst rofi-wayland neovim swappy \
	swww waybar brightnessctl grimblast-git cliphist pamixer pavucontrol \
	network-manager-applet blueman udiskie qt5-quickcontrols \
	qt5-quickcontrols2 qt5-graphicaleffects slurp \
	xdg-desktop-portal-hyprland nwg-look qt5ct qt6ct kvantum kvantum-qt5 \
	qt5-wayland qt6-wayland thunar thunar-archive-plugin ark pavucontrol \
	wlsunset rust xdg-desktop-portal hyprpicker  clipse

cd ../../
stow dunst hypr swappy kitty rofi scripts waybar xfce4
