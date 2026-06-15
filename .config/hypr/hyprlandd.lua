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
DISABLE_PLUGIN_WM = false

hl.on("hyprland.start", function()
    hl.exec_cmd("echo -n $HYPRLAND_INSTANCE_SIGNATURE > /tmp/hyprlandd_instance_signature")
    if not DISABLE_PLUGIN_WM then
        hl.exec_cmd(
            "hyprctl plugin load " .. os.getenv("HOME") .. "/Projects/hyprland/wm/build/debug/libwm.so"
        )
    end
end)

hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1, vrr = 1 })

require("hyprland")
