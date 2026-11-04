-- Monitors & Workspaces configuration
-- Generated for Hyprland 0.57+

hl.monitor({
    output = "eDP-1",
    mode = "1920x1200@60",
    position = "0x0",
    scale = "1.25",
})

local leftMonitor = "eDP-1"
local rightMonitor = "DP-2"

-- Assign workspaces 1-5 to leftMonitor, 6-10 to rightMonitor
for i = 1, 5 do
    hl.workspace_rule({
        workspace = tostring(i),
        monitor = leftMonitor,
    })
end

for i = 6, 10 do
    hl.workspace_rule({
        workspace = tostring(i),
        monitor = rightMonitor,
    })
end
