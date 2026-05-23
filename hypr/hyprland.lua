-- ############################################################
-- # hyprland.lua — Main Config (converted from hyprland.conf)
-- # Place at: ~/.config/hypr/hyprland.lua
-- ############################################################

-- Import Config Modules
require("modules/monitors")
require("modules/env")
require("modules/animations")
require("modules/autostarts")
require("modules/windowrules")
require("modules/binds")
require("modules/inputs")
require("modules/decorations")

-- Import HyprMod managed settings
-- require("modules/hyprland-gui")

-- HyprMod managed settings
dofile("/home/dzakeff/.config/hypr/modules/hyprland-gui.lua")
