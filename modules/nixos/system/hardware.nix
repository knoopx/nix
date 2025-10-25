{config, ...}: {
  hardware = {
    enableAllFirmware = true;
    enableRedistributableFirmware = true;

    bluetooth = {
      enable = config.defaults.bluetooth;
      powerOnBoot = config.defaults.bluetooth;
    };
  };
}
