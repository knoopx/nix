{
  pkgs,
  config,
  ...
}: {
  services = {
    accounts-daemon.enable = true;

    gvfs.enable = true;
    hardware.bolt.enable = false;
    colord.enable = false;
    geoclue2.enable = true;
    udisks2 = {
      enable = true;
      mountOnMedia = true;
    };
    upower.enable = true;
    flatpak.enable = true;

    xserver = {
      enable = false;
      xkb.layout = config.defaults.keyMap;
      excludePackages = [pkgs.xterm];
    };

    # GDM 50 broken with NVIDIA open kernel modules (gdm-wayland-session crashes with exit 64)
    # Using greetd + tuigreet instead
    displayManager.gdm.enable = false;

    greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd niri-session";
          user = "greeter";
        };
      };
    };

    gnome = {
      gnome-online-accounts.enable = true;
      gnome-settings-daemon.enable = true;
      evolution-data-server.enable = true;
      gnome-keyring.enable = true;
    };
  };
}
