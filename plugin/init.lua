local wezterm = require('wezterm')

local M = {}

-- Replace the existing package.path to support all other ?.lua files in this directory
package.path = package.path .. ';' .. (select(2, ...):gsub('init.lua$', '?.lua'))

function M.setup(opts)
  require('tabline.config').set(opts)

  wezterm.on('update-status', function(window)
    require('tabline.component').set_status(window)
  end)

  wezterm.on('format-tab-title', function(tab, _, _, _, hover, _)
    return require('tabline.tabs').set_title(tab, hover)
  end)

  require('tabline.extension').load()
end

function M.apply_to_config(config)
  config.use_fancy_tab_bar = false
  config.show_new_tab_button_in_tab_bar = false
  config.tab_max_width = 32
  config.window_decorations = 'RESIZE'
  config.window_padding = {
    left = 0,
    right = 0,
    top = 0,
    bottom = 0,
  }
  config.colors = {
    tab_bar = {
      background = require('tabline.config').colors.normal_mode.c.bg,
    },
  }
  config.status_update_interval = 500
end

function M.get_config()
  return require('tabline.config').opts
end

function M.get_colors()
  return require('tabline.config').colors
end

function M.refresh(window, tab)
  if window then
    require('tabline.component').set_status(window)
  end
  if tab then
    require('tabline.tabs').set_title(tab)
  end
end

return M
