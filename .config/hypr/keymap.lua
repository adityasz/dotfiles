local main_mod = (DEBUG_CONFIG or VM_CONFIG) and "ALT" or "SUPER"

hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })

-- When stuff hits the fan
if not DISABLE_PLUGIN_WM then
    hl.bind(main_mod .. " + CTRL + SHIFT + F9", hl.dsp.exec_cmd("hyprctl dispatch wm:debuginfo"))
end
hl.bind(main_mod .. " + CTRL + SHIFT + F10", hl.dsp.exec_cmd("kitty"))
hl.bind(main_mod .. " + CTRL + SHIFT + F11", hl.dsp.exec_cmd("ghostty"))
if DEBUG_CONFIG then
    hl.bind(main_mod .. " + CTRL + SHIFT + F12", hl.dsp.exit())
else
    hl.bind(main_mod .. " + CTRL + SHIFT + F12", hl.dsp.exec_cmd("uwsm stop"))
end

-- Overview
if not DISABLE_PLUGIN_HYPRVIEW then
    hl.on("hyprland.start", function()
        hl.exec_cmd("hyprctl keyword hyprview-gesture '3, vertical, toggle'")
    end)
    hl.bind(main_mod .. " + up", hl.dsp.exec_cmd("hyprctl dispatch hyprview:toggle placement:adaptive"))
end

-- (Focus/Move/)Launch apps
-- TODO: kitty appears to first fork and then move to a different cgroup. This
-- will avoid latency at launch, so consider writing a Hyprland plugin that does
-- that (and does systemd comms in a background thread) instead of using runapp.
local function load_app_from_file(file)
    local ok, t = pcall(dofile,
        os.getenv("XDG_STATE_HOME") or (os.getenv("HOME") .. "/.local/state")
        .. "/hypr/wm/" .. file .. ".lua"
    )
    return ok and t or nil
end

local prefix = "runapp -o"
local apps = {
    -- for when I need a keybind-free terminal for tmux's remote session persistence
    [0] = { class = "com.mitchellh.ghostty", cmd = "ghostty" },

    [1] = { class = "kitty", cmd = "kitty" },
    [2] = { class = "zen", cmd = BIN_DIR .. "/zen" },
    [3] = { class = "sioyek", cmd = BIN_DIR .. "/sioyek" },
    [4] = { class = "dev.zed.Zed-Dev", cmd = BIN_DIR .. "/zed" },
    [5] = { class = "org.kde.dolphin", cmd = "dolphin" },
    [6] = load_app_from_file("jetbrains"),
    [7] = load_app_from_file("ai_thing"),
    [8] = { class = "org.gnome.SystemMonitor", cmd = "gnome-system-monitor" },
}

if not DISABLE_PLUGIN_WM then
    local wm_apps
    if not DEBUG_CONFIG then
        wm_apps = apps
    else
        local debug_names = { "Alpha", "Bravo", "Charlie", "Delta", "Echo", "Foxtrot", "Golf", "Hotel" }
        wm_apps = {}
        for i, name in ipairs(debug_names) do
            wm_apps[i] = { class = name, cmd = BIN_DIR .. "/dummy_app " .. name }
        end
    end

    hl.config({ plugin = { wm = { prefix = prefix, apps = wm_apps } } })

    for i = 0, 8 do
        hl.bind(main_mod .. " + " .. i, hl.dsp.exec_cmd("hyprctl dispatch wm:focusorexec " .. i))
        hl.bind(main_mod .. " + SHIFT + " .. i, hl.dsp.exec_cmd("hyprctl dispatch wm:moveorexec " .. i))
        hl.bind(main_mod .. " + CTRL + " .. i, hl.dsp.exec_cmd("hyprctl dispatch wm:exec " .. i))
    end
else
    for i = 1, 8 do
        if apps[i] then
            hl.bind(main_mod .. " + " .. i, hl.dsp.exec_cmd(prefix .. " " .. apps[i].cmd))
        end
    end
end

if DISABLE_PLUGIN_WM then
    hl.bind(main_mod .. " + tab", hl.dsp.focus({ urgent_or_last = true }))
    hl.bind(main_mod .. " + tab", hl.dsp.window.alter_zorder({ mode = "top" }))
end

local function bind_hy3(keys, dispatcher, hy3_dispatcher, opts)
    local action = DISABLE_PLUGIN_HY3 and dispatcher or hl.dsp.exec_cmd(
        "hyprctl dispatch hy3:" .. hy3_dispatcher
    )
    hl.bind(main_mod .. " + " .. keys, action, opts)
end

-- Switch workspaces
for i = 1, 10 do
    hl.bind(main_mod .. " + F" .. i, hl.dsp.focus({ workspace = tostring(i) }))
