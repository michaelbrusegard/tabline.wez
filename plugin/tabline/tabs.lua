local config = require('tabline.config')
local util = require('tabline.util')
local opts = config.opts
local sections = opts.sections
local colors = config.colors

local M = {}

local reset = 'ResetAttributes'
local space = { Text = ' ' }
local left_tab_separator = { Text = opts.options.tab_separators.left or opts.options.tab_separators }
local right_tab_separator = { Text = opts.options.tab_separators.right or opts.options.tab_separators }
local active_attributes, inactive_attributes, active_separator_attributes, inactive_separator_attributes =
  {}, {}, {}, {}
local tab_active, tab_inactive = {}, {}

local function create_attributes()
  active_attributes = {
    { Foreground = { Color = colors.tab.active.fg } },
    { Background = { Color = colors.tab.active.bg } },
  }
  inactive_attributes = {
    { Foreground = { Color = colors.tab.inactive.fg } },
    { Background = { Color = colors.tab.inactive.bg } },
  }
  active_separator_attributes = {
    { Foreground = { Color = colors.tab.active.bg } },
    { Background = { Color = colors.tab.inactive.bg } },
  }
  inactive_separator_attributes = {
    { Foreground = { Color = colors.tab.inactive.bg } },
    { Background = { Color = colors.tab.inactive.bg } },
  }
end

local function create_tab_content(tab)
  tab_active = util.extract_components(sections.tab_active, active_attributes, tab)
  tab_inactive = util.extract_components(sections.tab_inactive, inactive_attributes, tab)
end

local function tabs(tab)
  local result = {}

  if tab.is_active then
    util.insert_elements(result, active_separator_attributes)
    table.insert(result, right_tab_separator)
    table.insert(result, reset)
    util.insert_elements(result, active_attributes)
    table.insert(result, space)
    util.insert_elements(result, tab_active)
    table.insert(result, space)
    util.insert_elements(result, active_separator_attributes)
    table.insert(result, left_tab_separator)
  else
    util.insert_elements(result, inactive_separator_attributes)
    table.insert(result, right_tab_separator)
    table.insert(result, reset)
    util.insert_elements(result, inactive_attributes)
    table.insert(result, space)
    util.insert_elements(result, tab_inactive)
    table.insert(result, space)
    util.insert_elements(result, inactive_separator_attributes)
    table.insert(result, left_tab_separator)
  end
  return result
end

M.set_title = function(tab)
  create_attributes()
  create_tab_content(tab)
  return tabs(tab)
end

return M
