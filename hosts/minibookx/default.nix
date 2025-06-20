{config, ...} @ inputs: let
  listNixModulesRecusive = import ../../lib/listNixModulesRecusive.nix inputs;
  system = "x86_64-linux";
in {
  imports =
    [
      ./boot.nix
      ./hardware.nix
    ]
    ++ (listNixModulesRecusive ../../modules/nixos);

  system.stateVersion = "25.11";

  services.keyd = {
    enable = true;
    keyboards = {
      default = {
        # nix run nixpkgs#keyd monitor
        ids = ["0001:0001"];
        settings = {
          main = {
            leftmeta = "leftalt";
            leftalt = "leftmeta";
          };
        };
      };
    };
  };

  networking.hostName = "minibookx";
  nix.settings.system-features = [
  ];

  nixpkgs = {
    hostPlatform = {
      inherit system;
    };
  };

  defaults.display.width = 1920;
  defaults.display.height = 1200;
  defaults.display.idleTimeout = 60; # 1 minute for battery conservation
  defaults.display.defaultColumnWidthPercent = 1.0;
  defaults.display.columnWidthPercentPresets = [0.5 0.75];

  home-manager.users.${config.defaults.username} = import ../../home/${config.defaults.username}.nix;
}