end
hl.bind(main_mod .. " + A", hl.dsp.focus({ workspace = "-1" }))
hl.bind(main_mod .. " + F", hl.dsp.focus({ workspace = "+1" }))
hl.bind(main_mod .. " + mouse_up", hl.dsp.focus({ workspace = "-1" }))
hl.bind(main_mod .. " + mouse_down", hl.dsp.focus({ workspace = "+1" }))
hl.bind(main_mod .. " + Z", hl.dsp.workspace.toggle_special("one"))
hl.bind(main_mod .. " + X", hl.dsp.workspace.toggle_special("two"))
hl.bind(main_mod .. " + C", hl.dsp.workspace.toggle_special("three"))
hl.bind(main_mod .. " + V", hl.dsp.workspace.toggle_special("four"))
hl.bind(main_mod .. " + B", hl.dsp.workspace.toggle_special("five"))

-- Do things to the window
hl.bind(main_mod .. " + mouse:274", hl.dsp.window.resize(), { mouse = true })
hl.bind(main_mod .. " + W", hl.dsp.window.close())
hl.bind(main_mod .. " + T", hl.dsp.window.float({ action = "toggle" }))
hl.bind(main_mod .. " + P", hl.dsp.window.pin())
hl.bind(
    main_mod .. " + F11",
    hl.dsp.window.fullscreen_state({ client = 2, internal = -1 }),
    { description = "client fullscreen" }
)
bind_hy3("I", hl.dsp.window.fullscreen_state({ client = -1, internal = 1 }), "maximize")
hl.bind(
    main_mod .. " + CTRL + I",
    hl.dsp.window.fullscreen_state({ client = -1, internal = 2 }),
    { description = "window fullscreen" }
)
bind_hy3("G", hl.dsp.group.toggle(), "makegroup tab toggle")
bind_hy3("SHIFT + T", hl.dsp.layout("togglesplit"), "changegroup opposite")

-- Focus windows
bind_hy3("H", hl.dsp.focus({ direction = "l" }), "movefocus l visible")
bind_hy3("J", hl.dsp.focus({ direction = "d" }), "movefocus d visible")
bind_hy3("K", hl.dsp.focus({ direction = "u" }), "movefocus u visible")
bind_hy3("L", hl.dsp.focus({ direction = "r" }), "movefocus r visible")
bind_hy3("bracketright", hl.dsp.group.next(), "focustab r wrap")
bind_hy3("bracketleft", hl.dsp.group.prev(), "focustab l wrap")
hl.bind(main_mod .. " + M", hl.dsp.window.alter_zorder({ mode = "bottom" }))
hl.bind(main_mod .. " + M", hl.dsp.window.cycle_next())

-- Move window
local function smart_move(direction, force_tile)
    return function()
        local w = hl.get_active_window()
        if not w then return end

        if w.floating then
            hl.dispatch(hl.dsp.window.float({ action = "disable" }))
            return
        end

        if w.fullscreen ~= 0 then
            hl.dispatch(hl.dsp.window.fullscreen({ action = "unset" }))
            return
        end

        if force_tile then
            hl.dispatch(hl.dsp.window.move({ out_of_group = direction }))
            return
        end

        local ws = w.workspace
        if not ws then return end
        local windows = ws:get_windows()
        local has_window = false
        local x1, y1 = w.at.x, w.at.y
        local x2, y2 = x1 + w.size.x, y1 + w.size.y

        -- super ugly (and inefficient)
        -- TODO: Rewrite dwindle tree. Binary trees are extraordinarily stupid for human use.
        for _, other in ipairs(windows) do
            if other.address ~= w.address and other.visible and not other.floating and other.fullscreen == 0 then
                local ox1, oy1 = other.at.x, other.at.y
                local ox2, oy2 = ox1 + other.size.x, oy1 + other.size.y

                if direction == "l" then
                    if ox2 <= x1 then has_window = true break end
                elseif direction == "r" then
                    if ox1 >= x2 then has_window = true break end
                elseif direction == "u" then
                    if oy2 <= y1 then has_window = true break end
                elseif direction == "d" then
                    if oy1 >= y2 then has_window = true break end
                end
            end
        end

        if has_window then
            hl.dispatch(hl.dsp.window.move({ into_or_create_group = direction }))
        else
            hl.dispatch(hl.dsp.window.move({ out_of_group = direction }))
        end
    end
end

