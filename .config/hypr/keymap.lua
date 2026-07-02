local function wm_bind(keys, dispatcher, opts)
    local mod = (DEBUG_CONFIG or VM_CONFIG) and "ALT" or "SUPER"
    hl.bind(mod .. " + " .. keys, dispatcher, opts)
end

hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })

-- (Focus/Move/)Launch apps
-- TODO(low priority): kitty first forks and then moves to a different cgroup.
-- runapp adds ~3.5 ms of latency at launch, so consider writing a Hyprland
-- plugin that copies kitty (and does systemd comms in a background thread).
local function load_app_from_file(file)
    local ok, t = pcall(
        dofile,
        (os.getenv("XDG_STATE_HOME") or (os.getenv("HOME") .. "/.local/state"))
        .. "/hypr/wm/" .. file .. ".lua"
    )
    return ok and t or nil
end

local bin_dir = os.getenv("HOME") .. "/.local/bin/"
local prefix = "runapp -o "
local apps = {
    [0] = { class = "com.mitchellh.ghostty", cmd = "ghostty" }, -- for when I need a keybind-free terminal for tmux's remote session persistence
    [1] = { class = "kitty", cmd = "kitty" },
    [2] = { class = "zen", cmd = "zen-browser" },
    [3] = { class = "sioyek", cmd = "sioyek" },
    [4] = { class = "dev.zed.Zed-Nightly", cmd = bin_dir .. "zed" },
    [5] = { class = "org.kde.dolphin", cmd = "dolphin" },
    [6] = load_app_from_file("jetbrains"),
    [7] = load_app_from_file("ai_thing"),
    [8] = { class = "org.gnome.SystemMonitor", cmd = "gnome-system-monitor" },
}

if ENABLE_PLUGIN_WM then
    if DEBUG_CONFIG then
        local debug_names = { "Alpha", "Bravo", "Charlie", "Delta", "Echo", "Foxtrot", "Golf", "Hotel" }
        for i, name in ipairs(debug_names) do
            apps[i] = { class = name, cmd = bin_dir .. "dummy_app " .. name }
        end
    end

    for i = 0, 8 do
        if apps[i] then
            wm_bind(i, hl.plugin.wm.focus_or_exec({ class = apps[i].class, cmd = prefix .. apps[i].cmd }))
            wm_bind("SHIFT + " .. i, hl.plugin.wm.move_or_exec(apps[i]))
            wm_bind("CTRL + " .. i, hl.dsp.exec_cmd(prefix .. apps[i].cmd))
        end
    end
else
    for i = 0, 8 do
        if apps[i] then
            wm_bind(i, hl.dsp.exec_cmd(prefix .. " " .. apps[i].cmd))
        end
    end
end

if not ENABLE_PLUGIN_WM then
    wm_bind("tab", hl.dsp.focus({ urgent_or_last = true }))
    wm_bind("tab", hl.dsp.window.alter_zorder({ mode = "top" }))
end

-- When stuff hits the fan
wm_bind("CTRL + SHIFT + F9", hl.dsp.exit())
wm_bind("CTRL + SHIFT + F10", hl.dsp.exec_cmd("kitty"))
wm_bind("CTRL + SHIFT + F11", hl.dsp.exec_cmd("ghostty"))
if not DEBUG_CONFIG then
    wm_bind("CTRL + SHIFT + F12", hl.dsp.exec_cmd("uwsm stop"))
end

-- Switch workspaces
for i = 1, 10 do
    wm_bind("F" .. i, hl.dsp.focus({ workspace = tostring(i) }))
end
wm_bind("A", hl.dsp.focus({ workspace = "-1" }))
wm_bind("F", hl.dsp.focus({ workspace = "+1" }))
wm_bind("mouse_up", hl.dsp.focus({ workspace = "-1" }))
wm_bind("mouse_down", hl.dsp.focus({ workspace = "+1" }))
wm_bind("Z", hl.dsp.workspace.toggle_special("one"))
wm_bind("X", hl.dsp.workspace.toggle_special("two"))
wm_bind("C", hl.dsp.workspace.toggle_special("three"))
wm_bind("V", hl.dsp.workspace.toggle_special("four"))
wm_bind("B", hl.dsp.workspace.toggle_special("five"))

-- Do things to the window
wm_bind("mouse:274", hl.dsp.window.resize(), { mouse = true })
wm_bind("W", hl.dsp.window.close())
if ENABLE_PLUGIN_WM then
    wm_bind("T", function()
        local w = hl.get_active_window()
        if not w then return end
        if w.fullscreen ~= 0 then
            hl.dispatch(hl.plugin.wm.fullscreen("disabled"))
            hl.dispatch(hl.dsp.window.float({ action = "unset" }))
            return
        end
        hl.dispatch(hl.dsp.window.float({ action = "toggle" }))
    end)
else
    wm_bind("T", hl.dsp.window.float({ action = "toggle" }))
end
wm_bind("P", hl.dsp.window.pin())
wm_bind("G", hl.dsp.group.toggle())
wm_bind("SHIFT + T", hl.dsp.layout("togglesplit"))
if ENABLE_PLUGIN_WM then
    wm_bind("I", hl.plugin.wm.fullscreen("maximized"))
    wm_bind("CTRL + I", hl.plugin.wm.fullscreen("fullscreen"))
else
    wm_bind("I", hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" }))
    wm_bind("CTRL + I", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }))
end

