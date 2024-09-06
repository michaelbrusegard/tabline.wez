local wezterm = require('wezterm')
local util = require('tabline.util')
local config = require('tabline.config')

local M = {}

local left_section_separator =
  { Text = config.opts.options.section_separators.left or config.opts.options.section_separators }
local right_section_separator =
  { Text = config.opts.options.section_separators.right or config.opts.options.section_separators }
local left_component_separator =
  { Text = config.opts.options.component_separators.left or config.opts.options.component_separators }
local right_component_separator =
  { Text = config.opts.options.component_separators.right or config.opts.options.component_separators }

local attributes_a, attributes_b, attributes_c = {}, {}, {}
local section_seperator_attributes_a, section_seperator_attributes_b, section_seperator_attributes_c = {}, {}, {}
local tabline_a, tabline_b, tabline_c, tabline_x, tabline_y, tabline_z = {}, {}, {}, {}, {}, {}

local function create_attributes(window)
  local mode = window:active_key_table() or 'normal_mode'
  attributes_a = {
    { Foreground = { Color = config.colors[mode].a.fg } },
    { Background = { Color = config.colors[mode].a.bg } },
    { Attribute = { Intensity = 'Bold' } },
  }
  attributes_b = {
    { Foreground = { Color = config.colors[mode].b.fg } },
    { Background = { Color = config.colors[mode].b.bg } },
    { Attribute = { Intensity = 'Normal' } },
  }
  attributes_c = {
    { Foreground = { Color = config.colors[mode].c.fg } },
    { Background = { Color = config.colors[mode].c.bg } },
  }
  section_seperator_attributes_a = {
    { Foreground = { Color = config.colors[mode].a.bg } },
    { Background = { Color = config.colors[mode].b.bg } },
  }
  section_seperator_attributes_b = {
    { Foreground = { Color = config.colors[mode].b.bg } },
    { Background = { Color = config.colors[mode].c.bg } },
  }
  section_seperator_attributes_c = {
    { Foreground = { Color = config.colors[mode].a.bg } },
    { Background = { Color = config.colors[mode].c.bg } },
  }
end

local function insert_component_separators(components, is_left)
  local i = 1
  while i <= #components do
    if type(components[i]) == 'table' and components[i].Text and i < #components then
      table.insert(components, i + 1, is_left and left_component_separator or right_component_separator)
      i = i + 1
    end
    i = i + 1
  end
  return components
end

local function create_sections(window)
  tabline_a =
    insert_component_separators(util.extract_components(config.sections.tabline_a, attributes_a, window), true)
  tabline_b =
    insert_component_separators(util.extract_components(config.sections.tabline_b, attributes_b, window), true)
  tabline_c =
    insert_component_separators(util.extract_components(config.sections.tabline_c, attributes_c, window), true)
  tabline_x =
    insert_component_separators(util.extract_components(config.sections.tabline_x, attributes_c, window), false)
  tabline_y =
    insert_component_separators(util.extract_components(config.sections.tabline_y, attributes_b, window), false)
  tabline_z =
    insert_component_separators(util.extract_components(config.sections.tabline_z, attributes_a, window), false)
end

local function right_section()
  local result = {}
  if #tabline_x > 0 then
    util.insert_elements(result, attributes_c)
    util.insert_elements(result, tabline_x)
  end
  if #tabline_y > 0 then
    util.insert_elements(result, section_seperator_attributes_b)
    table.insert(result, right_section_separator)
  end
  if #tabline_y > 0 then
    util.insert_elements(result, attributes_b)
    util.insert_elements(result, tabline_y)
  end
  if #tabline_z > 0 and #tabline_y > 0 then
    util.insert_elements(result, section_seperator_attributes_a)
    table.insert(result, right_section_separator)
  elseif #tabline_z > 0 and #tabline_x > 0 then
    util.insert_elements(result, section_seperator_attributes_c)
    table.insert(result, right_section_separator)
  end
  if #tabline_z > 0 then
    util.insert_elements(result, attributes_a)
    util.insert_elements(result, tabline_z)
  end
  return result
end

local function left_section()
  local result = {}
  if #tabline_a > 0 then
    util.insert_elements(result, attributes_a)
    util.insert_elements(result, tabline_a)
  end
  if #tabline_a > 0 and #tabline_b > 0 then
    util.insert_elements(result, section_seperator_attributes_a)
    table.insert(result, left_section_separator)
  elseif #tabline_a > 0 and #tabline_c > 0 then
    util.insert_elements(result, section_seperator_attributes_c)
    table.insert(result, left_section_separator)
  end
  if #tabline_b > 0 then
    util.insert_elements(result, attributes_b)
    util.insert_elements(result, tabline_b)
  end
  if #tabline_b > 0 then
    util.insert_elements(result, section_seperator_attributes_b)
    table.insert(result, left_section_separator)
  end
  if #tabline_c > 0 then
    util.insert_elements(result, attributes_c)
    util.insert_elements(result, tabline_c)
  end
  return result
end

function M.set_status(window)
  if not window.window_id then
    return
  end
  create_attributes(window)
  create_sections(window)
  window:set_left_status(wezterm.format(left_section()))
  window:set_right_status(wezterm.format(right_section()))
end

return M
