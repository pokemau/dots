#!/bin/bash

yay

yay -S sddm hyprland kitty firefox neovim swaync qt5-wayland qt6-wayland  \
hyprpolkitagent nwg-look qt5ct qt6ct rofi-wayland waybar gs lazygit \
wlsunset alacritty flatpak npm hyprlock hypridle swappy swww brightnessctl \
grimblast-git cliphist pamixer pavucontrol network-manager-applet udiskie \
stow power-profiles-daemon blueman bluez bluez-utils ripgrep yarn slurp \
xdg-desktop-portal-hyprland github-cli ark tmux  unzip xdg-utils \
xdg-desktop-portal xdg-desktop-portal-gtk zsh pyenv postgresql ruby-erb \
rubygems pnpm cmake gvfs clipse wget fd  fastfetch adw-gtk-theme \
wl-clipboard adw-gtk3

# APPS
yay -S qbittorrent visual-studio-code-bin selectdefaultapplication-git \
dbeaver chromium obsidian syncthing baobab gnome-system-monitor anki-bin \
brave-bin gnome-calculator zed

# FONTS
yay -S ttf-jetbrains-mono-nerd ttf-roboto-mono-nerd ttf-space-mono-nerd \
inter-font ttf-hack-nerd ttf-meslo-nerd noto-fonts ttf-ms-win11-auto \
ttf-droid ttf-space-mono-nerd nerd-fonts-sf-mono noto-fonts-cjk \
noto-fonts-emoji ttf-firacode-nerd ttf-ibmplex-mono-nerd apple-fonts



# SET BRAVE AS DEFAULT
# xdg-mime default brave.desktop x-scheme-handler/http
# xdg-mime default brave.desktop x-scheme-handler/https

gem install tmuxinator

git clone https://github.com/vinceliuice/Tela-circle-icon-theme
cd Tela-circle-icon-theme/
./install.sh

flatpak -y install flathub com.spotify.Client
flatpak -y install flathub org.videolan.VLC

systemctl enable sddm.service
systemctl enable power-profiles-daemon.service
systemctl start power-profiles-daemon.service
systemctl enable bluetooth

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
