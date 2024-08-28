local wezterm = require('wezterm')

return function(_, opts)
  local workspace = wezterm.mux.get_active_workspace()
  workspace = string.match(workspace, '[^/\\]+$')
  if opts.icons_enabled then
    workspace = wezterm.nerdfonts.cod_terminal_tmux .. ' ' .. workspace
  end
  return workspace
end
