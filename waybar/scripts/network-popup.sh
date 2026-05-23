#!/bin/bash

# Get current WiFi info
CURRENT_SSID=$(nmcli -t -f active,ssid dev wifi | grep '^yes' | cut -d: -f2)
CURRENT_IP=$(nmcli -t -f IP4.ADDRESS dev show wlp2s0 2>/dev/null | head -1 | cut -d: -f2)
WIFI_ENABLED=$(nmcli radio wifi)

# Build menu items
ITEMS=""

# Header info
if [ -n "$CURRENT_SSID" ]; then
    ITEMS+="  $CURRENT_SSID\n"
    ITEMS+="  Disconnect\n"
else
    ITEMS+="  Wi-Fi disconnected\n"
fi

ITEMS+="  Available Networks\n"
ITEMS+="  Connect to Hidden Network...\n"
ITEMS+="  Create New Wi-Fi Network...\n"
ITEMS+="  VPN Connections\n"

if [ "$WIFI_ENABLED" = "enabled" ]; then
    ITEMS+="  Disable Wi-Fi\n"
else
    ITEMS+="  Enable Wi-Fi\n"
fi

ITEMS+="  Enable Networking\n"
ITEMS+="  Connection Information\n"
ITEMS+="  Edit Connections..."

# Show rofi menu — anchored top-right
CHOICE=$(echo -e "$ITEMS" | rofi -dmenu \
    -theme-str '
    window {
        location: northeast;
        anchor: northeast;
        x-offset: -10px;
        y-offset: 50px;
        width: 280px;
        border-radius: 8px;
    }
    listview {
        lines: 12;
        fixed-height: false;
    }
    inputbar { enabled: false; }
    prompt { enabled: false; }
    ' \
    -p "" \
    -no-custom)

# Handle selection
case "$CHOICE" in
    *"Disconnect"*)
        nmcli dev disconnect wlp2s0
        ;;
    *"Available Networks"*)
        # Scan dan tampilin list WiFi
        NETWORKS=$(nmcli -t -f ssid,signal,security dev wifi list | \
            awk -F: '{printf "  %-30s %s%% %s\n", $1, $2, $3}')
        SELECTED=$(echo "$NETWORKS" | rofi -dmenu \
            -theme-str '
            window {
                location: northeast;
                anchor: northeast;
                x-offset: -10px;
                y-offset: 50px;
                width: 350px;
                border-radius: 8px;
            }
            inputbar { enabled: false; }
            ' \
            -p "WiFi Networks")
        if [ -n "$SELECTED" ]; then
            SSID=$(echo "$SELECTED" | awk '{print $2}')
            nmcli dev wifi connect "$SSID"
        fi
        ;;
    *"Enable Wi-Fi"*)
        nmcli radio wifi on
        ;;
    *"Disable Wi-Fi"*)
        nmcli radio wifi off
        ;;
    *"Edit Connections"*)
        nm-connection-editor &
        ;;
    *"Connection Information"*)
        notify-send "Network Info" "SSID: $CURRENT_SSID\nIP: $CURRENT_IP"
        ;;
    *"Connect to Hidden"*)
        SSID=$(rofi -dmenu -p "SSID:")
        if [ -n "$SSID" ]; then
            nmcli dev wifi connect "$SSID"
        fi
        ;;
esac
