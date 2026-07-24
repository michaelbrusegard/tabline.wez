local wezterm = require('wezterm')

local M = {}

--- Checks if the user is on windows
local is_windows = string.match(wezterm.target_triple, 'windows') ~= nil
local separator = is_windows and '\\' or '/'

local plugin_dir = wezterm.plugin.list()[1].plugin_dir:gsub(separator .. '[^' .. separator .. ']*$', '')

function plugin_package_path()

  local basename = "tabline.wez"

  -- simple encoding map (incomplete, though should work fine unless plugin is
  -- installed locally into the subfolder with really weird name). This mirrors
  -- the way wezterm encodes plugin URLs into the component/subdir name.
  local encmap = {
    [":"] = "sCs",
    ["/"] = "sZs",
    ["\\"] = "sBs",
    ["."]  = "sDs",
    ["%"]  = "sPs",
  }

  -- Encoded repo name as it appears at the end of an encoded plugin component,
  -- e.g. "tabline.wez" -> "tablinesDswez". We match on the repo name only,
  -- independent of the GitHub user/org, so forks resolve to their own checkout
  -- instead of always pointing back at the upstream author.
  local enc_basename = basename:gsub("[%:%/%\\%.%%]", encmap)
  -- Pattern-safe basename for matching raw (unencoded) local filesystem paths.
  local pat_basename = basename:gsub("[%(%)%.%%%+%-%*%?%[%]%^%$]", "%%%1")

  local plugin, plugin_subdir, my_package_subdir = {}, "", nil
  for _, plugin in ipairs(wezterm.plugin.list()) do
    plugin_subdir = plugin.component

    if plugin_subdir == basename or plugin_subdir == enc_basename then
      -- installed under the bare repo name (e.g. direct clone into
      -- $XDG_DATA_HOME/wezterm/plugins), or as the bare encoded name
      my_package_subdir = plugin_subdir
    elseif plugin_subdir:match("s[BZ]s" .. enc_basename .. "s[BZ]s$")
      or plugin_subdir:match("s[BZ]s" .. enc_basename .. "$") then
      -- encoded URL/path whose leaf folder is this repo, with or without a
      -- trailing separator; the user/org portion is ignored on purpose
      my_package_subdir = plugin_subdir
    elseif plugin_subdir:match("[/\\]" .. pat_basename .. "[/\\]?$") then
      -- raw (unencoded) local path whose leaf folder is this repo
      my_package_subdir = plugin_subdir
    end

    if my_package_subdir then
      break
    end
  end

  if not my_package_subdir then
    -- fallback to the bare repo name (best guess when nothing matched)
    my_package_subdir = enc_basename
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

  wezterm.on('update-status', function(window, pane)
    require('tabline.component').set_status(window, pane)
  end)

  wezterm.on('format-tab-title', function(tab, _, _, _, hover, _)
    return require('tabline.tabs').set_title(tab, tab.active_pane, hover)
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
