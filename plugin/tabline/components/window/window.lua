local wezterm = require('wezterm')
local util = require('tabline.util')

local default_opts = {
  icon = wezterm.nerdfonts.cod_window,
}

return function(window, opts)
  opts = util.deep_extend(default_opts, opts or {})
  local window_name = window:mux_window():get_title() or 'no_name'
  if opts.icons_enabled then
    window_name = opts.icon .. ' ' .. window_name
  end
  return window_name
end
