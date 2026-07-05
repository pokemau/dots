#!/bin/bash

mkdir -p ~/Apps
cd ~/Apps
git clone https://aur.archlinux.org/yay.git
cd yay && makepkg -si

##########
## APPS ##
##########
yay -S stow discord spotify-launcher power-profiles-daemon flatpak wlsunset nautilus \
    network-manager-applet blueman pavucontrol nwg-look brightnessctl pipewire wireplumber \
    xdg-desktop-portal-hyprland hyprpolkitagent hyprpaper grimblast-git qt5ct qt6ct \
    gnome-calculator baobab swaync obs-studio adw-gtk-theme qbittorrent pulseaudio\
    tela-circle-icon-theme-standard kvantum kvantum-qt5 fzf pipewire-pulse swappy \
    wget


flatpak install flathub org.videolan.VLC

###########
## FONTS ##
###########
# Menlo
# https://github.com/indirect/menlo-nerd-font
yay -S ttf-roboto-mono-nerd noto-fonts noto-fonts-cjk noto-fonts-emoji \
    ttf-jetbrains-mono-nerd inter-font

#########
## DEV ##
#########
yay -S git visual-studio-code-bin android-studio tmux zsh zed wl-clipboard xclip lazygit github-cli \
    zoxide neovim


##################
## STOW CONFIGS ##
##################
rm -rf ~/.config/hypr ~/.zshrc ~/.tmux.conf
cd ~/dots/configs && stow alacritty clang-format ghostty hypr kitty nvim quickshell scripts tmux wallpapers waybar zed zsh swappy \
    -t ~


###########
## THEME ##
###########

cd ~/Apps
git clone https://github.com/vinceliuice/Graphite-gtk-theme
cd Graphite-gtk-theme
./install.sh -l --tweaks normal

systemctl enable power-profiles-daemon.service
systemctl start power-profiles-daemon.service

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
