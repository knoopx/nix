{...} @ inputs: let
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
    ++ (listNixModulesRecusive ../../modules/nixos);

  networking.hostName = "desktop";
  nix.settings.system-features = [
    "kvm"
    "big-parallel"
    "gccarch-rocketlake"
    "gccarch-x86-64-v3"
    "gccarch-x86-64-v4"
  ];

  nixpkgs = {
    hostPlatform = {
      inherit system;
    };
    config = {
      cudaSupport = true;
    };
  };
}
