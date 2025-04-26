{
  pkgs,
  defaults,
  lib,
  ...
}:
lib.mkIf defaults.wm.gnome {
  services = {
    xserver = {
      desktopManager.gnome.enable = true;
    };

    displayManager = {
      sessionPackages = with pkgs; [
        gnome-session.sessions
      ];
    };

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
