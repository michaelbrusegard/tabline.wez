local wezterm = require('wezterm')
local util = require('tabline.util')
local config = require('tabline.config')
local extension = require('tabline.extension')
local mode = require('tabline.components.window.mode')

local M = {}

local left_section_separator =
  { Text = config.opts.options.section_separators.left or config.opts.options.section_separators }
local right_section_separator =
  { Text = config.opts.options.section_separators.right or config.opts.options.section_separators }
local left_component_separator =
  { Text = config.opts.options.component_separators.left or config.opts.options.component_separators }
local right_component_separator =
  { Text = config.opts.options.component_separators.right or config.opts.options.component_separators }

local attributes_a, attributes_b, attributes_c, attributes_x, attributes_y, attributes_z = {}, {}, {}, {}, {}, {}
local section_seperator_attributes_a, section_seperator_attributes_b, section_seperator_attributes_c, section_seperator_attributes_x, section_seperator_attributes_y, section_seperator_attributes_z =
  {}, {}, {}, {}, {}, {}
local tabline_a, tabline_b, tabline_c, tabline_x, tabline_y, tabline_z = {}, {}, {}, {}, {}, {}

local function create_attributes(window)
  local current_mode = mode.get(window)
  local colors = config.theme[current_mode]
  for _, ext in pairs(extension.extensions) do
    if ext.theme then
      colors = util.deep_extend(util.deep_copy(colors), ext.theme)
    end
  end
  attributes_a = {
    { Foreground = { Color = colors.a.fg } },
    { Background = { Color = colors.a.bg } },
    { Attribute = { Intensity = 'Bold' } },
  }
  attributes_b = {
    { Foreground = { Color = colors.b.fg } },
    { Background = { Color = colors.b.bg } },
    { Attribute = { Intensity = 'Normal' } },
  }
  attributes_c = {
    { Foreground = { Color = colors.c.fg } },
    { Background = { Color = colors.c.bg } },
  }
  attributes_x = {
    { Foreground = { Color = colors.x and colors.x.fg or colors.c.fg } },
    { Background = { Color = colors.x and colors.x.bg or colors.c.bg } },
  }
  attributes_y = {
    { Foreground = { Color = colors.y and colors.y.fg or colors.b.fg } },
    { Background = { Color = colors.y and colors.y.bg or colors.b.bg } },
    { Attribute = { Intensity = 'Normal' } },
  }
  attributes_z = {
    { Foreground = { Color = colors.z and colors.z.fg or colors.a.fg } },
    { Background = { Color = colors.z and colors.z.bg or colors.a.bg } },
    { Attribute = { Intensity = 'Bold' } },
  }
  section_seperator_attributes_a = {
    { Foreground = { Color = colors.a.bg } },
    { Background = { Color = colors.b.bg } },
  }
  section_seperator_attributes_b = {
    { Foreground = { Color = colors.b.bg } },
    { Background = { Color = colors.c.bg } },
  }
  section_seperator_attributes_c = {
    { Foreground = { Color = colors.a.bg } },
    { Background = { Color = colors.c.bg } },
  }
  section_seperator_attributes_x = {
    { Foreground = { Color = colors.z and colors.z.bg or colors.a.bg } },
    { Background = { Color = colors.x and colors.x.bg or colors.c.bg } },
  }
  section_seperator_attributes_y = {
    { Foreground = { Color = colors.y and colors.y.bg or colors.b.bg } },
    { Background = { Color = colors.x and colors.x.bg or colors.c.bg } },
  }
  section_seperator_attributes_z = {
    { Foreground = { Color = colors.z and colors.z.bg or colors.a.bg } },
    { Background = { Color = colors.y and colors.y.bg or colors.b.bg } },
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
  local sections = config.sections
  for _, ext in pairs(extension.extensions) do
    if ext.sections then
      sections = util.deep_extend(util.deep_copy(sections), ext.sections)
    end
  end
  tabline_a = insert_component_separators(util.extract_components(sections.tabline_a, attributes_a, window, true), true)
  tabline_b = insert_component_separators(util.extract_components(sections.tabline_b, attributes_b, window, true), true)
  tabline_c = insert_component_separators(util.extract_components(sections.tabline_c, attributes_c, window, true), true)
  tabline_x =
    insert_component_separators(util.extract_components(sections.tabline_x, attributes_x, window, true), false)
  tabline_y =
    insert_component_separators(util.extract_components(sections.tabline_y, attributes_y, window, true), false)
  tabline_z =
    insert_component_separators(util.extract_components(sections.tabline_z, attributes_z, window, true), false)
end

local function right_section()
  local result = {}
  if #tabline_x > 0 then
    util.insert_elements(result, attributes_x)
    util.insert_elements(result, tabline_x)
  end
  if #tabline_y > 0 then
    util.insert_elements(result, section_seperator_attributes_y)
    table.insert(result, right_section_separator)
  end
  if #tabline_y > 0 then
    util.insert_elements(result, attributes_y)
    util.insert_elements(result, tabline_y)
  end
  if #tabline_z > 0 and #tabline_y > 0 then
    util.insert_elements(result, section_seperator_attributes_z)
    table.insert(result, right_section_separator)
  elseif #tabline_z > 0 then
    util.insert_elements(result, section_seperator_attributes_x)
    table.insert(result, right_section_separator)
  end
  if #tabline_z > 0 then
    util.insert_elements(result, attributes_z)
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
  elseif #tabline_a > 0 then
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
  create_attributes(window)
  create_sections(window)
  window:set_left_status(wezterm.format(left_section()))
  window:set_right_status(wezterm.format(right_section()))
end

return M
