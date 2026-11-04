-- Theme specific settings

local GTK_THEME = "Catppuccin-Mocha"
local ICON_THEME = "Tela-circle-dracula"
local COLOR_SCHEME = "prefer-dark"

hl.layer_rule({
    match = { namespace = "waybar" },
    blur = true,
})

hl.config({
    general = {
        gaps_in = 3,
        gaps_out = 8,
        border_size = 2,
        col = {
            active_border = { colors = { "rgba(ca9ee6ff)", "rgba(f2d5cfff)" }, angle = 45 },
            inactive_border = { colors = { "rgba(b4befecc)", "rgba(6c7086cc)" }, angle = 45 },
        },
        layout = "dwindle",
        resize_on_border = true,
    },
    group = {
        col = {
            border_active = { colors = { "rgba(ca9ee6ff)", "rgba(f2d5cfff)" }, angle = 45 },
            border_inactive = { colors = { "rgba(b4befecc)", "rgba(6c7086cc)" }, angle = 45 },
            border_locked_active = { colors = { "rgba(ca9ee6ff)", "rgba(f2d5cfff)" }, angle = 45 },
            border_locked_inactive = { colors = { "rgba(b4befecc)", "rgba(6c7086cc)" }, angle = 45 },
        },
    },
    decoration = {
        rounding = 10,
        shadow = {
            enabled = false,
        },
        blur = {
            enabled = true,
            size = 6,
            passes = 3,
            new_optimizations = true,
            ignore_opacity = true,
            xray = false,
        },
    },
})

hl.on("config.reloaded", function()
    hl.exec_cmd("gsettings set org.gnome.desktop.interface icon-theme " .. ICON_THEME)
    hl.exec_cmd("gsettings set org.gnome.desktop.interface gtk-theme " .. GTK_THEME)
    hl.exec_cmd("gsettings set org.gnome.desktop.interface color-scheme " .. COLOR_SCHEME)
end)
