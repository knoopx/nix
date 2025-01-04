_: {
  hardware = {
    ksm.enable = true;
    cpu.intel.updateMicrocode = true;

    bluetooth = {
      enable = false;
      powerOnBoot = false;
    };

    graphics = {
      enable32Bit = true; # for 32-bit wine games
    };
  };

  powerManagement = {
    enable = true;
    powertop.enable = false;
    cpuFreqGovernor = "performance";
  };
}
