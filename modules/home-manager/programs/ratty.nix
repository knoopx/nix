{
  nixosConfig,
  lib,
  pkgs,
  ...
}: let
  palette = nixosConfig.defaults.colorScheme.palette;
in {
  home.packages = [pkgs.ratty];

  # ratty reads from ~/.config/ratty/ratty.toml — no HM module yet
  xdg.configFile."ratty/ratty.toml" = {
    text = let
      fontName = nixosConfig.defaults.fonts.monospace.name;
    in ''
      [window]
      width = 960
      height = 620
      scale_factor = 1.0
      opacity = 1.0

      [terminal]
      default_cols = 104
      default_rows = 32
      scrollback = 2000

      [env]
      TERM = "xterm-256color"

      [font]
      family = "${fontName}"
      style = "Regular"
      size = 24

      [cursor.model]
      path = "CairoSpinyMouse.obj"
      scale_factor = 6.0
      brightness = 0.5
      x_offset = 0.5
      plane_offset = 18.0
      visible = false

      [cursor.animation]
      spin_speed = 1.4
      bob_speed = 2.2
      bob_amplitude = 0.08

      [bindings]
      keys = [
        { key = "C", with = "Control | alt", action = "Copy" },
        { key = "V", with = "Control | alt", action = "Paste" },
        { key = "PageUp", with = "alt", action = "ScrollPageUp" },
        { key = "PageDown", with = "alt", action = "ScrollPageDown" },
        { key = "Up", with = "alt", action = "ScrollUp" },
        { key = "Down", with = "alt", action = "ScrollDown" },
        { key = "Equal", with = "Control", action = "IncreaseFontSize" },
        { key = "Minus", with = "Control", action = "DecreaseFontSize" },
        { key = "Digit0", with = "Control | alt", action = "ResetFontSize" },
        { key = "Enter", with = "Control | alt", action = "Toggle3DMode" },
        { key = "M", with = "Control | alt", action = "ToggleMobiusMode" },
        { key = "Up", with = "Control | alt", action = "IncreaseWarp" },
        { key = "Down", with = "Control | alt", action = "DecreaseWarp" },
      ]

      [theme]
      foreground = "#${palette.base05}"
      background = "#${palette.base00}"
      cursor = "#${palette.base0D}"

      [theme.normal]
      black = "#${palette.base00}"
      red = "#${palette.base08}"
      green = "#${palette.base0B}"
      yellow = "#${palette.base0A}"
      blue = "#${palette.base0D}"
      magenta = "#${palette.base0E}"
      cyan = "#${palette.base0C}"
      white = "#${palette.base05}"

      [theme.bright]
      black = "#${palette.base03}"
      red = "#${palette.base08}"
      green = "#${palette.base0B}"
      yellow = "#${palette.base0A}"
      blue = "#${palette.base0D}"
      magenta = "#${palette.base0E}"
      cyan = "#${palette.base0C}"
      white = "#${palette.base07}"
    '';
  };
}
