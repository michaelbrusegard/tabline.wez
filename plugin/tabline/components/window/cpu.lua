local wezterm = require('wezterm')
local util = require('tabline.util')

local default_opts = {
  throttle = 3,
  icon = wezterm.nerdfonts.oct_cpu,
}

local last_update_time = 0
local last_result = ''

return function(_, opts)
  local current_time = os.time()
  if current_time - last_update_time < default_opts.throttle then
    return last_result
  end

  opts = util.deep_extend(default_opts, opts or {})
  local os_name = os.getenv('OS')
  local handle
  if os_name == 'Windows_NT' then
    handle = io.popen(
      'powershell -Command "Get-WmiObject -Query \\"SELECT * FROM Win32_Processor\\" | ForEach-Object -MemberName LoadPercentage"'
    )
  elseif os_name == 'Linux' then
    handle = io.popen("awk '/^cpu / {print ($2+$4)*100/($2+$4+$5)}' /proc/stat")
  else
    handle = io.popen('ps -A -o %cpu | awk \'{s+=$1} END {print s ""}\'')
  end

  if not handle then
    return ''
  end

  local result = handle:read('*a')
  handle:close()

  local cpu = result:gsub('^%s*(.-)%s*$', '%1')

  if os_name ~= 'Windows_NT' and os_name ~= 'Linux' then
    local handle_cores = io.popen('sysctl -n hw.ncpu')
    if handle_cores then
      local num_cores = handle_cores:read('*a')
      handle_cores:close()
      num_cores = tonumber(num_cores)
      local cpu_num = tonumber(cpu)
      if num_cores and cpu_num then
        cpu = cpu_num / num_cores
      end
    end
  end

  cpu = string.format('%.2f%%', cpu)

  if opts.icons_enabled then
    cpu = opts.icon .. ' ' .. cpu
  end

  last_update_time = current_time
  last_result = cpu

  return cpu
end
