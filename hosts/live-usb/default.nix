{
  config,
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
      "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"
    ]
    ++ (listNixModulesRecusive ../../modules/nixos);

  networking.hostName = "live-usb";
  networking.wireless.enable = lib.mkForce false;

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
        user = config.defaults.username;
      };
    };
  };

  nixpkgs = {
    hostPlatform = {
      inherit system;
    };
  };

  home-manager.users.${config.defaults.username} = import ../../home/${config.defaults.username}.nix;
}
