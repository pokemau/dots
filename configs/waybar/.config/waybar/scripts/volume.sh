#!/bin/bash

# Nerd Font icons via unicode escapes
ICON_VOL_HIGH=$'\uf028'
ICON_VOL_MID=$'\uf027'
ICON_VOL_LOW=$'\uf026'
ICON_VOL_MUTE=$'\uf62e'
ICON_BT=$'\uf294'

get_volume_info() {
    local sink_name vol muted icon class tooltip

    sink_name=$(wpctl inspect @DEFAULT_AUDIO_SINK@ 2>/dev/null | grep "node.name" | head -1 | sed 's/.*= "\(.*\)"/\1/')
    vol=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ 2>/dev/null)
    muted=$(echo "$vol" | grep -c "MUTED")
    vol=$(echo "$vol" | awk '{printf "%.0f", $2 * 100}')

    if [ "$muted" -eq 1 ]; then
        icon="$ICON_VOL_MUTE"
        class="muted"
    elif echo "$sink_name" | grep -qi "blue"; then
        icon="$ICON_BT"
        class="bluetooth"
    else
        if [ "$vol" -gt 66 ]; then
            icon="$ICON_VOL_HIGH"
        elif [ "$vol" -gt 33 ]; then
            icon="$ICON_VOL_MID"
        else
            icon="$ICON_VOL_LOW"
        fi
        class="normal"
    fi

    tooltip="$sink_name: ${vol}%"
    printf '{"text": "%s %s%%", "class": "%s", "tooltip": "%s"}\n' "$icon" "$vol" "$class" "$tooltip"
}

# Initial output
get_volume_info

# Subscribe to PipeWire changes and re-output on each event
pactl subscribe 2>/dev/null | while read -r line; do
    if echo "$line" | grep -qE "'change'.*sink|'new'.*sink|'remove'.*sink"; then
        get_volume_info
    fi
done
