#!/bin/bash
find . -type d -links 2 -not -empty -exec bash -c 'echo -e "\e[38;5;27mIn {}$(tput sgr0)"; mp3gain -a "{}"/*.mp3' \;
