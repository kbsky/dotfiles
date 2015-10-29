#!/bin/bash
excludes=(.cache .xnview/Thumbs.db .thumbnails)
set -x
tar cvf "$2" -p -I 'xz -T 8' "${excludes[@]/#/--exclude=}" "$1"
