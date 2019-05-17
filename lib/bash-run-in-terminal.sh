if [[ -t 0 ]]; then
    type -t read_if_transient_term >/dev/null || read_if_transient_term() { :; }
else
    preferred_terms=(gnome-terminal xfce4-terminal)
    terminals=($(find /bin/ -name '*terminal' -printf '%f '))

    term=

    for t in "${preferred_terms[@]}"; do
        [[ -x "/bin/$t" ]] && { term=$t; break; }
    done

    if [[ -z $term ]]; then
        term=$(find /bin/ -name '*terminal' -printf '%f' -quit)
        [[ -n $term ]] || exit 1
    fi

    read_if_transient_term()
    {
        read "$@"
    }
    export -f read_if_transient_term
    exec "$term" -- env bash "$0" "$@"
fi
