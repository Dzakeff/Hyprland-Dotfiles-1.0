-- ############################################################
-- # modules/monitors.lua
-- # Place at: ~/.config/hypr/modules/monitors.lua
-- ############################################################

-- Default monitor: preferred resolution, auto position, scale 1
hl.monitor({
    output   = "eDP-1",
    mode     = "preferred",
    position = "0x0",
    scale    = "1",
})

hl.monitor({
    output   = "HDMI-A-1",
    mode     = "preferred",
    position = "1920x0",
    scale    = "1",
    -- mirror   = "eDP-1",
})

hl.monitor({
    output   = "DP-1",
    mode     = "preferred",
    position = "0x0",
    scale    = "1",
    -- mirror   = "eDP-1",
})
-- Workspaces pinned to eDP-1 (laptop screen)
-- hl.workspace({ id = 1, monitor = "eDP-1", persistent = true })
-- hl.workspace({ id = 2, monitor = "eDP-1", persistent = true })
-- hl.workspace({ id = 3, monitor = "eDP-1", persistent = true })
-- hl.workspace({ id = 4, monitor = "eDP-1", persistent = true })
-- hl.workspace({ id = 5, monitor = "eDP-1", persistent = true })
