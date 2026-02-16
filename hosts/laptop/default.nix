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
      ./disko.nix
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

    programs.niri = {
      settings = {
        outputs = {
          # internal display
          "BOE NE135A1M-NY1 Unknown" = {
            scale = 1.75;
            background-color = "#${config.defaults.colorScheme.palette.base02}";
          };

          "DP-1" = {
            focus-at-startup = true;
            mode = {
              width = 3840;
              height = 2160;
              refresh = 160.0;
            };
            scale = 1.5;
            background-color = "#${config.defaults.colorScheme.palette.base02}";
          };
        };
      };
    };
  };
}
