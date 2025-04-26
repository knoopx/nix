{
  lib,
  pkgs,
  defaults,
  ...
}:
lib.mkIf defaults.wm.niri {
  environment.systemPackages = with pkgs; [
    niri-unstable
  ];

  services = {
    displayManager = {
      sessionPackages = with pkgs; [
        niri-unstable
      ];
    };
  };
}
