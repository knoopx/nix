{
  config,
  nixosConfig,
  ...
}: {
  services.vicinae.enable = true;
  # https://docs.vicinae.com/theming#creating-a-custom-theme
  home.file.".config/vicinae/themes/custom.json" = {
    text = builtins.toJSON {
      version = "1.0.0";
      appearance = "dark";
      icon = "";
      name = "Custom Theme";
      description = "Theme generated from NixOS defaults colorScheme";
      palette = {
        base00 = "#${nixosConfig.defaults.colorScheme.palette.base00}";
        base01 = "#${nixosConfig.defaults.colorScheme.palette.base01}";
        base02 = "#${nixosConfig.defaults.colorScheme.palette.base02}";
        base03 = "#${nixosConfig.defaults.colorScheme.palette.base03}";
        base04 = "#${nixosConfig.defaults.colorScheme.palette.base04}";
        base05 = "#${nixosConfig.defaults.colorScheme.palette.base05}";
        base06 = "#${nixosConfig.defaults.colorScheme.palette.base06}";
        base07 = "#${nixosConfig.defaults.colorScheme.palette.base07}";
        base08 = "#${nixosConfig.defaults.colorScheme.palette.base08}";
        base09 = "#${nixosConfig.defaults.colorScheme.palette.base09}";
        base0A = "#${nixosConfig.defaults.colorScheme.palette.base0A}";
        base0B = "#${nixosConfig.defaults.colorScheme.palette.base0B}";
        base0C = "#${nixosConfig.defaults.colorScheme.palette.base0C}";
        base0D = "#${nixosConfig.defaults.colorScheme.palette.base0D}";
        base0E = "#${nixosConfig.defaults.colorScheme.palette.base0E}";
        base0F = "#${nixosConfig.defaults.colorScheme.palette.base0F}";
      };
    };
  };

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
      name = "custom.json";
    };
    window = {
      csd = true;
      opacity = 1;
      rounding = 8;
    };
  };
}
