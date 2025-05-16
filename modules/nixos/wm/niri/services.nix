{
  pkgs,
  lib,
  defaults,
  ...
}:
lib.mkIf defaults.wm.niri {
  services = {
    displayManager = {
      sessionPackages = with pkgs; [
        niri
      ];
    };
    gnome = {
      gnome-keyring.enable = true;
      gnome-online-accounts.enable = true;
      gnome-settings-daemon.enable = true;
      evolution-data-server.enable = true;
    };
  };
}
