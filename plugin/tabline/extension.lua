local wezterm = require('wezterm')
local util = require('tabline.util')
local config = require('tabline.config')

local M = {}

local function set_attributes(sections, colors, window)
  config.sections = sections
  config.colors.normal_mode = colors
  if window then
    require('tabline.component').set_status(window)
  end
end

local function setup_extension(extension)
  local sections = util.deep_extend(util.deep_copy(config.opts.sections), extension.sections or {})
  local colors = util.deep_extend(util.deep_copy(config.normal_mode_colors), extension.colors or {})
  local events = extension.events
  if sections and events then
    wezterm.on(events.show, function(window, ...)
      set_attributes(sections, colors, window)
      if not events.hide then
        wezterm.time.call_after(events.delay or 5, function()
          set_attributes(config.opts.sections, config.normal_mode_colors, window)
        end)
      end
      if events.callback then
        events.callback(window, ...)
      end
    end)
    if events.hide then
      wezterm.on(events.hide, function(window)
        if events.delay then
          wezterm.time.call_after(events.delay, function()
            set_attributes(config.opts.sections, config.normal_mode_colors, window)
          end)
        else
          set_attributes(config.opts.sections, config.normal_mode_colors, window)
        end
      end)
    end
  end
end

function M.load()
  for _, extension in ipairs(config.opts.extensions) do
    if type(extension) == 'string' then
      local internal_extension = require('tabline.extensions.' .. extension)
      for _, ext in ipairs(internal_extension) do
        setup_extension(ext)
      end
    elseif type(extension) == 'table' then
      setup_extension(extension)
    end
  end
end

return M
