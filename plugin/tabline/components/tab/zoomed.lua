local wezterm = require('wezterm')

return {
  update = function(tab, opts)
    for _, pane in ipairs(tab.panes) do
      if pane.is_zoomed then
        if opts.icons_enabled then
          local icon = opts.icon and opts.icon or wezterm.nerdfonts.oct_zoom_in
          return icon
        else
          return 'Z'
        end
      end

      return ''
    end
  end,
}
