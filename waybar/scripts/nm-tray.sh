#!/bin/bash
# Kill existing nm-applet instance
pkill -x nm-applet 2>/dev/null

# Launch nm-applet tanpa autostart indicator
nm-applet --indicator &
NM_PID=$!

# Tunggu sebentar biar tray icon kebaca, terus langsung hide
sleep 0.5

# Kill nm-applet setelah user selesai (timeout 30s)
sleep 30 && kill $NM_PID 2>/dev/null &
