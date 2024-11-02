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
qt6ct kvantum kvantum-qt5 qt5-wayland qt6-wayland thunar github-cli \
thunar-archive-plugin ark discord pipewire pipewire-alsa pipewire-audio \
pipewire-jack pipewire-pulse gst-plugin-pipewire wireplumber pavucontrol \
tmux zsh vlc qbittorrent unzip flatpak wlsunset rust xdg-desktop-portal \
hyprpicker noto-fonts bear ripgrep baobab gnome-calculator stow \
glfw ttf-ms-win11-auto xdg-desktop-portal-gtk ttf-cascadia-code-nerd \
ttf-cascadia-code ttf-roboto-mono-nerd nerd-fonts-sf-mono nwg-displays \
visual-studio-code-bin gvfs noto-fonts-cjk noto-fonts-emoji gvfs \
downgrade gnome-themes-extra clipse ttf-firacode-nerd spotify-adblock

# uncomment multilib in pacman.conf

# KDE Plasma
# plasma-desktop plasma-nm plasma-pa
#
# Gnome
# yay -S gnome gnome-browser-connector \
# nautilus-open-any-terminal gnome-tweaks \

flatpak install flathub com.github.IsmaelMartinez.teams_for_linux && \
flatpak install flathub com.spotify.Client

git clone https://github.com/vinceliuice/Tela-circle-icon-theme
./Tela-circle-icon-theme/install.sh

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
