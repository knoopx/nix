{pkgs, ...}: {
  programs.niri.enable = true;
  programs.xwayland.enable = true;

  security.polkit.enable = true;

  services.xserver.displayManager.gdm.enable = true;
  services.xserver.displayManager.gdm.wayland = true;

  services = {
    dbus.enable = true;
    gvfs.enable = true;
    flatpak.enable = true;
    gnome = {
      gnome-keyring.enable = true;
      gnome-online-accounts.enable = true;
      gnome-settings-daemon.enable = true;
      evolution-data-server.enable = true;
    };
  };
}
