local wezterm = require('wezterm')
local util = require('tabline.util')
local config = require('tabline.config')

local M = {}

local function setup_extension(extension)
  local sections = util.deep_extend(util.deep_copy(config.opts.sections), extension.sections)
  local events = extension.events
  if sections and events then
    wezterm.on(events.start, function()
      config.sections = sections
      if not events.stop then
        wezterm.time.call_after(events.delay or 5, function()
          wezterm.log_info(config.opts.sections)
          config.sections = config.opts.sections
        end)
      end
    end)
    if events.stop then
      wezterm.on(events.stop, function()
        if events.delay then
          wezterm.time.call_after(events.delay, function()
            config.sections = config.opts.sections
          end)
        else
          config.sections = config.opts.sections
        end
      end)
    end
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
