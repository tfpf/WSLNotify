local wezterm = require 'wezterm'

local config = wezterm.config_builder()

config.bold_brightens_ansi_colors = true

config.colors = {
    background = '#000000',
    foreground = '#EEEEEE',
    cursor_border = '#EEEEEE',
    cursor_bg = '#EEEEEE',

    selection_bg = '#EEEEEE',
    selection_fg = '#000000',

    ansi = {'#000000', '#cc0000', '#4e9a06', '#c4a000', '#3465a4', '#b124c9', '#06989a', '#d3d7cf'},
    brights = {'#5d5f5b', '#ef2929', '#8ae234', '#fce94f', '#739fcf', '#ff00e3', '#34e2e2', '#eeeeec'},
}

config.cursor_thickness = 1

config.default_cursor_style = 'SteadyBar'

config.default_prog = {'C:/Windows/system32/wsl.exe', '-d', 'Debian'}

config.font = wezterm.font 'CaskaydiaCove Nerd Font'

config.font_size = 13

config.keys = {}
for i = 1, 9 do
  table.insert(config.keys, {key = tostring(i), mods = 'ALT', action = wezterm.action.ActivateTab(i - 1)})
end
table.insert(config.keys, {key = 'F1', action = wezterm.action.SpawnCommandInNewTab {args = {'C:/msys64/msys2_shell.cmd', '-defterm', '-here', '-no-start', '-ucrt64'}}})
table.insert(config.keys, {key = 'Tab', mods = 'CTRL', action = wezterm.action.ActivateLastTab})

config.mouse_bindings = {
  {event = {Up = {streak = 1, button = 'Left'}}, action = wezterm.action.DisableDefaultAssignment},
  {event = {Down = {streak = 1, button = 'Left'}}, mods = 'CTRL', action = wezterm.action.Nop},
  {event = {Up = {streak = 1, button = 'Left'}}, mods = 'CTRL', action = wezterm.action.OpenLinkAtMouseCursor},
}

config.window_background_opacity = 0.8

return config
