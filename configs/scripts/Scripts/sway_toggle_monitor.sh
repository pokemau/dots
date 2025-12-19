# #!/bin/bash
#
# LOCKFILE="/tmp/sway_toggle_monitor.lock"
#
# # Try to acquire lock, exit if already locked (within 1 second)
# exec 200>"$LOCKFILE"
# flock -n 200 || exit 1
#
# # Optionally, clean up lock file on exit (not strictly needed with flock)
# trap 'rm -f "$LOCKFILE"' EXIT
#
# # Get list of connected monitors in JSON format
# monitors=$(swaymsg -t get_outputs)
#
# # echo $monitors | grep 'eDP-1'
#
# if echo "$monitors" | grep -A26 'eDP-1' | grep -q "\"active\": true"; then
#
#     echo "A"
#
#     if echo "$monitors" | grep -q 'HDMI-A-1'; then
#
#         if echo "$monitors" | grep -A5 'HDMI-A-1' | grep -q "\"active\": false"; then
#             echo "B"
#             swaymsg output HDMI-A-1 enable
#         else
#             echo "C"
#             swaymsg output eDP-1 disable
#         fi
#     fi
# else
#     echo "D"
#     swaymsg output eDP-1 enable
# fi

#!/bin/bash

LOCKFILE="/tmp/sway_toggle_monitor.lock"
exec 200>"$LOCKFILE"
flock -n 200 || exit 1
trap 'rm -f "$LOCKFILE"' EXIT

outputs=$(swaymsg -t get_outputs -r)

eDP_active=$(echo "$outputs" | jq -r '.[] | select(.name=="eDP-1") | .active')
HDMI_active=$(echo "$outputs" | jq -r '.[] | select(.name=="HDMI-A-1") | .active')

if [ "$eDP_active" = "true" ]; then
    if [ -n "$HDMI_active" ]; then
        if [ "$HDMI_active" = "false" ]; then
            swaymsg output HDMI-A-1 enable
        else
            swaymsg output eDP-1 disable
        fi
    fi
else
    swaymsg output eDP-1 enable
fi
