#!/usr/bin/env bash

pgrep -f $(basename "$0") | grep -v $$ | xargs kill 2>/dev/null

WALLPAPER_DIR="$HOME/.dotfiles/wallpaper"
DEFAULT_WALLPAPER="$WALLPAPER_DIR/sanji.webp"
INTERVAL=600

TRANSITION_TYPE="wave"
TRANSITION_FPS=144
TRANSITION_DURATION=2
TRANSITION_ANGLE=270
TRANSITION_WAVE="50,25"

if ! swww query &> /dev/null; then
    swww-daemon --format xrgb &
    sleep 1
fi

default_mode=0
menu_mode=0

while [[ $# -gt 0 ]]; do
  case "$1" in
    -d|--default) default_mode=1; shift ;;
    -m|--menu)    menu_mode=1;    shift ;;
    *) break ;;
  esac
done

if (( default_mode )); then
  [[ -f "$DEFAULT_WALLPAPER" ]] \
    || { echo "Default wallpaper not found: $DEFAULT_WALLPAPER"; exit 1; }
  wallpaper="$DEFAULT_WALLPAPER"

else
  mapfile -t images < <(find "$WALLPAPER_DIR" -maxdepth 1 -type f | sort)
  (( ${#images[@]} > 0 )) \
    || { echo "No wallpapers found in $WALLPAPER_DIR"; exit 1; }

  if (( menu_mode )); then
    selection=$(
      printf '%s\n' "${images[@]}" \
        | vicinae dmenu -p "Select a wallpaper..."
    )

    [[ -n "${selection// }" ]] || exit 0

    wallpaper="$selection"

  else
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

		  sleep "$INTERVAL"
	  done
  fi
fi

swww img "$wallpaper" \
  --transition-type     "$TRANSITION_TYPE" \
  --transition-fps      "$TRANSITION_FPS" \
  --transition-duration "$TRANSITION_DURATION" \
  --transition-angle    "$TRANSITION_ANGLE" \
  --transition-wave     "$TRANSITION_WAVE"
