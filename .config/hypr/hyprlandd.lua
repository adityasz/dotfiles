-- -----------------------------------------------------------------------------
-- That terrible wallpaper must not appear under any circumstances. It has
-- nothing to do with the Hyprland logo.
--
--                   THE FOLLOWING LINE MUST NOT BE REMOVED
hl.config({ misc = { disable_hyprland_logo = true, disable_splash_rendering = true } })
--                   THE LINE ABOVE THIS MUST NOT BE REMOVED
-- -----------------------------------------------------------------------------

VM_CONFIG = false
DEBUG_CONFIG = true
ENABLE_PLUGIN_WM = true

hl.on("hyprland.start", function()
    hl.exec_cmd("echo -n $HYPRLAND_INSTANCE_SIGNATURE > /tmp/hyprlandd_instance_signature")
end)

hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1, vrr = 1 })

require("hyprland")

if ENABLE_PLUGIN_WM then
    hl.bind("ALT + I", hl.plugin.wm.fullscreen("maximized"))
    hl.bind("ALT + CTRL + I", hl.plugin.wm.fullscreen("fullscreen"))
end
