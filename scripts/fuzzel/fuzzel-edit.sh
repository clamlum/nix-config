#!/usr/bin/env bash
set -euo pipefail

dir="${1:-$HOME}"

while true; do
    entries=$(
        printf '.\n'
        printf '..\n'
        printf '/\n'

        find "$dir" -maxdepth 1 -mindepth 1 -type d -printf '%f/\n' 2>/dev/null | sort

        find "$dir" -maxdepth 1 -mindepth 1 -type l -printf '%f\n' 2>/dev/null \
            | while read -r l; do [ -d "$dir/$l" ] && echo "$l/" || echo "$l"; done | sort

        find "$dir" -maxdepth 1 -mindepth 1 -type f -printf '%f\n' 2>/dev/null | sort
    )

    selected=$(
        printf '%s\n' "$entries" \
            | fuzzel --dmenu \
            --prompt="$(printf '%s' "$dir" | sed "s|$HOME|~|") ❯ " \
            --placeholder='Select file or folder' \
            --lines=10 \
            --width=50
    ) || exit 0

    if [[ "$selected" == "." ]]; then
            zeditor "$dir"
            exit 0
    elif [[ "$selected" == ".." ]]; then
            dir="$(dirname "$dir")"
            continue
    elif [[ "$selected" == "/" ]]; then
            dir="/"
            continue
    elif [[ "$selected" == */ ]]; then
            dir="$dir/${selected%/}"
    else
            zeditor "$dir/$selected"
            exit 0
    fi
done
