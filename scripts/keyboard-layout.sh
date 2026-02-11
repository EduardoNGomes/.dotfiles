#!/bin/bash

PROFILE_PATH="$HOME/.dotfiles/fcitx5/profile"
INPUT_METHODS=$(grep -oP '(?<=Name=).*' "$PROFILE_PATH" | grep -v '^Default$')
CURRENT_METHOD=$(fcitx5-remote -n)
METHODS_ARRAY=($INPUT_METHODS)
CURRENT_INDEX=-1

for i in "${!METHODS_ARRAY[@]}"; do
    if [[ "${METHODS_ARRAY[i]}" == "$CURRENT_METHOD" ]]; then
        CURRENT_INDEX=$i
        break
    fi
done

NEXT_INDEX=$(( (CURRENT_INDEX + 1) % ${#METHODS_ARRAY[@]} ))
NEXT_METHOD=${METHODS_ARRAY[NEXT_INDEX]}

fcitx5-remote -s "$NEXT_METHOD"
