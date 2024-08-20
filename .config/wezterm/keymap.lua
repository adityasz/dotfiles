local wezterm = require("wezterm")
local act = wezterm.action
local module = {}

function module.apply_to_config(config)
    config.keys = {
        {
            key = "r",
            mods = "ALT",
            action = act.SplitPane({direction = "Right", size = {Percent = 50}})
        },
        {
            key = "d",
            mods = "ALT",
            action = act.SplitPane({direction = "Down", size = {Percent = 50}})
        },
        {
            key = "h",
            mods = "ALT",
            action = act.ActivatePaneDirection("Left")
        },
        {
            key = "j",
            mods = "ALT",
            action = act.ActivatePaneDirection("Down")
        },
        {
            key = "k",
            mods = "ALT",
            action = act.ActivatePaneDirection("Up")
        },
        {
            key = "l",
            mods = "ALT",
            action = act.ActivatePaneDirection("Right")
        },
        {
            key = "t",
            mods = "ALT",
            action = act.SpawnTab("CurrentPaneDomain")
        },
        {
            key = "Backspace",
            mods = "CTRL",
            action = act.SendKey({key = "w", mods = "CTRL"})
        },
        {
            key = "c",
            mods = "ALT",
            action = act.CopyTo("Clipboard")
        },
        {
            key = "v",
            mods = "ALT",
            action = act.PasteFrom("Clipboard")
        },
        {
            key = "n",
            mods = "CTRL|SHIFT",
            action = act.SpawnWindow
        },
        {
            key = "F11",
            action = act.ToggleFullScreen
        },
        {
            key = "Tab",
            mods = "CTRL",
            action = act.ActivateLastTab
        }
    }

    for i = 1, 8 do
        table.insert(config.keys, {
            key = tostring(i),
            mods = "ALT",
            action = act.ActivateTab(i - 1)
        })
    end

end

return module
