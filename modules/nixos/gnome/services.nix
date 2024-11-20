{
  pkgs,
  lib,
  defaults,
  ...
}: {
  services = {
    libinput.enable = false;

    xserver = {
      enable = true;
      xkb.layout = defaults.keyMap;
      desktopManager.gnome.enable = true;
      excludePackages = [pkgs.xterm];
      displayManager = {
        gdm = {
          enable = true;
          wayland = true;
          # autoSuspend = false;
        };
      };
    };

    displayManager = {
      sessionPackages = [pkgs.gnome-session.sessions];
    };

    # geoclue2.enable = false;
    gvfs.enable = true;
    colord.enable = false;
    hardware.bolt.enable = false;
    # udisks2.enable = false;
    # upower.enable = false;

    gnome = {
      # gnome-keyring.enable = true;
      # gnome-online-accounts.enable = false;
      # networking.networkmanager.enable = false;
      # gnome-keyring.enable = false;
      # gnome-online-accounts.enable = false;
      # gnome-settings-daemon.enable = false;
      # glib-networking.enable = lib.mkDefault false;

      at-spi2-core.enable = lib.mkDefault false;
      core-developer-tools.enable = false;
      core-utilities.enable = false;
      evolution-data-server.enable = lib.mkDefault false;
      gnome-browser-connector.enable = false;
      gnome-initial-setup.enable = false;
      gnome-remote-desktop.enable = false;
      gnome-user-share.enable = false;
      localsearch.enable = false;
      rygel.enable = false;
      tinysparql.enable = false;
    };
  };
}
