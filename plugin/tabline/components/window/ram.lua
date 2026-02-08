local wezterm = require('wezterm')

local last_update_time = 0
local last_result = ''

return {
  default_opts = {
    throttle = 3,
    icon = wezterm.nerdfonts.cod_server,
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
          'Get-CimInstance Win32_OperatingSystem | Select-Object -ExpandProperty FreePhysicalMemory',
        }
      else
        success, result = wezterm.run_child_process {
          'cmd.exe',
          '/C',
          'wmic OS get FreePhysicalMemory',
        }
      end
    elseif string.match(wezterm.target_triple, 'linux') ~= nil then
      success, result =
        wezterm.run_child_process { 'bash', '-c', 'free -m | LC_NUMERIC=C awk \'NR==2{printf "%.2f", $3/1000 }\'' }
    elseif string.match(wezterm.target_triple, 'darwin') ~= nil then
      success, result = wezterm.run_child_process { 'vm_stat' }
    elseif string.match(wezterm.target_triple, 'freebsd') ~= nil then
      success, result = wezterm.run_child_process { 'sysctl', '-n',
          'hw.pagesize',
          'vm.stats.vm.v_free_count',
          'vm.stats.vm.v_inactive_count',
          'vm.stats.vm.v_active_count',
          'vm.stats.vm.v_wire_count',
          'vm.stats.vm.v_laundry_count',
      }
    end

    if not success or not result then
      return ''
    end

    local ram
    if string.match(wezterm.target_triple, 'linux') ~= nil then
      ram = string.format('%.2f GB', tonumber(result))
    elseif string.match(wezterm.target_triple, 'darwin') ~= nil then
      local page_size = result:match('page size of (%d+) bytes')
      local anonymous_pages = result:match('Anonymous pages: +(%d+).')
      local pages_purgeable = result:match('Pages purgeable: +(%d+).')
      local app_memory = anonymous_pages - pages_purgeable
      local wired_memory = result:match('Pages wired down: +(%d+).')
      local compressed_memory = result:match('Pages occupied by compressor: +(%d+).')
      local used_memory = (app_memory + wired_memory + compressed_memory) * page_size / 1024 / 1024 / 1024
      ram = string.format('%.2f GB', used_memory)
    elseif string.match(wezterm.target_triple, 'windows') ~= nil then
      if opts.use_pwsh then
        ram = tonumber(result:match('%d+%.?%d*') or '0')
        ram = string.format('%.2f GB', ram / 1024 / 1024)
      else
        ram = result:match('%d+')
        ram = string.format('%.2f GB', tonumber(ram) / 1024 / 1024)
      end
    elseif string.match(wezterm.target_triple, 'freebsd') ~= nil then
      local pg_sz, mem_free, mem_inact, mem_act, mem_wired, mem_laundry = result:match( '(%d+)%s+(%d+)%s+(%d+)%s+(%d+)%s(%d+)%s(%d+)' )
      local used = tonumber(mem_wired) + tonumber(mem_act) + tonumber(mem_laundry)
      used = tonumber(pg_sz) * used / 2^30
      ram = string.format('%.2f GB', used)
    end

    last_update_time = current_time
    last_result = ram

    return ram
  end,
}
