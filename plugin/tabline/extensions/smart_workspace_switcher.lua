local config = require('tabline.config')

return {
  {
    events = {
      show = 'smart_workspace_switcher.workspace_switcher.start',
      hide = 'smart_workspace_switcher.workspace_switcher.finished',
    },
    sections = {
      tabline_a = {
        ' Switch Workspace ',
      },
      tabline_c = {},
      tab_active = {},
      tab_inactive = {},
    },
    colors = {
      a = { bg = config.colors.scheme.compose_cursor },
      b = { fg = config.colors.scheme.compose_cursor },
    },
  },
}
