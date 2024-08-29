local wezterm = require('wezterm')

return {
  default_opts = {
    icon = wezterm.nerdfonts.cod_window,
  },
  update = function(window, opts)
    local window_name = window:mux_window():get_title() or 'no_name'
    if opts.icons_enabled then
      window_name = opts.icon .. ' ' .. window_name
    end
    return window_name
  end,
}
