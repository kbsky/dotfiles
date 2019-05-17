#!/bin/bash
. ~/lib/bash-run-in-terminal.sh

date_format='%Y-%m-%d_%H-%M-%S'

movs=()
others=()

for f; do
    [[ ${f,,} == *.mov ]] && movs+=("$f") || others+=("$f")
done

[[ ${#others[@]} -ne 0 ]] && \
    exiftool -FileName'<${DateTimeOriginal}.%e' -d "$date_format" "${others[@]}"
[[ ${#movs[@]} -ne 0 ]] && \
    exiftool -FileName'<${CreateDate}.%e' -d "$date_format" "${movs[@]}"

read_if_transient_term
