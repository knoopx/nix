{
  config,
  nixosConfig,
  lib,
  pkgs,
  ...
}: let
  customTheme = pkgs.writeText "custom-theme.toml" ''
    [meta]
    version = 1
    name = "Custom Theme"
    description = "Custom Theme"
    variant = "dark"
    inherits = "vicinae-dark"

    [colors.core]
    accent = "#${nixosConfig.defaults.colorScheme.palette.base0D}"
    background = "#${nixosConfig.defaults.colorScheme.palette.base00}"
    foreground = "#${nixosConfig.defaults.colorScheme.palette.base05}"
    secondary_background = "#${nixosConfig.defaults.colorScheme.palette.base0D}"
    border = "#${nixosConfig.defaults.colorScheme.palette.base02}"

    [colors.accents]
    blue = "#${nixosConfig.defaults.colorScheme.palette.base0D}"
    green = "#${nixosConfig.defaults.colorScheme.palette.base0B}"
    magenta = "#${nixosConfig.defaults.colorScheme.palette.base0F}"
    orange = "#${nixosConfig.defaults.colorScheme.palette.base09}"
    purple = "#${nixosConfig.defaults.colorScheme.palette.base0E}"
    red = "#${nixosConfig.defaults.colorScheme.palette.base08}"
    yellow = "#${nixosConfig.defaults.colorScheme.palette.base0A}"
    cyan = "#${nixosConfig.defaults.colorScheme.palette.base0C}"
  '';
in {
  services.vicinae.enable = true;

  home.activation.createVicinaeTheme = config.lib.dag.entryAfter ["writeBoundary"] ''
    mkdir -p ${config.home.homeDirectory}/.local/share/flatpak/exports/share/vicinae/themes
    cp ${customTheme} ${config.home.homeDirectory}/.local/share/flatpak/exports/share/vicinae/themes/custom.toml
  '';

  # https://docs.vicinae.com/theming#creating-a-custom-theme

  home.file.".config/vicinae/vicinae.json".text = builtins.toJSON {
    faviconService = "google";
    font = {
      size = 10;
    };
    popToRootOnClose = true;
    rootSearch = {
      searchFiles = false;
    };
    theme = {
      iconTheme = config.gtk.iconTheme.name;
      name = "Custom Theme";
    };
    window = {
      csd = true;
      opacity = 1;
      rounding = 8;
    };
  };
}