hl.bind(main_mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(main_mod .. " + SHIFT + H", smart_move("l"))
hl.bind(main_mod .. " + SHIFT + J", smart_move("d"))
hl.bind(main_mod .. " + SHIFT + K", smart_move("u"))
hl.bind(main_mod .. " + SHIFT + L", smart_move("r"))
hl.bind(main_mod .. " + CTRL + H", smart_move("l", true))
hl.bind(main_mod .. " + CTRL + J", smart_move("d", true))
hl.bind(main_mod .. " + CTRL + K", smart_move("u", true))
hl.bind(main_mod .. " + CTRL + L", smart_move("r", true))
hl.bind(main_mod .. " + SHIFT + left", hl.dsp.window.swap({ direction = "l" }))
hl.bind(main_mod .. " + SHIFT + down", hl.dsp.window.swap({ direction = "d" }))
hl.bind(main_mod .. " + SHIFT + up", hl.dsp.window.swap({ direction = "u" }))
hl.bind(main_mod .. " + SHIFT + right", hl.dsp.window.swap({ direction = "r" }))
bind_hy3("S", hl.dsp.window.move({ workspace = "-1", follow = true }), "movetoworkspace -1 follow")
bind_hy3("D", hl.dsp.window.move({ workspace = "+1", follow = true }), "movetoworkspace +1 follow")
for i = 1, 10 do
    bind_hy3("SHIFT + F" .. i, hl.dsp.window.move({ workspace = tostring(i) }), "movetoworkspace " .. i)
end
bind_hy3("SHIFT + Z", hl.dsp.window.move({ workspace = "special:one" }), "movetoworkspace special:one")
bind_hy3("SHIFT + X", hl.dsp.window.move({ workspace = "special:two" }), "movetoworkspace special:two")
bind_hy3("SHIFT + C", hl.dsp.window.move({ workspace = "special:three" }), "movetoworkspace special:three")
bind_hy3("SHIFT + V", hl.dsp.window.move({ workspace = "special:four" }), "movetoworkspace special:four")
bind_hy3("SHIFT + B", hl.dsp.window.move({ workspace = "special:five" }), "movetoworkspace special:five")
bind_hy3("SHIFT + minus", hl.dsp.window.move({ workspace = "e+0" }), "movetoworkspace e+0")

if not DEBUG_CONFIG then
    -- Vicinae
    hl.bind("ALT + space", hl.dsp.exec_cmd("vicinae toggle"))

    -- Swaync
    hl.bind("SUPER + N", hl.dsp.exec_cmd("swaync-client -t"),
        { description = "Toggle notification center" })

    -- Color picker
    hl.bind("SUPER + page_up", hl.dsp.exec_cmd("hyprpicker -al"),
        { description = "Autocopy lowercase hex" })

    -- Waybar
    hl.bind("SUPER + insert", hl.dsp.exec_cmd("killall -SIGUSR1 waybar"),
        { description = "Toggle visibility" })

    -- Screenshot
    hl.bind("print", hl.dsp.exec_cmd(BIN_DIR .. "/omarchy-cmd-screenshot"),
        { bypass = true, description = "Screenshot selection and then edit" })
    hl.bind("SHIFT + print", hl.dsp.exec_cmd(BIN_DIR .. "/omarchy-cmd-screenshot smart clipboard"),
        { bypass = true, description = "Screenshot selection to clipboard" })
    hl.bind("ALT + print", hl.dsp.exec_cmd(BIN_DIR .. "/hyprshot -m window -m active"),
        { bypass = true, description = "Screenshot current window to disk" })
    hl.bind("SUPER + print", hl.dsp.exec_cmd(BIN_DIR .. "/hyprshot -m output -m active"),
        { bypass = true, description = "Screenshot entire screen to disk" })
    hl.bind(
        "SUPER + SHIFT + print",
        hl.dsp.exec_cmd(BIN_DIR .. "/omarchy-cmd-screenshot fullscreen clipboard"),
        { bypass = true, description = "Screenshot entire screen to clipboard" }
    )

    -- Lockscreen
    hl.bind("XF86LogOff", hl.dsp.exec_cmd("hyprlock"), { bypass = true, description = "Lock the screen" })
    -- hyprlock does not turn the screen off. The following adds a 1 second delay
    -- even when the machine was already locked (i.e., press a key to turn display
    -- on, see time, press the key to run the following, wait 1 second for screen to
    -- turn off). I am not going to write a long shell command to fix it; hyprlock
    -- is the place to fix it.
    hl.bind("XF86LogOff", hl.dsp.exec_cmd("sleep 1 && hyprctl dispatch dpms off"),
        { bypass = true, locked = true, description = "Turn the screen off after one second" })

    -- Laptop multimedia keys for volume and LCD brightness
    hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"),
        { locked = true, repeating = true })
    hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
        { locked = true, repeating = true })
    hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
        { locked = true, repeating = true })
    hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
        { locked = true, repeating = true })
    hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl s 10%+"),
        { locked = true, repeating = true })
    hl.bind( "XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl s 10%-"),
        { locked = true, repeating = true })

    -- This was a part of the default config, never used it
    hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
    hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
    hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
    hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
end
