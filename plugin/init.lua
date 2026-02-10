local wezterm = require('wezterm')

local M = {}

--- Checks if the user is on windows
local is_windows = string.match(wezterm.target_triple, 'windows') ~= nil
local separator = is_windows and '\\' or '/'

local plugin_dir = wezterm.plugin.list()[1].plugin_dir:gsub(separator .. '[^' .. separator .. ']*$', '')

function plugin_package_path()

  local basename = "tabline.wez"

  -- simple encoding map (incomplete, though should work fine unless plugin is
  -- installed locally into the subfolder with really weird name)
  local encmap = {
    [":"] = "sCs",
    ["/"] = "sZs",
    ["\\"] = "sBs",
    ["."]  = "sDs",
    ["%"]  = "sPs",
  }

  local components = {
    string.format("https://github.com/michaelbrusegard/%s", basename),
    string.format("https://github.com/michaelbrusegard/%s/", basename),
    string.format("http://github.com/michaelbrusegard/%s", basename),
    string.format("http://github.com/michaelbrusegard/%s/", basename),
    basename,
  }

  local i = nil
  for i = 1, #components do
    components[i] = components[i]:gsub("[%:%/%\\%.%%]", encmap)
  end

  -- add unescaped name "as-is". Covers the case when plugin is installed
  -- into $XDG_DATA_HOME/wezterm/plugins via direct clone
  components[#components+1] = basename

  local plugin, plugin_subdir, my_package_subdir = {}, "", nil
  for _, plugin in ipairs(wezterm.plugin.list()) do
    plugin_subdir = plugin.component
    for i = 1, #components do

      -- this one covers both (https:// and http://) cause ":" is translated to "sCs"
      if plugin_subdir:sub(1, 5) == "https" then
        if plugin_subdir == components[i] then
          my_package_subdir = plugin_subdir
          break
        end
      elseif plugin_subdir:sub(1, 7) == "filesCs" then
        -- there is no way predict the full local path. Therefore, the best
        -- can be done here is checking the "leaf" folder
        if plugin_subdir:match("s[BZ]s" .. components[i] .. "$") ~= nil then
          my_package_subdir = plugin_subdir
          break
        end
      elseif plugin_subdir == components[i] then
        -- this one handles the case when plugin whas cloned "as is" somewhere
        -- into $XDG_DATA_HOME/weztermp/plugins
        my_package_subdir = plugin_subdir
        break
      end
    end

    if my_package_subdir then
      break
    end
  end

  if not my_package_subdir then
    -- fallback to the most probable (derived from official github address) option
    my_package_subdir = components[1]
  end

  return plugin_dir
        .. separator
        .. my_package_subdir
        .. separator
        .. 'plugin'
        .. separator
        .. '?.lua'


end

package.path = package.path
  .. ';'
  .. plugin_package_path()

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
  config.window_padding = config.window_padding or {}
  config.window_padding.left = 0
  config.window_padding.right = 0
  config.window_padding.top = 0
  config.window_padding.bottom = 0
  config.colors = config.colors or {}
  config.colors.tab_bar = config.colors.tab_bar or {}
  config.colors.tab_bar.background = require('tabline.config').theme.normal_mode.c.bg
  config.status_update_interval = 500
end

function M.get_config()
  return require('tabline.config').opts
end

function M.get_theme()
  return require('tabline.config').theme
end

function M.set_theme(theme, overrides)
  return require('tabline.config').set_theme(theme, overrides)
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
