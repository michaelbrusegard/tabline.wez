local wezterm = require("wezterm")

return function()
	local time = wezterm.time.now():format("%Y-%m-%d %H:%M:%S")
	return time
end
