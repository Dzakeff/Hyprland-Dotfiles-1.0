-- ############################################################
-- # modules/binds.lua
-- # Place at: ~/.config/hypr/modules/binds.lua
-- ############################################################

local mainMod     = "SUPER"
local terminal    = "kitty"
local fileManager = "nautilus"
local menu        = "~/.config/rofi/launchers/type-6/launcher.sh"

-- #####################
-- ### CORE KEYBINDS ###
-- #####################

hl.bind(mainMod .. " + Return",   hl.dsp.exec_cmd(terminal))
local closeWindowBind = hl.bind(mainMod .. " + W", hl.dsp.window.close())
-- hl.bind(mainMod .. " + M",        hl.dsp.exec_cmd("exit"))
hl.bind(mainMod .. " + E",        hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + F",        hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + D",        hl.dsp.exec_cmd(menu .. " || pkill rofi"))
hl.bind(mainMod .. " + J",        hl.dsp.layout("togglesplit"))  -- dwindle
hl.bind(mainMod .. " + R",        hl.dsp.exec_cmd("~/.config/waybar/scripts/launch.sh"))

-- Theme Switcher
hl.bind(mainMod .. " + SHIFT + T",hl.dsp.exec_cmd("~/.config/colorschemes/theme-switcher.sh"))

-- Lock Screen
hl.bind(mainMod .. " + L",        hl.dsp.exec_cmd("hyprlock -c ~/.config/hypr/hyprlock/hyprlock.conf"))

-- Zen Browser (from hyprland-gui.conf / HyprMod)
hl.bind(mainMod .. " + B",        hl.dsp.exec_cmd("zen-browser"))

-- Move focus with arrow keys
hl.bind(mainMod .. " + left",     hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right",    hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up",       hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down",     hl.dsp.focus({ direction = "down" }))

-- Switch workspaces 1–10
for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind(mainMod .. " + " .. key,             hl.dsp.focus({ workspace = i}))
    hl.bind(mainMod .. " + SHIFT + " .. key,     hl.dsp.window.move({ workspace = i }))
end

-- Example special workspace (scratchpad)
hl.bind(mainMod .. " + S",         hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- Scroll through existing workspaces with mainMod + scrol
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- ######################
-- ### MULTIMEDIA KEYS ###
-- ######################

-- Laptop multimedia keys for volume and LCD brightness
hl.bind("XF86AudioRaiseVolume",         hl.dsp.exec_cmd("~/.config/hypr/scripts/volume.sh --inc"),       	{ locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume",         hl.dsp.exec_cmd("~/.config/hypr/scripts/volume.sh --dec"),       	{ locked = true, repeating = true })
hl.bind("XF86AudioMute",                hl.dsp.exec_cmd("~/.config/hypr/scripts/volume.sh --toggle"),    	{ locked = true, repeating = true })
hl.bind("XF86AudioMicMute",             hl.dsp.exec_cmd("~/.config/hypr/scripts/volume.sh --toggle-mic"),	{ locked = true, repeating = true })
hl.bind("ALT + XF86AudioRaiseVolume",   hl.dsp.exec_cmd("~/.config/hypr/scripts/volume.sh --mic-inc"),      { locked = true, repeating = true })
hl.bind("ALT + XF86AudioLowerVolume",   hl.dsp.exec_cmd("~/.config/hypr/scripts/volume.sh --mic-dec"),      { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp",          hl.dsp.exec_cmd("~/.config/hypr/scripts/brightness.sh --inc"),		{ locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown",        hl.dsp.exec_cmd("~/.config/hypr/scripts/brightness.sh --dec"),		{ locked = true, repeating = true })

-- Requires playerctl
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })

-- Wlogout
hl.bind("XF86PowerOff",           hl.dsp.exec_cmd("wlogout --protocol layer-shell"), { locked = true })
hl.bind(mainMod .. " + X",          hl.dsp.exec_cmd("wlogout"))
-- hl.bind(mainMod .. " + SHIFT + Q",  hl.dsp.exec_cmd("wlogout --protocol layer-shell"))

-- Laptop Lid: disable/enable eDP-1
hl.bind("switch:on:Lid Switch",   hl.dsp.exec_cmd('hyprctl keyword monitor "eDP-1,disable"'),            { locked = true })
hl.bind("switch:off:Lid Switch",  hl.dsp.exec_cmd('hyprctl keyword monitor "eDP-1,preferred,auto,1"'),   { locked = true })

-- #######################
-- ### CLIPBOARD & MISC ###
-- #######################

-- Clipboard history via rofi
hl.bind(mainMod .. " + V", hl.dsp.exec_cmd(
    'cliphist list | ~/.config/rofi/launchers/type-1/menus.sh | cliphist decode | wl-copy'))

-- Screenshot: full output
hl.bind("Print",        hl.dsp.exec_cmd("hyprshot -m output -m eDP-1 --clipboard-only"), { repeat_ = true })

-- Screenshot: region → satty
hl.bind("SHIFT + Print", hl.dsp.exec_cmd("hyprshot -m region --raw | satty --filename -"), { repeat_ = true })
