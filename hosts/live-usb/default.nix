{
  defaults,
  lib,
  pkgs,
  modulesPath,
  ...
} @ inputs: let
  system = "x86_64-linux";
  listNixModulesRecusive = import ../../lib/listNixModulesRecusive.nix inputs;
in {
  imports =
    [
    ]
    ++ (listNixModulesRecusive ../../modules/nixos);

  networking.hostName = "vm";
  networking.wireless.enable = lib.mkForce false;
  # networking.networkmanager.enable = lib.mkForce false;

  system = {
    stateVersion = "25.05";
  };

  environment.systemPackages = with pkgs; [
    gparted
  ];

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd niri-session";
        user = "greeter";
      };
      initial_session = {
        command = "niri-session";
        user = defaults.username;
      };
    };
  };

  nixpkgs = {
    hostPlatform = {
      inherit system;
    };
  };
}
