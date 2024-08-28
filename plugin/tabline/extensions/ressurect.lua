local wezterm = require('wezterm')

return function()
  wezterm.on('smart_workspace_switcher.workspace_switcher.chosen', function(window)
    require('tabline.component').set_status(window)
  end)

  wezterm.on('smart_workspace_switcher.workspace_switcher.created', function(window)
    -- require('tabline.component').set_status(window)
  end)
end
