local wezterm = require("wezterm")

return function(window, opts)
	local window_name = window:mux_window():get_title() or "no_name"
	if opts.icons_enabled then
		window_name = wezterm.nerdfonts.cod_window .. " " .. window_name
	end
	return window_name
end
