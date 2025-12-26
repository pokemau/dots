#!/bin/bash

# install yay
mkdir -p ~/Apps/git
cd ~/Apps/git
git clone https://aur.archlinux.org/yay.git
cd yay && makepkg -si
cd ~/dots/distro/arch

# cp -r ~/dots/wallpapers ~/wallpapers

# yay -S nvm dunst rofi-wayland neovim swappy swww waybar brightnessctl \
#     grimblast-git cliphist pamixer pavucontrol network-manager-applet \
#     blueman udiskie ttf-jetbrains-mono-nerd ttf-hack-nerd ttf-meslo-nerd \
#     yarn npm qt5-quickcontrols qt5-quickcontrols2 qt5-graphicaleffects \
#     slurp xdg-desktop-portal-hyprland nwg-look qt5ct qt6ct kvantum \
#     kvantum-qt5 qt5-wayland qt6-wayland thunar github-cli \
#     thunar-archive-plugin ark pipewire pipewire-alsa pipewire-audio \
#     pipewire-jack pipewire-pulse gst-plugin-pipewire wireplumber pavucontrol \
#     tmux zsh vlc qbittorrent unzip flatpak wlsunset rust xdg-desktop-portal \
#     hyprpicker noto-fonts bear ripgrep baobab gnome-calculator stow \
#     glfw ttf-ms-win11-auto xdg-desktop-portal-gtk ttf-cascadia-code-nerd \
#     ttf-cascadia-code ttf-roboto-mono-nerd nerd-fonts-sf-mono nwg-displays \
#     visual-studio-code-bin noto-fonts-cjk noto-fonts-emoji gvfs \
#     downgrade gnome-themes-extra clipse ttf-firacode-nerd cmake \
#     libreoffice-still wget obsidian gdb discord fd kwallet-pam \
#     ttf-ibmplex-mono-nerd pyenv syncthing brave-bin kwallet kwalletmanager \
#     kwallet-pam power-profiles-daemon tmuxinator inter-font apple-fonts \
#     ttf-ubuntu-mono-nerd imagemagick swaync clipboard-sync

yay -S wl-clipboard lazygit github-cli android-studio dbeaver xorg-xlsclients \
	kvantum qt5ct qt6ct

# FONTS
yay -S ttf-roboto-mono-nerd

# GNOME INSTALLATION SETUP
yay -S nvm neovim yarn npm tmux zsh qbittorrent unzip flatpak bear ripgrep stow \
	visual-studio-code-bin downgrade cmake libreoffice-still wget obsidian gdb discord fd \
	pyenv syncthing brave-bin power-profiles-daemon tmuxinator gnome-tweaks extension-manager \

# OPENCODE
curl -fsSL https://opencode.ai/install | bash

systemctl enable power-profiles-daemon.service
systemctl start power-profiles-daemon.service

git config --global user.name "pokemau"
git config --global user.email "rentillosa90@gmail.com"

# uncomment multilib in pacman.conf

# INSTALL GNOME
# yay -S gnome gnome-browser-connector \
# nautilus-open-any-terminal gnome-tweaks \
# power-profiles-daemon \

# flatpak install flathub com.discordapp.Discord
flatpak install flathub com.github.IsmaelMartinez.teams_for_linux
flatpak install flathub com.spotify.Client
flatpak install flathub org.videolan.VLC
# flatpak install flathub app.zen_browser.zen

# SET ZEN AS DEFAULT BROWSER
#xdg-settings set default-web-browser /var/lib/flatpak/exports/share/applications/app.zen_browser.zen.desktop


sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
