{
  pkgs,
  defaults,
  lib,
  ...
}: {
  services = {
    accounts-daemon.enable = true;

    gvfs.enable = true;
    hardware.bolt.enable = false;
    colord.enable = false;
    geoclue2.enable = true;
    udisks2.enable = true;
    upower.enable = true;
    flatpak.enable = true;

    # dbus.packages = with pkgs; [
    #   gcr
    #   gnome-keyring
    #   gvfs
    #   gtk3
    #   glib
    # ];

    xserver = {
      enable = false;
      xkb.layout = defaults.keyMap;
      excludePackages = [pkgs.xterm];
      displayManager.gdm.enable = true;
      displayManager.gdm.wayland = true;
    };

    gnome = {
      gnome-online-accounts.enable = true;
      gnome-settings-daemon.enable = true;
      evolution-data-server.enable = true;
    };
  };
}
