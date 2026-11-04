-- Animations entry
hl.layer_rule({
    match = { namespace = "hyprpicker" },
    no_anim = true,
})
hl.layer_rule({
    match = { namespace = "selection" },
    no_anim = true,
})

require("animations.animations-default")
