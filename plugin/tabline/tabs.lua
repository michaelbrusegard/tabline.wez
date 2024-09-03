local config = require('tabline.config')
local util = require('tabline.util')

local M = {}

local left_tab_separator = { Text = config.opts.options.tab_separators.left or config.opts.options.tab_separators }
local right_tab_separator = { Text = config.opts.options.tab_separators.right or config.opts.options.tab_separators }
local active_attributes, inactive_attributes, active_separator_attributes, inactive_separator_attributes =
  {}, {}, {}, {}
local tab_active, tab_inactive = {}, {}

local function create_attributes(hover)
  active_attributes = {
    { Foreground = { Color = config.colors.tab.active.fg } },
    { Background = { Color = config.colors.tab.active.bg } },
  }
  inactive_attributes = {
    { Foreground = { Color = hover and config.colors.tab.inactive_hover.fg or config.colors.tab.inactive.fg } },
    { Background = { Color = hover and config.colors.tab.inactive_hover.bg or config.colors.tab.inactive.bg } },
  }
  active_separator_attributes = {
    { Foreground = { Color = config.colors.tab.active.bg } },
    { Background = { Color = config.colors.tab.inactive.bg } },
  }
  inactive_separator_attributes = {
    { Foreground = { Color = hover and config.colors.tab.inactive_hover.bg or config.colors.tab.inactive.bg } },
    { Background = { Color = config.colors.tab.inactive.bg } },
  }
end

local function create_tab_content(tab)
  tab_active = util.extract_components(config.sections.tab_active, active_attributes, tab)
  tab_inactive = util.extract_components(config.sections.tab_inactive, inactive_attributes, tab)
end

local function tabs(tab)
  local result = {}

  if #tab_active > 0 and tab.is_active then
    util.insert_elements(result, active_separator_attributes)
    table.insert(result, right_tab_separator)
    util.insert_elements(result, active_attributes)
    util.insert_elements(result, tab_active)
    util.insert_elements(result, active_separator_attributes)
    table.insert(result, left_tab_separator)
  elseif #tab_inactive > 0 then
    util.insert_elements(result, inactive_separator_attributes)
    table.insert(result, right_tab_separator)
    util.insert_elements(result, inactive_attributes)
    util.insert_elements(result, tab_inactive)
    util.insert_elements(result, inactive_separator_attributes)
    table.insert(result, left_tab_separator)
  end
  return result
end

M.set_title = function(tab, hover)
  create_attributes(hover)
  create_tab_content(tab)
  return tabs(tab)
end

return M
