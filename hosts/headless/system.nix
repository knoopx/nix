{
  pkgs,
  modulesPath,
  defaults,
  lib,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  system = {
    autoUpgrade.enable = true;
    stateVersion = "24.05";
  };

  documentation = {
    nixos.enable = false;
    man.enable = false;
    dev.enable = false;
  };

  security = {
    rtkit.enable = true;

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

  environment = {
    variables = {
      EDITOR = defaults.editor;
    };
  };

  time.timeZone = defaults.timeZone;
  i18n.defaultLocale = defaults.defaultLocale;
  i18n.extraLocaleSettings = {
    LANGUAGE = defaults.defaultLocale;
    LC_ALL = defaults.defaultLocale;
    LC_ADDRESS = defaults.defaultLocale;
    LC_IDENTIFICATION = defaults.defaultLocale;
    LC_MEASUREMENT = defaults.defaultLocale;
    LC_MONETARY = defaults.defaultLocale;
    LC_NAME = defaults.defaultLocale;
    LC_NUMERIC = defaults.defaultLocale;
    LC_PAPER = defaults.defaultLocale;
    LC_TELEPHONE = defaults.defaultLocale;
    LC_TIME = defaults.defaultLocale;
  };

  console = {
    inherit (defaults) keyMap;
    earlySetup = true;
  };

  fonts = {
    enableDefaultPackages = true;
    enableGhostscriptFonts = true;

    fontDir.enable = true;

    packages = with pkgs; [
      corefonts
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
