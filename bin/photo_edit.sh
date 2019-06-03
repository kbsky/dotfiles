#!/bin/bash
. ~/lib/bash-run-in-terminal.sh

for img; do
    wait=y
    [[ $img =~ (.*)\.(JPG|ORF) ]] || { echo "Skipping $img: not a JPG/ORF"; continue; }
    base=${BASH_REMATCH[1]}
    jpg="$base.JPG"
    orf="$base.ORF"
    if [[ -f $orf ]]; then
        if [[ -f $jpg ]]; then
            orig_jpg="${BASH_REMATCH[1]}_orig.JPG"
            [[ -e $orig_jpg ]] && { echo "$orig_jpg already exists, skipping $img"; continue; }
            cp "$jpg" "$orig_jpg"
        fi
        rawtherapee "$orf"
        if [[ -v orig_jpg ]]; then
            if diff -q "$orig_jpg" "$jpg" >/dev/null; then
                # Unchanged
                rm "$orig_jpg"
            else
                xnviewmp "$orig_jpg" "$jpg" >/dev/null 2>&1
            fi
        fi
    else
        orig="${BASH_REMATCH[1]}_orig.JPG"
        [[ -e $orig ]] && { echo "$orig already exists, skipping $img"; continue; }
        cp "$img" "$orig"
        chmod -w "$orig"
        rawtherapee "$orig"
        read -p "Keep the edit? [Y/n] > "
        if [[ ${REPLY,} != ?(y) ]]; then
            mv "$orig" "$img"
            rm "${orig}.pp3"
            chmod +w "$img"
        fi
    fi
    wait=
done

[[ -n $wait ]] && read_if_transient_term
