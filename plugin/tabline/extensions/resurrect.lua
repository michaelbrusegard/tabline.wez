local wezterm = require('wezterm')
local config = require('tabline.config')

return {
  {
    events = {
      show = 'resurrect.fuzzy_load.start',
      hide = 'resurrect.fuzzy_load.finished',
    },
    sections = {
      tabline_a = {
        ' ' .. wezterm.nerdfonts.md_sleep_off .. ' Resurrect Workspace ',
      },
      tabline_c = {},
      tab_active = {},
      tab_inactive = {},
    },
    colors = {
      a = { bg = config.colors.scheme.ansi[3] },
      b = { fg = config.colors.scheme.ansi[3] },
    },
  },
  {
    events = {
      show = 'resurrect.periodic_save',
      delay = 7,
    },
    sections = {
      tabline_x = {
        { Foreground = { Color = config.colors.scheme.indexed[16] } },
        wezterm.nerdfonts.cod_save .. ' saved workspace ',
      },
    },
  },
}
