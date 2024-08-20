local wezterm = require("wezterm")
local module = {}

function module.apply_to_config(config)
    function get_appearance()
        if wezterm.gui then
            return wezterm.gui.get_appearance()
        end
        return "Light"
    end

    function scheme_for_appearance(appearance)
        if appearance:find 'Dark' then
            return "OneHalfDark"
        else
            return "Light"
        end
    end
    config.window_frame = {
        active_titlebar_bg = "#ffffff",
        inactive_titlebar_bg = "#eeeeee"
    }

    config.colors = {
        tab_bar = {
            active_tab = {
                bg_color = "#eeeeee",
                fg_color = "#000000"
            },
            inactive_tab = {
                bg_color = "#ffffff",
                fg_color = "#000000",
            },
            new_tab = {
                bg_color = "#ffffff",
                fg_color = "#000000"
            }
        }
    }
    config.color_scheme = scheme_for_appearance(get_appearance())
end

return module
