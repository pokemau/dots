#!/bin/bash

mkdir Code Apps

flatpak remote-add --if-not-exists flathub-beta https://flathub.org/beta-repo/flathub-beta.flatpakrepo

sudo dnf install git vim gnome-tweaks zsh neovim alacritty kitty tmux stow \
    fastfetch fira-code-fonts gcc gcc-c++ rust cargo qbittorrent golang \
    cmake bear

flatpak install flathub org.videolan.VLC
flatpak install flathub io.github.vikdevelop.SaveDesktop
flatpak install flathub com.discordapp.Discord
flatpak install flathub-beta com.discordapp.DiscordCanary 
flatpak install flathub com.spotify.Client
flatpak install flathub com.obsproject.Studio
flatpak install flathub com.brave.Browser

git clone https://github.com/vinceliuice/Colloid-gtk-theme
cd Colloid-gtk-theme 
./install.sh -s compact -l --tweaks normal

sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/vscode.repo > /dev/null
dnf check-update
sudo dnf install code


# GH CLI
sudo dnf install dnf5-plugins
sudo dnf config-manager addrepo --from-repofile=https://cli.github.com/packages/rpm/gh-cli.repo
sudo dnf install gh --repo gh-cli


sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"


# NOISETORCH
# https://github.com/noisetorch/NoiseTorch
