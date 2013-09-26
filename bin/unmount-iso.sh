#!/bin/sh
MOUNTPOINT="/media/iso"

mount | grep -q "$MOUNTPOINT" && fusermount -u "$MOUNTPOINT"
