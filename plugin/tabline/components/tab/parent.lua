local util = require("tabline.util")

local parent = ""

local default_opts = { max_length = 16 }

return function(tab, opts)
	opts = util.deep_extend(default_opts, opts or {})
	local cwd_uri = tab.active_pane.current_working_dir
	if cwd_uri then
		local file_path = cwd_uri.file_path
		parent = file_path:match(".*/(.*)/")
		if parent and #parent > opts.max_length then
			parent = parent:sub(1, opts.max_length - 1) .. "…"
		end
	end
	return parent
end
