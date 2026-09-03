-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

local act = wezterm.action

-- This is where you actually apply your config choices.
config.window_frame = {
  -- The font used in the tab bar.
  -- Roboto Bold is the default; this font is bundled
  -- with wezterm.
  -- Whatever font is selected here, it will have the
  -- main font setting appended to it to pick up any
  -- fallback fonts you may have used there.
  font = wezterm.font({ family = "DankMono" }),

  -- The size of the font in the tab bar.
  -- Default to 10.0 on Windows but 12.0 on other systems
  font_size = 16.0,

  -- The overall background color of the tab bar when
  -- the window is focused
  active_titlebar_bg = "#30202E",

  -- The overall background color of the tab bar when
  -- the window is not focused
  inactive_titlebar_bg = "#333333",
}

-- config.font = wezterm.font("Fira Code")

-- For example, changing the initial geometry for new windows:
config.initial_cols = 120
config.initial_rows = 28

-- or, changing the font size and color scheme.
--config.font = wezterm.font("DankMono")
config.font_size = 18
config.color_scheme = "Dark+"

config.keys = {
  {
    key = "c",
    mods = "CMD",
    action = wezterm.action.SendKey({ key = "c", mods = "CTRL" }),
  },
}

-- Finally, return the configuration to wezterm:
return config
