{
  lib,
  config,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.luks.devices."cryptroot" = {
    device = lib.mkForce "/dev/disk/by-partlabel/cryptroot";
    allowDiscards = lib.mkForce true;
    bypassWorkqueues = lib.mkForce true;
  };

  fileSystems."/" = lib.mkForce {
    device = "/dev/mapper/cryptroot";
    fsType = "xfs";
    options = ["noatime"];
  };

  fileSystems."/boot" = lib.mkForce {
    device = "/dev/disk/by-label/BOOT";
    fsType = "vfat";
    options = ["fmask=0022" "dmask=0022"];
  };

  swapDevices = [
    {
      device = "/dev/disk/by-partlabel/swap";
      randomEncryption.enable = true;
    }
  ];

  zramSwap = {
    enable = true;
    algorithm = "zstd";
  };

  services.btrfs.autoScrub.enable = lib.mkForce false;

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
