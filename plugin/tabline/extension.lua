local wezterm = require('wezterm')
local util = require('tabline.util')
local config = require('tabline.config')

local M = {}

local function setup_extension(extension)
  local sections = util.deep_extend(config.opts.sections, extension.sections)
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

function M.load()
  for _, extension in ipairs(config.opts.extensions) do
    if type(extension) == 'string' then
      local extension_plugin = require('tabline.extensions.' .. extension)
      for _, ext in ipairs(extension_plugin) do
        setup_extension(ext)
      end
    elseif type(extension) == 'table' then
      setup_extension(extension)
    end
  end
end

return M
