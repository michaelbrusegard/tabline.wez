local wezterm = require("wezterm")
local config = require("tabline.config")

return function(window)
	local window_name = window:mux_window():get_title() or "no_name"
	if config.opts.options.icons_enabled then
		window_name = wezterm.nerdfonts.md_monitor_multiple .. " " .. window_name
	end
	return window_name
end
