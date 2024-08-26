return function(tab, max_length)
	max_length = max_length or 16
	local cwd = ""
	local cwd_uri = tab.active_pane.current_working_dir
	if cwd_uri then
		local file_path = cwd_uri.file_path
		cwd = file_path:match("([^/]+)/?$")
		if cwd and #cwd > max_length then
			cwd = cwd:sub(1, max_length - 1) .. "…"
		end
	end
	return cwd
end
