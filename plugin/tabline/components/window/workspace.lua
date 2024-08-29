local wezterm = require('wezterm')

return {
  default_opts = {
    icon = wezterm.nerdfonts.cod_terminal_tmux,
  },
  update = function(_, opts)
    local workspace = wezterm.mux.get_active_workspace()
    workspace = string.match(workspace, '[^/\\]+$')
    if opts.icons_enabled then
      workspace = opts.icon .. ' ' .. workspace
    end
    return workspace
  end,
}
