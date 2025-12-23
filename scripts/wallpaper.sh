#!/usr/bin/env bash

WALLPAPER_DIR="$HOME/.dotfiles/wallpaper"
INTERVAL=300

if ! swww query &> /dev/null; then
    swww-daemon --format xrgb &
    wait $!
    sleep 1 
fi

while true; do
    RANDOM_IMG=$(find "$WALLPAPER_DIR" -type f | shuf -n 1)

    if [[ -n "$RANDOM_IMG" ]]; then
        swww img "$RANDOM_IMG" \
            --transition-type wave \
            --transition-fps 144 \
            --transition-duration 2 \
            --transition-angle 270 \
            --transition-wave 50,25
    fi

    sleep $INTERVAL
done
