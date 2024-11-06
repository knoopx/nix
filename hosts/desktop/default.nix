_: let
  system = "x86_64-linux";
in {
  imports = [
    ../../modules/nixos/containers/traefik.nix
    ../../modules/nixos/containers/immich.nix
    ../../modules/nixos/containers/open-webui.nix
    ../../modules/nixos/containers/watchtower.nix
    ../../modules/nixos/containers/silverbullet.nix
    # ../../modules/nixos/containers/baserow.nix
    # ../../modules/nixos/containers/eidos.nix

    ../../modules/nixos/headless

    ../../modules/nixos/gnome/overlays.nix
    ../../modules/nixos/gnome/packages.nix
    ../../modules/nixos/gnome/programs.nix
    ../../modules/nixos/gnome/services.nix
    ../../modules/nixos/gnome/xdg.nix

    ./boot.nix
    ./filesystems.nix
    ./btrfs.nix
    ./hardware.nix
    ./nvidia.nix
    ./packages.nix
    ./flatpak.nix
    ./services.nix
    ./virtualisation.nix
  ];

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
