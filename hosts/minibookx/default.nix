{
  pkgs,
  lib,
  config,
  ...
} @ inputs: let
  listNixModulesRecusive = import ../../lib/listNixModulesRecusive.nix inputs;
  system = "x86_64-linux";
in {
  imports =
    [
      ./boot.nix
      ./hardware.nix
      ./services.nix
    ]
    ++ (listNixModulesRecusive ../../modules/nixos);

  system.stateVersion = "25.11";

  networking.hostName = "minibookx";

  nixpkgs = {
    hostPlatform = {
      inherit system;
    };
  };

  defaults.display.width = lib.mkForce 1920;
  defaults.display.height = lib.mkForce 1200;
  defaults.display.idleTimeout = lib.mkForce 60; # 1 minute for battery conservation
  defaults.display.defaultColumnWidthPercent = lib.mkForce 1.0;
  defaults.display.columnWidthPercentPresets = lib.mkForce [0.5 0.75];

  home-manager.users.${config.defaults.username} = {
    imports = [
      ../../home/${config.defaults.username}.nix
    ];
    home.packages = with pkgs; [niri-rotate-display-desktop-items];
    services.autoDisplayRotation.enable = true;
  };
}
