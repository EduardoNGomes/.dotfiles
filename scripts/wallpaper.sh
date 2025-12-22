#!/usr/bin/env bash

WALLPAPER_DIR="$HOME/.dotfiles/wallpaper"
INTERVAL=300 

swww query || swww-daemon --format xrgb

while true; do
    RANDOM_IMG=$(find "$WALLPAPER_DIR" -type f | shuf -n 1)

    swww img "$RANDOM_IMG" \
        --transition-type wave \
        --transition-fps 144 \
        --transition-duration 2 \
        --transition-angle 270 \
        --transition-wave 50,25
    sleep $INTERVAL
done
