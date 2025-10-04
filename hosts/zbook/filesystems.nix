_: {
  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/CE1C-5D58";
    fsType = "vfat";
    options = ["fmask=0022" "dmask=0022"];
  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/00907fcc-48c9-46b2-8cf3-b599ad9c85d6";
    fsType = "btrfs";
    options = ["subvol=@nix"];
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/00907fcc-48c9-46b2-8cf3-b599ad9c85d6";
    fsType = "btrfs";
    options = ["subvol=@home"];
  };

  swapDevices = [
    {device = "/dev/disk/by-uuid/9aaf8e75-2620-4eb7-ac4f-d3ac44986136";}
  ];

  zramSwap = {
    enable = false;
    algorithm = "zstd";
  };
}
