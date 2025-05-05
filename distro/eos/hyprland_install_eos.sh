#!/bin/bash

yay

yay -S sddm hyprland kitty firefox neovim swaync qt5-wayland qt6-wayland  \
hyprpolkitagent nwg-look qt5ct qt6ct rofi-wayland waybar gs lazygit \
wlsunset alacritty flatpak ttf-jetbrains-mono-nerd npm hyprlock hypridle \
swappy swww brightnessctl grimblast-git cliphist pamixer pavucontrol \
network-manager-applet udiskie stow power-profiles-daemon blueman \
bluez bluez-utils ripgrep yarn slurp xdg-desktop-portal-hyprland \
github-cli ark tmux qbittorrent unzip visual-studio-code-bin \
selectdefaultapplication-git xdg-utils xdg-desktop-portal \
xdg-desktop-portal-gtk zsh pyenv ttf-roboto-mono-nerd postgresql ruby-erb \
rubygems pnpm dbeaver ttf-droid ttf-space-mono-nerd chromium cmake \
inter-font ttf-hack-nerd ttf-meslo-nerd noto-fonts ttf-ms-win11-auto \
nerd-fonts-sf-mono noto-fonts-cjk noto-fonts-emoji gvfs ttf-firacode-nerd \
clipse wget obsidian fd ttf-ibmplex-mono-nerd syncthing apple-fonts fastfetch \
adw-gtk-theme baobab gnome-system-monitor anki-bin

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
