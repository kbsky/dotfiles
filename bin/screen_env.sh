#!/bin/bash
if [[ ! -v STY ]]; then
  # When invoked as a command (outside screen).
  read -ep 'Session name > ' -i "$(basename "$PWD")" session_name
  [[ -z $session_name ]] && exit 1
  screen -s "$0" -t bash -S "$session_name" "$@"
elif [[ $0 != bash ]]; then
  # When invoked as a shell by screen; since it is the default shell, it will
  # also be invoked by any command run in the shells, and therefore we need
  # to forward arguments.
  exec bash --init-file "$0" "$@"
else
  # Custom initrc.
  . ~/.bashrc
  . env.sh
fi
