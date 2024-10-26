{
  pkgs,
  lib,
  defaults,
  ...
}: {
  services = {
    gvfs.enable = true;

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

    gnome = {
      at-spi2-core.enable = lib.mkDefault false;
      core-developer-tools.enable = false;
      core-utilities.enable = false;
      # evolution-data-server.enable = false;
      gnome-browser-connector.enable = false;
      gnome-keyring.enable = true;
      # gnome-online-accounts.enable = false;

      localsearch.enable = false;
      tinysparql.enable = false;
    };
  };
}
