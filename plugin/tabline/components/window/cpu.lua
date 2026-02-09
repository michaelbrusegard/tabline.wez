local wezterm = require('wezterm')

local last_update_time = 0
local last_result = ''
local last_sample = nil

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
    elseif string.match(wezterm.target_triple, 'freebsd') ~= nil then
      -- get the aggregated cpu metrics
      -- https://freebsdfoundation.org/wp-content/uploads/2023/01/jones_activitymonitor.pdf
      success, result = wezterm.run_child_process {
        'sysctl',
        '-n',
        'hw.ncpu',
        'kern.cp_times',
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
    elseif string.match(wezterm.target_triple, 'freebsd') ~= nil then
      -- the mertics follow like this (split onto lines for readability):
      --
      --    NCPU                                                    --<< total # of CPUs/cores
      --    cpu0(user) cpu0(nice) cpu0(sys) cpu0(intr) cpu0(idle)   --<< CPU/core counters
      --    cpu1(user) cpu1(nice) cpu1(sys) cpu1(intr) cpu1(idle)
      --    ...
      --    cpuN(user) cpuN(nice) cpuN(sys) cpuN(intr) cpuN(idle)
      --
      -- Thefore, for instance the N-th CPU(sys) will be at offset: 1 + N*5 + 3
      local i, counter, cur_sample = 1, "", {}
      for counter in cpu:gmatch('%d+') do
          cur_sample[i], i = tonumber(counter), i + 1
      end

      if last_sample ~= nil and #cur_sample == #last_sample then
          local ncpu, n, usage = cur_sample[1], 0, 0
          -- process every CPU core
          for n = 1, ncpu do
            local offset = 5 * (n - 1) + 1
            local busy, idle = 0, 0
            -- calculate "busy", includes: user(1), nice(2), sys(3), intr(4)
            for i = 1, 4 do
              busy = busy + (cur_sample[offset+i] - last_sample[offset+i])
            end
            -- calculate "free", includes: idle(5)
            idle = cur_sample[offset + 5] - last_sample[offset+5]
            usage = usage + busy/(busy + idle)
          end
          cpu = usage / ncpu * 100
      else
        last_sample = {}
      end

      for i = 1, #cur_sample do
        last_sample[i] = cur_sample[i]
      end

      if type(cpu) ~= "number" then
          cpu = 0
      end
    end

    cpu = string.format('%.2f%%', cpu)

    last_update_time = current_time
    last_result = cpu

    return cpu
  end,
}
