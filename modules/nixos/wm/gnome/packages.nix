{
  lib,
  pkgs,
  defaults,
  ...
}:
lib.mkIf defaults.wm.gnome {
  environment.systemPackages =
    lib.mkIf defaults.wm.gnome
    (with pkgs; [
      xdg-desktop-portal-gnome
    ]);

  environment.gnome.excludePackages = with pkgs; [
    evolution
    evolution-data-server
    gnome-initial-setup
    gnome-tour
    gnome-user-docs
    networkmanager-openconnect
    openconnect
  ];
}
