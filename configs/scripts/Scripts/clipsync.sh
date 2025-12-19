#!/usr/bin/env sh

insert() {
    value=$(cat)
    wValue="$(wl-paste)"
    xValue="$(xclip -o -selection clipboard)"

    notify() {
        notify-send -u low -c clipboard "$1" "$value"
    }

if [ "$value" != "$wValue" ]; then
    notify "Wayland"
    echo -n "$value" | wl-copy
fi

if [ "$value" != "$xValue" ]; then
    notify "X11"
    echo -n "$value" | xclip -selection clipboard
fi

}

watch() {
    wl-paste --type text --watch "/home/mau/Scripts/clipsync.sh" insert &

    while clipnotify; do
        xclip -o -selection clipboard | ~/Scripts insert
    done &
}

kill() {
    pkill wl-paste
    pkill clipnotify
    pkill xclip
    pkill clipsync
}

"$@"
