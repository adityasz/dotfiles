hl.window_rule({
    match = { class = ".*" },
    float = true,
})

-- with general.allow_tearing = true
hl.window_rule({
    match = { class = "cs2" },
    immediate = true,
})

-- Hyprland sucks
--
-- For dolphin, manually modify dolphinstaterc (not required with other wayland compositors) after
-- seeing what dolphin writes to that file in any other compositor.
--
-- For zen, I don't know which file to touch, hence this mess:
hl.window_rule({
    match = { class = "zen" },
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
