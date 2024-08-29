local wezterm = require('wezterm')

return {
  default_opts = {
    icon = {
      empty = wezterm.nerdfonts.fa_battery_empty,
      quarter = wezterm.nerdfonts.fa_battery_quarter,
      half = wezterm.nerdfonts.fa_battery_half,
      three_quarters = wezterm.nerdfonts.fa_battery_three_quarters,
      full = wezterm.nerdfonts.fa_battery_full,
    },
  },
  update = function(_, opts)
    local bat = ''
    local bat_icon = ''
    for _, b in ipairs(wezterm.battery_info()) do
      local charge = b.state_of_charge * 100
      bat = string.format('%.0f%%', charge)
      if charge <= 10 then
        bat_icon = opts.icon.empty
      elseif charge <= 25 then
        bat_icon = opts.icon.quarter
      elseif charge <= 50 then
        bat_icon = opts.icon.half
      elseif charge <= 75 then
        bat_icon = opts.icon.three_quarters
      else
        bat_icon = opts.icon.full
      end
    end
    if opts.icons_enabled then
      bat = bat_icon .. ' ' .. bat
    end
    return bat
  end,
}
