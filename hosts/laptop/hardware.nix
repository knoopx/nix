{
  lib,
  config,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/F607-C392";
    fsType = "vfat";
    options = ["fmask=0022" "dmask=0022"];
  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/6583650f-b0f3-4759-b6ad-e433ed4b0512";
    fsType = "btrfs";
    options = ["subvol=@nix"];
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/6583650f-b0f3-4759-b6ad-e433ed4b0512";
    fsType = "btrfs";
    options = ["subvol=@home"];
  };

  swapDevices = [
    {device = "/dev/disk/by-uuid/cef73190-8ae1-48c6-b249-3f4d8cfe45e1";}
  ];

  networking.useDHCP = lib.mkDefault true;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = true;

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
