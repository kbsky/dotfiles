#!/bin/bash

subtitle_edit_path="$HOME/.wine2/drive_c/Program Files/Subtitle Edit/SubtitleEdit.exe"

tmpdir=$(mktemp -d -p "/tmp")
trap 'rm -r $tmpdir; read;' INT EXIT

set -x
for mkv; do
    if [[ $mkv != *.mkv ]]; then
        echo "$mkv: not an MKV!"
        continue
    fi

    if [[ -v TRACK_NR ]]; then
        track_nr=$TRACK_NR
    else
        track_nr=$(mkvinfo -s "$mkv" | head -n 20 | awk '/PGS/ { print $NF; exit }')
        if [[ -z $track_nr ]]; then
            echo "$mkv: no PGS track found"
            continue
        fi
    fi

    mkvextract tracks "$mkv" "$track_nr:$tmpdir/sub.pgs" || exit $?
    WINEPREFIX="$HOME/.wine2" wine "$subtitle_edit_path" \
        /convert "$tmpdir/sub.pgs" subrip /outputfolder:"Z:\\tmp\\${tmpdir#/tmp/}"
    mv "$tmpdir/sub.srt" "${mkv%.mkv}.srt"
done
