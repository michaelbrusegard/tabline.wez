local parent = ""

return function(tab)
	local max_length = 16
	local cwd_uri = tab.active_pane.current_working_dir
	if cwd_uri then
		local file_path = cwd_uri.file_path
		parent = file_path:match(".*/(.*)/")
		if parent and #parent > max_length then
			parent = parent:sub(1, max_length - 1) .. "…"
		end
	end
	return parent
end
