#!/bin/bash

# LOCKFILE="/tmp/niri_toggle_monitor.lock"
# exec 200>"$LOCKFILE"
# flock -n 200 || exit 1
# trap 'rm -f "$LOCKFILE"' EXIT

# LAPTOP="eDP-1"
# EXTERNAL="HDMI-A-1"

OUTPUTS=$(niri msg --json outputs)

# laptop_exists=$(echo "$OUTPUTS" | jq -r "has(\"$LAPTOP\")")
# external_exists=$(echo "$OUTPUTS" | jq -r "has(\"$EXTERNAL\")")
# laptop_enabled=$(echo "$OUTPUTS" | jq -r ".\"$LAPTOP\".logical != null")
# external_enabled=$(echo "$OUTPUTS" | jq -r ".\"$EXTERNAL\".logical != null // false")

echo "HELLO WROLD"

# # Determine current state
# if [ "$laptop_enabled" = "true" ] && [ "$external_enabled" = "false" ]; then
#     CURRENT_STATE="laptop-only"
# elif [ "$laptop_enabled" = "true" ] && [ "$external_enabled" = "true" ]; then
#     CURRENT_STATE="both"
# elif [ "$laptop_enabled" = "false" ] && [ "$external_enabled" = "true" ]; then
#     CURRENT_STATE="external-only"
# else
#     # Fallback: enable laptop if state is unclear
#     CURRENT_STATE="laptop-only"
#     niri msg output "$LAPTOP" on
# fi

# # Toggle to next state
# case "$CURRENT_STATE" in
#     "laptop-only")
#         # Try to enable external if it exists
#         if [ "$external_exists" = "true" ]; then
#             niri msg output "$EXTERNAL" on
#         fi
#         ;;
#     "both")
#         # Disable laptop, keep external only
#         niri msg output "$LAPTOP" off
#         ;;
#     "external-only")
#         # Enable laptop, disable external
#         niri msg output "$LAPTOP" on
#         niri msg output "$EXTERNAL" off
#         ;;
# esac