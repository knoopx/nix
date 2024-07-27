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

  hardware = {
    enableAllFirmware = true;
    enableRedistributableFirmware = true;
    pulseaudio.enable = false;
  };

  security = {
    sudo = {
      wheelNeedsPassword = false;
    };
  };

  boot = {
    plymouth.enable = false;
    crashDump.enable = false;
    tmp.cleanOnBoot = true;

    loader = {
      grub = {
        enable = true;
        device = "nodev";
        # useOSProber = true;
        efiSupport = true;
      };
      efi.canTouchEfiVariables = true;
    };
  };

  environment = {
    variables = {
      EDITOR = defaults.editor;
    };
  };


  time.timeZone = defaults.timeZone;
  i18n.defaultLocale = defaults.defaultLocale;

  console = {
    keyMap = defaults.keyMap;
  };

  fonts = {
    enableDefaultPackages = true;
    enableGhostscriptFonts = true;

    fontDir.enable = true;

    packages = with pkgs; [
      corefonts
      iosevka
      inter
      roboto
      noto-fonts-emoji
      font-awesome
    ];

    fontconfig = {
      enable = true;
      antialias = true;
      # TODO: dedupe
      defaultFonts = {
        serif = ["Roboto Slab"];
        sansSerif = ["Inter"];
        monospace = ["JetBrainsMono Nerd Font" "Iosevka"];
        emoji = ["Noto Color Emoji"];
      };
    };
  };

  powerManagement = {
    enable = true;
    powertop.enable = false;
    cpuFreqGovernor = "performance";
  };
}
