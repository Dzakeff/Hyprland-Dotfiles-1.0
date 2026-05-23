hl.config({
    general = {
        gaps_in              = 8,
        gaps_out             = 18,
        border_size          = 2,
        col = {
        active_border = { colors = {"rgba(a7c080ff)", "rgba(384b55ff)"}, angle = 225 },
        inactive_border = "rgba(3a464cff)",
        },
        resize_on_border     = false,
        allow_tearing        = false,
        layout               = "dwindle",
    },

    decoration = {
        rounding             = 14,
        rounding_power       = 3,
        active_opacity       = 1.0,
        inactive_opacity     = 1.0,
        shadow = {
            enabled          = true,
            range            = 4,
            render_power     = 2,
            color            = "rgba(1a1a1aee)",
        },
        blur = {
            enabled          = true,
            size             = 3,
            passes           = 1,
            vibrancy         = 0.1696,
        },
    },

    master = {
        new_status = "master",
    },

    misc = {
        force_default_wallpaper  = 0,
        disable_hyprland_logo    = false,
    },
})