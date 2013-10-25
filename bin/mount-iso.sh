#!/bin/sh
MOUNTPOINT="/media/iso"

./unmount-iso.sh

fuseiso "$1" "$MOUNTPOINT"
