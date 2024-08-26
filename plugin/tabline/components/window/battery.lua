local wezterm = require("wezterm")
local config = require("tabline.config")

return function()
	local bat = ""
	local bat_icon = ""
	for _, b in ipairs(wezterm.battery_info()) do
		local charge = b.state_of_charge * 100
		bat = string.format("%.0f%%", charge)
		if charge <= 10 then
			bat_icon = wezterm.nerdfonts.fa_battery_empty
		elseif charge <= 25 then
			bat_icon = wezterm.nerdfonts.fa_battery_quarter
		elseif charge <= 50 then
			bat_icon = wezterm.nerdfonts.fa_battery_half
		elseif charge <= 75 then
			bat_icon = wezterm.nerdfonts.fa_battery_three_quarters
		else
			bat_icon = wezterm.nerdfonts.fa_battery_full
		end
	end
	if config.opts.options.icons_enabled then
		bat = bat_icon .. " " .. bat
	end
	return bat
end