-- Focus windows
local function shift_focus(direction)
    local focus_cmd = hl.dsp.focus({ direction = direction })
    local raise_cmd = hl.dsp.window.alter_zorder({ mode = "top" })
    return function()
        hl.dispatch(focus_cmd)
        local w = hl.get_active_window()
        if not w or w.floating then return end
        hl.dispatch(raise_cmd)
    end
end
wm_bind("H", shift_focus("l"))
wm_bind("J", shift_focus("d"))
wm_bind("K", shift_focus("u"))
wm_bind("L", shift_focus("r"))

wm_bind("bracketright", hl.dsp.group.next())
wm_bind("bracketleft", hl.dsp.group.prev())
wm_bind("M", function()
    hl.dispatch(hl.dsp.window.alter_zorder({ mode = "bottom" }))
    hl.dispatch(hl.dsp.window.cycle_next())
end)

-- Move window
local function smart_move(direction, force_tile)
    return function()
        local w = hl.get_active_window()
        if not w then return end

        if w.fullscreen ~= 0 then
            if ENABLE_PLUGIN_WM then
                hl.dispatch(hl.plugin.wm.fullscreen("disabled"))
            else
                hl.dispatch(hl.dsp.window.fullscreen({ action = "unset" }))
            end
        end

        if w.floating then
            hl.dispatch(hl.dsp.window.float({ action = "disable" }))
            return
        end

        -- super ugly (and inefficient)
        -- TODO: Write an i3-like tree. Binary trees are extraordinarily stupid for human use.
        -- Note: It is faster to write a tree from scratch than it is to fix the (probably vibe-coded) hy3 mess.

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

wm_bind("mouse:272", hl.dsp.window.drag(), { mouse = true })
wm_bind("SHIFT + H", smart_move("l"))
wm_bind("SHIFT + J", smart_move("d"))
wm_bind("SHIFT + K", smart_move("u"))
wm_bind("SHIFT + L", smart_move("r"))
wm_bind("CTRL + H", smart_move("l", true))
wm_bind("CTRL + J", smart_move("d", true))
wm_bind("CTRL + K", smart_move("u", true))
wm_bind("CTRL + L", smart_move("r", true))
wm_bind("SHIFT + left", hl.dsp.window.swap({ direction = "l" }))
wm_bind("SHIFT + down", hl.dsp.window.swap({ direction = "d" }))
wm_bind("SHIFT + up", hl.dsp.window.swap({ direction = "u" }))
wm_bind("SHIFT + right", hl.dsp.window.swap({ direction = "r" }))

-- Focus and window ordering in Hyprland is retarded.
-- Even with follow = true, the window can go behind other windows.
local function move_to_workspace_and_follow(workspace)
    local move_cmd = hl.dsp.window.move({ workspace = workspace, follow = true })
    local raise_cmd = hl.dsp.window.alter_zorder({ mode = "top" })
    return function()
        hl.dispatch(move_cmd)
        hl.dispatch(raise_cmd)
    end
end
wm_bind("S", move_to_workspace_and_follow("-1"))
wm_bind("D", move_to_workspace_and_follow("+1"))

for i = 1, 10 do
    wm_bind("SHIFT + F" .. i, hl.dsp.window.move({ workspace = tostring(i) }))
end
wm_bind("SHIFT + Z", hl.dsp.window.move({ workspace = "special:one" }))
wm_bind("SHIFT + X", hl.dsp.window.move({ workspace = "special:two" }))
wm_bind("SHIFT + C", hl.dsp.window.move({ workspace = "special:three" }))
wm_bind("SHIFT + V", hl.dsp.window.move({ workspace = "special:four" }))
wm_bind("SHIFT + B", hl.dsp.window.move({ workspace = "special:five" }))
wm_bind("SHIFT + minus", hl.dsp.window.move({ workspace = "e+0" }))

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
    hl.bind("print", hl.dsp.exec_cmd(bin_dir .. "omarchy-cmd-screenshot"),
        { dont_inhibit = true, description = "Screenshot selection and then edit" })
    hl.bind("SHIFT + print", hl.dsp.exec_cmd(bin_dir .. "omarchy-cmd-screenshot smart clipboard"),
        { dont_inhibit = true, description = "Screenshot selection to clipboard" })
    hl.bind("ALT + print", hl.dsp.exec_cmd(bin_dir .. "hyprshot -m window -m active"),
        { dont_inhibit = true, description = "Screenshot current window to disk" })
    hl.bind("SUPER + print", hl.dsp.exec_cmd(bin_dir .. "hyprshot -m output -m active"),
        { dont_inhibit = true, description = "Screenshot entire screen to disk" })
    hl.bind(
        "SUPER + SHIFT + print",
        hl.dsp.exec_cmd(bin_dir .. "omarchy-cmd-screenshot fullscreen clipboard"),
        { dont_inhibit = true, description = "Screenshot entire screen to clipboard" }
    )

    -- Lockscreen
    hl.bind("XF86LogOff", hl.dsp.exec_cmd("hyprlock"), { dont_inhibit = true, description = "Lock the screen" })
    -- hyprlock does not turn the screen off. The following adds a 1 second delay
    -- even when the machine was already locked (i.e., press a key to turn display
    -- on, see time, press the key to run the following, wait 1 second for screen to
    -- turn off). I am not going to write a long shell command to fix it; hyprlock
    -- is the place to fix it.
    hl.bind("XF86LogOff", function()
        hl.timer(function()
            hl.dispatch(hl.dsp.dpms({ action = "disable" }))
        end, {timeout = 750, type = "oneshot"})
    end, { locked = true })

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
