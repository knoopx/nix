{
  nixosConfig,
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
  networking.hostName = "laptop";

  nixpkgs = {
    hostPlatform = {
      inherit system;
    };
  };

  defaults.wifi = lib.mkForce true;
  defaults.bluetooth = lib.mkForce true;

  home-manager.users.${config.defaults.username} = {
    imports = [
      ../../home/${config.defaults.username}.nix
    ];
  };

  programs.niri = {
    settings = {
      outputs = {
        "BOE NE135A1M-NY1 Unknown" = {
          scale = 1.75;
          background-color = "#${nixosConfig.defaults.colorScheme.palette.base02}";
        };
      };
    };
  };
}
