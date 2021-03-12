#!/bin/bash
cur_src=$(pactl info | grep "Default Source" | cut -f3 -d" ")
pactl list sources | awk '/Name: '"$cur_src"'$/,/^Source/ { if (/Mute:/) { print ($2 == "yes" ? "Muted" : "Listening"); exit } }'
