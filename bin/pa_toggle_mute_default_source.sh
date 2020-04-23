#!/bin/bash
pactl set-source-mute @DEFAULT_SOURCE@ toggle

status=$(~/bin/pa_show_default_source_muted.sh)
if [[ $status == "Muted" ]]; then
    icon="microphone-sensitivity-muted"
else
    icon="microphone-sensitivity-high"
fi
notify-send -i $icon -h int:transient:1 -u low "$status"
