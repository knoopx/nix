{...}: {
  # swapDevices = [
  #   {device = "/swap/swapfile";}
  # ];

  # zramSwap = {
  #   enable = true;
  #   algorithm = "zstd";
  # };

  fileSystems = {
    "/" = {
      device = "/dev/nvme0n1p2";
      fsType = "btrfs";
      options = ["subvol=@nixos" "compress=zstd" "noatime" "nodiratime" "discard"];
    };

    "/boot" = {
      device = "/dev/nvme0n1p1";
      fsType = "vfat";
      options = ["fmask=0077" "dmask=0077"];
    };

    "/home" = {
      device = "/dev/nvme0n1p2";
      fsType = "btrfs";
      options = ["subvol=@home" "compress=zstd" "noatime"];
    };

    "/btrfs" = {
      device = "/dev/nvme0n1p2";
      fsType = "btrfs";
      options = ["compress=zstd" "noatime"];
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
  };
}
