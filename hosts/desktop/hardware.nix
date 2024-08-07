{
  pkgs,
  lib,
  modulesPath,
  ...
}: {
  hardware = {
    ksm.enable = true;
    cpu.intel.updateMicrocode = true;
    pulseaudio.enable = false;
    bluetooth = {
      enable = false;
      powerOnBoot = false;
    };
  };

  powerManagement = {
    enable = true;
    powertop.enable = false;
    cpuFreqGovernor = "performance";
  };
}
