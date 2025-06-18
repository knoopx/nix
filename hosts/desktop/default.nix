{config, ...} @ inputs: let
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
    "gccarch-rocketlake"
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

  home-manager.users.${config.defaults.username} = import ../../home/${config.defaults.username}.nix;
}
