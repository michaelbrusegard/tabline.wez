local wezterm = require('wezterm')
local config = require('tabline.config')

local M = {}

function M.load()
  for _, extension in ipairs(config.opts.extensions) do
    if type(extension) == 'string' then
      require('tabline.extensions.' .. extension)()
    elseif type(extension) == 'table' then
      local sections = extension.sections
      local events = extension.events

      if sections and events then
        wezterm.on(events.start, function()
          config.sections = sections
        end)

        wezterm.on(events.stop, function()
          config.sections = config.opts.sections
        end)
      end
    end
  end
end

return M
