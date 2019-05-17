readarray -t files <<<"${NEMO_SCRIPT_SELECTED_FILE_PATHS%$'\n'}"
exec ~/bin/$(basename "$0").sh "${files[@]}"
