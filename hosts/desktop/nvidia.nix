{
  lib,
  config,
  ...
}: {
  # programs.gamemode.enable = true;

  boot.initrd.kernelModules = ["nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm"];
  boot.kernelParams = ["nvidia-drm.modeset=1" "nvidia_drm.fbdev=1"];
  nixpkgs.config.nvidia.acceptLicense = true;

  hardware = {
    graphics = {
      enable = true;
    };

    nvidia = {
      modesetting.enable = true;

      powerManagement = {
        enable = false;
        finegrained = false;
      };

      open = true;
      nvidiaSettings = false;
      forceFullCompositionPipeline = false;
      package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
        version = "610.43.02";
        sha256_64bit = "sha256:0qvllxnb20arjhw3bxdz0hw521di9ib75hldzx97gpscpdaa0d1h";
        sha256_aarch64 = "sha256:0qvllxnb20arjhw3bxdz0hw521di9ib75hldzx97gpscpdaa0d1h";
        openSha256 = "sha256-hP5NVZZ4vGsACHLmUDKq4uckpd/kn1GxCSYnnJfAuBs=";
        settingsSha256 = "sha256-0YAhufRgjDW+uR+kjaTb154fibpcDw8QowfrucoZsKE=";
        persistencedSha256 = "sha256:0nd0bf2s9b2ic8a0rcscddasddkryx2qf6mx4861bv44wblm513z";
      };
    };
  };

  services = {
    xserver.videoDrivers = ["nvidia"];
  };

  hardware.nvidia-container-toolkit.enable = true;
}
