{...}: let
  system = "x86_64-linux";
  gcc = {
    arch = "rocketlake";
    tune = "rocketlake";
  };
in {
  imports = [
    ../modules/traefik.nix
    ../modules/immich.nix
    ../modules/watchtower.nix
    ../modules/silverbullet.nix
    # ../modules/baserow.nix
    # ../modules/eidos.nix

    ./headless.nix

    ./gnome/overlays.nix
    ./gnome/packages.nix
    ./gnome/programs.nix
    ./gnome/services.nix
    ./gnome/xdg.nix

    ./desktop/boot.nix
    ./desktop/filesystems.nix
    ./desktop/hardware.nix
    ./desktop/nvidia.nix
    ./desktop/packages.nix
    ./desktop/services.nix
    ./desktop/virtualisation.nix
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
