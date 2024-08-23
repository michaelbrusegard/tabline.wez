local wezterm = require("wezterm")
local util = require("util")
local config = require("config")
local opts = config.opts
local colors = config.colors

local M = {}

local left_section_separator = { Text = opts.section_separators.left }
local right_section_separator = { Text = opts.section_separators.right }
local left_component_separator =
	{ { Text = " " }, { Text = opts.component_separators.left }, { Text = " " }, "ResetAttributes" }
local right_component_separator =
	{ { Text = " " }, { Text = opts.component_separators.right }, { Text = " " }, "ResetAttributes" }

local attributes_a, attributes_b, attributes_c = {}, {}, {}
local tabline_a, tabline_b, tabline_c, tabline_x, tabline_y, tabline_z = {}, {}, {}, {}, {}, {}

local function create_attributes(mode)
	attributes_a = {
		{ Foreground = { Color = colors[mode].a.fg } },
		{ Background = { Color = colors[mode].a.bg } },
		{ Attribute = { Intensity = "Bold" } },
	}
	attributes_b = {
		{ Foreground = { Color = colors[mode].b.fg } },
		{ Background = { Color = colors[mode].b.bg } },
	}
	attributes_c = {
		{ Foreground = { Color = colors[mode].c.fg } },
		{ Background = { Color = colors[mode].c.bg } },
	}
end

local function create_sections() end

local function right_component(mode)
	local result = {}
	util.insert_elements(result, attributes_c)
	util.insert_elements(result, tabline_x)
	util.insert_elements(result, right_component_separator)
	util.insert_elements(result, attributes_b)
	util.insert_elements(result, tabline_y)
	util.insert_elements(result, right_component_separator)
	util.insert_elements(result, attributes_a)
	util.insert_elements(result, tabline_z)
	util.insert_elements(result, right_component_separator)
	return result
end

local function left_component()
	local result = {}
	util.insert_elements(result, attributes_a)
	util.insert_elements(result, tabline_a)
	util.insert_elements(result, left_component_separator)
	util.insert_elements(result, attributes_b)
	util.insert_elements(result, tabline_b)
	util.insert_elements(result, left_component_separator)
	util.insert_elements(result, attributes_c)
	util.insert_elements(result, tabline_c)
	util.insert_elements(result, left_component_separator)
	return result
end

function M.set_status(window, pane)
	local mode = window:active_key_table() or "normal_mode"
	create_attributes(mode)
	create_sections()
	window:set_left_status(wezterm.format(left_component()))
	window:set_right_status(wezterm.format(right_component()))
end

return M
