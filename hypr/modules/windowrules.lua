-- ############################################################
-- # modules/windowrules.lua
-- # Place at: ~/.config/hypr/modules/windowrules.lua
-- ############################################################

-- Ignore maximize requests from all apps
hl.window_rule({
    name           = "suppress-maximize-events",
    match          = { class = ".*" },
    suppress_event = "maximize",
})

-- Fix some dragging issues with XWayland
hl.window_rule({
    name     = "fix-xwayland-drags",
    match    = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },
    no_focus = true,
})

-- Hyprland-run window: float and pin to bottom-left
hl.window_rule({
    name  = "move-hyprland-run",
    match = { class = "hyprland-run" },
    move  = { "20", "monitor_h-120" },
    float = true,
})

-- ##################
-- ### LAYER RULES ###
-- ##################

-- Waybar: blur + fade animation
hl.layer_rule({ match = { namespace = "waybar" }, blur = true, ignore_alpha = 0.5 })
hl.layer_rule({ match = { namespace = "waybar" }, animation = "fade" })

-- Swaync: blur notification windows
hl.layer_rule({ match = { namespace = "swaync-control-center" }, blur = true, ignore_alpha = 0.5 })
hl.layer_rule({ match = { namespace = "swaync-notification-window" }, blur = true, ignore_alpha = 0.5 })

-- wlogout: blur + fade
hl.layer_rule({ match = { namespace = "logout_dialog" }, animation = "fade", blur = true })

-- Rofi: popin animation
hl.layer_rule({
    name = "rofi-popup",
    match = { namespace = "rofi" },
    animation = "popin 95%",
    dim_around = true

})

-- Dashboard: slide from left, no blur
hl.layer_rule({
    name      = "dashboard-rules",
    match     = { namespace = "dashboard" },
    animation = "slide left",
    blur      = false,
})

-- Instant eyedropper
hl.layer_rule({ match = { namespace = "ie-r" }, animation = "fade" })

-- Fuzzel launcher: no animation
hl.layer_rule({ match = { namespace = "launcher" }, no_anim = true })
