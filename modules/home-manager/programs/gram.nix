{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: let
  colors = config.lib.stylix.colors;
  theme = colors {templateRepo = inputs.stylix.inputs.tinted-zed;};
  settings = builtins.toJSON {
    ui_font_size = 13;
    buffer_font_size = 13;
    buffer_font_family = "JetBrainsMono Nerd Font";
    ui_font_weight = 400;
    buffer_font_weight = 300;
    buffer_line_height = "standard";
    terminal = {
      font_size = 11;
      font_weight = 100;
      line_height = "standard";
    };
    node = {
      allow_binary_download = true;
    };
    lsp = {
      "tailwindcss-language-server".binary.allow_binary_download = true;
      eslint.binary.allow_binary_download = true;
      vtsls.binary.allow_binary_download = true;
      nil.binary.allow_binary_download = true;
    };
    features = {};
    telemetry = {
      metrics = false;
    };
    theme = {
      mode = "dark";
      dark = "Base16 ${colors.scheme-name}";
      light = "Base16 ${colors.scheme-name}";
    };
    base_keymap = "VSCode";
    vim_mode = false;
  };
in {
  xdg.configFile."gram/settings.jsonc".text = settings;
  xdg.configFile."gram/themes/stylix.json".source = theme;
}
