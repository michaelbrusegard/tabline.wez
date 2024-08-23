local config = require("config")

return function(window)
	local mode = window:active_key_table() or "normal_mode"

	return { Text = config.opts.options["mode_text"][mode] }
end
