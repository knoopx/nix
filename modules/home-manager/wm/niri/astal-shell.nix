{
  nixosConfig,
  nix-colors,
  ...
}: let
  palette = nixosConfig.defaults.colorScheme.palette;

  # Helper function to create rgba strings from hex colors
  rgba = hex: alpha: let
    rgb = nix-colors.lib.conversions.hexToRGB hex;
  in "rgba(${toString (builtins.elemAt rgb 0)}, ${toString (builtins.elemAt rgb 1)}, ${toString (builtins.elemAt rgb 2)}, ${toString alpha})";
in {
  services.astal-shell = {
    enable = true;

    # Configure display margins
    displays = {
      "LG HDR 4K" = [390 145];
      "Unknown" = [200 70];
    };

    # Configure theme
    theme = {
      background = {
        primary = rgba palette.base02 1.0;
        secondary = rgba palette.base03 1.0;
      };
      text = {
        primary = rgba palette.base05 1.0;
        secondary = rgba palette.base04 0.7;
        focused = rgba palette.base05 1.0;
        unfocused = rgba palette.base04 0.7;
      };
      accent = {
        primary = rgba palette.base0D 1.0;
        secondary = rgba palette.base02 1.0;
        border = rgba palette.base04 1.0;
        overlay = rgba palette.base00 0.7;
      };
      status = {
        success = rgba palette.base0B 1.0;
        warning = rgba palette.base0A 1.0;
        error = rgba palette.base08 1.0;
      };
    };
  };
}
