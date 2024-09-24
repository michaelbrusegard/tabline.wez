local config = require('tabline.config')

return {
  {
    'smart_workspace_switcher',
    events = {
      show = 'smart_workspace_switcher.workspace_switcher.start',
      hide = {
        'smart_workspace_switcher.workspace_switcher.canceled',
        'smart_workspace_switcher.workspace_switcher.chosen',
        'smart_workspace_switcher.workspace_switcher.created',
      },
    },
    sections = {
      tabline_a = {
        ' Switch Workspace ',
      },
      tabline_b = { 'workspace' },
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
