local foreground_process_name = ""

return function(tab)
	if tab.active_pane and tab.active_pane.foreground_process_name then
		foreground_process_name = tab.active_pane.foreground_process_name
		foreground_process_name = foreground_process_name:match("([^/]+)/?$") or foreground_process_name
	end
	return foreground_process_name
end
