local wezterm = require('wezterm')
local config = require('tabline.config')

return {
  {
    'presentation',
    events = {
      show = 'xarvex.presentation.activate',
      hide = 'xarvex.presentation.deactivate',
    },
    sections = {
      tabline_a = {
        ' ' .. wezterm.nerdfonts.md_presentation_play .. ' Presenting ',
      },
      tabline_b = { 'workspace' },

      -- Clear for a focused presentation.
      tabline_c = {},
      tabline_x = {},
      tabline_y = {},
      tabline_z = { 'datetime' },
      tab_active = {},
      tab_inactive = {},
    },
    colors = {
      a = { bg = config.colors.scheme.ansi[7] },
      b = { fg = config.colors.scheme.ansi[7] },
    },
  },
}
