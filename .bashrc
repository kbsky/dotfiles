# Only run if interactive
[[ $- == *i* ]] || return

########################### Source external scripts ###########################

# Source global definitions
if [[ -f /etc/bashrc ]]; then
    . /etc/bashrc
fi

# Source specific before (e.g. env var)
if [[ -f $HOME/.bashrc_specific_before ]]; then
    . $HOME/.bashrc_specific_before
fi


################################# Setup prompt ################################

set_prompt()
{
    local black blue green cyan red magenta yellow white clr bold rev
    if [[ $(tput colors) -ge 256 ]]; then
        black="\[\e[38;5;0m\]"
        blue="\[\e[38;5;27m\]"
        green="\[\e[38;5;28m\]"
        cyan="\[\e[38;5;37m\]"
        red="\[\e[38;5;160m\]"
        magenta="\[\e[38;5;99m\]"
        yellow="\[\e[38;5;214m\]"
        white="\[\e[38;5;255m\]"
    else
        black="\[$(tput setf 0)\]"
        blue="\[$(tput setf 62)\]"
        green="\[$(tput setf 2)\]"
        cyan="\[$(tput setf 3)\]"
        red="\[$(tput setf 4)\]"
        magenta="\[$(tput setf 5)\]"
        yellow="\[$(tput setf 6)\]"
        white="\[$(tput setf 7)\]"
    fi

    clr="\[$(tput sgr0)\]"
    bold="\[$(tput bold)\]"
    rev="\[$(tput rev)\]"

    local mk status
    [[ $UID -eq 0 ]] && mk="#" || mk="$"
    status='$(e=$?; [[ $e -ne 0 ]] && echo "'"$yellow{$bold$red"'$e'"$clr$yellow}$clr"'")'

    PS1="$status$green[$bold$red\u$clr$yellow@$magenta\h$yellow:$bold$cyan\w$clr$green]$mk$clr "
}
set_prompt

################################ Bash settings ################################

# Use vi bindings
set -o vi

# Enable extended glob (needed for dir_in_path) and directory glob (**)
shopt -s extglob globstar
# Do not match . and .. with globs (e.g. .*)
export GLOBIGNORE=.
# Setting GLOBIGNORE also sets dotglob, disable it
shopt -u dotglob

# Expand variables in directory names when performing completion
shopt -s direxpand


##################### Various command settings and aliases #####################

# Colors
# ls
eval $(dircolors ~/.dir_colors)
# gcc (4.9+)
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
# ip (iproute2 4.1+)
if ip -c -V > /dev/null 2>&1; then
    alias ip='ip -c'
fi

# Use vimpager as pager and less
if [[ -x $HOME/bin/vimpager ]]; then
    export PAGER=$HOME/bin/vimpager
    alias less=$PAGER
    alias zless=$PAGER
fi

export SYSTEMD_PAGER=
export GIT_PAGER='env GIT_DIR="$(git rev-parse --git-dir)" $PAGER'

# Editor
export SVN_EDITOR=vim
export EDITOR=vim

# Alias
alias lsdir='ls --group-directories-first'
alias clip='xclip -sel clipboard'
alias dd='dd bs=1M status=progress conv=fsync'
alias journalctl='SYSTEMD_PAGER=less journalctl'
alias yaourt='GIT_PAGER= yaourt' # To prevent opening a pager for AUR diffs

# Completion for complex aliases that __git doesn't manage to recognise

# Make readelf always use the wide format, for all toolchains
for readelf in $(find ${PATH//:/ } -name '*readelf' -printf '%f '); do
    alias $readelf="$readelf -W"
done

# Alias adresses
export iftp="kbrodsky@iftpserv2.insa-lyon.fr"
export tw_cs="kxb414@tw.cs.bham.ac.uk"


################################## Functions ##################################

. "$HOME/lib/bash-utils.sh"

########################## Other environment settings #########################

# Add ~/bin to PATH (prepend to be able to shadow commands)
prepend_to_path "$HOME/bin"


# Source specific
if [[ -f $HOME/.bashrc_specific ]]; then
    . $HOME/.bashrc_specific
fi

# vim: set ts=4 sw=4 sts=4 et:
