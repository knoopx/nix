{
  lib,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/c471922e-d022-421e-a926-d4a34139b06e";
    fsType = "btrfs";
    options = ["subvol=@nixos"];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/44DE-862D";
    fsType = "vfat";
    options = ["fmask=0022" "dmask=0022"];
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/c471922e-d022-421e-a926-d4a34139b06e";
    fsType = "btrfs";
    options = ["subvol=@home"];
  };

  swapDevices = [];

  networking.useDHCP = lib.mkDefault true;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = true;

  powerManagement = {
    enable = true;
  };

  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
  };
}
