local wezterm = require("wezterm")
local config = require("tabline.config")

local M = {}

function M.init()
	wezterm.on("update-status", function(window)
		require("tabline.component").set_status(window)
	end)
	wezterm.on("format-tab-title", function(tab)
		return require("tabline.tabs").set_title(tab)
	end)
	if type(config.opts.extensions.ressurect) == "string" then
		require("tabline.extensions.ressurect")()
	end
end

return M
