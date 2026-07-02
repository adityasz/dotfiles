local plugin_dir = os.getenv("HOME") .. "/.local/lib/"

if ENABLE_PLUGIN_WM then
    if DEBUG_CONFIG then
        hl.plugin.load(os.getenv("HOME") .. "/Projects/hyprland/wm/build/debug/libwm.so")
        -- hl.plugin.load(os.getenv("HOME") .. "/Projects/hyprland/wm/build/release/libwm.so")
    else
        -- hl.plugin.load(os.getenv("HOME") .. "/Projects/hyprland/wm/build/release/libwm.so")
        hl.plugin.load(plugin_dir .. "libwm.so")
    end
end
