-- Hyprland main configuration file (Lua)
-- Migrated to Hyprland 0.57+ native Lua API

local home = os.getenv("HOME")
local scrPath = home .. "/.local/share/bin"
local binPath = home .. "/.local/bin"

-- Environment variables
hl.env("PATH", binPath .. ":" .. (os.getenv("PATH") or "") .. ":" .. scrPath)
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")
hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", "1")
hl.env("MOZ_ENABLE_WAYLAND", "1")
hl.env("GDK_SCALE", "1")
hl.env("LC_CTYPE", "zh_TW.UTF-8")

-- Input method (fcitx5)
hl.env("GTK_IM_MODULE", "fcitx")
hl.env("QT_IM_MODULE", "fcitx")
hl.env("XMODIFIERS", "@im=fcitx")
hl.env("SDL_IM_MODULE", "fcitx")
hl.env("INPUT_METHOD", "fcitx")
hl.env("GLFW_IM_MODULE", "ibus")

-- Base input & general configuration
hl.config({
    input = {
        kb_layout = "us",
        follow_mouse = 1,
        touchpad = {
            natural_scroll = false,
        },
        sensitivity = 0,
        force_no_accel = 1,
        numlock_by_default = true,
    },
    dwindle = {
        preserve_split = true,
    },
    master = {
        new_status = "master",
    },
    misc = {
        vrr = 0,
        disable_hyprland_logo = true,
        disable_splash_rendering = true,
        force_default_wallpaper = 0,
    },
    xwayland = {
        force_zero_scaling = true,
    },
})

hl.device({
    name = "epic mouse V1",
    sensitivity = -0.5,
})

-- Autostart processes
hl.on("hyprland.start", function()
    hl.exec_cmd(scrPath .. "/resetxdgportal.sh")
    hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
    hl.exec_cmd("dbus-update-activation-environment --systemd --all")
    hl.exec_cmd("systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
    hl.exec_cmd(scrPath .. "/polkitkdeauth.sh")
    hl.exec_cmd("waybar")
    hl.exec_cmd("blueman-applet")
    hl.exec_cmd("udiskie --no-automount --smart-tray")
    hl.exec_cmd("nm-applet --indicator")
    hl.exec_cmd("dunst")
    hl.exec_cmd("wl-paste --type text --watch cliphist store")
    hl.exec_cmd("wl-paste --type image --watch cliphist store")
    hl.exec_cmd(scrPath .. "/batterynotify.sh")
    hl.exec_cmd("/usr/lib/pam_kwallet_init")
end)

-- Modular configuration components
require("animations")
require("keybindings")
require("windowrules")
require("themes.common")
require("themes.theme")
pcall(require, "themes.colors")
require("monitors")
require("userprefs")
