local wezterm = require("wezterm")
local util = require("util")

local M = {}

M.opts = {}
M.colors = {}

local default_opts = {
	options = {
		icons_enabled = true,
		theme = "Catppuccin Mocha",
		component_separators = {
			left = wezterm.nerdfonts.pl_left_soft_divider,
			right = wezterm.nerdfonts.pl_right_soft_divider,
		},
		section_separators = {
			left = wezterm.nerdfonts.pl_left_hard_divider,
			right = wezterm.nerdfonts.pl_right_hard_divider,
		},
		mode_text = {
			normal_mode = "WINDOW 󱂬",
			search_mode = "FIND ",
			copy_mode = "YANK 󰆏",
		},
	},
	sections = {
		tabline_a = { "mode" },
		tabline_b = {},
		tabline_c = {},
		tabline_x = {},
		tabline_y = { "workspace" },
		tabline_z = { "hostname" },
	},
	extensions = {},
}

local function get_colors(theme)
	local scheme = wezterm.color.get_builtin_schemes()[theme]
	local mantle = scheme.colors["tab_bar"].inactive_tab["bg_color"]
	local blue = scheme.colors["ansi"][5]
	local surface0 = scheme.colors["tab_bar"]["inactive_tab_edge"]
	local text = scheme.colors.foreground
	local yellow = scheme.colors["ansi"][3]
	local green = scheme.colors["ansi"][2]

	return {
		normal_mode = {
			a = { fg = mantle, bg = blue },
			b = { fg = blue, bg = surface0 },
			c = { fg = text, bg = mantle },
		},
		copy_mode = { a = { fg = mantle, bg = yellow } },
		search_mode = { a = { fg = mantle, bg = green } },
	}
end

function M.update(user_opts)
	local color_overrides = user_opts.options.color_overrides or {}
	user_opts.options.color_overrides = nil
	M.opts = util.deep_extend(default_opts, user_opts or {})
	M.colors = util.deep_extend(get_colors(M.opts.options.theme), color_overrides)
end

return M
