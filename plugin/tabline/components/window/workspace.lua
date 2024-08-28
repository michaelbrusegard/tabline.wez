local wezterm = require('wezterm')
local util = require('tabline.util')

local default_opts = {
  icon = wezterm.nerdfonts.cod_terminal_tmux,
}

return function(_, opts)
  opts = util.deep_extend(default_opts, opts or {})
  local workspace = wezterm.mux.get_active_workspace()
  workspace = string.match(workspace, '[^/\\]+$')
  if opts.icons_enabled then
    workspace = opts.icon .. ' ' .. workspace
  end
  return workspace
end
