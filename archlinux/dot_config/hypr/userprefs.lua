local mainMod = "Super"
local menu = "[movefocus] rofi -show combi -modes combi -combi-modes run,ssh -run-command 'hyprctl dispatch \\'hl.dsp.exec_cmd(\"{cmd}\")\\''"
local terminal = "kitty"

hl.bind(mainMod .. " + R", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + CTRL + M", hl.dsp.exec_cmd("[floating] " .. terminal .. " pulsemixer"))
hl.bind(mainMod .. " + F1", hl.dsp.exec_cmd(terminal .. " -d ~/Workspace"))
hl.bind(mainMod .. " + F2", hl.dsp.exec_cmd("brave"))
hl.bind(mainMod .. " + SHIFT + F2", hl.dsp.exec_cmd("brave --user-data-dir=" .. os.getenv("HOME") .. "/.config/BraveSoftware/Brave-Browser/proxy-profile --proxy-server=socks://localhost:9090"))
hl.bind(mainMod .. " + SHIFT + F3", hl.dsp.exec_cmd("brave --user-data-dir=" .. os.getenv("HOME") .. "/.config/BraveSoftware/Brave-Browser/proxy-profile-k232 --proxy-server=socks://localhost:29090"))
hl.bind(mainMod .. " + F3", hl.dsp.exec_cmd("dolphin"))
hl.bind(mainMod .. " + F4", hl.dsp.exec_cmd(terminal .. " ranger"))
hl.bind(mainMod .. " + F5", hl.dsp.exec_cmd("logseq"))

-- Screen Snap
hl.bind("Print", hl.dsp.exec_cmd("grim -c -o \"$(hyprctl activeworkspace -j | jq -r '.monitor')\" - | feh --fullscreen - & grim -g \"$(slurp -d -w 0)\" - | wl-copy ; pkill -f 'feh --fullscreen -'"))

hl.config({
    input = {
        touchpad = {
            natural_scroll = true,
        },
    },
})

hl.on("hyprland.start", function()
    hl.exec_cmd("brave")
    hl.exec_cmd("fcitx5-remote -r")
    hl.exec_cmd("vesktop & telegram-desktop", { workspace = "7 silent" })
    hl.exec_cmd("/usr/bin/teams-for-linux --password-store=detect", { workspace = "9 silent" })
end)
