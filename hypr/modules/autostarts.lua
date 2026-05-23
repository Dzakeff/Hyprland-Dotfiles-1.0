-- ############################################################
-- # modules/autostarts.lua
-- # Place at: ~/.config/hypr/modules/autostarts.lua
-- ############################################################

hl.on("hyprland.start", function ()

-- Wallpaper Switcher
hl.exec_cmd("awww-daemon")

-- Waybar
hl.exec_cmd("waybar")

-- Notification daemon
hl.exec_cmd("swaync")

-- Polkit Agent
hl.exec_cmd("/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1")

-- Clipboard manager
hl.exec_cmd("wl-paste --type text --watch cliphist store")
hl.exec_cmd("wl-paste --type image --watch cliphist store")

-- Idle daemon
hl.exec_cmd("hypridle")

-- OneDrive GUI
hl.exec_cmd("onedrivegui")

-- Dolphin / KDE service cache
-- hl.exec_cmd("kbuildsycoca6")

-- Root XDisplay Priviledges
hl.exec_cmd("xhost +SI:localuser:root")

-- sunshine
hl.exec_cmd("sunshine")

end)
