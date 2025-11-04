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

  home-manager.users.${config.defaults.username} = {
    imports = [../../home/${config.defaults.username}.nix] ++ (listNixModulesRecusive ./home-manager);
  };

  defaults.display.idleTimeout = lib.mkForce (15 * 60);
}
