#!/bin/bash

file_path="$HOME/.local/share/applications/spotify[].desktop"

mkdir -p "$(dirname "$file_path")"

#flatpak install flathub com.spotify.Client

git clone https://github.com/abba23/spotify-adblock.git
cd spotify-adblock
make
sudo make install

mkdir -p ~/.spotify-adblock && cp target/release/libspotifyadblock.so ~/.spotify-adblock/spotify-adblock.so
mkdir -p ~/.config/spotify-adblock && cp config.toml ~/.config/spotify-adblock
flatpak override --user --filesystem="~/.spotify-adblock/spotify-adblock.so" --filesystem="~/.config/spotify-adblock/config.toml" com.spotify.Client

cat <<EOL > "$file_path"
[Desktop Entry]
Type=Application
Name=Spotify[]
GenericName=Music Player
Icon=com.spotify.Client
Exec=flatpak run --file-forwarding --command=sh com.spotify.Client -c 'eval "\$(sed s#LD_PRELOAD=#LD_PRELOAD=\$HOME/.spotify-adblock/spotify-adblock.so:#g /app/bin/spotify)"' @@u %U @@
Terminal=false
MimeType=x-scheme-handler/spotify;
Categories=Audio;Music;Player;AudioVideo;
StartupWMClass=spotify
EOL
