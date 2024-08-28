# tabline.wez

A versatile and easy to use tab-bar written in Lua.

`tabline.wez` requires the [WezTerm](https://wezfurlong.org/wezterm/index.html) terminal emulator.

Tabline was greatly inspired by [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim/tree/master), a statusline plugin for [Neovim](https://neovim.io), and tries to use the same configuration format.

## Contributing

Feel free to create an issue/PR if you want to see anything else implemented, or if you have some question or need help with configuration.

## Screenshots

Here is a preview of what the tab-bar can look like.

<p>
  <img width="1656" alt="tabline 1" src="https://github.com/user-attachments/assets/bc3a2dc3-fa95-4386-a2b2-6b593dc4cef8">
  <img width="1656" alt="tabline 2" src="https://github.com/user-attachments/assets/6c72b8b0-7751-4972-950e-ee1e3de1a39b">
  <img width="1656" alt="tabline 3" src="https://github.com/user-attachments/assets/cd61edca-8c50-477b-a14a-84a89d369600">
  <img width="1656" alt="tabline 4" src="https://github.com/user-attachments/assets/38b194ec-33d9-4955-af08-c70c25b3bcf0">
  <img width="1656" alt="tabline 5" src="https://github.com/user-attachments/assets/ff216ab2-8a60-494d-9b11-9295212143df">
</p>

`tabline.wez` supports all the same themes as WezTerm. You can find the list of themes [here](https://wezfurlong.org/wezterm/colorschemes/index.html).

## Installation

### WezTerm Plugin API

```lua
 wezterm.plugin.require("https://github.com/michaelbrusegard/tabline.wez")
```

You'll also need to have a patched font if you want icons.

## Usage and customization

Tabline has sections as shown below just like lualine with the addition of `tabs` in the middle.

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
    theme = 'Catppuccin Mocha',
    color_overrides = {},
    section_separators = {
      left = wezterm.nerdfonts.pl_left_hard_divider,
      right = wezterm.nerdfonts.pl_right_hard_divider,
    },
    component_separators = {
      left = wezterm.nerdfonts.pl_left_soft_divider,
      right = wezterm.nerdfonts.pl_right_soft_divider,
    },
    tab_separators = {
      left = wezterm.nerdfonts.pl_left_hard_divider,
      right = wezterm.nerdfonts.pl_right_hard_divider,
    },
  },
  sections = {
    tabline_a = { 'mode' },
    tabline_b = { 'workspace' },
    tabline_c = {},
    tab_active = {
      'tab_index',
      ' ',
      'parent',
      '/',
      'cwd',
    },
    tab_inactive = { 'tab_index', ' ', 'process' },
    tabline_x = { 'ram', 'cpu' },
    tabline_y = { 'datetime', 'battery' },
    tabline_z = { 'hostname' },
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
options = { theme = 'GruvboxDark' }
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

#### Getting colors

If you want to get the colors used in the current theme, you can do so with:

```lua
tabline.get_colors()
```

> [!TIP]
> This can be useful when creatting your own components or extensions and you want to use the same colors as the current theme

---

### Separators

tabline defines three kinds of separators:

- `section_separators` - separators between sections
- `component_separators` - separators between the different components in sections
- `tab_separators` - separators around tabs

```lua
options = {
  section_separators = {
    left = wezterm.nerdfonts.pl_left_hard_divider,
    right = wezterm.nerdfonts.pl_right_hard_divider,
  },
  component_separators = {
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
  section_separators = '',
  component_separators = '',
  tab_separators = '',
}
```

---

### Changing components in tabline sections

```lua
sections = { tabline_a = { 'mode' } }
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
  return 'Hello World'
end
sections = { tabline_a = { hello } }
```

> [!NOTE]
> Functions receive the `Window` object or `TabInformation` object as the first argument depending on the component group. The second argument is always an opts table with the provided options

##### Text string as tabline component

```lua
sections = { tabline_a = { 'Hello World' } }
```

##### WezTerm Formatitem as tabline component

You can find all the available format items [here](https://wezfurlong.org/wezterm/config/lua/wezterm/format.html). The `ResetAttributes` format item has been overwritten to reset all attributes back to the default for that component instead of the WezTerm default.

```lua
sections = {
  tabline_c = {
    { Attribute = { Underline = 'Single' } },
    { Foreground = { AnsiColor = 'Fuchsia' } },
    { Background = { Color = 'blue' } },
    'Hello World', -- { Text = 'Hello World' }
  }
}

```

> [!TIP]
> Strings are automatically wrapped in a Text FormatItem when used as a component.

##### Lua expressions as tabline component

You can use any valid lua expression as a component including:

- oneliners
- global variables (as strings)
- require statements

```lua
sections = { tabline_c = { os.date('%a'), data, require('util').status() } }
```

`data` is a global variable in this example.

---

### Component options

Component options can change the way a component behave.
There are two kinds of options:

- global options affecting all components
- local options affecting specific

Global options can be used as local options (can be applied to specific components)
but you cannot use local options as global.
Global options used locally overwrites the global, for example:

```lua
tabline.setup {
  options = { fmt = string.lower },
  sections = {
    tabline_a = {
      { 'mode', fmt = function(str) return str:sub(1,1) end }
    },
    tabline_b = { 'window' }
  }
}
```

`mode` will be formatted with the passed function so only first char will be
shown. On the other hand `window` will be formatted with the global formatter
`string.lower` so it will be showed in lower case.

#### Available options

#### Global options

These are `options` that are used in the options table.
They set behavior of tabline.

Values set here are treated as default for other options
that work in the component level.

For example even though `icons_enabled` is a general component option.
You can set `icons_enabled` to `false` and icons will be disabled on all
component. You can still overwrite defaults set in the options table by specifying
the option value in the component.

```lua
options = {
  theme = 'nord', -- tabline theme
  section_separators = {
    left = wezterm.nerdfonts.ple_right_half_circle_thick,
    right = wezterm.nerdfonts.ple_left_half_circle_thick,
  },
  component_separators = {
    left = wezterm.nerdfonts.ple_right_half_circle_thin,
    right = wezterm.nerdfonts.ple_left_half_circle_thin,
  },
  tab_separators = {
    left = wezterm.nerdfonts.ple_right_half_circle_thick,
    right = wezterm.nerdfonts.ple_left_half_circle_thick,
  },
}
```

#### General component options

These are options that control behavior at the component level
and are available for all components.

```lua
sections = {
  tabline_a = {
    {
      'mode',
      icons_enabled = true, -- Enables the display of icons alongside the component.
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
      'datetime',
      -- options: your own format string ('%Y/%m/%d %H:%M:%S', etc.)
      style = '%H:%M',
    },
  },
}
```

#### cwd and parent component options

```lua
sections = {
  tab_active = {
    {
      'cwd',
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
      'tab_index',
      zero_indexed = false, -- Does the tab index start at 0 or 1
    },
  },
}
```

#### cpu and ram component options

```lua
sections = {
  tab_active = {
    {
      'cpu',
      throttle = 3, -- How often in seconds the component updates, set to 0 to disable throttling
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
extensions = { 'resurrect' }
```

#### Available extensions

- resurrect

#### Custom extensions

You can define your own extensions. If you believe an extension may be useful to others, then please submit a PR.
Custom extensions requires a start event to be defined. You can also define a stop event and a delay.
If the stop event is defined the delay will be how long it waits to stop the extension after the stop event is triggered.
If the stop event is not defined it will stop the extension after the delay. Delay is by default 5 seconds if the stop event is not defined.
If a section is not defined, it will use the default from the config.

```lua
local my_extension = {
    events = {
        start = 'my_plugin.start',
        stop = 'my_plugin.stop',
        delay = 3
    },
  sections = {
    tabline_a = { 'mode' }
  }
}

tabline.setup({ extensions = { my_extension } })
```

---

### Refreshing tabline

By default tabline refreshes itself based on the [`status_update_interval`](https://wezfurlong.org/wezterm/config/lua/config/status_update_interval.html). However you can also force
tabline to refresh at any time by calling `tabline.refresh` function.
The refresh function needs the Window object to refresh the tabline, and the TabInformation object to refresh the tabs. If passing one of them as nil it won't refresh the respective section.

```lua
tabline.refresh(window, tab)
```

Avoid calling `tabline.refresh` inside components. Since components are evaluated
during refresh, calling refresh while refreshing can have undesirable effects.

### Contributors

Thanks to [MLFlexer](https://github.com/MLFlexer) for some tips in developing a plugin for WezTerm.

Thanks to [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim) for the inspiration and a nice statusline for my Neovim.

```

```
