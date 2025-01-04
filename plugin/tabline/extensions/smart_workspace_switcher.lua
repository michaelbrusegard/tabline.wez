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
        'resurrect.fuzzy_load.start',
        'resurrect.tab_state.restore_tab.start',
        'resurrect.window_state.restore_window.start',
        'resurrect.workspace_state.restore_workspace.start',
        'quick_domain.fuzzy_selector.opened',
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
    theme = {
      a = { bg = config.theme.colors.compose_cursor },
      b = { fg = config.theme.colors.compose_cursor },
    },
  },
}
