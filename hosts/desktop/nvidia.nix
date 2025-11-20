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
      package = config.boot.kernelPackages.nvidiaPackages.beta;
    };
  };

  services = {
    xserver.videoDrivers = ["nvidia"];
  };

  hardware.nvidia-container-toolkit.enable = true;
  systemd.services.nvidia-container-toolkit-cdi-generator.serviceConfig.ExecStartPre = lib.mkForce null;
}
