local config = require('tabline.config')

return {
  {
    events = {
      show = 'resurrect.periodic_save',
      delay = 7,
    },
    sections = {
      tabline_x = {
        { Foreground = { Color = config.scheme.indexed['16'] } },
        'saving workspace',
      },
    },
  },
}
