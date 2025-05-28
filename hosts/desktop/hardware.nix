{pkgs, ...}: {
  hardware = {
    ksm.enable = true;
    cpu.intel.updateMicrocode = true;

    bluetooth = {
      enable = false;
      powerOnBoot = false;
    };

    graphics = {
      enable = true;
      enable32Bit = true; # for 32-bit wine games
      extraPackages = with pkgs; [
        intel-compute-runtime
        intel-media-driver
        vaapiIntel
      ];
    };
  };

  powerManagement = {
    enable = true;
    powertop.enable = false;
    cpuFreqGovernor = "performance";
  };
}
