{
  pkgs,
  config,
  ...
}: {
  programs.gamemode.enable = true;

  environment = {
    variables = {
      NIXOS_OZONE_WL = "1";
      # __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      # EGL_VENDOR_LIBRARY_FILENAMES = "/run/opengl-driver/share/glvnd/egl_vendor.d/10_nvidia.json";
      # GBM_BACKEND = "nvidia-drm";
      # GDK_BACKEND = "wayland";
      # LIBVA_DRIVER_NAME = "nvidia";
      # MOZ_ENABLE_WAYLAND = "1";
      # NVD_BACKEND = "direct";
      # NVIDIA_DRIVER_CAPABILITIES = "all";
      # NVIDIA_VISIBLE_DEVICES = "all";
      # QT_QPA_PLATFORM = "wayland;xcb";
      # QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
      # SDL_VIDEODRIVER = "wayland";
      # WLR_BACKEND = "vulkan";
      # WLR_DRM_NO_ATOMIC = "1";
      # WLR_NO_HARDWARE_CURSORS = "1";
      # WLR_RENDERER = "vulkan";
      # XDG_SESSION_TYPE = "wayland";
    };

    systemPackages = with pkgs; [
      # egl-wayland
      # glxinfo
      # libva
      # libva-utils
      # vulkan-loader
      # vulkan-tools
      # vulkan-validation-layers
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
    nvidia-container-toolkit.enable = true;

    graphics = {
      enable = true;
      extraPackages = with pkgs; [
        libvdpau-va-gl
        nvidia-vaapi-driver
        # vaapiIntel
        vaapiVdpau
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
