{lib, ...}: {
  # Disko disk configuration for laptop
  # Uses $DISKO_DEVICE_MAIN environment variable set by the installer
  disko.devices = {
    disk = {
      main = {
        device = "/dev/\${DISKO_DEVICE_MAIN}";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            esp = {
              type = "EF00";
              size = "1G";
              label = "BOOT";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = ["fmask=0022" "dmask=0022"];
                extraArgs = ["-n" "BOOT"];
              };
            };
            swap = {
              size = "32G";
              label = "swap";
              content = {
                type = "swap";
                randomEncryption = true;
              };
            };
            root = {
              size = "100%";
              label = "cryptroot";
              content = {
                type = "luks";
                name = "cryptroot";
                passwordFile = "/tmp/luks-passphrase";
                settings = {
                  allowDiscards = true;
                  bypassWorkqueues = true;
                };
                content = {
                  type = "filesystem";
                  format = "xfs";
                  mountpoint = "/";
                  mountOptions = ["noatime"];
                };
              };
            };
          };
        };
      };
    };
  };

  zramSwap = {
    enable = true;
    algorithm = "zstd";
  };
}
