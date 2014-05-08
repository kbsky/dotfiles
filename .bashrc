# .bashrc

# Source global definitions
if [[ -f /etc/bashrc ]]; then
	. /etc/bashrc
fi

# User specific aliases and function

# Source specific before (e.g. env var)
if [[ -f $HOME/.bashrc_specific_before ]]; then
	. $HOME/.bashrc_specific_before
fi

# Colors for display
if [[ `tput colors` -ge 256 ]]; then
	BLACK="\[\e[38;5;0m\]"
	BLUE="\[\e[38;5;27m\]"
	GREEN="\[\e[38;5;28m\]"
	CYAN="\[\e[38;5;37m\]"
	RED="\[\e[38;5;160m\]"
	MAGENTA="\[\e[38;5;99m\]"
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
if [[ $UID -eq 0 ]];
	then MK="#"
	else MK="$"
fi

PS1="$GREEN[$BOLD$RED\u$RETURN$YELLOW@$MAGENTA\h$YELLOW:$BOLD$CYAN\w$RETURN$GREEN]$MK$RETURN "

# Path
if [[ !$(eval echo $PATH | grep "$(eval echo ~/bin)") ]]; then
	export PATH=$PATH:~/bin
fi

# Colors
# ls
eval `dircolors ~/.dir_colors`
# gcc
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# Use vi bindings in shell
set -o vi

# Use vimpager as pager and less
export PAGER=~/bin/vimpager
alias less=$PAGER
alias zless=$PAGER

# Git autocompletion
# &> to silence in case Git is not installed
. ~/.git-completion.bash &> /dev/null

# Editor
export SVN_EDITOR=vim
export EDITOR=vim

# Alias
alias lsdir='ls --group-directories-first'

# Alias adresses
export iftp="kbrodsky@iftpserv2.insa-lyon.fr"


# Functions

mgrep()
{
	[[ $# -lt 2 ]] && { echo "Not enough arguments"; return 1; }
	grep -Pzo ${@:1:$(($#-2))} "(?s)${@: -2: 1}" "${@: -1}"
}

silent_bg()
{
	if [[ $1 ]]; then
		$1 2> /dev/null "${@:2}" &
	else
		echo "No command given"
		return 1
	fi
}


# Source specific
if [[ -f $HOME/.bashrc_specific ]]; then
	. $HOME/.bashrc_specific
fi
