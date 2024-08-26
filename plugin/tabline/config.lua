local wezterm = require("wezterm")
local util = require("tabline.util")

local M = {}

M.opts = {}
M.colors = {}

local default_opts = {
	options = {
		theme = "Catppuccin Mocha",
		component_separators = {
			left = wezterm.nerdfonts.pl_left_hard_divider,
			right = wezterm.nerdfonts.pl_right_hard_divider,
		},
		section_separators = {
			left = wezterm.nerdfonts.pl_left_soft_divider,
			right = wezterm.nerdfonts.pl_right_soft_divider,
		},
		tab_separators = {
			left = wezterm.nerdfonts.pl_left_hard_divider,
			right = wezterm.nerdfonts.pl_right_hard_divider,
		},
		color_overrides = {},
	},
	sections = {
		tabline_a = { "mode" },
		tabline_b = { "workspace" },
		tabline_c = {},
		tab_active = {
			"tab_index",
			":",
			"Space",
			"parent",
			"/",
			"cwd",
		},
		tab_inactive = { "tab_index", "Space", "process" },
		tabline_x = {},
		tabline_y = { "workspace" },
		tabline_z = { "hostname" },
	},
	extensions = {},
}

local function lighten_color(color, percent)
	local r = tonumber(color:sub(2, 3), 16)
	local g = tonumber(color:sub(4, 5), 16)
	local b = tonumber(color:sub(6, 7), 16)

	r = math.floor(r + ((255 - r) * percent))
	g = math.floor(g + ((255 - g) * percent))
	b = math.floor(b + ((255 - b) * percent))

	return string.format("#%02x%02x%02x", r, g, b)
end

local function get_colors(theme)
	local scheme = wezterm.color.get_builtin_schemes()[theme]

	local mantle = scheme.background
	local surface0 = lighten_color(scheme.background, 0.1)
	local blue = scheme["ansi"][5]
	local text = scheme.foreground
	local yellow = scheme["ansi"][4]
	local green = scheme["ansi"][3]

	if scheme["tab_bar"] then
		if scheme["tab_bar"].inactive_tab then
			mantle = scheme["tab_bar"].inactive_tab["bg_color"] or mantle
			surface0 = scheme["tab_bar"]["inactive_tab_edge"] or surface0
		end
	end

	return {
		normal_mode = {
			a = { fg = mantle, bg = blue },
			b = { fg = blue, bg = surface0 },
			c = { fg = text, bg = mantle },
		},
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
			active = { fg = text, bg = surface0 },
			inactive = { fg = text, bg = mantle },
		},
	}
end

function M.set(user_opts)
	user_opts = user_opts or { options = {} }
	local color_overrides = user_opts.options.color_overrides or {}
	user_opts.options.color_overrides = {}
	M.opts = util.deep_extend(default_opts, user_opts)
	M.colors = util.deep_extend(get_colors(M.opts.options.theme), color_overrides)
end

return M
