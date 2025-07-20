#!/bin/bash

wall_dir=~/wallpapers/

list_wallpapers() {
    for e in "$wall_dir"/*
    do
        echo "$(basename "$e")"
    done
}

selected_file=$(list_wallpapers | rofi -dmenu -p "Select Wallpaper" -lines 10 -width 30 -i)

if [ -n "$selected_file" ]; then
    full_path="$wall_dir/$selected_file"
    
    swww img "$full_path" --transition-type center
fi
