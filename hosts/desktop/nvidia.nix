{
  pkgs,
  config,
  ...
}: {
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

    systemPackages = with pkgs; [
    ];
  };

  boot = {
    initrd.kernelModules = [
      "nvidia nvidia_modeset nvidia_uvm nvidia_drm"
    ];

    # extraModprobeConfig = ''

    # kernelParams = [
    #   "nomodeset"
    #   "intel_iommu=on"
    #   "iommu=pt"
    #   "nvidia_drm.modeset=1"
    #   "nvidia_drm.fbdev=1"
    # ];

    blacklistedKernelModules = ["nouveau"];
  };
  nixpkgs.config.nvidia.acceptLicense = true;

  hardware = {
    nvidia-container-toolkit.enable = true;

    graphics = {
      enable = true;
      extraPackages = with pkgs; [
        # libvdpau-va-gl
        # nvidia-vaapi-driver
        # # vaapiIntel
        # vaapiVdpau
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
      forceFullCompositionPipeline = false;

      # nvidiaPersistenced = true;

      # https://http.download.nvidia.com/XFree86/Linux-x86_64/
      package = config.boot.kernelPackages.nvidiaPackages.beta;

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
