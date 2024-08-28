local wezterm = require('wezterm')
local util = require('tabline.util')

local default_opts = {
  style = '%H:%M',
  icon = {
    ['00'] = wezterm.nerdfonts.md_clock_time_twelve_outline,
    ['01'] = wezterm.nerdfonts.md_clock_time_one_outline,
    ['02'] = wezterm.nerdfonts.md_clock_time_two_outline,
    ['03'] = wezterm.nerdfonts.md_clock_time_three_outline,
    ['04'] = wezterm.nerdfonts.md_clock_time_four_outline,
    ['05'] = wezterm.nerdfonts.md_clock_time_five_outline,
    ['06'] = wezterm.nerdfonts.md_clock_time_six_outline,
    ['07'] = wezterm.nerdfonts.md_clock_time_seven_outline,
    ['08'] = wezterm.nerdfonts.md_clock_time_eight_outline,
    ['09'] = wezterm.nerdfonts.md_clock_time_nine_outline,
    ['10'] = wezterm.nerdfonts.md_clock_time_ten_outline,
    ['11'] = wezterm.nerdfonts.md_clock_time_eleven_outline,
    ['12'] = wezterm.nerdfonts.md_clock_time_twelve,
    ['13'] = wezterm.nerdfonts.md_clock_time_one,
    ['14'] = wezterm.nerdfonts.md_clock_time_two,
    ['15'] = wezterm.nerdfonts.md_clock_time_three,
    ['16'] = wezterm.nerdfonts.md_clock_time_four,
    ['17'] = wezterm.nerdfonts.md_clock_time_five,
    ['18'] = wezterm.nerdfonts.md_clock_time_six,
    ['19'] = wezterm.nerdfonts.md_clock_time_seven,
    ['20'] = wezterm.nerdfonts.md_clock_time_eight,
    ['21'] = wezterm.nerdfonts.md_clock_time_nine,
    ['22'] = wezterm.nerdfonts.md_clock_time_ten,
    ['23'] = wezterm.nerdfonts.md_clock_time_eleven,
  },
}

return function(_, opts)
  opts = util.deep_extend(default_opts, opts or {})
  local time = wezterm.time.now()
  local datetime = time:format(opts.style)

  if opts.icons_enabled then
    local hour = time:format('%H')
    local icon = opts.icon[hour]
    datetime = icon .. ' ' .. datetime
  end

  return datetime
end
