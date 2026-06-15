-- For my tiling plugin
hl.window_rule({
    match = { class = ".*" },
    float = true,
})

-- Hyprland sucks
hl.window_rule({
    match = { class = "org.kde.dolphin|zen" },
    persistent_size = true,
    suppress_event = "maximize",
})

-- From default config
hl.window_rule({
    name  = "fix-xwayland-drags",
    match = {
        class = "^$",
        title = "^$",
        xwayland = true,
        float = true,
        fullscreen = false,
        pin = false,
    },
    no_focus = true,
})
