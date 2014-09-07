#!/bin/sh
set -x
sudo reflector --verbose --threads 8 -l 10 -c 'France' -p http --sort rate --save /etc/pacman.d/mirrorlist
{ set +x; } 2>/dev/null
