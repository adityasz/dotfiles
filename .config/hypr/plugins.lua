local plugin_dir = os.getenv("HOME") .. "/.local/lib/hyprland-plugins"

hl.on("hyprland.start", function()
    local plugins = {
        { disabled = DISABLE_PLUGIN_WM,       path = "/libwm.so" },
        { disabled = DISABLE_PLUGIN_HY3,      path = "/libhy3.so" },
        { disabled = DISABLE_PLUGIN_HYPRVIEW, path = "/hyprview.so" },
    }

    for _, plugin in ipairs(plugins) do
        if not plugin.disabled then
            hl.plugin.load(plugin_dir .. plugin.path)
        end
    end
end)

if not DISABLE_PLUGIN_HY3 then
    hl.config({
        plugin = {
            hy3 = {
                tab_first_window = false,
                tabs = {
                    height = 0,
                    padding = 0,
                    render_text = false,
                    text_height = 0,
                    text_padding = 0,
                    blur = false,
                    opacity = 1
                }
            }
        }
    })
end

if not DISABLE_PLUGIN_WM then
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
