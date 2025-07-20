#!/bin/bash

# Toggle the microphone mute
pactl set-source-mute @DEFAULT_SOURCE@ toggle

# Optional: Send a notification
SOURCE=$(pactl get-default-source)
MUTED=$(pactl get-source-mute "$SOURCE" | grep -o "yes\|no")

if [ "$MUTED" = "yes" ]; then
    notify-send -t 1000 -i audio-input-microphone-muted "Microphone Muted"
else
    notify-send -t 1000 -i audio-input-microphone "Microphone Unmuted"
fi
