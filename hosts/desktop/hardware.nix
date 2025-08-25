{pkgs, ...}: {
  hardware = {
    ksm.enable = true;
    cpu.amd.updateMicrocode = true;

    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };

    graphics = {
      enable = true;
      enable32Bit = true; # for 32-bit wine games
    };

    # MediaTek WiFi/Bluetooth firmware for ROG Strix X870-F
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
