local wezterm = require('wezterm')

return {
  default_opts = {
    icon = { wezterm.nerdfonts.cod_terminal_tmux },
  },
  update = function()
    local workspace = wezterm.mux.get_active_workspace()
    workspace = string.match(workspace, '[^/\\]+$')
    return workspace
  end,
}
