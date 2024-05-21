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

    ansi = {'#000000', '#CC0000', '#4E9A06', '#C4A000', '#3465A4', '#B124C9', '#06989A', '#D3D7CF'},
    brights = {'#5D5F5B', '#EF2929', '#8AE234', '#FCE94F', '#739FCF', '#FF00E3', '#34E2E2', '#EEEEEC'},
}

config.cursor_thickness = 1

config.default_cursor_style = 'SteadyBar'

config.default_prog = {'C:/Windows/system32/wsl.exe', '~', '-d', 'Debian'}

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
