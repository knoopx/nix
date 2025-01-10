{
  lib,
  pkgs,
  ...
}: let
  system = "x86_64-linux";
in {
  imports = [
    ../../modules/containers
    ../../modules/nixos
    ../../modules/nixos/gnome

    ./boot.nix
    ./filesystems.nix
    ./hardware.nix
    ./nvidia.nix
    ./services.nix
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
