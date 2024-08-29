local wezterm = require('wezterm')
local util = require('tabline.util')

return {
  default_opts = {
    battery_to_icon = {
      empty = wezterm.nerdfonts.fa_battery_empty,
      quarter = wezterm.nerdfonts.fa_battery_quarter,
      half = wezterm.nerdfonts.fa_battery_half,
      three_quarters = wezterm.nerdfonts.fa_battery_three_quarters,
      full = wezterm.nerdfonts.fa_battery_full,
    },
  },
  update = function(_, opts)
    local bat = ''
    for _, b in ipairs(wezterm.battery_info()) do
      local charge = b.state_of_charge * 100
      bat = string.format('%.0f%%', charge)
      if opts.icons_enabled and opts.battery_to_icon then
        if charge <= 10 then
          util.overwrite_icon(opts, opts.battery_to_icon.empty)
        elseif charge <= 25 then
          util.overwrite_icon(opts, opts.battery_to_icon.quarter)
        elseif charge <= 50 then
          util.overwrite_icon(opts, opts.battery_to_icon.half)
        elseif charge <= 75 then
          util.overwrite_icon(opts, opts.battery_to_icon.three_quarters)
        else
          util.overwrite_icon(opts, opts.battery_to_icon.full)
        end
      end
    end
    return bat
  end,
}
