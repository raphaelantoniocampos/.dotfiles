#!/bin/bash

WALLPAPER_DIR="$HOME/Pictures/wallpapers/"

if [[ "$1" == "random" ]]; then
       IMAGE=$(find "$WALLPAPER_DIR" \
        -type f \
        -not -path '*/.*' | shuf -n 1) 

    if [ -z "$IMAGE" ]; then
        notify-send "Error" "No wallpapers found in the directory."
        exit 1
    fi
else
    SELECTED=$(imv -n 1 "$WALLPAPER_DIR")

    if [ -n "$SELECTED" ]; then
        IMAGE=$(echo "$SELECTED" | tail -n 1)
    else
        notify-send "Selection Canceled" "No wallpaper was selected."
        exit 0
    fi
fi

matugen image "$IMAGE" --prefer value
notify-send "Changed Wallpaper" "Themes successfully updated para: $(basename "$IMAGE")"
exit 0
