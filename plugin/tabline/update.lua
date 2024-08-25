local wezterm = require("wezterm")
local config = require("tabline.config")

local M = {}

function M.init()
	wezterm.on("update-status", function(window)
		require("tabline.component").set_status(window)
	end)
	if config.opts.extensions.ressurect then
		require("tabline.extensions.ressurect")()
	end
end

return M
