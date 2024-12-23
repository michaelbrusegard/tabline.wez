local wezterm = require('wezterm')

return {
  default_opts = { icon = wezterm.nerdfonts.md_bell_badge_outline, icon_no_output = wezterm.nerdfonts.md_bell_outline },
  update = function(tab, opts)
    for _, pane in ipairs(tab.panes) do
      if pane.has_unseen_output then
        if opts.icons_enabled then
          return ''
        end
        return '!'
      end
    end
    if opts.icons_enabled then
      opts.icon = opts.icon_no_output
      return ''
    end
  end,
}
