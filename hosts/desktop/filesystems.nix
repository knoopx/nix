_: {
  fileSystems = {
    "/" = {
      # device = "/dev/nvme0n1p2";
      device = "/dev/disk/by-label/system";
      fsType = "btrfs";
      options = ["subvol=@nixos" "compress=zstd" "noatime" "nodiratime" "discard"];
    };

    "/home" = {
      # device = "/dev/nvme0n1p2";
      device = "/dev/disk/by-label/system";
      fsType = "btrfs";
      options = ["subvol=@home" "compress=zstd" "noatime"];
    };

    "/boot" = {
      # device = "/dev/nvme0n1p1";
      # device = "/dev/disk/by-label/BOOT";
      device = "/dev/disk/by-id/nvme-eui.0025385391b31874-part1";
      fsType = "vfat";
      options = ["fmask=0077" "dmask=0077"];
    };

    "/mnt/storage" = {
      fsType = "btrfs";
      device = "/dev/disk/by-label/Storage";
      options = ["nosuid" "nodev" "nofail" "compress=zstd" "noatime" "x-gvfs-show"];
    };

    "/mnt/junk" = {
      device = "/dev/disk/by-label/Junk";
      options = ["nosuid" "nodev" "nofail" "x-gvfs-show"];
      fsType = "btrfs";
    };

    "/mnt/mixed" = {
      device = "/dev/disk/by-label/Mixed";
      options = ["nosuid" "nodev" "nofail" "x-gvfs-show"];
      fsType = "ntfs-3g";
    };

    "/mnt/music" = {
      device = "/dev/disk/by-label/Music";
      options = ["nosuid" "nodev" "nofail" "x-gvfs-show"];
      fsType = "ntfs-3g";
    };

    "/btrfs" = {
      device = "/dev/disk/by-label/system";
      fsType = "btrfs";
      options = ["compress=zstd" "noatime"];
    };

    "/swap" = {
      device = "/dev/disk/by-label/system";
      fsType = "btrfs";
      options = ["subvol=@swap" "compress=lzo" "noatime"];
    };
  };

  swapDevices = [
    {device = "/swap/swapfile";}
  ];

  zramSwap = {
    enable = true;
    algorithm = "zstd";
  };
}
