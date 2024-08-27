# tabline.wez

A versatile and easy to use tab-bar written in Lua.

`tabline.wez` requires the [WezTerm](https://wezfurlong.org/wezterm/index.html) terminal emulator.

Tabline was greatly inspired by [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim/tree/master), a statusline plugin for [Neovim](https://neovim.io), and tries to use the same configuration format.

## Contributing

Feel free to create an issue/PR if you want to see anything else implemented, or if you have some question or need help with configuration.

## Screenshots

Here is a preview of what the tab-bar can look like.

<p>
<img width='700' />
<img width='700' />
<img width='700' />
<img width='700' />
<img width='700' />
</p>

`tabline.wez` supports all the same themes as WezTerm. You can find the list of themes [here](https://wezfurlong.org/wezterm/colorschemes/index.html).

## Installation

### WezTerm Plugin API

```lua
 wezterm.plugin.require("https://github.com/michaelbrusegard/tabline.wez")
```

You'll also need to have a patched font if you want icons.

## Usage and customization

Tabline has sections as shown below just like lualine with the addition of the `tabs` section.

```text
+-------------------------------------------------+
| A | B | C |  TABS                   | X | Y | Z |
+-------------------------------------------------+
```

Each sections holds its components e.g. Current active keytable (mode).

### Configuring tabline in wezterm.lua

#### Default configuration

```lua
tabline.setup({
  options = {
    icons_enabled = true,
    theme = "Catppuccin Mocha",
    color_overrides = {},
    component_separators = {
      left = wezterm.nerdfonts.pl_left_hard_divider,
      right = wezterm.nerdfonts.pl_right_hard_divider,
    },
    section_separators = {
      left = wezterm.nerdfonts.pl_left_soft_divider,
      right = wezterm.nerdfonts.pl_right_soft_divider,
    },
    tab_separators = {
      left = wezterm.nerdfonts.pl_left_hard_divider,
      right = wezterm.nerdfonts.pl_right_hard_divider,
    },
  },
  sections = {
    tabline_a = { "mode" },
    tabline_b = { "workspace" },
    tabline_c = {},
    tab_active = {
      "tab_index",
      "Space",
      "parent",
      "/",
      "cwd",
    },
    tab_inactive = { "tab_index", "Space", "process" },
    tabline_x = { "ram", "cpu" },
    tabline_y = { "datetime", "battery" },
    tabline_z = { "hostname" },
  },
  extensions = {},
})
```

If you want to get your current tabline config, you can
do so with:

```lua
tabline.get_config()
```

#### Config options

Tabline requires that some options are applied to the WezTerm [Config](https://wezfurlong.org/wezterm/config/lua/config/index.html) struct. For example the retro tab-bar must be enabled. Tabline provides a function to apply some recommended options to the config. If you already set these options in your `wezterm.lua` you do not need this function.

```lua
tabline.apply_to_config(config)
```

> [!WARNING]
> This function must be called AFTER the `tabline.setup` function.

---

### Starting tabline

```lua
tabline.setup()
```

---

### Setting a theme

```lua
options = { theme = "GruvboxDark" }
```

All available themes are found [here](https://wezfurlong.org/wezterm/colorschemes/index.html).

#### Customizing themes

To modify a theme, you can use the `color_overrides` option.

```lua
-- Change the background of tabline_c section for normal mode
tabline.setup({
  options = {
    color_overrides = {
      normal_mode = {
        c = { bg = '#112233' },
      },
    }
  }
})
```

This is also where you would specify the colors for a new [Key Table](https://wezfurlong.org/wezterm/config/key-tables.html) (mode). Tabline expects each key table to end with `_mode`.

```lua
tabline.setup({
  options = {
    color_overrides = {
      normal_mode = {
        a = { fg = mantle, bg = blue },
        b = { fg = blue, bg = surface0 },
        c = { fg = text, bg = mantle },
      },
      copy_mode = {
        a = { fg = mantle, bg = yellow },
        b = { fg = yellow, bg = surface0 },
        c = { fg = text, bg = mantle },
      },
      search_mode = {
        a = { fg = mantle, bg = green },
        b = { fg = green, bg = surface0 },
        c = { fg = text, bg = mantle },
      },
      -- Defining colors for a new key table
      window_mode = {
        a = { fg = mantle, bg = purple },
        b = { fg = purple, bg = surface0 },
        c = { fg = text, bg = mantle },
      },
      tab = {
        active = { fg = text, bg = surface0 },
        inactive = { fg = text, bg = mantle },
      }
    }
  }
})
```

---

### Separators

tabline defines three kinds of separators:

- `section_separators` - separators between sections
- `component_separators` - separators between the different components in sections
- `tab_separators` - separators around tabs

```lua
options = {
  component_separators = {
    left = wezterm.nerdfonts.pl_left_hard_divider,
    right = wezterm.nerdfonts.pl_right_hard_divider,
  },
  section_separators = {
    left = wezterm.nerdfonts.pl_left_soft_divider,
    right = wezterm.nerdfonts.pl_right_soft_divider,
  },
  tab_separators = {
    left = wezterm.nerdfonts.pl_left_hard_divider,
    right = wezterm.nerdfonts.pl_right_hard_divider,
  },
}
```

Here, left refers to the left-most sections (a, b, c), and right refers
to the right-most sections (x, y, z). For the tabs it refers to each side of the tab.

#### Disabling separators

```lua
options = {
  component_separators = {
    left = "",
    right = "",
  },
  section_separators = {
    left = "",
    right = "",
  },
  tab_separators = {
    left = "",
    right = "",
  },
}
```

---

### Changing components in tabline sections

```lua
sections = { tabline_a = { "mode" } }
```

#### Available components

Tabline separates components into ones available for the tabline components (`tabline_a`, `tabline_b`, etc...), which are grouped under Window since they have access to the [Window](https://wezfurlong.org/wezterm/config/lua/window/index.html) object.

And the `tab_active` and `tab_inactive` components which are grouped under Tab and have access to [TabInformation](https://wezfurlong.org/wezterm/config/lua/TabInformation.html).

- Window
  - `battery` (battery percentage)
  - `cpu` (cpu percentage)
  - `datetime` (current date and time)
  - `hostname` (hostname of the machine)
  - `ram` (ram used in GB)
  - `window` (window title)
  - `workspace` (active wezterm workspace)
- Tab
  - `cwd` (current working directory)
  - `parent` (parent directory)
  - `process` (process name)
  - `tab_index` (tab index)

#### Custom components

##### Lua functions as tabline component

```lua
local function hello()
  return [[hello world]]
end
sections = { tabline_a = { hello } }
```

> [!NOTE]
> Functions receive the `Window` object or `TabInformation` object as the first argument depending on the component group.

##### Text string as tabline component

```lua
sections = { tabline_a = { "Hello World" } }
```

##### WezTerm Formatitem as tabline component

```lua
sections = {
  lualine_c = {
    { Attribute = { Underline = 'Single' } },
    { Foreground = { AnsiColor = 'Fuchsia' } },
    { Background = { Color = 'blue' } },
    "Hello World", -- { Text = 'Hello World' }
  }
}

> [!TIP]
> Strings are automatically wrapped in a Text FormatItem when used as a component.
```

##### Lua expressions as tabline component

You can use any valid lua expression as a component including:

- oneliners
- global variables (as strings)
- require statements

```lua
sections = { lualine_c = { os.date('%a'), data, require('util').status() } }
```

`data` is a global variable in this example.

---

#### General component options

These are options that control behavior at the component level
and are available for all components.

```lua
sections = {
  lualine_a = {
    {
      "mode",
      cond = nil, -- Condition function, the component is loaded when the function returns `true`.

      fmt = nil, -- Format function, formats the component's output.
      -- This function receives two arguments:
      -- - string that is going to be displayed and
      --   that can be changed, enhanced and etc.
      -- - Window/TabInformation object with information you might
      --   need. E.g. active_pane if used with Window.
    },
  },
}
```

#### Component specific options

These are options that are available on specific components.
For example, you have option on `tab_index` component to
specify if it should be zero indexed.

#### datetime component options

```lua
sections = {
  tabline_a = {
    {
      "datetime",
      -- options: your own format string ("%Y/%m/%d %H:%M:%S", etc.)
      style = "%H:%M",
    },
  },
}
```

#### cwd and parent component options

```lua
sections = {
  tab_active = {
    {
      "cwd",
      max_length = 16, -- Max length before it is truncated
    },
  },
}
```

#### tab_index component options

```lua
sections = {
  tab_active = {
    {
      "tab_index",
      zero_indexed = false, -- Does the tab index start at 0 or 1
    },
  },
}
```

---

### Extensions

tabline extensions change statusline appearance for other plugins.

By default no extensions are loaded to improve performance.
You can load extensions with:

```lua
extensions = { "resurrect" }
```

#### Available extensions

- resurrect

#### Custom extensions

You can define your own extensions. If you believe an extension may be useful to others, then please submit a PR. Custom extensions requires a start and end event to be defined.

```lua
local my_extension = {
  sections = {
    lualine_a = { "mode" }
  },
  events = {
    start = "my_plugin.start",
    end = "my_plugin.end",
  }
}

tabline.setup({ extensions = { my_extension } })
```

---

### Refreshing tabline

By default tabline refreshes itself based on the [`status_update_interval`](https://wezfurlong.org/wezterm/config/lua/config/status_update_interval.html). However you can also force
tabline to refresh at any time by calling `tabline.refresh` function.

```lua
tabline.refresh()
```

Avoid calling `tabline.refresh` inside components. Since components are evaluated
during refresh, calling refresh while refreshing can have undesirable effects.

### Disabling tabline

You can also disable tabline completely.
Note that you need to call this after the setup

```lua
tabline.hide()
```

To enable it again you can do

```lua
tabline.hide({ unhide = true })
```

### Contributors

Thanks to these wonderful people, we enjoy this awesome plugin.

<a href="https://github.com/nvim-lualine/lualine.nvim/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=nvim-lualine/lualine.nvim" />
</a>
