local wezterm = require 'wezterm'

local config = wezterm.config_builder()
config.default_prog = {'C:/Windows/system32/wsl.exe', '-d', 'Debian'}

return config
