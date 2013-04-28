# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific aliases and function

# Colors for display
if [ `tput colors` -ge 256 ]; then
	BLACK="\[\e[38;5;0m\]"
	BLUE="\[\e[38;5;27m\]"
	GREEN="\[\e[38;5;28m\]"
	CYAN="\[\e[38;5;37m\]"
	RED="\[\e[38;5;160m\]"
	MAGENTA="\[\e[38;5;57m\]"
	YELLOW="\[\e[38;5;214m\]"
	WHITE="\[\e[38;5;255m\]"
else
	BLACK="\[$(tput setf 0)\]"
	BLUE="\[$(tput setf 62)\]"
	GREEN="\[$(tput setf 2)\]"
	CYAN="\[$(tput setf 3)\]"
	RED="\[$(tput setf 4)\]"
	MAGENTA="\[$(tput setf 5)\]"
	YELLOW="\[$(tput setf 6)\]"
	WHITE="\[$(tput setf 7)\]"
fi

RETURN="\[$(tput sgr0)\]"
BOLD="\[$(tput bold)\]"
REV="\[$(tput rev)\]"

# Prompt
if [ $UID -eq 0 ];
	then MK="#"
	else MK="$"
fi

PS1="$GREEN[$BOLD$RED\u$RETURN$YELLOW@$MAGENTA\h$YELLOW:$BOLD$CYAN\w$RETURN$GREEN]$MK$RETURN "

# ls colors
eval `dircolors ~/.dir_colors`

# Use vi binding in shell
set -o vi

# Back to default language
export LANG=C

# Use vimpager as pager and less
export PAGER=~/bin/vimpager
alias less=$PAGER
alias zless=$PAGER

# Git autocompletion
. ~/.git-completion.bash

# Editor
export SVN_EDITOR=vim
export EDITOR=vim

# Alias

# Alias adresses
export iftp="kbrodsky@iftpserv2.insa-lyon.fr"
