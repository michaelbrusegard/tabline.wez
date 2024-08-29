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
    local os_name = os.getenv('OS')
    local handle
    if os_name == 'Windows_NT' then
      handle = io.popen('systeminfo | findstr /C:"Available Physical Memory"')
    elseif os_name == 'Linux' then
      handle = io.popen('free -m | awk \'NR==2{printf "%.2f", $3*100/$2 }\'')
    else
      handle = io.popen('vm_stat')
    end

    if not handle then
      return ''
    end

    local result = handle:read('*a')
    handle:close()

    local ram
    if os_name == 'Windows_NT' then
      local available_memory = result:match('Available Physical Memory: +(%d+).')
      ram = string.format('%.2f GB', available_memory / 1024 / 1024)
    elseif os_name == 'Linux' then
      ram = string.format('%.2f GB', tonumber(result))
    else
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
    end

    last_update_time = current_time
    last_result = ram

    return ram
  end,
}
