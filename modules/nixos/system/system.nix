{
  pkgs,
  modulesPath,
  defaults,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  system = {
    autoUpgrade.enable = true;
    stateVersion = "24.05";
  };

  security = {
    rtkit.enable = true;
    polkit.enable = true;

    sudo = {
      wheelNeedsPassword = false;
    };
    pam.loginLimits = [
      {
        domain = "*";
        type = "soft";
        item = "nofile";
        value = "8192";
      }
    ];
  };

  time.timeZone = defaults.timeZone;
  i18n.defaultLocale = defaults.defaultLocale;

  i18n.supportedLocales = [
    "en_US.UTF-8/UTF-8"
    "es_ES.UTF-8/UTF-8"
  ];

  i18n.extraLocaleSettings = {
    LANGUAGE = defaults.defaultLocale;
    LC_ALL = defaults.region;
    LC_ADDRESS = defaults.region;
    LC_IDENTIFICATION = defaults.region;
    LC_MEASUREMENT = defaults.region;
    LC_MONETARY = defaults.region;
    LC_NAME = defaults.region;
    LC_NUMERIC = defaults.region;
    LC_PAPER = defaults.region;
    LC_TELEPHONE = defaults.region;
    LC_TIME = defaults.region;
  };

  console = {
    # inherit (defaults) keyMap;
    earlySetup = true;
  };

  fonts = {
    enableDefaultPackages = true;
    enableGhostscriptFonts = true;

    fontDir.enable = true;

    packages = with pkgs; [
      corefonts
      quicksand
    ];

    fontconfig = {
      enable = true;
      antialias = true;
      defaultFonts = {
        serif = [defaults.fonts.serif.name];
        sansSerif = [defaults.fonts.sansSerif.name];
        monospace = [defaults.fonts.monospace.name];
        emoji = [defaults.fonts.emoji.name];
      };
    };
  };
}
