local wezterm = require("wezterm")
local config = require("tabline.config")

return function()
	local workspace = wezterm.mux.get_active_workspace()
	workspace = string.match(workspace, "[^/\\]+$")
	if config.opts.options.icons_enabled then
		workspace = wezterm.nerdfonts.md_monitor_multiple .. " " .. workspace
	end
	return workspace
end
