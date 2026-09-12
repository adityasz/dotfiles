hl.config({
    cursor = {
        no_warps = true,
    },
    input = {
        repeat_rate = 40,
        follow_mouse = 2,
        special_fallthrough = true,
        float_switch_override_focus = 0,
        sensitivity = 0.16182572614107893,
        touchpad = {
            natural_scroll = true,
            scroll_factor = 0.30,
        },
    },
})

if DEBUG_CONFIG then
    hl.config({
        cursor = { no_hardware_cursors = 0 }
    })
end

local function sens(dpi)
    return -0.53891213400000004 * dpi / 800
end

hl.device({
    name = "hp--inc-hyperx-pulsefire-fuse-wireless",
    sensitivity = sens(800),
    accel_profile = "flat",
})
