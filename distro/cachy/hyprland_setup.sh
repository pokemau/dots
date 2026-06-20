#!/bin/bash

mkdir -p ~/Apps
cd ~/Apps
git clone https://aur.archlinux.org/yay.git
cd yay && makepkg -si


# apps
yay -S stow discord spotify-launcher power-profiles-daemon flatpak wlsunset nautilus \
    network-manager-applet blueman pavucontrol nwg-look brightnessctl pipewire wireplumber \
    xdg-desktop-portal-hyprland hyprpolkitagent hyprpaper grimblast-git qt5ct qt6ct \
    gnome-calculator baobab swaync obs-studio adw-gtk-theme qbittorrent

flatpak install flathub org.videolan.VLC

# fonts
yay -S ttf-roboto-mono-nerd noto-fonts noto-fonts-cjk noto-fonts-emoji \
    ttf-jetbrains-mono-nerd

# dev
yay -S git visual-studio-code-bin android-studio tmux zsh zed wl-clipboard xclip lazygit github-cli \
    zoxide neovim
    
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# fonts

# stow configs
rm -rf ~/.config/hypr ~/.zshrc ~/.tmux.conf
cd ~/dots/configs && stow alacritty clang-format ghostty hypr kitty nvim quickshell scripts tmux wallpapers waybar zed zsh \
    -t ~

systemctl enable power-profiles-daemon.service
systemctl start power-profiles-daemon.service