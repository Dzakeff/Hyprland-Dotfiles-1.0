#!/bin/bash

WALL=$(cat ~/.cache/awww/0.12.0/eDP-1)

cp "$WALL" ~/.cache/awww/current_wallpaper.png

hyprlock
