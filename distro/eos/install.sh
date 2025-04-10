#!/bin/bash


# yay -S plasma-desktop kitty neovim \
# ttf-jetbrains-mono-nerd ttf-hack-nerd ttf-meslo-nerd yarn npm \
# qt5-quickcontrols qt5-quickcontrols2 qt5-graphicaleffects \
# qt5ct qt6ct kvantum kvantum-qt5 qt5-wayland qt6-wayland thunar github-cli \
# thunar-archive-plugin ark \
# discord pipewire pipewire-alsa pipewire-audio pipewire-jack \
# pipewire-pulse gst-plugin-pipewire wireplumber pavucontrol \
# tmux zsh vlc qbittorrent unzip flatpak rust \
# noto-fonts bear ripgrep stow \
# glfw ttf-ms-win11-auto xdg-desktop-portal-gtk ttf-cascadia-code-nerd \
# ttf-cascadia-code ttf-roboto-mono-nerd nerd-fonts-sf-mono nwg-displays \
# visual-studio-code-bin gvfs noto-fonts-cjk noto-fonts-emoji gvfs \
# downgrade gnome-themes-extra clipse ttf-firacode-nerd spotify-adblock cmake \
# libreoffice-still nwg-look

yay -S neovim flatpak zsh tmux qbittorrent visual-studio-code-bin wget obsidian \
	gdb discord fd pyenv syncthing brave-bin tmuxinator inter-font \
	github-cli gnome-tweaks ttf-meslo-nerd alacritty kitty stow npm \
	postgresql pnpm gnome-browser-connector blueman bluez bluez-utils \
	nautilus-open-any-terminal cmake nerd-fonts-sf-mono zed bear ripgrep \
	ttf-hack-nerd roboto-mono-nerd ttf-jetbrains-mono-nerd

systemctl enable bluetooth

git clone https://github.com/vinceliuice/Tela-circle-icon-theme && ./Tela-circle-icon-theme/install.sh

flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

flatpak install flathub com.spotify.Client
flatpak install flathub com.github.IsmaelMartinez.teams_for_linux
flatpak install flathub org.videolan.VLC
flatpak install flathub com.mattjakeman.ExtensionManager

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
