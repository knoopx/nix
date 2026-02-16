{
  lib,
  config,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  networking.useDHCP = lib.mkDefault true;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = true;

  powerManagement = {
    enable = true;
  };

  hardware = {
    bluetooth = {
      enable = config.defaults.bluetooth;
      powerOnBoot = config.defaults.bluetooth;
    };
  };
}
