#!/bin/sh
set -x
sudo reflector --verbose --threads 8 -n 20 -c 'Sweden' -p https --sort rate --save /etc/pacman.d/mirrorlist
{ set +x; } 2>/dev/null
