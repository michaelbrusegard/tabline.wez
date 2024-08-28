local M = {}

function M.deep_extend(t1, t2)
  local overwrite = {
    tabline_a = true,
    tabline_b = true,
    tabline_c = true,
    tab_active = true,
    tab_inactive = true,
    tabline_x = true,
    tabline_y = true,
    tabline_z = true,
    extensions = true,
  }

  for k, v in pairs(t2) do
    if overwrite[k] then
      t1[k] = v
    elseif type(v) == 'table' then
      if type(t1[k] or false) == 'table' then
        M.deep_extend(t1[k], t2[k])
      else
        t1[k] = v
      end
    else
      t1[k] = v
    end
  end
  return t1
end

function M.deep_copy(orig)
  local orig_type = type(orig)
  local copy
  if orig_type == 'table' then
    copy = {}
    for orig_key, orig_value in next, orig, nil do
      copy[M.deep_copy(orig_key)] = M.deep_copy(orig_value)
    end
    setmetatable(copy, M.deep_copy(getmetatable(orig)))
  else
    copy = orig
  end
  return copy
end

function M.insert_elements(dest, src)
  for _, v in ipairs(src) do
    table.insert(dest, v)
  end
end

local reset_attributes = {
  { Attribute = { Underline = 'None' } },
  { Attribute = { Intensity = 'Normal' } },
  { Attribute = { Italic = false } },
}

local function require_component(window, v)
  local component
  if window.tab_id then
    component = 'tabline.components.tab.' .. v
  else
    component = 'tabline.components.window.' .. v
  end
  return component
end

function M.extract_components(components_opts, attributes, window)
  local component_opts = require('tabline.config').component_opts
  local components = {}
  for _, v in ipairs(components_opts) do
    if type(v) == 'string' then
      if v == 'ResetAttributes' then
        M.insert_elements(components, reset_attributes)
        M.insert_elements(components, attributes)
      else
        local ok, result = pcall(require, require_component(window, v))
        if ok then
          table.insert(components, { Text = component_opts.fmt(result(window, component_opts), window) .. '' })
        else
          table.insert(components, { Text = v .. '' })
        end
      end
    elseif type(v) == 'table' and type(v[1]) == 'string' then
      local ok, result = pcall(require, require_component(window, v[1]))
      if ok then
        local opts = M.deep_extend(M.deep_copy(component_opts), v)
        table.remove(opts, 1)
        if type(opts.cond) ~= 'function' or opts.cond(window) then
          table.insert(components, { Text = opts.fmt(result(window, opts), window) .. '' })
        end
      end
    elseif type(v) == 'function' then
      table.insert(components, { Text = v(window) .. '' })
    elseif type(v) == 'table' then
      table.insert(components, v)
    end
  end
  return components
end

return M
