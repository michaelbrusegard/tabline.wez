local wezterm = require("wezterm")

return function()
	local workspace = wezterm.mux.get_active_workspace()
	workspace = string.match(workspace, "[^/\\]+$")

	return workspace
end
