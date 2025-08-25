{pkgs, ...}: {
  hardware = {
    ksm.enable = true;
    cpu.amd.updateMicrocode = true;

    bluetooth = {
      enable = false;
      powerOnBoot = false;
    };

    graphics = {
      enable = true;
      enable32Bit = true; # for 32-bit wine games
    };
  };

  services.thermald.enable = true;

  powerManagement = {
    enable = true;
    powertop.enable = true;
    cpuFreqGovernor = "performance";
  };
}
