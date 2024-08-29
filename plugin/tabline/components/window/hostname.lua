local wezterm = require('wezterm')

return {
  update = function(window)
    local cwd_uri = window:active_pane():get_current_working_dir()
    local hostname = ''

    if cwd_uri == nil then
      hostname = wezterm.hostname()
    elseif type(cwd_uri) == 'userdata' then
      hostname = cwd_uri.host or wezterm.hostname()
    else
      cwd_uri = cwd_uri:sub(8)
      local slash = cwd_uri:find('/')
      if slash then
        hostname = cwd_uri:sub(1, slash - 1)
      end
    end

    local dot = hostname:find('[.]')
    if dot then
      hostname = hostname:sub(1, dot - 1)
    end

    return hostname
  end,
}
