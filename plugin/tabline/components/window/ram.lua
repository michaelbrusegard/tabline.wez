local wezterm = require('wezterm')

local last_update_time = 0
local last_result = ''

return {
  default_opts = {
    throttle = 3,
    icon = wezterm.nerdfonts.cod_server,
  },
  update = function(_, opts)
    local current_time = os.time()
    if current_time - last_update_time < opts.throttle then
      return last_result
    end
    local success, result
    if wezterm.target_triple == 'x86_64-pc-windows-msvc' then
      success, result = wezterm.run_child_process {
        'cmd.exe',
        '/C',
        'wmic OS get FreePhysicalMemory'
      }
    elseif wezterm.target_triple == 'x86_64-unknown-linux-gnu' then
      success, result = wezterm.run_child_process { 'bash', '-c', 'free -m | awk \'NR==2{printf "%.2f", $3*100/$2 }\'' }
    elseif wezterm.target_triple == 'x86_64-apple-darwin' or wezterm.target_triple == 'aarch64-apple-darwin' then
      success, result = wezterm.run_child_process { 'vm_stat' }
    end

    if not success or not result then
      return ''
    end

    local ram
    if wezterm.target_triple == 'x86_64-unknown-linux-gnu' then
      ram = string.format('%.2f GB', tonumber(result))
    elseif wezterm.target_triple == 'x86_64-apple-darwin' or wezterm.target_triple == 'aarch64-apple-darwin' then
      local page_size = result:match('page size of (%d+) bytes')
      local pages_free = result:match('Pages free: +(%d+).')
      local pages_active = result:match('Pages active: +(%d+).')
      local pages_inactive = result:match('Pages inactive: +(%d+).')
      local pages_speculative = result:match('Pages speculative: +(%d+).')
      local total_memory = (pages_free + pages_active + pages_inactive + pages_speculative)
          * page_size
          / 1024
          / 1024
          / 1024
      ram = string.format('%.2f GB', total_memory)
    elseif wezterm.target_triple == 'x86_64-pc-windows-msvc' then
      ram = result:match("%d+")
      ram = string.format('%.2f GB', tonumber(ram) / 1024 / 1024)
    end

    last_update_time = current_time
    last_result = ram

    return ram
  end,
}
