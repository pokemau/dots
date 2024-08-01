#!/bin/bash


# install yay
mkdir -p ~/Apps/git
cd ~/Apps/git
git clone https://aur.archlinux.org/yay.git
cd yay && makepkg -si

cd ~/dots/distro/arch
	
yay -S dunst rofi-wayland neovim swappy swww waybar \
brightnessctl grimblast-git cliphist pamixer pavucontrol \
network-manager-applet blueman udiskie ttf-jetbrains-mono-nerd \
ttf-hack-nerd ttf-meslo-nerd yarn npm qt5-quickcontrols qt5-quickcontrols2 \
qt5-graphiacaleffects slurp xdg-desktop-portal-hyprland nwg-look qt5ct \
qt6ct kvantum kvantum-qt5 qt5-wayland qt6-wayland thunar \
thunar-archive-plugin ark discord pipewire pipewire-alsa pipewire-audio \
pipewire-jack pipewire-pulse gst-plugin-pipewire wireplumber pavucontrol \
tmux zsh vlc qbittorrent unzip flatpak wlsunset rust xdg-desktop-portal \
hyprpicker-git noto-fonts bear ripgrep baobab gnome-calculator stow

stow Scripts

git clone https://github.com/vinceliuice/Tela-circle-icon-theme
./Tela-circle-icon-theme/install.sh

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
