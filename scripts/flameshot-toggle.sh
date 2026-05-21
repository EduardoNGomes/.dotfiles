#!/usr/bin/env bash

# Toggle flameshot screenshot:
#  - If the portal monitor picker (spawned by flameshot) or the flameshot
#    overlay is already open, close it.
#  - Otherwise launch `flameshot gui` and float+center the picker when it
#    appears, so it doesn't open tiled.

portal_query='.[] | select(
    (.class | test("xdg-desktop-portal"; "i"))
    or (.class | test("flameshot"; "i"))
) | .address'

mapfile -t addrs < <(hyprctl clients -j | jq -r "$portal_query")

if (( ${#addrs[@]} > 0 )); then
    for addr in "${addrs[@]}"; do
        hyprctl dispatch closewindow "address:$addr" >/dev/null
    done
    exit 0
fi

flameshot gui &

# Wait for the portal picker to show up, then float + center it.
for _ in {1..40}; do
    addr=$(hyprctl clients -j | jq -r "$portal_query" | head -n1)
    if [[ -n "$addr" ]]; then
        hyprctl dispatch setfloating "address:$addr" >/dev/null
        hyprctl dispatch centerwindow >/dev/null
        break
    fi
    sleep 0.05
done
