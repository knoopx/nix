{
  pkgs,
  lib,
  modulesPath,
  ...
}: {
  hardware = {
    ksm.enable = true;
    cpu.intel.updateMicrocode = true;
    enableAllFirmware = true;
    enableRedistributableFirmware = true;
    bluetooth = {
      enable = false;
      powerOnBoot = false;
    };
  };
}
