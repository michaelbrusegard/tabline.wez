local wezterm = require('wezterm')
local util = require('tabline.util')

local M = {}

local default_opts = {
  options = {
    theme = 'Catppuccin Mocha',
    tabs_enabled = true,
    section_separators = {
      left = wezterm.nerdfonts.pl_left_hard_divider,
      right = wezterm.nerdfonts.pl_right_hard_divider,
    },
    component_separators = {
      left = wezterm.nerdfonts.pl_left_soft_divider,
      right = wezterm.nerdfonts.pl_right_soft_divider,
    },
    tab_separators = {
      left = wezterm.nerdfonts.pl_left_hard_divider,
      right = wezterm.nerdfonts.pl_right_hard_divider,
    },
  },
  sections = {
    tabline_a = { 'mode' },
    tabline_b = { 'workspace' },
    tabline_c = { ' ' },
    tab_active = {
      'index',
      { 'parent', padding = 0 },
      '/',
      { 'cwd', padding = { left = 0, right = 1 } },
      { 'zoomed', padding = 0 },
    },
    tab_inactive = { 'index', { 'process', padding = { left = 0, right = 1 } } },
    tabline_x = { 'ram', 'cpu' },
    tabline_y = { 'datetime', 'battery' },
    tabline_z = { 'domain' },
  },
  extensions = {},
}

local default_component_opts = {
  icons_enabled = true,
  icons_only = false,
  padding = 1,
}

local function lighten_color(color, percent)
  local r = tonumber(color:sub(2, 3), 16)
  local g = tonumber(color:sub(4, 5), 16)
  local b = tonumber(color:sub(6, 7), 16)

  r = math.floor(r + ((255 - r) * percent))
  g = math.floor(g + ((255 - g) * percent))
  b = math.floor(b + ((255 - b) * percent))

  return string.format('#%02x%02x%02x', r, g, b)
end

local function get_colors(theme)
  local colors = type(theme) == 'string' and wezterm.color.get_builtin_schemes()[theme] or theme
  local surface = lighten_color(colors.background, 0.1)
  local background = colors.tab_bar and colors.tab_bar.inactive_tab and colors.tab_bar.inactive_tab.bg_color
    or colors.background

  if colors.tab_bar and colors.tab_bar.inactive_tab and colors.tab_bar.inactive_tab_edge ~= background then
    surface = colors.tab_bar.inactive_tab_edge or surface
  end

  return {
    normal_mode = {
      a = { fg = background, bg = colors.ansi[5] },
      b = { fg = colors.ansi[5], bg = surface },
      c = { fg = colors.foreground, bg = background },
    },
    copy_mode = {
      a = { fg = background, bg = colors.ansi[4] },
      b = { fg = colors.ansi[4], bg = surface },
      c = { fg = colors.foreground, bg = background },
    },
    search_mode = {
      a = { fg = background, bg = colors.ansi[3] },
      b = { fg = colors.ansi[3], bg = surface },
      c = { fg = colors.foreground, bg = background },
    },
    tab = {
      active = { fg = colors.ansi[5], bg = surface },
      inactive = { fg = colors.foreground, bg = background },
      inactive_hover = { fg = colors.ansi[6], bg = surface },
    },
    colors = colors,
  }
end

local function set_component_opts(user_opts)
  local component_opts = {}

  for key, default_value in pairs(default_component_opts) do
    component_opts[key] = default_value
    if user_opts.options[key] ~= nil then
      component_opts[key] = user_opts.options[key]
      user_opts.options[key] = nil
    end
  end

  return component_opts
end

function M.set(user_opts)
  user_opts = user_opts or { options = {} }
  user_opts.options = user_opts.options or {}
  local color_overrides = user_opts.options.color_overrides or {}
  user_opts.options.color_overrides = nil

  M.component_opts = set_component_opts(user_opts)
  M.opts = util.deep_extend(default_opts, user_opts)
  M.sections = util.deep_copy(M.opts.sections)
  M.theme = util.deep_extend(get_colors(M.opts.options.theme), color_overrides)
end

return M
