{
  config,
  pkgs,
  ...
}: {
  nixpkgs.config.nvidia.acceptLicense = true;

  environment = {
    sessionVariables = {
      # NIXOS_OZONE_WL = "1";
      # WLR_NO_HARDWARE_CURSORS = "1";
      # NVD_BACKEND = "direct";
      # GBM_BACKEND = "nvidia-drm";
      # WLR_DRM_NO_ATOMIC = "1";
      # LIBVA_DRIVER_NAME = "nvidia";
      # __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    };
    # systemPackages = with pkgs; [
    #   vulkan-loader
    #   vulkan-validation-layers
    #   vulkan-tools
    #   libva
    #   libva-utils
    #   glxinfo
    #   egl-wayland
    # ];
  };

  boot = {
    initrd.kernelModules = [
      "nvidia nvidia_modeset nvidia_uvm nvidia_drm"
    ];

    kernelParams = [
      "nomodeset"
      "intel_iommu=on"
      "iommu=pt"
      "nvidia_drm.modeset=1"
      "nvidia_drm.fbdev=1"
    ];

    blacklistedKernelModules = ["nouveau"];
  };

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
        enable = true;
        finegrained = false;
      };

      open = false;
      nvidiaSettings = false;
      nvidiaPersistenced = true;
      forceFullCompositionPipeline = true;

      # https://http.download.nvidia.com/XFree86/Linux-x86_64/
      package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
        version = "535.183.01";
        sha256_64bit = "sha256-9nB6+92pQH48vC5RKOYLy82/AvrimVjHL6+11AXouIM=";
        settingsSha256 = "sha256-9wqoDEWY4I7weWW05F4igj1Gj9wjHsREFMztfEmqm10=";
        persistencedSha256 = "sha256-9DTOKOCoO65UpvQwAMwKO23AcCJGF+/UsUPLWO4XE6A=";
      };
      # package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
      #   version = "560.28.03";
      #   sha256_64bit = "sha256-martv18vngYBJw1IFUCAaYr+uc65KtlHAMdLMdtQJ+Y=";
      #   sha256_aarch64 = "sha256-+u0ZolZcZoej4nqPGmZn5qpyynLvu2QSm9Rd3wLdDmM=";
      #   openSha256 = "sha256-asGpqOpU0tIO9QqceA8XRn5L27OiBFuI9RZ1NjSVwaM=";
      #   settingsSha256 = "sha256-b4nhUMCzZc3VANnNb0rmcEH6H7SK2D5eZIplgPV59c8=";
      #   persistencedSha256 = "sha256-MhITuC8tH/IPhCOUm60SrPOldOpitk78mH0rg+egkTE=";
      # };
    };
  };

  services = {
    xserver.videoDrivers = ["nvidia"];
  };
}
