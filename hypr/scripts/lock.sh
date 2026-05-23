#!/bin/bash

RAW=$(cat ~/.cache/awww/0.12.0/eDP-1)

WALL=$(echo "$RAW" | sed 's/^.*\/home/\/home/' | sed 's/%$//')

cp "$WALL" ~/.cache/hyprlock_wallpaper.png

hyprlock -c ~/.config/hypr/hyprlock/hyprlock.conf
