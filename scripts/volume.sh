#!/bin/bash

SINK_VOLUME=$(pactl get-sink-volume @DEFAULT_SINK@ | awk '{print $5}' | sed 's/%//')
SOURCE_VOLUME=$(pactl get-source-volume @DEFAULT_SOURCE@ | awk '{print $5}' | sed 's/%//')

adjust_sink_volume() {
    if [ "$1" == "--up" ]; then
        NEW_SINK_VOLUME=$(($SINK_VOLUME + 5))
        if [ "$NEW_SINK_VOLUME" -le 100 ]; then
            pactl set-sink-volume @DEFAULT_SINK@ +5%
        else
            pactl set-sink-volume @DEFAULT_SINK@ 100%
        fi
    elif [ "$1" == "--down" ]; then
        NEW_SINK_VOLUME=$(($SINK_VOLUME - 5))
        if [ "$NEW_SINK_VOLUME" -ge 0 ]; then
            pactl set-sink-volume @DEFAULT_SINK@ -5%
        else
            pactl set-sink-volume @DEFAULT_SINK@ 0%
        fi
    fi
}

adjust_source_volume() {
    if [ "$1" == "--up" ]; then
        NEW_SOURCE_VOLUME=$(($SOURCE_VOLUME + 5))
        if [ "$NEW_SOURCE_VOLUME" -le 100 ]; then
            pactl set-source-volume @DEFAULT_SOURCE@ +5%
        else
            pactl set-source-volume @DEFAULT_SOURCE@ 100%
        fi
    elif [ "$1" == "--down" ]; then
        NEW_SOURCE_VOLUME=$(($SOURCE_VOLUME - 5))
        if [ "$NEW_SOURCE_VOLUME" -ge 0 ]; then
            pactl set-source-volume @DEFAULT_SOURCE@ -5%
        else
            pactl set-source-volume @DEFAULT_SOURCE@ 0%
        fi
    fi
}

if [ "$1" == "sink" ]; then
    adjust_sink_volume "$2"
elif [ "$1" == "source" ]; then
    adjust_source_volume "$2"
else
    echo "Usage: $0 {sink|source} --up|--down"
    exit 1
fi
