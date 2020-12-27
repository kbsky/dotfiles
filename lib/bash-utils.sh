# Internal function to check # of arguments of the calling function
# $1 is caller's $#, $2 is the needed # of arguments
_need_nb_args()
{
    [[ $1 -lt $2 ]] &&
        { echo "${FUNCNAME[1]}: not enough arguments ($2 needed)"; return 1; }
    return 0
}

## PATH manipulation

# $1 in ${!2}? ($2 = PATH by default)
# (${!2} = the expansion of the variable named by $2)
dir_in_path()
{
    local var=${2:-PATH}
    [[ $1 && ${!var} ==  ?(*:)$1?(:*) ]]
}

# Append $1 to ${!2}? ($2 = PATH by default)
append_to_path()
{
    _need_nb_args $# 1 || return 1
    local var=${2:-PATH}
    remove_from_path "$1" "$var"
    export "$var"="${!var:+${!var}:}$1"
}

# Prepend $1 to ${!2}? ($2 = PATH by default)
prepend_to_path()
{
    _need_nb_args $# 1 || return 1
    local var=${2:-PATH}
    remove_from_path "$1" "$var"
    export "$var"="$1${!var:+:${!var}}"
}

# Remove $1 from ${!2}? ($2 = PATH by default)
remove_from_path()
{
    _need_nb_args $# 1 || return 1
    local var=${2:-PATH}

    if dir_in_path "$1" "$var"; then
        # If IFS is not set, we must not restore an empty value (here we restore
        # the default value)
        local old_ifs="${IFS-$' \t\n'}"
        IFS=:
        # Read all paths and put them in an array
        # IFS must only be set for read, otherwise it just doesn't work
        read -a p_array <<< "${!var}"

        # For each path, if it matches $1, remove it from the array
        for i in "${!p_array[@]}"; do
            [[ ${p_array[i]} == $1 ]] && unset -v 'p_array[i]'
        done

        # Set PATH with the new value (IFS being set to :, array's elements will
        # be concatenated using : )
        export "$var"="${p_array[*]}"

        IFS="$old_ifs"
        return 0
    fi
    return 1
}

func_def()
{
    shopt -s extdebug && declare -F "$1" && shopt -u extdebug
}

multigrep()
{
    _need_nb_args $# 2 || return 1
    grep -Pzo ${@:1:$(($#-2))} "(?s)${@: -2: 1}" "${@: -1}"
}

launch_silent_bg()
{
    _need_nb_args $# 1 || return 1
    "$@" > /dev/null 2>&1 < /dev/null &
}

launch_detached()
{
    _need_nb_args $# 1 || return 1
    launch_silent_bg "$@"
    disown
}

launch_silent_bg_wait()
{
    _need_nb_args $# 1 || return 1
    while pgrep "$1" > /dev/null; do
        sleep 1s
    done
    shift
    launch_silent_bg "$@"
}
complete -F _command launch_silent_bg launch_detached launch_silent_bg_wait

cat_dir()
{
    [[ ${1,,} == '-r' ]] && { local recursive=1; shift; }
    _need_nb_args $# 1 || return 1

    local d f
    for d; do
        d=${d%/}
        echo "> In $d/"
        for f in "$d"/*; do
            [[ -f $f ]] && { echo ">> $(basename $f)"; cat "$f"; }
        done

        if [[ $recursive ]]; then
            for f in "$d"/*; do
                [[ -d $f ]] && cat_dir -r "$f"
            done
        fi
    done
}
complete -o dirnames cat_dir

swap()
{
    local tmp ret=1
    while true; do
        [[ -e $1 || -e $2 ]] || break
        if ! [[ -e $1 && -e $2 ]]; then
            local existing new
            if [[ -e $1 ]]; then
                existing=$1
                new=$2
            else
                existing=$1
                new=$2
            fi

            if [[ -d $existing ]]; then
                mkdir "$new" || break
            else
                touch "$new" || break
            fi
        fi

        tmp=$(mktemp -dp "$(dirname "$1")") || break

        while true; do
            mv "$1" "$tmp" || break
            mv "$2" "$1" || break
            mv "$tmp/$(basename "$1")" "$2" || break
            ret=0
            break
        done

        rmdir "$tmp"
        break
    done

    return $ret
}

# print_binary <number> [<width of blocks in bits> [<min number of blocks>]]
print_binary()
{
    _need_nb_args $# 1 || return 1
    perl -E '
        my ($num, $width, $pad) = @ARGV; my @blocks;
        do { unshift @blocks, $num & ((1 << $width) - 1) } while $num >>= $width;
        printf "%0${width}b ", $_ for (0) x ($pad - @blocks), @blocks; say' \
            $(($1)) ${2:-8} ${3:-0}
    # Note: arithmetic evaluation of $1 automatically converts hex or octal
    # to decimal, otherwise we'd need to tell Perl which base is used
}

dl_files_recursive()
{
    _need_nb_args $# 1 || return 1
    wget -r --no-parent -nd --reject='*htm*' -e robots=off "$1"
}

exif_shift_time()
{
    local regex='(\+|-)([0-9]+)'
    [[ $1 =~ $regex ]] || { echo "Wrong format"; return 1; }
    local sign=${BASH_REMATCH[1]} value=${BASH_REMATCH[2]} i
    local -a args
    for attr in 'AllDates' 'ModifyDate' 'FileModifyDate'; do
        args+=(-${attr}${sign}=${value})
    done
    shift
    exiftool "${args[@]}" "$@"
}

ffmpeg_cut()
{
    [[ $# -ge 2 ]] || { echo "Usage: $FUNCNAME file [start]-[stop]..."; return 1; }

    local -i i=0
    local format='([0-9:]*)-([0-9:]*)'
    local arg
    local file=$1
    local dir=$(dirname "$file")
    local name=$(basename "$file")
    local ext=${name##*.}
    name=${name%.*}
    shift

    for arg; do
        [[ $arg =~ $format ]] || { echo "Invalid format: $arg"; return 1; }
    done

    mkdir -p /tmp/conv

    for arg; do
        [[ $arg =~ $format ]]
        local start=${BASH_REMATCH[1]} stop=${BASH_REMATCH[2]}
        ffmpeg ${start:+-ss $start} ${stop:+-to $stop} \
            -i "$file" -c copy -map_metadata 0 \
            /tmp/conv/${basename}_$((i++)).$ext ||
                return $?
    done

    mv "$file" "$dir/$name.orig.$ext"
    ffmpeg -f concat -safe 0 \
        -i <(printf "file %s\n" /tmp/conv/${basename}_*.$ext) -c copy -map_metadata 0 \
        "$file" ||
            return $?

    # Restore the original modification date.
    touch -r "$dir/$name.orig.$ext"  "$file"

    rm /tmp/conv/${basename}_*.$ext
}

pacman_size()
{
    _need_nb_args $# 1 || return 1
    pacman -Qql "$@" | grep -v '/$' | tr '\n' '\0' \
        | du -hc --files0-from=- | tail -n 1
}

pacman_ls()
{
    pacman -Qql "$@" | grep -v '/$' | xargs ls -lh --color
}

pacman_list()
{
    pacman --color always -Ql "$@" | grep -v ' /usr/share/locale'
}

_pacman_pkg_only() { local cur; _get_comp_words_by_ref cur; _pacman_pkg Qq; }
complete -F _pacman_pkg_only pacman_size pacman_ls pacman_list

# vim: set ts=4 sw=4 sts=4 et:
