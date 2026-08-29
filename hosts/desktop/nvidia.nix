{
  lib,
  config,
  pkgs,
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
      package = config.boot.kernelPackages.nvidia_x11_latest;
    };
  };

  services = {
    xserver.videoDrivers = ["nvidia"];
  };

  # libvulkan.so.1 for llama.cpp's Vulkan backend (llama.cpp b10310-vulkan);
  # the driver ICD json is already provided via /run/opengl-driver/share/vulkan/icd.d
  environment.systemPackages = [ pkgs.vulkan-loader ];

  hardware.nvidia-container-toolkit.enable = true;
}
