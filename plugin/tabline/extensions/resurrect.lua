local wezterm = require('wezterm')
local config = require('tabline.config')

return {
  {
    'resurrect',
    events = {
      show = 'resurrect.fuzzy_load.start',
      hide = {
        'resurrect.fuzzy_load.finished',
        'quick_domain.fuzzy_selector.opened',
        'smart_workspace_switcher.workspace_switcher.start',
      },
    },
    sections = {
      tabline_a = {
        ' ' .. wezterm.nerdfonts.md_sleep_off .. ' Resurrect ',
      },
      tabline_b = { 'workspace' },
      tabline_c = { 'window' },
      tab_active = {},
      tab_inactive = {},
    },
    colors = {
      a = { bg = config.theme.colors.ansi[3] },
      b = { fg = config.theme.colors.ansi[3] },
    },
  },
  {
    'resurrect.periodic_save',
    events = {
      show = 'resurrect.periodic_save',
      delay = 7,
    },
    sections = {
      tabline_x = {
        { Foreground = { Color = config.theme.colors.indexed[16] } },
        wezterm.nerdfonts.cod_save .. ' saved workspace ',
      },
    },
  },
}
