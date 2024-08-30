local wezterm = require('wezterm')

return {
  default_opts = {
    icon = wezterm.nerdfonts.cod_window,
  },
  update = function(window)
    local window_name = window:mux_window():get_title()
    return window_name == '' and 'default' or window_name
  end,
}
