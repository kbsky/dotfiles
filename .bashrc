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

# Aliases
alias lsd='ls --group-directories-first'
alias clip='xclip -sel clipboard'
alias dd='dd bs=1M status=progress conv=fsync'
alias journalctl='SYSTEMD_PAGER=less journalctl'
# Make readelf always use the wide format, for all toolchains
for readelf in $(find ${PATH//:/ } -maxdepth 1 -name '*readelf' -printf '%f '); do
    alias $readelf="$readelf -W"
done
unset readelf

# Arch stuff
alias pqi='pacman -Qi'
alias pql='pacman -Ql'
alias pqo='pacman -Qo'
alias pqs='pacman -Qs'
alias pS='pacman -S'
alias psi='pacman -Si'
alias pss='pacman -Ss'
alias pu='pacman -U'
alias yaourt='GIT_PAGER= yaourt' # To prevent opening a pager for AUR diffs

# Generic completion function that expands aliases
# Based on https://github.com/cykerway/complete-alias
_alias_complete()
{
    local -r alias_name="${COMP_WORDS[0]}"
    local regex cmd_offset=0
    if [[ -v BASH_ALIASES[$alias_name] ]]; then
        local -r alias_expansion=${BASH_ALIASES[$alias_name]}
        local -r alias_expansion_words=(${alias_expansion})

        # Rewrite current completion context by expanding alias.
        COMP_WORDS=("${alias_expansion_words[@]}" "${COMP_WORDS[@]:1}")
        ((COMP_CWORD += ${#alias_expansion_words[@]} - 1))
        COMP_LINE="${alias_expansion}${COMP_LINE:${#alias_name}}"
        ((COMP_POINT += ${#alias_expansion} - ${#alias_name}))

        # Rough support for leading variable assignments and redirections -
        # assuming that the command name does not contain any of [<>=].
        local i
        for ((i = 0; i < ${#COMP_WORDS[@]}; ++i)); do
            regex='^[^=<>]*$'
            [[ ${COMP_WORDS[$i]} =~ $regex ]] && cmd_offset=$i && break
        done

        local -r cmd=${COMP_WORDS[$cmd_offset]}
        # Note that just comparing $cmd with $alias_name is not enough, as $cmd
        # may very well be another alias.
        regex='\b_alias_complete\b'
        if [[ $(complete -p $cmd 2>/dev/null) =~ $regex ]]; then
            # We have to do something, otherwise _command_offset will call
            # _alias_complete and we will end up in an infinite recursion.
            # We temporarily unset the completion function and let
            # bash-completion find an appropriate function.
            complete -r $cmd
            # Some commands don't have a completion file, make it work
            # anyway...
            local c
            for c in diff grep ls; do
                [[ $cmd == $c ]] && complete -F _longopt $cmd && break
            done
            # To avoid making bash-completion source the completion file again
            # if it has already done so, we try to find to find an obvious
            # candidate function and use it if it exists.
            local comp_fn="_${cmd//-/_}"
            for comp_fn in $comp_fn ${comp_fn}_module; do
                type -t $comp_fn >/dev/null && complete -F $comp_fn $cmd && break
            done
        fi
    fi
    
    # Let bash-completion reparse the completion line and invoke the right
    # completion function
    _command_offset $cmd_offset

    # If we had to change the completion function, reset it now that the
    # completion has been done.
    [[ $comp_fn ]] && complete -F _alias_complete $cmd
}

# Complete all aliases
complete -F _alias_complete "${!BASH_ALIASES[@]}"

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
