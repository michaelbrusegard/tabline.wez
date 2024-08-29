local wezterm = require('wezterm')
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

local function require_component(object, v)
  local component
  if object.tab_id then
    component = 'tabline.components.tab.' .. v
  else
    component = 'tabline.components.window.' .. v
  end
  return component
end

function M.extract_components(components_opts, attributes, object)
  local component_opts = require('tabline.config').component_opts
  local components = {}
  for _, v in ipairs(components_opts) do
    if type(v) == 'string' then
      if v == 'ResetAttributes' then
        M.insert_elements(components, reset_attributes)
        M.insert_elements(components, attributes)
      else
        local ok, result = pcall(require, require_component(object, v))
        if ok then
          local opts = M.deep_copy(component_opts)
          if result.default_opts then
            opts = M.deep_extend(result.default_opts, opts)
          end
          local component = M.create_component(result.update(object, opts), opts, object)
          if component then
            M.insert_elements(components, component)
          end
        else
          table.insert(components, { Text = v .. '' })
        end
      end
    elseif type(v) == 'table' and type(v[1]) == 'string' then
      local ok, result = pcall(require, require_component(object, v[1]))
      if ok then
        local opts = M.deep_extend(M.deep_copy(component_opts), v)
        table.remove(opts, 1)
        if result.default_opts then
          opts = M.deep_extend(result.default_opts, opts)
        end
        local component = M.create_component(result.update(object, opts), opts, object)
        if component then
          M.insert_elements(components, component)
        end
      end
    elseif type(v) == 'function' then
      table.insert(components, { Text = v(object) .. '' })
    elseif type(v) == 'table' then
      table.insert(components, v)
    end
  end
  return components
end

function M.create_component(name, opts, object)
  wezterm.log_info(opts)
  if opts.cond and not opts.cond(object) then
    return
  end
  if opts.fmt then
    name = opts.fmt(name, object)
  end
  if opts.padding then
    local left_padding, right_padding
    if type(opts.padding) == 'table' then
      left_padding = string.rep(' ', opts.padding.left or 0)
      right_padding = string.rep(' ', opts.padding.right or 0)
    else
      left_padding = string.rep(' ', opts.padding)
      right_padding = left_padding
    end
    name = left_padding .. name .. right_padding
  end
  return { { Text = name } }
end

return M
