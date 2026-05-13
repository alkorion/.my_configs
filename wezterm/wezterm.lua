local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- Solarized Dark to match existing terminal theme
config.color_scheme = 'Solarized Dark (Gogh)'

-- OSC 8 hyperlinks are on by default; extend with common URL patterns
config.hyperlink_rules = wezterm.default_hyperlink_rules()

return config
