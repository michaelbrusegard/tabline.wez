local wezterm = require("wezterm")
local util = require("tabline.util")
local config = require("tabline.config")
local opts = config.opts
local colors = config.colors

local M = {}

local left_section_separator = { Text = opts.options.section_separators.left }
local right_section_separator = { Text = opts.options.section_separators.right }
local left_component_separator = { Text = opts.options.component_separators.left }
local right_component_separator = { Text = opts.options.component_separators.right }

local attributes_a, attributes_b, attributes_c = {}, {}, {}
local component_seperator_attributes_b, component_seperator_attributes_c = {}, {}
local tabline_a, tabline_b, tabline_c, tabline_x, tabline_y, tabline_z = {}, {}, {}, {}, {}, {}

local function create_attributes(window)
	local mode = window:active_key_table() or "normal_mode"
	attributes_a = {
		{ Foreground = { Color = colors[mode].a.fg } },
		{ Background = { Color = colors[mode].a.bg } },
		{ Attribute = { Intensity = "Bold" } },
	}
	attributes_b = {
		{ Foreground = { Color = colors[mode].b.fg or colors[mode].a.fg } },
		{ Background = { Color = colors[mode].b.bg or colors[mode].a.bg } },
	}
	attributes_c = {
		{ Foreground = { Color = colors[mode].c.fg or colors[mode].a.fg } },
		{ Background = { Color = colors[mode].c.bg or colors[mode].a.bg } },
	}
	component_seperator_attributes_b = {
		{ Foreground = { Color = colors[mode].b.fg or colors[mode].a.fg } },
		{ Background = { Color = colors[mode].b.bg or colors[mode].a.bg } },
	}
	component_seperator_attributes_c = {
		{ Foreground = { Color = colors[mode].b.bg or colors[mode].a.bg } },
		{ Background = { Color = colors[mode].b.fg or colors[mode].a.fg } },
	}
end

local function extract_components(components_opts, window)
	local components = {}
	for _, v in ipairs(components_opts) do
		if type(v) == "string" then
			if v == "ResetAttributes" then
				table.insert(components, v)
			end
			local ok, result = pcall(require, "tabline.components." .. v)
			if ok then
				table.insert(components, { Text = " " .. result(window) .. " " })
			else
				table.insert(components, { Text = " " .. v .. " " })
			end
		elseif type(v) == "table" and type(v[1]) == "string" then
			local ok, result = pcall(require, "tabline." .. v[1])
			if ok then
				if type(v.fmt) == "function" then
					table.insert(components, { Text = " " .. v.fmt(result, window) .. " " })
				end
			end
		elseif type(v) == "function" then
			table.insert(components, { Text = v(window) })
		elseif type(v) == "table" then
			table.insert(components, v)
		end
	end
	return components
end

local function insert_section_separators(components, is_left)
	local i = 1
	while i <= #components do
		-- if type(components[i]) == "table" and components[i].Text then
		-- 	table.insert(components, i + 1, is_left and left_section_separator or right_section_separator)
		-- 	i = i + 1
		-- end
		i = i + 1
	end
	return components
end

local function create_sections(window)
	tabline_a = insert_section_separators(extract_components(opts.sections.tabline_a, window), true)
	tabline_b = insert_section_separators(extract_components(opts.sections.tabline_b, window), true)
	tabline_c = insert_section_separators(extract_components(opts.sections.tabline_c, window), true)
	tabline_x = insert_section_separators(extract_components(opts.sections.tabline_x, window), false)
	tabline_y = insert_section_separators(extract_components(opts.sections.tabline_y, window), false)
	tabline_z = insert_section_separators(extract_components(opts.sections.tabline_z, window), false)
end

local function right_component()
	local result = {}
	util.insert_elements(result, attributes_c)
	if #tabline_x > 0 then
		util.insert_elements(result, tabline_x)
	end
	util.insert_elements(result, attributes_b)
	if #tabline_y > 0 then
		util.insert_elements(result, tabline_y)
	end
	util.insert_elements(result, attributes_a)
	if #tabline_z > 0 then
		util.insert_elements(result, tabline_z)
	end
	return result
end

local function left_component()
	local result = {}
	util.insert_elements(result, attributes_a)
	if #tabline_a > 0 then
		util.insert_elements(result, tabline_a)
	end
	util.insert_elements(result, attributes_b)
	if #tabline_b > 0 then
		util.insert_elements(result, tabline_b)
	end
	util.insert_elements(result, attributes_c)
	if #tabline_c > 0 then
		util.insert_elements(result, tabline_c)
	end
	return result
end

function M.set_status(window)
	create_attributes(window)
	create_sections(window)
	window:set_left_status(wezterm.format(left_component()))
	window:set_right_status(wezterm.format(right_component()))
end

return M
