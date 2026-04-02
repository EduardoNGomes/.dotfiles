#!/usr/bin/env bash

set -u

terminal_cmd=(kitty)
terminal_classes='^(kitty|Alacritty|foot|org\.wezfurlong\.wezterm|com\.mitchellh\.ghostty)$'
priority_procs='^(zsh|bash|fish|sh|tmux|nvim|vim|vi|hx|helix|lf|yazi|ranger|nnn)$'
terminal_procs='^(kitty|alacritty|foot|ghostty|wezterm-gui|wezterm)$'

launch_default() {
    exec "${terminal_cmd[@]}"
}

proc_cwd() {
    local pid="$1"
    local cwd

    [[ -L "/proc/$pid/cwd" ]] || return 1
    cwd="$(readlink -f "/proc/$pid/cwd" 2>/dev/null)" || return 1
    [[ -d "$cwd" ]] || return 1

    printf '%s\n' "$cwd"
}

proc_comm() {
    local pid="$1"

    [[ -r "/proc/$pid/comm" ]] || return 1
    tr -d '\n' < "/proc/$pid/comm"
}

list_descendants() {
    local root_pid="$1"
    local -a queue=("$root_pid")
    local current
    local child

    while ((${#queue[@]})); do
        current="${queue[0]}"
        queue=("${queue[@]:1}")

        while read -r child; do
            [[ -n "$child" ]] || continue
            printf '%s\n' "$child"
            queue+=("$child")
        done < <(pgrep -P "$current" 2>/dev/null || true)
    done
}

resolve_terminal_cwd() {
    local terminal_pid="$1"
    local descendants
    local pid
    local comm
    local cwd

    descendants="$(list_descendants "$terminal_pid" | sort -nr | uniq)" || descendants=""

    while read -r pid; do
        [[ -n "$pid" ]] || continue
        comm="$(proc_comm "$pid" 2>/dev/null || true)"
        [[ "$comm" =~ $priority_procs ]] || continue
        cwd="$(proc_cwd "$pid" 2>/dev/null || true)"
        [[ -n "$cwd" ]] || continue
        printf '%s\n' "$cwd"
        return 0
    done <<< "$descendants"

    while read -r pid; do
        [[ -n "$pid" ]] || continue
        comm="$(proc_comm "$pid" 2>/dev/null || true)"
        [[ "$comm" =~ $terminal_procs ]] && continue
        cwd="$(proc_cwd "$pid" 2>/dev/null || true)"
        [[ -n "$cwd" ]] || continue
        printf '%s\n' "$cwd"
        return 0
    done <<< "$descendants"

    return 1
}

main() {
    local active_json
    local class
    local pid
    local cwd

    active_json="$(hyprctl -j activewindow 2>/dev/null)" || launch_default

    class="$(jq -r '.class // empty' <<< "$active_json")"
    pid="$(jq -r '.pid // empty' <<< "$active_json")"

    [[ -n "$class" ]] || launch_default
    [[ "$class" =~ $terminal_classes ]] || launch_default
    [[ "$pid" =~ ^[0-9]+$ ]] || launch_default

    cwd="$(resolve_terminal_cwd "$pid" 2>/dev/null || true)"
    [[ -n "$cwd" ]] || launch_default

    exec "${terminal_cmd[@]}" --directory "$cwd"
}

main "$@"
