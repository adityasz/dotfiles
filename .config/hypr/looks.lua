local active_border_color, inactive_border_color
if DEBUG_CONFIG then
    active_border_color = "#ff0000ff"
    inactive_border_color = "#000000ff"
else
    active_border_color = "#80808088"
    inactive_border_color = "#80808033"
end

hl.config({
    group = {
        col = {
            border_active = active_border_color,
            border_inactive = inactive_border_color,
        },
        groupbar = { enabled = false }
    },
    general = {
        gaps_in = -1,
        gaps_out = 0,
        gaps_workspaces = -1,
        border_size = DEBUG_CONFIG and 3 or 1,
        col = {
            active_border = active_border_color,
            inactive_border = inactive_border_color,
        }
    }
})

if DEBUG_CONFIG then
    hl.config({
        decoration = {
            rounding = 0,
            shadow = { enabled = false },
            blur = { enabled = false },
        },
        animations = { enabled = false }
    })
else
    hl.config({
        decoration = {
            rounding = 12,
            rounding_power = 4,
            shadow = {
                enabled = true,
                range = 50,
                render_power = 10,
                color = "#1a1a1a50",
                color_inactive = "#1a1a1a15"
            },
            blur = {
                enabled = true,
                size = 5,
                passes = 3,
                noise = 0.03,
                vibrancy = 0.1696
            }
        },
        animations = {
            enabled = true
        }
    })

    -- from the default hyprlang config from several releases ago with some minor changes for speedup
    hl.curve("easeOutQuint", { type = "bezier", points = { { 0.23, 1 }, { 0.32, 1 } } })
    hl.curve("easeInOutCubic", { type = "bezier", points = { { 0.65, 0.05 }, { 0.36, 1 } } })
    hl.curve("linear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })
    hl.curve("almostLinear", { type = "bezier", points = {{0.5, 0.5}, {0.75, 1}} })
    hl.curve("quick", { type = "bezier", points = {{0.15, 0}, {0.1, 1}} })

    hl.animation({ leaf = "global", enabled = true, speed = 10, bezier = "default" })
    hl.animation({ leaf = "border", enabled = true, speed = 5.39, bezier = "easeOutQuint" })
    hl.animation({ leaf = "windows", enabled = true, speed = 4.79, bezier = "easeOutQuint" })
    hl.animation({ leaf = "windowsIn", enabled = true, speed = 0.5, bezier = "easeOutQuint", style = "popin 87%" })
    hl.animation({ leaf = "windowsOut", enabled = true, speed = 1.49, bezier = "linear", style = "popin 87%" })
    hl.animation({ leaf = "windowsMove", enabled = true, speed = 1.94, bezier = "almostLinear", style = "slide" })
    hl.animation({ leaf = "fade", enabled = true, speed = 3.03, bezier = "quick" })
    hl.animation({ leaf = "fadeIn", enabled = false })
    hl.animation({ leaf = "fadeOut", enabled = true, speed = 1.46, bezier = "almostLinear" })
    hl.animation({ leaf = "layers", enabled = true, speed = 3.81, bezier = "easeOutQuint" })
    hl.animation({ leaf = "layersIn", enabled = true, speed = 4, bezier = "easeOutQuint", style = "fade" })
    hl.animation({ leaf = "layersOut", enabled = true, speed = 1.5, bezier = "linear", style = "fade" })
    hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = 1.79, bezier = "almostLinear" })
    hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear" })
    hl.animation({ leaf = "workspaces", enabled = true, speed = 1.00, bezier = "almostLinear", style = "fade" })
    hl.animation({ leaf = "workspacesIn", enabled = true, speed = 1.00, bezier = "almostLinear", style = "slide" })
    hl.animation({ leaf = "workspacesOut", enabled = true, speed = 1.00, bezier = "almostLinear", style = "slide" })
    hl.animation({ leaf = "zoomFactor", enabled = true, speed = 7, bezier = "quick" })
end

-- Fix border around hyprshot
hl.layer_rule({ match = { namespace = "hyprpicker" }, no_anim = true })
hl.layer_rule({ match = { namespace = "selection" }, no_anim = true })

hl.layer_rule({ match = { namespace = "waybar" }, blur = true, ignore_alpha = 0.2 })

hl.layer_rule({ match = { namespace = "swaync-control-center" }, blur = true, ignore_alpha = 0.3 })
hl.layer_rule({ match = { namespace = "swaync-notification-window" }, blur = true, ignore_alpha = 0.3 })

hl.layer_rule({ match = { namespace = "notifications" }, no_anim = true, blur = true, ignore_alpha = 0.2 })

hl.window_rule({ match = { class = "vicinae" }, no_anim = true })
hl.layer_rule({ match = { namespace = "vicinae" }, no_anim = true, blur = true, ignore_alpha = 0.2 })

hl.env("XCURSOR_THEME", "custom")
hl.env("XCURSOR_SIZE", "26")
hl.env("HYPRCURSOR_SIZE", "26")
hl.env("QT_QPA_PLATFORMTHEME", "qt5ct")
