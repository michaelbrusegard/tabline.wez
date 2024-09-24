local wezterm = require('wezterm')
local config = require('tabline.config')

local M = {}

M.extensions = {}

local function correct_window(window)
  if window then
    if window.gui_window then
      window = window:gui_window()
    end
  end
  return window
end

local function refresh_tabline(window)
  if window and window.window_id then
    require('tabline.component').set_status(window)
  end
end

local function add_extension(extension)
  local exists = false
  for _, ext in ipairs(M.extensions) do
    if ext[1] == extension[1] then
      exists = true
      break
    end
  end
  if not exists then
    table.insert(M.extensions, extension)
  end
end

local function remove_extension(extension)
  for i, ext in ipairs(M.extensions) do
    if ext[1] == extension[1] then
      table.remove(M.extensions, i)
      break
    end
  end
end

local function on_show_event(event, extension)
  wezterm.on(event, function(window, ...)
    window = correct_window(window)
    add_extension(extension)
    refresh_tabline(window)
    if not extension.events.hide then
      wezterm.time.call_after(extension.events.delay or 5, function()
        remove_extension(extension)
        refresh_tabline(window)
      end)
    end
    if extension.events.callback then
      extension.events.callback(window, ...)
    end
  end)
end

local function on_hide_event(event, extension)
  wezterm.on(event, function(window)
    window = correct_window(window)
    if extension.events.delay then
      wezterm.time.call_after(extension.events.delay, function()
        remove_extension(extension)
        refresh_tabline(window)
      end)
    else
      remove_extension(extension)
      refresh_tabline(window)
    end
  end)
end

local function setup_extension(extension)
  if type(extension.events.show) == 'string' then
    on_show_event(extension.events.show, extension)
  else
    for _, event in ipairs(extension.events.show) do
      on_show_event(event, extension)
    end
  end
  if extension.events.hide then
    if type(extension.events.hide) == 'string' then
      on_hide_event(extension.events.hide, extension)
    elseif type(extension.events.hide) == 'table' then
      for _, event in ipairs(extension.events.hide) do
        on_hide_event(event, extension)
      end
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
