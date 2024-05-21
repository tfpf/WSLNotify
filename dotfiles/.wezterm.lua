local wezterm = require 'wezterm'

local config = wezterm.config_builder()
config.default_prog = {'C:/Windows/system32/wsl.exe', '-d', 'Debian'}
config.keys = {
  {
    key = 'F1',
    action = wezterm.action.SpawnCommandInNewTab {args = {'C:/msys64/msys2_shell.cmd', '-defterm', '-here', '-no-start', '-ucrt64'}},
  },
}

return config
