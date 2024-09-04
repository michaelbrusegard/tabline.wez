local foreground_process_name = ''

return {
  update = function(tab)
    -- get the foreground process name if available
    if tab.active_pane and tab.active_pane.foreground_process_name then
      foreground_process_name = tab.active_pane.foreground_process_name
      foreground_process_name = foreground_process_name:match('([^/\\]+)[/\\]?$') or foreground_process_name
    end

    -- fallback to the title if the foreground process name is unavailable
    -- Wezterm uses OSC 1/2 escape sequences to guess the process name and set the title
    -- see https://wezfurlong.org/wezterm/config/lua/pane/get_title.html
    -- title defaults to 'wezterm' if another name is unavailable
    if foreground_process_name == '' then
      foreground_process_name = (tab.tab_title and #tab.tab_title > 0) and tab.tab_title or tab.active_pane.title
    end

    -- if the tab active pane contains a non-local domain, use the domain name
    if foreground_process_name == 'wezterm' then
      foreground_process_name = tab.active_pane.domain_name ~= 'local' and tab.active_pane.domain_name or 'wezterm'
    end

    return foreground_process_name
  end,
}
