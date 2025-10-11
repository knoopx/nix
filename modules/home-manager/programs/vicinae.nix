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
      name = "Custom";
      palette = {
        background = "#${nixosConfig.defaults.colorScheme.palette.base00}";
        foreground = "#${nixosConfig.defaults.colorScheme.palette.base05}";
        blue = "#${nixosConfig.defaults.colorScheme.palette.base0D}";
        green = "#${nixosConfig.defaults.colorScheme.palette.base0B}";
        magenta = "#${nixosConfig.defaults.colorScheme.palette.base0F}";
        orange = "#${nixosConfig.defaults.colorScheme.palette.base09}";
        purple = "#${nixosConfig.defaults.colorScheme.palette.base0E}";
        red = "#${nixosConfig.defaults.colorScheme.palette.base08}";
        yellow = "#${nixosConfig.defaults.colorScheme.palette.base0A}";
        cyan = "#${nixosConfig.defaults.colorScheme.palette.base0C}";
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
