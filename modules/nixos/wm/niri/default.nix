{
  lib,
  pkgs,
  defaults,
  ...
}:
lib.mkIf defaults.wm.niri {
  environment.systemPackages = with pkgs; [
    niri
  ];

  services = {
    displayManager = {
      sessionPackages = with pkgs; [
        niri
      ];
    };
  };
}
