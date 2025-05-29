{
  pkgs,
  defaults,
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

    dbus.packages = with pkgs; [
      gcr
      gnome-keyring
    ];

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

  # Environment variables for better session management
  # environment.sessionVariables = {
  #   # Ensure proper input method integration
  #   GTK_IM_MODULE = "ibus";
  #   QT_IM_MODULE = "ibus";
  #   XMODIFIERS = "@im=ibus";
  # };
}
