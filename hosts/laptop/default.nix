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
          # internal display
        "BOE NE135A1M-NY1 Unknown" = {
          scale = 1.75;
            background-color = "#${config.defaults.colorScheme.palette.base02}";
          };

          "GIGA-BYTE TECHNOLOGY CO., LTD. M27UA 0x01010101" = {
            focus-at-startup = true;
            # 2560x1440@119.998
            mode = {
              # custom = true;
              width = 2560;
              height = 1440;
              refresh = 119.998;
            };
            scale = 1;
            background-color = "#${config.defaults.colorScheme.palette.base02}";
          };
        };
      };
    };
  };
}
