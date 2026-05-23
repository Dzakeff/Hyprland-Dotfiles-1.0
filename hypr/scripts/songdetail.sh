#!/bin/bash

# Ambil player yang lagi aktif
PLAYER=$(playerctl -l 2>/dev/null | head -1)

if [ -z "$PLAYER" ]; then
    echo "󰝛 nothing playing"
    exit 0
fi

STATUS=$(playerctl --player="$PLAYER" status 2>/dev/null)

if [ "$STATUS" != "Playing" ] && [ "$STATUS" != "Paused" ]; then
    echo "󰝛 nothing playing"
    exit 0
fi

TITLE=$(playerctl --player="$PLAYER" metadata title 2>/dev/null)
ARTIST=$(playerctl --player="$PLAYER" metadata artist 2>/dev/null)
URL=$(playerctl --player="$PLAYER" metadata xesam:url 2>/dev/null)

# Icon berdasarkan player/source
case "$PLAYER" in
    *spotify*)
        ICON="󰓇"
        ;;
    *firefox*|*zen*|*chrome*|*chromium*|*msedge*|*edge*)
        case "$URL" in
            *youtube.com*|*youtu.be*)
                ICON="󰗃"        # YouTube (semua browser)
                ;;
            *)
                case "$PLAYER" in
                    *msedge*|*edge*)     ICON="󰇩" ;;   # Edge
                    *chrome*|*chromium*) ICON="󰊯" ;;   # Chrome
                    *firefox*|*zen*)     ICON="" ;;
                    *)                   ICON="󰖟" ;;  
                esac
                ;;
        esac
        ;;
    *vlc*)           ICON="󰕼" ;;
    *mpv*)           ICON="󰐊" ;;
    *rhythmbox*)     ICON="󰓇" ;;
    *cmus*)          ICON="󱑽" ;;
    *ncmpcpp*|*mpd*) ICON="󰝚" ;;
    *strawberry*)    ICON="󰓇" ;;
    *)               ICON="󰎈" ;;
esac

# Pause indicator
if [ "$STATUS" = "Paused" ]; then
    PAUSE=" 󰏤"
else
    PAUSE=""
fi

# Truncate kalau terlalu panjang
MAX=35
if [ ${#TITLE} -gt $MAX ]; then
    TITLE="${TITLE:0:$MAX}..."
fi

if [ -n "$ARTIST" ]; then
    echo "$ICON $TITLE — $ARTIST$PAUSE"
else
    echo "$ICON $TITLE$PAUSE"
fi