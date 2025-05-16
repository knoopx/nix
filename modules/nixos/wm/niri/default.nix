{
  lib,
  pkgs,
  defaults,
  ...
}:
lib.mkIf defaults.wm.niri {
  programs.dconf.enable = true;

  environment.systemPackages = with pkgs; [
    niri
    gnome-control-center
  ];
}
