-- -----------------------------------------------------------------------------
-- That terrible wallpaper must not appear under any circumstances. It has
-- nothing to do with the Hyprland logo.
--
--                   THE FOLLOWING LINE MUST NOT BE REMOVED
hl.config({ misc = { disable_hyprland_logo = true } })
--                   THE LINE ABOVE THIS MUST NOT BE REMOVED
-- -----------------------------------------------------------------------------

BIN_DIR = os.getenv("HOME") .. "/.local/bin"

-- because hyprlandd.lua sources this
VM_CONFIG = (VM_CONFIG == nil) and true or VM_CONFIG
DEBUG_CONFIG = (DEBUG_CONFIG == nil) and false or DEBUG_CONFIG
DISABLE_PLUGIN_WM = (DISABLE_PLUGIN_WM == nil) and true or DISABLE_PLUGIN_WM
DISABLE_PLUGIN_HY3 = (DISABLE_PLUGIN_HY3 == nil) and true or DISABLE_PLUGIN_HY3

-- TODO:
-- 1. Show windows in window groups also
-- 2. Fix hardcoded placement algorithm for gestures
-- FIXME:
-- 1. Upgrade to 0.55
-- 2. Fix segfault when switching workspaces using gesture with overview open
DISABLE_PLUGIN_HYPRVIEW = (DISABLE_PLUGIN_HYPRVIEW == nil) and true or DISABLE_PLUGIN_HYPRVIEW

if not DEBUG_CONFIG then
    require("monitors")
    require("autostart")
    require("plugins")
end

require("input")
require("looks")
require("keymap")
require("rules")

hl.config({
    general = {
        layout = (not DISABLE_PLUGIN_HY3) and "hy3" or "dwindle",
        no_focus_fallback = true,
        resize_on_border = false,
        allow_tearing = false
    },
    dwindle = {
        preserve_split = true
    },
    gestures = {
        workspace_swipe_use_r = true
    },
    misc = {
        focus_on_activate = false, -- TODO: Show apps that request to be focused in waybar; hide once focused
        mouse_move_enables_dpms = true,
        key_press_enables_dpms = true
    },
    debug = {
        disable_logs = not DEBUG_CONFIG,
        damage_blink = false,
        overlay = false
    }
})
