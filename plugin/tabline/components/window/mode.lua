return {
  update = function(window)
    local key_table = (window and window.active_key_table and window:active_key_table()) or 'normal_mode'
    local mode = key_table:gsub('_mode', ''):upper()
    return mode
  end,
}
