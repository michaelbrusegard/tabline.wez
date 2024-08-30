local config = require('tabline.config')

return {
  {
    events = {
      show = 'resurrect.fuzzy_load.start',
      hide = 'resurrect.fuzzy_load.stop',
    },
    sections = {
      tabline_a = {
        ' Resurrect a Workspace: ',
      },
      tabline_c = {},
      tab_active = {},
      tab_inactive = {},
    },
  },
  {
    events = {
      show = 'resurrect.periodic_save',
      delay = 7,
    },
    sections = {
      tabline_x = {
        { Foreground = { Color = config.colors.scheme.indexed['16'] } },
        'saving workspace',
      },
    },
  },
}
