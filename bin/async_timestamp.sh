#!/bin/bash
start=$(date +%s.%N)
threshold=${1:-1.0}

last=0
while read; do
  now=$(echo "$(date +%s.%N) - $start" | bc)
  if [[ $(echo "$now - $last > $threshold" | bc) -eq 1 ]]; then
    last=$now
    now_s=${now%.*}; now_s=${now_s:-0}
    printf "\e[38;5;245m%03dm%02ds~$(tput sgr0)\n\r" $(($now_s / 60)) $(($now_s % 60))
  fi
done
