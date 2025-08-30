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
        blue = "#${nixosConfig.defaults.colorScheme.palette.base0D}";
        green = "#${nixosConfig.defaults.colorScheme.palette.base0B}";
        magenta = "#${nixosConfig.defaults.colorScheme.palette.base0E}";
        orange = "#${nixosConfig.defaults.colorScheme.palette.base09}";
        purple = "#${nixosConfig.defaults.colorScheme.palette.base0F}";
        red = "#${nixosConfig.defaults.colorScheme.palette.base08}";
        yellow = "#${nixosConfig.defaults.colorScheme.palette.base0A}";
        cyan = "#${nixosConfig.defaults.colorScheme.palette.base0C}";

        background = "#${nixosConfig.defaults.colorScheme.palette.base01}";
        foreground = "#${nixosConfig.defaults.colorScheme.palette.base05}";

        # Text colors
        text = "#${nixosConfig.defaults.colorScheme.palette.base05}";
        subtext = "#${nixosConfig.defaults.colorScheme.palette.base04}";
        textTertiary = "#${nixosConfig.defaults.colorScheme.palette.base03}";
        textDisabled = "#${nixosConfig.defaults.colorScheme.palette.base03}";
        textOnAccent = "#${nixosConfig.defaults.colorScheme.palette.base00}";
        textError = "#${nixosConfig.defaults.colorScheme.palette.base08}";
        textSuccess = "#${nixosConfig.defaults.colorScheme.palette.base0B}";
        textWarning = "#${nixosConfig.defaults.colorScheme.palette.base0A}";

        # Background colors
        mainBackground = "#${nixosConfig.defaults.colorScheme.palette.base01}";
        mainSelectedBackground = "#${nixosConfig.defaults.colorScheme.palette.base02}";
        mainHoveredBackground = "#${nixosConfig.defaults.colorScheme.palette.base02}";
        secondaryBackground = "#${nixosConfig.defaults.colorScheme.palette.base00}";
        tertiaryBackground = "#${nixosConfig.defaults.colorScheme.palette.base00}";
        statusBackground = "#${nixosConfig.defaults.colorScheme.palette.base01}";
        statusBackgroundBorder = "#${nixosConfig.defaults.colorScheme.palette.base02}";
        statusBackgroundHover = "#${nixosConfig.defaults.colorScheme.palette.base02}";
        statusBackgroundLighter = "#${nixosConfig.defaults.colorScheme.palette.base00}";

        # Button colors
        buttonPrimary = "#${nixosConfig.defaults.colorScheme.palette.base0D}";
        buttonPrimaryHover = "#${nixosConfig.defaults.colorScheme.palette.base0D}";
        buttonPrimaryPressed = "#${nixosConfig.defaults.colorScheme.palette.base0E}";
        buttonPrimaryDisabled = "#${nixosConfig.defaults.colorScheme.palette.base03}";
        buttonSecondary = "#${nixosConfig.defaults.colorScheme.palette.base02}";
        buttonSecondaryHover = "#${nixosConfig.defaults.colorScheme.palette.base01}";
        buttonSecondaryPressed = "#${nixosConfig.defaults.colorScheme.palette.base00}";
        buttonSecondaryDisabled = "#${nixosConfig.defaults.colorScheme.palette.base03}";
        buttonDestructive = "#${nixosConfig.defaults.colorScheme.palette.base08}";
        buttonDestructiveHover = "#${nixosConfig.defaults.colorScheme.palette.base08}";
        buttonDestructivePressed = "#${nixosConfig.defaults.colorScheme.palette.base09}";

        # Input colors
        inputBackground = "#${nixosConfig.defaults.colorScheme.palette.base00}";
        inputBorder = "#${nixosConfig.defaults.colorScheme.palette.base02}";
        inputBorderFocus = "#${nixosConfig.defaults.colorScheme.palette.base0D}";
        inputBorderError = "#${nixosConfig.defaults.colorScheme.palette.base08}";
        inputPlaceholder = "#${nixosConfig.defaults.colorScheme.palette.base03}";

        # Border colors
        border = "#${nixosConfig.defaults.colorScheme.palette.base02}";
        borderSubtle = "#${nixosConfig.defaults.colorScheme.palette.base01}";
        borderStrong = "#${nixosConfig.defaults.colorScheme.palette.base02}";
        separator = "#${nixosConfig.defaults.colorScheme.palette.base02}";
        shadow = "#${nixosConfig.defaults.colorScheme.palette.base00}";

        # State colors
        errorBackground = "#${nixosConfig.defaults.colorScheme.palette.base08}";
        errorBorder = "#${nixosConfig.defaults.colorScheme.palette.base08}";
        successBackground = "#${nixosConfig.defaults.colorScheme.palette.base0B}";
        successBorder = "#${nixosConfig.defaults.colorScheme.palette.base0B}";
        warningBackground = "#${nixosConfig.defaults.colorScheme.palette.base0A}";
        warningBorder = "#${nixosConfig.defaults.colorScheme.palette.base0A}";

        # Link colors
        linkDefault = "#${nixosConfig.defaults.colorScheme.palette.base0D}";
        linkHover = "#${nixosConfig.defaults.colorScheme.palette.base0C}";
        linkVisited = "#${nixosConfig.defaults.colorScheme.palette.base0F}";

        # Focus and overlay colors
        focus = "#${nixosConfig.defaults.colorScheme.palette.base0D}";
        overlay = "#${nixosConfig.defaults.colorScheme.palette.base00}";
        tooltip = "#${nixosConfig.defaults.colorScheme.palette.base01}";
        tooltipText = "#${nixosConfig.defaults.colorScheme.palette.base05}";
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
