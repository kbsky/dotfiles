#!/bin/bash
for s in $(pactl list sinks short | cut -d$'\t' -f2 ); do
    [[ $1 == $s ]] && sink=$s
done

[[ $sink ]] || { notify-send -i dialog-warning "No such sink: $1"; exit 1; }

pactl set-default-sink "$sink"
for input in $(pactl list sink-inputs short | cut -d$'\t' -f1); do
    pactl move-sink-input "$input" "$sink"
done

pretty_name=$(pactl list sinks | perl -n0E "/Name: $sink\n\s*Description: (.*)/ && print \$1")
notify-send -i audio-card -h int:transient:1 -u low "Default sink set to $pretty_name"
