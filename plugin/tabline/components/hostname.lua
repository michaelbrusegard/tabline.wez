local wezterm = require("wezterm")

return function(window)
	local cwd_uri = window:active_pane():get_current_working_dir()
	local hostname = ""

	if type(cwd_uri) == "userdata" then
		-- Running on a newer version of wezterm and we have
		-- a URL object here, making this simple!
		hostname = cwd_uri.host or wezterm.hostname()
	else
		-- an older version of wezterm, 20230712-072601-f4abf8fd or earlier,
		-- which doesn't have the Url object
		cwd_uri = cwd_uri:sub(8)
		local slash = cwd_uri:find("/")
		if slash then
			hostname = cwd_uri:sub(1, slash - 1)
		end
	end

	local dot = hostname:find("[.]")
	if dot then
		hostname = hostname:sub(1, dot - 1)
	end

	return hostname
end
