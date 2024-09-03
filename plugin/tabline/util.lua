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
          local component = M.create_component(result.update(object, opts), opts, object, attributes)
          if component then
            table.insert(components, component)
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
        local component = M.create_component(result.update(object, opts), opts, object, attributes)
        if component then
          table.insert(components, component)
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

function M.create_component(name, opts, object, attributes)
  if opts.cond and not opts.cond(object) then
    return
  end
  if opts.fmt then
    name = opts.fmt(name, object)
  end
  local left_padding_element, right_padding_element
  local left_padding, right_padding
  if opts.padding then
    if type(opts.padding) == 'table' then
      left_padding = string.rep(' ', opts.padding.left or 0)
      right_padding = string.rep(' ', opts.padding.right or 0)
    else
      left_padding = string.rep(' ', opts.padding)
      right_padding = left_padding
    end
    left_padding_element = { Text = left_padding }
    right_padding_element = { Text = right_padding }
  end
  if opts.icons_enabled and opts.icon and not name == 'zoomed' then
    local icon_name = {}
    table.insert(icon_name, left_padding_element)
    if type(opts.icon) == 'table' then
      if opts.icon.align == 'right' then
        table.insert(icon_name, { Text = name })
        if opts.icon.color then
          if opts.icon.color.fg then
            table.insert(icon_name, { Foreground = opts.icon.color.fg })
          end
          if opts.icon.color.bg then
            table.insert(icon_name, { Background = opts.icon.color.bg })
          end
        end
        table.insert(icon_name, { Text = ' ' .. opts.icon[1] })
        M.insert_elements(icon_name, reset_attributes)
        M.insert_elements(icon_name, attributes)
      else
        if opts.icon.color then
          if opts.icon.color.fg then
            table.insert(icon_name, { Foreground = opts.icon.color.fg })
          end
          if opts.icon.color.bg then
            table.insert(icon_name, { Background = opts.icon.color.bg })
          end
        end
        table.insert(icon_name, { Text = opts.icon[1] .. ' ' })
        M.insert_elements(icon_name, reset_attributes)
        M.insert_elements(icon_name, attributes)
        table.insert(icon_name, { Text = name })
      end
    else
      table.insert(icon_name, { Text = opts.icon .. ' ' })
      table.insert(icon_name, { Text = name })
    end
    table.insert(icon_name, right_padding_element)
    name = wezterm.format(icon_name)
  else
    name = left_padding .. name .. right_padding
  end
  return { Text = name }
end

function M.overwrite_icon(opts, new_icon)
  if type(opts.icon) == 'table' then
    opts.icon[1] = new_icon
  else
    opts.icon = new_icon
  end
end

return M
