local wezterm = require('wezterm')
local util = require('tabline.util')
local foreground_process_name = ''

return {
  default_opts = {
    process_to_icon = {
      ['air'] = wezterm.nerdfonts.md_language_go,
      ['apt'] = wezterm.nerdfonts.dev_debian,
      ['bacon'] = '🥓',
      ['bash'] = wezterm.nerdfonts.cod_terminal_bash,
      ['bat'] = wezterm.nerdfonts.md_bat,
      ['btm'] = wezterm.nerdfonts.md_chart_donut_variant,
      ['btop'] = wezterm.nerdfonts.md_chart_areaspline,
      ['btop4win++'] = wezterm.nerdfonts.md_chart_areaspline,
      ['cargo'] = wezterm.nerdfonts.dev_rust,
      ['chezmoi'] = wezterm.nerdfonts.md_home_plus_outline,
      ['cmd.exe'] = wezterm.nerdfonts.md_console_line,
      ['curl'] = wezterm.nerdfonts.md_flattr,
      ['debug'] = wezterm.nerdfonts.cod_debug,
      ['default'] = wezterm.nerdfonts.md_application,
      ['docker'] = wezterm.nerdfonts.linux_docker,
      ['docker-compose'] = wezterm.nerdfonts.linux_docker,
      ['dpkg'] = wezterm.nerdfonts.dev_debian,
      ['fish'] = wezterm.nerdfonts.md_fish,
      ['gh'] = wezterm.nerdfonts.dev_github_badge,
      ['git'] = wezterm.nerdfonts.dev_git,
      ['go'] = wezterm.nerdfonts.md_language_go,
      ['htop'] = wezterm.nerdfonts.md_chart_areaspline,
      ['kubectl'] = wezterm.nerdfonts.linux_docker,
      ['kuberlr'] = wezterm.nerdfonts.linux_docker,
      ['lazydocker'] = wezterm.nerdfonts.linux_docker,
      ['lazygit'] = wezterm.nerdfonts.cod_github,
      ['lua'] = wezterm.nerdfonts.seti_lua,
      ['make'] = wezterm.nerdfonts.seti_makefile,
      ['nix'] = wezterm.nerdfonts.linux_nixos,
      ['node'] = wezterm.nerdfonts.md_nodejs,
      ['npm'] = wezterm.nerdfonts.md_npm,
      ['nvim'] = wezterm.nerdfonts.custom_neovim,
      ['pacman'] = wezterm.nerdfonts.md_pac_man,
      ['paru'] = wezterm.nerdfonts.md_pac_man,
      ['pnpm'] = wezterm.nerdfonts.md_npm,
      ['postgresql'] = wezterm.nerdfonts.dev_postgresql,
      ['powershell.exe'] = wezterm.nerdfonts.md_console,
      ['psql'] = wezterm.nerdfonts.dev_postgresql,
      ['pwsh.exe'] = wezterm.nerdfonts.md_console,
      ['rpm'] = wezterm.nerdfonts.dev_redhat,
      ['redis'] = wezterm.nerdfonts.dev_redis,
      ['ruby'] = wezterm.nerdfonts.cod_ruby,
      ['rust'] = wezterm.nerdfonts.dev_rust,
      ['serial'] = wezterm.nerdfonts.md_serial_port,
      ['ssh'] = wezterm.nerdfonts.md_pipe,
      ['sudo'] = wezterm.nerdfonts.fa_hashtag,
      ['tls'] = wezterm.nerdfonts.md_power_socket,
      ['topgrade'] = wezterm.nerdfonts.md_rocket_launch,
      ['unix'] = wezterm.nerdfonts.md_bash,
      ['valkey'] = wezterm.nerdfonts.dev_redis,
      ['vim'] = wezterm.nerdfonts.dev_vim,
      ['wget'] = wezterm.nerdfonts.md_arrow_down_box,
      ['yarn'] = wezterm.nerdfonts.seti_yarn,
      ['yay'] = wezterm.nerdfonts.md_pac_man,
      ['yum'] = wezterm.nerdfonts.dev_redhat,
      ['zsh'] = wezterm.nerdfonts.dev_terminal,
    },
  },
  update = function(tab, opts)
    -- get the foreground process name if available
    if tab.active_pane and tab.active_pane.foreground_process_name then
      foreground_process_name = tab.active_pane.foreground_process_name
      foreground_process_name = foreground_process_name:match('([^/\\]+)[/\\]?$') or foreground_process_name
    end

    -- fallback to the title if the foreground process name is unavailable
    -- Wezterm uses OSC 1/2 escape sequences to guess the process name and set the title
    -- see https://wezfurlong.org/wezterm/config/lua/pane/get_title.html
    -- title defaults to 'wezterm' if another name is unavailable
    if foreground_process_name == '' then
      foreground_process_name = (tab.tab_title and #tab.tab_title > 0) and tab.tab_title or tab.active_pane.title
    end

    -- if the tab active pane contains a non-local domain, use the domain name
    if foreground_process_name == 'wezterm' then
      foreground_process_name = tab.active_pane.domain_name ~= 'local' and tab.active_pane.domain_name or 'wezterm'
    end

    if opts.icons_enabled and opts.process_to_icon then
      util.overwrite_icon(opts, opts.process_to_icon[foreground_process_name])
    end

    return foreground_process_name
  end,
}
