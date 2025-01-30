#!/bin/bash


wget https://github.com/ppy/osu/releases/latest/download/osu.AppImage
chmod +x osu.AppImage
mkdir -p ~/Apps/osu
mkdir -p ~/.local/share/applications
mv osu.AppImage ~/Apps/osu

file_path="$HOME/.local/share/applications/osu.desktop"

touch $HOME/.local/share/applications/osu.desktop 

cat <<EOL > "$file_path"
[Desktop Entry]
Type=Application
Name=Osu
Exec=/home/$USER/Apps/osu/osu.AppImage
Terminal=false
StartupWMClass=osu
EOL
