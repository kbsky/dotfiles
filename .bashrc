# .bashrc

## Source external scripts

# Source global definitions
if [[ -f /etc/bashrc ]]; then
	. /etc/bashrc
fi

# Source specific before (e.g. env var)
if [[ -f $HOME/.bashrc_specific_before ]]; then
	. $HOME/.bashrc_specific_before
fi


## Setup prompt

# Colors for display
if [[ $(tput colors) -ge 256 ]]; then
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

RESET_COLOR="\[$(tput sgr0)\]"
BOLD="\[$(tput bold)\]"
REV="\[$(tput rev)\]"

# Prompt
[[ $UID -eq 0 ]] && MK="#" || MK="$"
PS1="$GREEN[$BOLD$RED\u$RESET_COLOR$YELLOW@$MAGENTA\h$YELLOW:$BOLD$CYAN\w$RESET_COLOR$GREEN]$MK$RESET_COLOR "


## Bash settings

# Use vi bindings
set -o vi

# Enable extended glob (needed for dir_in_path)
shopt -s extglob

## Various settings

# Colors
# ls
eval $(dircolors ~/.dir_colors)
# gcc
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# Use vimpager as pager and less
export PAGER="$HOME/bin/vimpager"
alias less=$PAGER
alias zless=$PAGER

# Git autocompletion
command -v git > /dev/null && . ~/.git-completion.bash

# Editor
export SVN_EDITOR=vim
export EDITOR=vim

# Alias
alias lsdir='ls --group-directories-first'

# Alias adresses
export iftp="kbrodsky@iftpserv2.insa-lyon.fr"


## Functions

# Internal function to check # of arguments of the calling function
# $1 is caller's $#, $2 is the needed # of arguments
_need_nb_args()
{
	[[ $1 -lt $2 ]] && 
		{ echo "${FUNCNAME[1]}: not enough arguments ($2 needed)"; return 1; }
	return 0
}

# PATH manipulation

dir_in_path()
{
	[[ $1 && $PATH ==  ?(*:)$1?(:*) ]]
}

append_to_path()
{
	_need_nb_args $# 1 || return 1
	dir_in_path "$1" || export PATH="$PATH:$1"
}

prepend_to_path()
{
	_need_nb_args $# 1 || return 1
	dir_in_path "$1" || export PATH="$1:$PATH"
}

remove_from_path()
{
	_need_nb_args $# 1 || return 1

	if dir_in_path "$1"; then
		# If IFS is not set, we must not restore an empty value (here we restore
		# the default value)
		old_ifs="${IFS-$' \t\n'}"
		IFS=: 
		# Read all paths and put them in an array
		# IFS must only be set for read, otherwise it just doesn't work
		read -a p_array <<< "$PATH"

		# For each path, if it matches $1, remove it from the array
		for i in "${!p_array[@]}"; do
			[[ ${p_array[i]} == $1 ]] && unset -v 'p_array[i]'
		done

		# Set PATH with the new value (IFS being set to :, array's elements will
		# be concatenated using : )
		export PATH="${p_array[*]}"

		IFS="$old_ifs"
		return 0
	fi
	return 1
}

multigrep()
{
	_need_nb_args $# 2 || return 1
	grep -Pzo ${@:1:$(($#-2))} "(?s)${@: -2: 1}" "${@: -1}"
}

silent_bg()
{
	_need_nb_args $# 1 || return 1
	$1 2> /dev/null "${@:2}" &
}


## Other environment settings

# Add ~/bin to PATH (prepend to be able to shadow commands)
prepend_to_path "$HOME/bin"


# Source specific
if [[ -f $HOME/.bashrc_specific ]]; then
	. $HOME/.bashrc_specific
fi
