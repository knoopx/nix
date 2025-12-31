{
  lib,
  config,
  ...
} @ inputs: let
  system = "x86_64-linux";
  listNixModulesRecusive = import ../../lib/listNixModulesRecusive.nix inputs;
in {
  imports =
    [
      ./boot.nix
      ./filesystems.nix
      ./hardware.nix
      ./nvidia.nix
      ./services.nix
    ]
    ++ (listNixModulesRecusive ./services)
    ++ (listNixModulesRecusive ./containers)
    ++ (listNixModulesRecusive ../../modules/nixos);

  networking.hostName = "desktop";
  nix.settings.system-features = [
    "kvm"
    "big-parallel"
    "gccarch-zen5"
    "gccarch-x86-64-v3"
    "gccarch-x86-64-v4"
  ];

  system = {
    stateVersion = "24.05";
  };

  nixpkgs = {
    hostPlatform = {
      inherit system;
    };
    config = {
      cudaSupport = true;
    };
  };

  defaults.display.idleTimeout = lib.mkForce (15 * 60);

  home-manager.users.${config.defaults.username} = {
    imports = [../../home/${config.defaults.username}.nix] ++ (listNixModulesRecusive ./home-manager);

    programs.niri = {
      settings = {
        outputs = {
          "GIGA-BYTE TECHNOLOGY CO., LTD. MO27U2 25130B000565" = {
            mode = {
              width = 3840;
              height = 2160;
              refresh = 240.0;
            };
            scale = 1.5;
            background-color = "#${config.defaults.colorScheme.palette.base02}";
          };
        };
        binds = {
          "Mod+Tab".action = lib.mkForce {"switch-focus-between-floating-and-tiling" = [];};
          "Mod+Shift+Tab".action = lib.mkForce {"focus-monitor-next" = [];};
        };
      };
    };
  };
}
