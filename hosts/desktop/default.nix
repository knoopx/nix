{
  lib,
  pkgs,
  ...
}: let
  system = "x86_64-linux";
in {
  imports = [
    ../../modules/nixos/containers/traefik.nix
    ../../modules/nixos/containers/immich.nix
    ../../modules/nixos/containers/open-webui.nix
    ../../modules/nixos/containers/watchtower.nix
    ../../modules/nixos/containers/silverbullet.nix
    ../../modules/nixos/containers/memos.nix
    # ../../modules/nixos/containers/nextcloud.nix
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
    # ./flatpak.nix
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

  environment = {
    sessionVariables = {
      # make gstreamer plugins available to apps
      GST_PLUGIN_SYSTEM_PATH_1_0 = lib.makeSearchPathOutput "lib" "lib/gstreamer-1.0" (with pkgs.gst_all_1; [
        gst-libav
        gst-plugins-bad
        gst-plugins-base
        gst-plugins-good
        gst-plugins-ugly
        gst-vaapi
        gstreamer
      ]);
    };
  };
}
