{
  pkgs,
  modulesPath,
  config,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  system = {
    autoUpgrade.enable = true;
  };

  services = {
    systembus-notify = {
      enable = true;
    };

    smartd = {
      enable = true;
      autodetect = true;
      notifications = {
        systembus-notify.enable = true;
      };
    };

    earlyoom = {
      enable = true;
      enableNotifications = true;
    };
    pulseaudio.enable = false;
    fstrim.enable = true;
    btrfs.autoScrub.enable = true;
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

  time.timeZone = config.defaults.timeZone;
  i18n.defaultLocale = config.defaults.defaultLocale;

  i18n.supportedLocales = [
    "en_US.UTF-8/UTF-8"
    "es_ES.UTF-8/UTF-8"
  ];

  i18n.extraLocaleSettings = {
    LANGUAGE = config.defaults.defaultLocale;
    LC_ALL = config.defaults.region;
    LC_ADDRESS = config.defaults.region;
    LC_IDENTIFICATION = config.defaults.region;
    LC_MEASUREMENT = config.defaults.region;
    LC_MONETARY = config.defaults.region;
    LC_NAME = config.defaults.region;
    LC_NUMERIC = config.defaults.region;
    LC_PAPER = config.defaults.region;
    LC_TELEPHONE = config.defaults.region;
    LC_TIME = config.defaults.region;
  };

  console = {
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
        serif = [config.defaults.fonts.serif.name];
        sansSerif = [config.defaults.fonts.sansSerif.name];
        monospace = [config.defaults.fonts.monospace.name];
        emoji = [config.defaults.fonts.emoji.name];
      };
    };
  };
}
