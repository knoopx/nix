_: {
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/system";
      options = ["subvol=@nixos" "compress=zstd" "noatime" "nodiratime" "discard"];
      fsType = "btrfs";
    };

    "/home" = {
      device = "/dev/disk/by-label/system";
      options = ["subvol=@home" "compress=zstd" "noatime" "nodiratime" "discard"];
      fsType = "btrfs";
    };
    "/boot" = {
      device = "/dev/disk/by-id/nvme-eui.0025385391b31874-part1";
      fsType = "vfat";
      options = ["fmask=0077" "dmask=0077"];
    };
    "/mnt/storage" = {
      device = "/dev/disk/by-label/Storage";
      options = ["nosuid" "compress=zstd" "nodev" "nofail" "x-gvfs-show"];
      fsType = "btrfs";
    };
    "/mnt/music" = {
      device = "/dev/disk/by-label/Music";
      options = ["nosuid" "compress=zstd" "nodev" "nofail" "x-gvfs-show"];
      fsType = "btrfs";
    };
    "/btrfs" = {
      device = "/dev/disk/by-label/system";
      options = ["compress=zstd" "noatime"];
      fsType = "btrfs";
    };
    "/swap" = {
      device = "/dev/disk/by-label/system";
      options = ["subvol=@swap" "compress=lzo" "noatime"];
      fsType = "btrfs";
    };
  };

  swapDevices = [
    {device = "/swap/swapfile";}
  ];

  zramSwap = {
    enable = false;
    algorithm = "zstd";
  };
}
