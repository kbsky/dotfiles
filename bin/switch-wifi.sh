#!/bin/sh

if nmcli nm wifi | grep -q 'enabled'; then
	nmcli nm wifi off
else
	nmcli nm wifi on
fi
