local wezterm = require('wezterm')

return {
  default_opts = {
    icon = wezterm.nerdfonts.cod_window,
  },
  update = function(window)
    local window_name = window:mux_window():get_title() or 'no_name'
    return window_name
  end,
}
