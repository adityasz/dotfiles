local wezterm = require("wezterm")
local colors = require("colors")
local keymap = require("keymap")
local config = wezterm.config_builder()

config.enable_wayland = false
config.default_prog = {"/usr/bin/zsh"}
config.font = wezterm.font("JetBrains Mono", {weight = "Medium"})
config.window_decorations = "RESIZE"
config.tab_bar_at_bottom = true
config.window_padding = {
    left = 2,
    right = 2,
    top = 2,
    bottom = 2
}
config.initial_rows = 30
config.initial_cols = 100
config.inactive_pane_hsb = {
    saturation = 1.0,
    brightness = 1.0
}
config.font = wezterm.font("JetBrains Mono", {weight = "Medium"})
config.font_size = 14.0

colors.apply_to_config(config)
keymap.apply_to_config(config)

return config
