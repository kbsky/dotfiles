#!/bin/sh
ASOUNDRC=$HOME/.asoundrc

MAX_CARD=1
while [[ -d "/proc/asound/card$((MAX_CARD+1))" ]]; do
	: $((++MAX_CARD))
done

CURRENT_CARD=$(grep -Pom 1 'card \d' "$ASOUNDRC" | cut -d' ' -f2)

NEW_CARD=1
[[ $CURRENT_CARD -lt $MAX_CARD ]] && : $((++NEW_CARD))

sed -i "s/card $CURRENT_CARD/card $NEW_CARD/" "$ASOUNDRC" 

NEW_CARD_NAME=$(grep -Pzo "^ $NEW_CARD.*\n.*(?= at)" /proc/asound/cards | tail -n 1 \
				| sed -r 's/(^\s*|\s*$)//g')
notify-send -u low -i xfce4-mixer "Switch sound card: $NEW_CARD" \
	"Default ALSA card switched to $NEW_CARD ($NEW_CARD_NAME)"
