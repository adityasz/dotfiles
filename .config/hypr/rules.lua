-- For my tiling plugin
hl.window_rule({ match = { class = ".*" }, float = true })

-- For clients that do not remember window size and launch at a stupid size
hl.window_rule({ match = { class = "^(org.freedesktop.impl.portal.desktop.kde)$" }, size = "1087 722" })
hl.window_rule({ match = { class = "^(zen)$" }, size = "1500 1280" })
hl.window_rule({ match = { class = "^(neovide)$" }, size = "1280 800" })

-- Ignore maximize requests from apps.
hl.window_rule({ match = { class = ".*" }, suppress_event = "maximize" })

-- Fix some dragging issues with XWayland
hl.window_rule({ match = { class = "^$", title = "^$", xwayland = true, float = true, fullscreen = false, pin = false }, no_focus = true })
