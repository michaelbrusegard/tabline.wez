local wezterm = require("wezterm")

local M = {}

--- Checks if the user is on windows
local is_windows = wezterm.target_triple == "x86_64-pc-windows-msvc"
local separator = is_windows and "\\" or "/"

local plugin_dir = wezterm.plugin.list()[1].plugin_dir:gsub(separator .. "[^" .. separator .. "]*$", "")

--- Checks if the plugin directory exists
local function directory_exists(path)
	local success, result = pcall(wezterm.read_dir, plugin_dir .. path)
	return success and result
end

--- Returns the name of the package, used when requiring modules
local function get_require_path()
	local path1 = "httpssCssZssZsgithubsDscomsZsmichaelbrusegardsZstablinesDswez"
	local path2 = "httpssCssZssZsgithubsDscomsZsmichaelbrusegardsZstablinesDswezsZs"
	return directory_exists(path2) and path2 or path1
end

package.path = package.path
	.. ";"
	.. plugin_dir
	.. separator
	.. get_require_path()
	.. separator
	.. "plugin"
	.. separator
	.. "?.lua"

function M.setup(opts)
	require("tabline.config").set(opts)
	require("tabline.update").init()
end

return M
