#!/bin/bash

yay -S discord alacritty spotify-launcher inter-font apple-fonts github-cli \
	stow tmux zsh ttf-ubuntu-mono-nerd flatpak jre21-openjdk zed xorg-xlsclients \
	cmake cups gutenprint cups-pdf gtk3-print-backends nmap \
	system-config-printer sane-airscan simple-scan epson-inkjet-printer-escpr \
	ttf-ubuntu-font-family fastfetch xclip nautilus libreoffice-fresh postgresql \
	lazygit npm pnpm nvm visual-studio-code-bin qbittorrent gnome-calculator \
	gpu-screen-recorder baobab lxappearance wl-clipboard opencode-bin ruby



gem install tmuxinator

systemctl enable bluetooth


# git clone https://github.com/vinceliuice/Tela-circle-icon-theme && ./Tela-circle-icon-theme/install.sh

flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

flatpak install flathub org.pgadmin.pgadmin4
flatpak install flathub com.pokemmo.PokeMMO
flatpak install flathub com.dec05eba.gpu_screen_recorder
flatpak install flathub com.github.IsmaelMartinez.teams_for_linux
flatpak install flathub org.videolan.VLC
