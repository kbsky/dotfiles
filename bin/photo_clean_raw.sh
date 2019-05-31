#!/bin/bash
. ~/lib/bash-run-in-terminal.sh

raws_to_delete=()
pp3s_to_delete=()

for img; do
    [[ $img == *.ORF ]] || continue
    if ! compgen -G "${img%.ORF}*.JPG" > /dev/null; then
        echo "  $img"
        raws_to_delete+=("$img")
        [[ -f "${img}.pp3" ]] && pp3s_to_delete+=("${img}.pp3")
    fi
done

if [[ ${#raws_to_delete[@]} -ne 0 ]]; then
    size=$(du -hc "${raws_to_delete[@]}" | tail -n 1 | cut -d$'\t' -f1)
    read -p "Delete ${#raws_to_delete[@]} files ($size) [y/N] > "
    if [[ ${REPLY,} == y ]]; then
        rm "${raws_to_delete[@]}"
        [[ -v pp3s_to_delete ]] && rm "${pp3s_to_delete[@]}"
    fi
else
    echo "Nothing to delete"
    read_if_transient_term
fi
