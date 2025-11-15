{config, ...}: {
  programs.gamemode.enable = true;

  environment = {
    variables = {
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      EGL_VENDOR_LIBRARY_FILENAMES = "/run/opengl-driver/share/glvnd/egl_vendor.d/10_nvidia.json";
      GBM_BACKEND = "nvidia-drm";
      NVD_BACKEND = "direct";
      NVIDIA_DRIVER_CAPABILITIES = "all";
      NVIDIA_VISIBLE_DEVICES = "all";
    };
  };

  boot = {
    initrd.kernelModules = [
      "nvidia nvidia_modeset nvidia_uvm nvidia_drm"
    ];

    blacklistedKernelModules = ["nouveau"];
  };
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
}
