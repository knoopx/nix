{pkgs, ...}: {
  hardware = {
    ksm.enable = true;
    cpu.amd.updateMicrocode = true;

    graphics = {
      enable = true;
      enable32Bit = true; # for 32-bit wine games
    };

    firmware = [
      pkgs.linux-firmware
    ];
  };

  # services.thermald.enable = true;
  # powerManagement = {
  #   enable = true;
  #   # powertop.enable = true;
  #   cpuFreqGovernor = "performance";
  # };
}
