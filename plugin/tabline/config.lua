local wezterm = require('wezterm')
local util = require('tabline.util')

local M = {}

M.opts = {}
M.sections = {}
M.component_opts = {}
M.colors = {}
M.normal_mode_colors = {}

local default_opts = {
  options = {
    theme = 'Catppuccin Mocha',
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
      'tab_index',
      { 'parent', padding = 0 },
      '/',
      { 'cwd', padding = { left = 0, right = 1 } },
    },
    tab_inactive = { 'tab_index', { 'process', padding = { left = 0, right = 1 } } },
    tabline_x = { 'ram', 'cpu' },
    tabline_y = { 'datetime', 'battery' },
    tabline_z = { 'hostname' },
  },
  extensions = {},
}

local default_component_opts = {
  icons_enabled = true,
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
  local scheme = wezterm.color.get_builtin_schemes()[theme]

  local mantle = scheme.background
  local surface0 = lighten_color(scheme.background, 0.1)
  local blue = scheme.ansi[5]
  local text = scheme.foreground
  local yellow = scheme.ansi[4]
  local green = scheme.ansi[3]
  local pink = scheme.ansi[6]

  if scheme.tab_bar then
    if scheme.tab_bar.inactive_tab then
      mantle = scheme.tab_bar.inactive_tab.bg_color or mantle
      if scheme.tab_bar.inactive_tab_edge ~= mantle then
        surface0 = scheme.tab_bar.inactive_tab_edge or surface0
      end
    end
  end

  M.normal_mode_colors = {
    a = { fg = mantle, bg = blue },
    b = { fg = blue, bg = surface0 },
    c = { fg = text, bg = mantle },
  }

  return {
    normal_mode = util.deep_copy(M.normal_mode_colors),
    copy_mode = {
      a = { fg = mantle, bg = yellow },
      b = { fg = yellow, bg = surface0 },
      c = { fg = text, bg = mantle },
    },
    search_mode = {
      a = { fg = mantle, bg = green },
      b = { fg = green, bg = surface0 },
      c = { fg = text, bg = mantle },
    },
    tab = {
      active = { fg = blue, bg = surface0 },
      inactive = { fg = text, bg = mantle, hover = { fg = pink, bg = surface0 } },
    },
    scheme = scheme,
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
  local color_overrides = user_opts.options.color_overrides or {}
  user_opts.options.color_overrides = nil

  M.component_opts = set_component_opts(user_opts)
  M.opts = util.deep_extend(default_opts, user_opts)
  M.sections = util.deep_copy(M.opts.sections)
  M.colors = util.deep_extend(get_colors(M.opts.options.theme), color_overrides)
end

return M
