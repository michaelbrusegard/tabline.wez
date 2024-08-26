local util = require("tabline.util")

local default_opts = { zero_indexed = false }

return function(tab, opts)
	opts = util.deep_extend(default_opts, opts or {})
	return opts.zero_indexed and tab.tab_index or tab.tab_index + 1
end
