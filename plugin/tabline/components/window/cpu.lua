local wezterm = require('wezterm')

local last_update_time = 0
local last_result = ''

return {
  default_opts = {
    throttle = 3,
    icon = wezterm.nerdfonts.oct_cpu,
  },
  update = function(_, opts)
    local current_time = os.time()
    if current_time - last_update_time < opts.throttle then
      return last_result
    end
    local success, result
    if wezterm.target_triple == 'x86_64-pc-windows-msvc' then
      success, result = wezterm.run_child_process {
        'powershell',
        '-Command',
        'Get-WmiObject -Query "SELECT * FROM Win32_Processor" | ForEach-Object -MemberName LoadPercentage',
      }
    elseif wezterm.target_triple == 'x86_64-unknown-linux-gnu' then
      success, result = wezterm.run_child_process {
        'bash',
        '-c',
        "awk '/^cpu / {print ($2+$4)*100/($2+$4+$5)}' /proc/stat",
      }
    elseif wezterm.target_triple == 'x86_64-apple-darwin' or wezterm.target_triple == 'aarch64-apple-darwin' then
      success, result = wezterm.run_child_process {
        'bash',
        '-c',
        'ps -A -o %cpu | awk \'{s+=$1} END {print s ""}\'',
      }
    end

    if not success then
      return ''
    end

    local cpu = result:gsub('^%s*(.-)%s*$', '%1')

    if wezterm.target_triple == '-86_64-apple-darwin' or wezterm.target_triple == 'aarch64-apple-darwin' then
      success, result = wezterm.run_child_process {
        'sysctl',
        '-n',
        'hw.ncpu',
      }
      if success then
        local num_cores = tonumber(result)
        local cpu_num = tonumber(cpu)
        if num_cores and cpu_num then
          cpu = cpu_num / num_cores
        end
      end
    end

    cpu = string.format('%.2f%%', cpu)

    last_update_time = current_time
    last_result = cpu

    return cpu
  end,
}
