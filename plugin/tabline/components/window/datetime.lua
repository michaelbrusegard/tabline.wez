local wezterm = require("wezterm")
local config = require("tabline.config")
local util = require("tabline.util")

local hour_to_icon = {
	["00"] = "md_clock_time_twelve_outline",
	["01"] = "md_clock_time_one_outline",
	["02"] = "md_clock_time_two_outline",
	["03"] = "md_clock_time_three_outline",
	["04"] = "md_clock_time_four_outline",
	["05"] = "md_clock_time_five_outline",
	["06"] = "md_clock_time_six_outline",
	["07"] = "md_clock_time_seven_outline",
	["08"] = "md_clock_time_eight_outline",
	["09"] = "md_clock_time_nine_outline",
	["10"] = "md_clock_time_ten_outline",
	["11"] = "md_clock_time_eleven_outline",
	["12"] = "md_clock_time_twelve",
	["13"] = "md_clock_time_one",
	["14"] = "md_clock_time_two",
	["15"] = "md_clock_time_three",
	["16"] = "md_clock_time_four",
	["17"] = "md_clock_time_five",
	["18"] = "md_clock_time_six",
	["19"] = "md_clock_time_seven",
	["20"] = "md_clock_time_eight",
	["21"] = "md_clock_time_nine",
	["22"] = "md_clock_time_ten",
	["23"] = "md_clock_time_eleven",
}

local default_opts = {
	style = "%H:%M",
}

return function(_, opts)
	opts = util.deep_extend(default_opts, opts or {})
	local time = wezterm.time.now()
	local datetime = time:format(opts.style)

	if config.opts.options.icons_enabled then
		local hour = time:format("%H")
		local icon = hour_to_icon[hour]
		datetime = wezterm.nerdfonts[icon] .. " " .. datetime
	end

	return datetime
end
