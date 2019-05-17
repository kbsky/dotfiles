#!/bin/bash
. ~/lib/bash-run-in-terminal.sh

raws_to_delete=()

for img; do
    [[ $img == *.ORF ]] || continue
    side_files=("${img%.ORF}".*)
    if [[ ${#side_files[@]} -eq 1 ]]; then
        echo "  $img"
        raws_to_delete+=("$img")
    fi
done

if [[ ${#raws_to_delete[@]} -ne 0 ]]; then
    size=$(du -hc "${raws_to_delete[@]}" | tail -n 1 | cut -d$'\t' -f1)
    read -p "Delete ${#raws_to_delete[@]} files ($size) [y/N] > "
    if [[ ${REPLY,} == y ]]; then
        rm "${raws_to_delete[@]}"
    fi
else
    echo "Nothing to delete"
    read_if_transient_term
fi
