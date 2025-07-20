# #!/bin/bash
#
# # Get the default source (microphone)
# SOURCE=$(pactl get-default-source)
#
# # Check if the source is muted
# MUTED=$(pactl get-source-mute "$SOURCE" | grep -o "yes\|no")
#
# if [ "$MUTED" = "yes" ]; then
#     echo '{"text": "🎤", "class": "muted", "tooltip": "Microphone is muted (click to unmute)"}'
# else
#     echo '{"text": "🎤", "class": "unmuted", "tooltip": "Microphone is active (click to mute)"}'
# fi

#!/bin/bash

# Get the default source (microphone)
SOURCE=$(pactl get-default-source)

# Check if the source is muted
MUTED=$(pactl get-source-mute "$SOURCE" | grep -o "yes\|no")

if [ "$MUTED" = "yes" ]; then
    echo '{"text": "󰍭", "class": "muted", "tooltip": "Microphone is muted (click to unmute)"}'
else
    echo '{"text": "󰍬", "class": "unmuted", "tooltip": "Microphone is active (click to mute)"}'
fi