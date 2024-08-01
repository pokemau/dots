#!/bin/bash

function get_volume {
    pamixer --get-volume
}

case $1 in
i)  # increase the volume
    if [[ $(get_volume) -lt 10 ]] ; then
        # increase the volume by 1% if less than 10%
        pamixer --increase 1
    else
        # increase the volume by 5% otherwise
        pamixer --increase 5
    fi
    ;;
d)  # decrease the volume
    if [[ $(get_volume) -le 10 ]] ; then
        # decrease the volume by 1% if less than 10%
        pamixer --decrease 1
    else
        # decrease the volume by 5% otherwise
        pamixer --decrease 5
    fi
    ;;
*)  # display help message if no valid argument is passed
    echo "Usage: $0 {i|d}"
    echo "  i: increase the volume"
    echo "  d: decrease the volume"
    ;;
esac
