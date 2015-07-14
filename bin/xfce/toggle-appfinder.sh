#!/bin/sh
window_id=$(xdotool search --name 'Application Finder')

if [[ $window_id ]]; then
	xdotool windowactivate $window_id key --delay 200 'alt+F4'
else
	xfce4-appfinder
fi
