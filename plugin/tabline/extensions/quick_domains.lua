local config = require('tabline.config')

return {
  {
    events = {
      show = 'quick_domain.fuzzy_selector.opened',
      hide = 'quick_domain.fuzzy_selector.canceled',
    },
    sections = {
      tabline_a = {
        ' Switch Domains ',
      },
      tabline_b = { 'workspace' },
      tabline_c = {},
      tab_active = {},
      tab_inactive = {},
    },
    colors = {
      a = { bg = config.colors.scheme.tab_bar.active_tab.bg_color },
      b = { fg = config.colors.scheme.tab_bar.active_tab.bg_color },
    },
  },
}
