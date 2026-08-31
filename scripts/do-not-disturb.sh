#!/usr/bin/env bash

set -u

runtime_dir="${XDG_RUNTIME_DIR:-/tmp}"
legacy_audio_state_file="$runtime_dir/waybar-do-not-disturb-audio-${UID}.state"
lock_file="$runtime_dir/waybar-do-not-disturb-${UID}.lock"

exec 9>"$lock_file"
flock 9

unavailable() {
    printf '{"text":"󰂚","tooltip":"Do not disturb is unavailable","class":"unavailable"}\n'
}

restore_legacy_audio_state() {
    local sink previous_mute

    [[ -f "$legacy_audio_state_file" ]] || return 0
    command -v pactl >/dev/null 2>&1 || return 1
    pactl info >/dev/null 2>&1 || return 1

    while IFS=$'\t' read -r sink previous_mute; do
        [[ -n "$sink" && -n "$previous_mute" ]] || continue
        pactl set-sink-mute "$sink" "$previous_mute" >/dev/null 2>&1 || true
    done < "$legacy_audio_state_file"

    rm -f -- "$legacy_audio_state_file"
}

restore_legacy_audio_state || true

if ! command -v dunstctl >/dev/null 2>&1; then
    unavailable
    exit 0
fi

if ! paused="$(dunstctl is-paused 2>/dev/null)"; then
    unavailable
    exit 0
fi

case "${1:-status}" in
    toggle)
        if [[ "$paused" == "true" ]]; then
            if dunstctl set-paused false >/dev/null 2>&1; then
                paused=false
            fi
        elif dunstctl set-paused true >/dev/null 2>&1; then
            dunstctl close-all >/dev/null 2>&1 || true
            paused=true
        fi
        ;;
    status)
        ;;
    *)
        printf 'Usage: %s [status|toggle]\n' "$(basename "$0")" >&2
        exit 2
        ;;
esac

if [[ "$paused" == "true" ]]; then
    printf '{"text":"󰂛","tooltip":"Do not disturb: enabled","class":"enabled"}\n'
else
    printf '{"text":"󰂚","tooltip":"Do not disturb: disabled","class":"disabled"}\n'
fi
