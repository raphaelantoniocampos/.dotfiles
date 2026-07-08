#!/bin/sh

SND_ON="/usr/share/sounds/freedesktop/stereo/device-added.oga"
SND_OFF="/usr/share/sounds/freedesktop/stereo/device-removed.oga"

TARGET=$1
if [[ "$TARGET" == "sink" ]]; then
    NODE="@DEFAULT_AUDIO_SINK@"
    LABEL="Volume"
    ICON_MUTED=""
    ICON_UNMUTED=" "
else
    NODE="@DEFAULT_AUDIO_SOURCE@"
    LABEL="Mic"
    ICON_MUTED=" "
    ICON_UNMUTED=""
fi

# toggle mute
wpctl set-mute "$NODE" toggle

# Get current status
STATE=$(wpctl get-volume "$NODE")

if [[ "$STATE" == *"[MUTED]"* ]]; then
    notify-send -u critical -t 2000 "$LABEL: MUTED $ICON_MUTED"
else
    notify-send -u low -t 2000 "$LABEL: UNMUTED $ICON_UNMUTED"
fi
