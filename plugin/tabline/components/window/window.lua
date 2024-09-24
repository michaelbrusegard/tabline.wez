local wezterm = require('wezterm')

return {
  default_opts = {
    icon = wezterm.nerdfonts.cod_window,
  },
  update = function(window)
    local window_title = window:mux_window():get_title()
    return window_title == '' and 'default' or window_title
  end,
}
