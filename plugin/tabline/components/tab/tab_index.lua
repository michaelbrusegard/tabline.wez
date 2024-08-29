return {
  default_opts = { zero_indexed = false },
  update = function(tab, opts)
    return opts.zero_indexed and tab.tab_index or tab.tab_index + 1
  end,
}
