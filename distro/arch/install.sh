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
qt5-graphicaleffects slurp xdg-desktop-portal-hyprland nwg-look qt5ct \
qt6ct kvantum kvantum-qt5 qt5-wayland qt6-wayland thunar github-cli \
thunar-archive-plugin ark pipewire pipewire-alsa pipewire-audio \
pipewire-jack pipewire-pulse gst-plugin-pipewire wireplumber pavucontrol \
tmux zsh vlc qbittorrent unzip flatpak wlsunset rust xdg-desktop-portal \
hyprpicker noto-fonts bear ripgrep baobab gnome-calculator stow \
glfw ttf-ms-win11-auto xdg-desktop-portal-gtk ttf-cascadia-code-nerd \
ttf-cascadia-code ttf-roboto-mono-nerd nerd-fonts-sf-mono nwg-displays \
visual-studio-code-bin gvfs noto-fonts-cjk noto-fonts-emoji gvfs \
downgrade gnome-themes-extra clipse ttf-firacode-nerd cmake \
libreoffice-still wget obsidian gdb discord


# yay -S spotify-adblock

# uncomment multilib in pacman.conf

# KDE Plasma
# plasma-desktop plasma-nm plasma-pa
#
# Gnome
# yay -S gnome gnome-browser-connector \
# nautilus-open-any-terminal gnome-tweaks \
# power-profiles-daemon \
#
# systemctl enable power-profiles-daemon.service
# systemctl start power-profiles-daemon.service

flatpak install flathub com.discordapp.Discord
flatpak install flathub com.github.IsmaelMartinez.teams_for_linux
flatpak install flathub com.spotify.Client
flatpak install flathub app.zen_browser.zen


# SET ZEN AS DEFAULT BROWSER
#xdg-settings set default-web-browser /var/lib/flatpak/exports/share/applications/app.zen_browser.zen.desktop

git clone https://github.com/vinceliuice/Tela-circle-icon-theme && ./Tela-circle-icon-theme/install.sh \
&& \\
git clone https://github.com/vinceliuice/Colloid-gtk-theme && \
./Colloid-gtk-theme/install.sh -s compact -l --tweaks normal &&\

rm -rf Colloid-gtk-theme

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
