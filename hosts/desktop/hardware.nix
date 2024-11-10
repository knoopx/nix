_: {
  hardware = {
    ksm.enable = true;
    cpu.intel.updateMicrocode = true;
    pulseaudio.enable = false;

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
