local foreground_process_name = ''

return {
  update = function(tab)
    -- get the foreground process name if available
    if tab.active_pane and tab.active_pane.foreground_process_name then
      foreground_process_name = tab.active_pane.foreground_process_name
      foreground_process_name = foreground_process_name:match('([^/\\]+)[/\\]?$') or foreground_process_name
    end

    -- fallback to the domain name if it is a non-local domain
    if foreground_process_name == '' then
      foreground_process_name = tab.active_pane.domain_name ~= 'local' and tab.active_pane.domain_name or ''
    end

    -- fallback to the title if the foreground process name is unavailable
    -- title defaults to 'wezterm' if another name is unavailable
    if foreground_process_name == '' then
      foreground_process_name = (tab.tab_title and #tab.tab_title > 0) and tab.tab_title or tab.active_pane.title
    end

    return foreground_process_name
  end,
}
