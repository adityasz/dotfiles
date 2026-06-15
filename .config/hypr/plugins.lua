local plugin_dir = os.getenv("HOME") .. "/.local/lib/"

if not DISABLE_PLUGIN_WM then
    hl.plugin.load(plugin_dir .. "libwm.so")
    -- hl.on("hyprland.start", function()
    --     hl.plugin.load(plugin_dir .. "libwm.so")
    -- end)

    hl.config({
        plugin = {
            wm = {
                app_switcher = {
                    container = { radius = 50 },
                    selection = { radius = 40 }
                }
            }
        }
    })
end
