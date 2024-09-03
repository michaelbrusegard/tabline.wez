local wezterm = require('wezterm')

return {
  default_opts = { icon = wezterm.nerdfonts.oct_zoom_in },
  update = function(tab, opts)
    for _, pane in ipairs(tab.panes) do
      if pane.is_zoomed then
        if opts.icons_enabled then
          return ''
        end
        return 'Z'
      end
    end
  end,
}
