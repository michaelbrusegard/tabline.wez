local wezterm = require("wezterm")

local M = {}

function M.setup(opts)
  require("config").update(opts)
end

return M
