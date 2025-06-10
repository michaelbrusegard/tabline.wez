local wezterm = require('wezterm')

local last_update_time = 0
local last_result = ''

return {
  default_opts = {
    throttle = 3,
    icon = wezterm.nerdfonts.oct_cpu,
    use_pwsh = false,
  },
  update = function(_, opts)
    local current_time = os.time()
    if current_time - last_update_time < opts.throttle then
      return last_result
    end
    local success, result
    if string.match(wezterm.target_triple, 'windows') ~= nil then
      if opts.use_pwsh then
        success, result = wezterm.run_child_process {
          'powershell.exe',
          '-Command',
          'Get-CimInstance Win32_Processor | Select-Object -ExpandProperty LoadPercentage',
        }
      else
        success, result = wezterm.run_child_process {
          'cmd.exe',
          '/C',
          'wmic cpu get loadpercentage',
        }
      end
    elseif string.match(wezterm.target_triple, 'linux') ~= nil then
      success, result = wezterm.run_child_process {
        'bash',
        '-c',
        "LC_NUMERIC=C awk '/^cpu / {print ($2+$4)*100/($2+$4+$5)}' /proc/stat",
      }
    elseif string.match(wezterm.target_triple, 'darwin') ~= nil then
      success, result = wezterm.run_child_process {
        'bash',
        '-c',
        'ps -A -o %cpu | LC_NUMERIC=C awk \'{s+=$1} END {print s ""}\'',
      }
    end

    if not success or not result then
      return ''
    end

    local cpu
    if string.match(wezterm.target_triple, 'windows') ~= nil then
      if opts.use_pwsh then
        cpu = tonumber(result:match('%d+%.?%d*') or '0')
      else
        cpu = result:match('%d+')
      end
    else
      cpu = result:gsub('^%s*(.-)%s*$', '%1')
    end

    if string.match(wezterm.target_triple, 'darwin') ~= nil then
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
