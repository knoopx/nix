{
  config,
  pkgs,
  ...
}: {
  programs.gamemode.enable = true;

  environment = {
    sessionVariables = {
      NIXOS_OZONE_WL = "1";
      # WLR_NO_HARDWARE_CURSORS = "1";
      # WLR_DRM_NO_ATOMIC = "1";
      # NVD_BACKEND = "direct";
      # GBM_BACKEND = "nvidia-drm";
      # LIBVA_DRIVER_NAME = "nvidia";
      # __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    };
    systemPackages = with pkgs; [
      vulkan-loader
      # vulkan-validation-layers
      vulkan-tools
      libva
      libva-utils
      glxinfo
      egl-wayland
    ];
  };

  boot = {
    initrd.kernelModules = [
      "nvidia nvidia_modeset nvidia_uvm nvidia_drm"
    ];

    # options nvidia NVreg_EnablePCIeGen3=1
    # options nvidia NVreg_EnableMSI=1
    # options nvidia NVreg_InitializeSystemMemoryAllocations=1
    # options nvidia NVreg_RegistryDwords="PowerMizerEnable=0x1; PowerMizerLevel=0x3; PowerMizerDefault=0x3; PowerMizerDefaultAC=0x3; PerfLevelSrc=0x3333; OverrideMaxPerf=0x1"
    extraModprobeConfig = ''
      options nvidia_drm modeset=1
      options nvidia_drm fbdev=1
      options nvidia NVreg_UsePageAttributeTable=1
      options nvidia NVreg_EnableGpuFirmware=0
      options nvidia NVreg_PreserveVideoMemoryAllocations=1
    '';

    kernelParams = [
      "nomodeset"
      "intel_iommu=on"
      "iommu=pt"
      "nvidia_drm.modeset=1"
      "nvidia_drm.fbdev=1"
    ];

    blacklistedKernelModules = ["nouveau"];
  };

  nixpkgs.config.nvidia.acceptLicense = true;

  hardware = {
    graphics = {
      enable = true;
      extraPackages = with pkgs; [
        vaapiIntel
        vaapiVdpau
        libvdpau-va-gl
      ];
    };

    nvidia = {
      modesetting.enable = true;

      powerManagement = {
        enable = false;
        finegrained = false;
      };

      open = false;
      nvidiaSettings = false;

      # nvidiaPersistenced = true;
      forceFullCompositionPipeline = false;

      # https://http.download.nvidia.com/XFree86/Linux-x86_64/
      # package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
      #   version = "535.183.01";
      #   sha256_64bit = "sha256-9nB6+92pQH48vC5RKOYLy82/AvrimVjHL6+11AXouIM=";
      #   settingsSha256 = "sha256-9wqoDEWY4I7weWW05F4igj1Gj9wjHsREFMztfEmqm10=";
      #   persistencedSha256 = "sha256-9DTOKOCoO65UpvQwAMwKO23AcCJGF+/UsUPLWO4XE6A=";
      # };
    };
  };

  services = {
    xserver.videoDrivers = ["nvidia"];
  };
}
