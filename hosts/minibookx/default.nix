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

  services.iio-niri = {
    enable = true;
    extraArgs = ["--monitor" "DSI-1"];
  };

  hardware.sensor.iio.enable = true;

  nixpkgs = {
    hostPlatform = {
      inherit system;
    };
  };

  defaults.wifi = lib.mkForce true;
  defaults.bluetooth = lib.mkForce true;
  defaults.display.width = lib.mkForce 1920;
  defaults.display.height = lib.mkForce 1200;
  defaults.display.idleTimeout = lib.mkForce 60; # 1 minute for battery conservation
  defaults.display.defaultColumnWidthPercent = lib.mkForce 1.0;
  defaults.display.columnWidthPercentPresets = lib.mkForce [0.5 0.75];

  home-manager.users.${config.defaults.username} = {
    imports = [
      ../../home/${config.defaults.username}.nix
    ];
  };

  programs.niri = {
    settings = {
      input = {
        tablet.map-to-output = "DSI-1";
        touch.map-to-output = "DSI-1";
      };

      outputs = {
        "DSI-1" = {
          transform.rotation = 270;
          scale = 1.5;
          background-color = "#${config.defaults.colorScheme.palette.base02}";
        };
      };
    };
  };
}
