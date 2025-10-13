{pkgs, ...}: {
  hardware = {
    ksm.enable = true;
    cpu.amd.updateMicrocode = true;

    # powerManagement = {
    #   enable = true;
    #   # powertop.enable = true;
    #   cpuFreqGovernor = "performance";
    # };

    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };

    graphics = {
      enable = true;
      enable32Bit = true; # for 32-bit wine games
    };

    firmware = [
      pkgs.linux-firmware
    ];
  };
}
