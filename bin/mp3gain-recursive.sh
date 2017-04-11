#!/bin/bash
find . -type d -links 2 -exec bash -c 'echo -e "\e[38;5;27mIn {}$(tput sgr0)"; mp3gain -a -d '"${1:-+3.0}"' "{}"/*.mp3' \;
