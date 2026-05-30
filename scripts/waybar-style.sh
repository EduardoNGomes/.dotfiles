#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
dotfiles_dir="$(cd -- "$script_dir/.." && pwd)"
waybar_dir="$dotfiles_dir/waybar"
styles_dir="$waybar_dir/styles"
state_file="$waybar_dir/.style-current"

usage() {
    printf 'Usage: %s [natural|pill|toggle]\n' "$(basename "$0")" >&2
}

current_style() {
    if [[ -f "$state_file" ]]; then
        cat "$state_file"
    else
        printf 'natural\n'
    fi
}

style="${1:-toggle}"

case "$style" in
    toggle)
        case "$(current_style)" in
            natural) style="pill" ;;
            *) style="natural" ;;
        esac
        ;;
    natural|pill)
        ;;
    *)
        usage
        exit 2
        ;;
esac

cp "$styles_dir/$style.css" "$waybar_dir/style.css"
printf '%s\n' "$style" > "$state_file"

if pgrep -x waybar >/dev/null; then
    pkill -SIGUSR2 waybar
fi

printf 'Waybar style: %s\n' "$style"
